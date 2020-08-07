//From https://www.mpi-forum.org/docs/mpi-3.1/mpi31-report.pdf Chap-3

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "mpi.h"

#define BAND(t) ((D*1.0)/(t*(1L<<20)))

int main( int argc, char *argv[])
{
  if(argc<2){
    printf("1st argument should be D.\n");
    return 0;
  }

  long long int D = atoi(argv[1]);
  char message[D], recv[D];
  
  int myrank, two_rank, to, size, from, level, color;
  MPI_Status status;
  MPI_Comm two_comm;
  MPI_Request req;
  MPI_Init( &argc, &argv );
  MPI_Comm_rank(MPI_COMM_WORLD, &myrank );
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  /*
  To perform all node pair communication, each rank sends to rank+1 and recieves from rank-1. 
  Then sends to rank+2 and recieves from rank-2 and so on till sends to rank+size-1 and recieves from rank-size+1.
  Note: all addition subtraction are modulo size.
  */

  double start, elapsed, bandwidth, times[size], bw;
  for(int shift=1;shift<size;shift++){
    /*
    shift means rank i will send to (i+shift)%size and recieve from (i-shift+size)%size.
    To measure each communication, I divide communication into levels.
    For each shift it takes maximum 3 levels if we create maximum possible concurrent pairs at each level such that each node either sends or recieves data.
    Next I determine which level a rank will send.
    */
    int arr[size]; // This array stores level in which myrank has to send.
    for(int j=0;j<size;j++) arr[j]=0;
    for(int j=0;j<size;j++){
      to = (j+shift)%size;
      from = (j-shift+size)%size;
      /*
      If both nodes to which rank j has to send and from which it recieves are free in L level, 
      Then rank j will send in this L level. I find minimum possible such level for j.
      */
      if(arr[from]!=1 && arr[to]!=1){
        arr[j]=1;
      }else if(arr[from]!=2 && arr[to]!=2){
        arr[j]=2;
      }else if(arr[from]!=3 && arr[to]!=3){
        arr[j]=3;
      }
    }

    to = (myrank+shift)%size;
    from = (myrank-shift+size)%size;
    for(level=1;level<=3;level++){
      MPI_Barrier(MPI_COMM_WORLD);
      if(arr[myrank]==level){
        // this node has to be sender in this level

        //unique color for sender-reciever pair
        color = myrank*(size+1)+to;

        MPI_Comm_split(MPI_COMM_WORLD, color, myrank, &two_comm);

        start = MPI_Wtime();
        MPI_Send(message, D, MPI_BYTE, to, 99, MPI_COMM_WORLD);
        elapsed = MPI_Wtime() - start;

        MPI_Comm_rank(two_comm, &two_rank);
        MPI_Reduce(&elapsed, times+to, 1, MPI_DOUBLE, MPI_MAX, two_rank, two_comm);
      }else if(arr[from]==level){
        // If node from which it recieves is calling MPI_Send, then call MPI_Recv

        //unique color for sender-reciever pair
        color = from*(size+1)+myrank;

        MPI_Comm_split(MPI_COMM_WORLD, color, myrank, &two_comm);

        start = MPI_Wtime();
        MPI_Recv(message, D, MPI_BYTE, from, 99, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        elapsed = MPI_Wtime() - start;

        MPI_Comm_rank(two_comm, &two_rank);
        MPI_Reduce(&elapsed, times+to, 1, MPI_DOUBLE, MPI_MAX, two_rank^1, two_comm);
      }else{
        //This rank not participating in this level.
        color=-1;
        MPI_Comm_split(MPI_COMM_WORLD, color, myrank, &two_comm);
      }
    }
  }

  start = MPI_Wtime();
  MPI_Isend(message, D, MPI_BYTE, myrank, 99, MPI_COMM_WORLD, &req);
  MPI_Irecv(recv, D, MPI_BYTE, myrank, 99, MPI_COMM_WORLD, &req);
  MPI_Wait(&req, MPI_STATUS_IGNORE);
  elapsed = MPI_Wtime() - start;
  times[myrank] = elapsed;

  for(int i=0;i<size;i++){
    printf("%d %d %lf\n", myrank, i, BAND(times[i]));
  }

  MPI_Comm_free(&two_comm);
  MPI_Finalize();
  return 0;
}
