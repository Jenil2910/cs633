//From https://www.mpi-forum.org/docs/mpi-3.1/mpi31-report.pdf Chap-3

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include "mpi.h"

int MY_Allgather(const void *sendbuf, int sendcount, MPI_Datatype sendtype, void *recvbuf, int recvcount, MPI_Datatype recvtype, MPI_Comm comm){
  int recvts, sendts;
  MPI_Type_size(recvtype, &recvts);
  MPI_Type_size(sendtype, &sendts);
  int myrank, size, recvsize = recvcount*recvts, sendsize = sendcount*sendts;
  MPI_Comm_rank(comm, &myrank);
  MPI_Comm_size(comm, &size);
  assert(recvsize == sendsize);

  MPI_Request req[2];
  MPI_Status stat[2];
  int from = (myrank+size-1)%size, to = (myrank+1)%size;
  void* toptr, *fromptr, *tmpptr;
  int torank = myrank, fromrank = from;
  /*
  I am assuming that recvbuf can be divided into recvcount blocks each of size recvsize. Which is true for our case.
  In each step of Ring, I keep track of which block to send and which to recieve and do them simultaneously.
  */
  
  memcpy(recvbuf + (myrank*recvsize), sendbuf, recvsize);

  for(int i=1;i<size;i++){
    /*
      I do send and recieve simultaneously in each Ring step.
      Send the buffer recieved in previous step and Recv buffer and store next block(which will be sent in next step).

      In ith step i have to send myrank+i-1 block and recieve in myrank+i(which is fromrank+i-1) block
    */
    toptr = recvbuf + (((torank+i-1)%size)*recvsize);
    fromptr = recvbuf + (((fromrank+i-1)%size)*recvsize);

    MPI_Isend(toptr, recvcount, recvtype, to, 99, MPI_COMM_WORLD, req);
    MPI_Irecv(fromptr, recvcount, recvtype, from, 99, MPI_COMM_WORLD, req+1);
    MPI_Waitall(2, req, stat);
  }

  return 0;
}

int MY_Bcast(void *buffer, int count, MPI_Datatype datatype, int root, MPI_Comm comm){
  //Scatter + RingAllgather
  int myrank, size, ts, bufsize;
  MPI_Comm_rank(comm, &myrank);
  MPI_Comm_size(comm, &size);
  MPI_Type_size(datatype, &ts);
  bufsize = count*ts;

  assert(bufsize%(ts*size)==0);

  int recvcount = bufsize/(ts*size);
  void* recv = (void*)malloc(recvcount*ts);

  MPI_Scatter(buffer, recvcount, datatype, recv, recvcount, datatype, root, comm);
  MY_Allgather(recv, recvcount, datatype, buffer, recvcount, datatype, comm);

  free(recv);
  return 0;
}

double Bcast_wrapper(int type, int myrank, int size, void *buffer, int count, MPI_Datatype datatype, int root, MPI_Comm comm){
  /*
  Calls MPI or MY Bcast depending on type and measures it.
  */
  double start, elapsed, final_time, bandwidth;
  if(type==0){
    start = MPI_Wtime();
    MY_Bcast(buffer, count, datatype, root, comm);
    elapsed = MPI_Wtime() - start;
  }else{
    start = MPI_Wtime();
    MPI_Bcast(buffer, count, datatype, root, comm);
    elapsed = MPI_Wtime() - start;
  }

  MPI_Reduce(&elapsed, &final_time, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);

  bandwidth = (count*1.0*sizeof(float)*(size-1)/(elapsed*(1<<20)));
  if(type==0){
    return bandwidth;
  }else{
    return bandwidth;
  }
}

int main( int argc, char *argv[])
{
  if(argc<2){
    printf("1st argument should be D.\n");
    return 0;
  }

  int D = atoi(argv[1])/sizeof(float);
  float* message = (float*)malloc(D*sizeof(float));
  
  int myrank, size;
  MPI_Status status;
  MPI_Init( &argc, &argv );
  MPI_Comm_rank( MPI_COMM_WORLD, &myrank );
  MPI_Comm_size(MPI_COMM_WORLD, &size);

  if(!myrank) printf("%ld ", D*sizeof(float));
  
  MPI_Barrier(MPI_COMM_WORLD);
  double mpibw = Bcast_wrapper(1, myrank, size, message, D, MPI_FLOAT, 0, MPI_COMM_WORLD);

  MPI_Barrier(MPI_COMM_WORLD);
  double mybw = Bcast_wrapper(0, myrank, size, message, D, MPI_FLOAT, 0, MPI_COMM_WORLD);
  
  if(!myrank) printf("%lf %lf\n", mybw, mpibw);

  free(message);
  MPI_Finalize();
  return 0;
}
