//From https://www.mpi-forum.org/docs/mpi-3.1/mpi31-report.pdf Chap-3

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "mpi.h"

int main( int argc, char *argv[])
{
  if(argc<2){
    printf("1st argument should be D.\n");
    return 0;
  }

  int D = atoi(argv[1]);
  char message[D];
  for(int i=0;i<D-1;i++){
	  message[i]='a'+(i%26);
  }
  message[D-1] = '\0';
  
  int myrank;
  MPI_Status status;
  MPI_Init( &argc, &argv );
  MPI_Comm_rank( MPI_COMM_WORLD, &myrank );

  double start = MPI_Wtime();

  if (myrank == 0)    /* code for process 0 */
  {
    for(int i=0;i<100;i++){
        MPI_Send(message, D, MPI_BYTE, 1, i, MPI_COMM_WORLD);
    }
  }
  else if (myrank == 1)  /* code for process 1 */
  {
    // char recv[D];
    for(int i=0;i<100;i++){
        MPI_Recv(message, D, MPI_BYTE, 0, i, MPI_COMM_WORLD, &status);
    }
  }

  double elapsed_time = MPI_Wtime() - start;
  double bandwidth = (D*100.0)/(elapsed_time);
  bandwidth = bandwidth/(1L<<20);
  if(myrank==1) printf("%d,%lf\n", D, bandwidth);

  MPI_Finalize();
  return 0;
}
