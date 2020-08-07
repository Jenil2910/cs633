#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "mpi.h"

int main( int argc, char *argv[])
{
  if(argc<2){
    printf("First argument must be D.\n");
    return 0;
  }

  long long int D = atoi(argv[1]);
  char message[D];
  for(int i=0;i<D-1;i++){
          message[i]='a'+(i%26);
  }
  message[D-1] = '\0';

  int myrank, size;

  MPI_Init(&argc, &argv);
  MPI_Comm_rank( MPI_COMM_WORLD, &myrank );
  MPI_Comm_size( MPI_COMM_WORLD, &size );
  MPI_Status status[size-1];
  MPI_Request request[size-1];
  
  double start = MPI_Wtime();
  if (myrank == 0)
  {
    for(int i=0;i<100;i++){
      //char recvarr[size-1][D];
      for (int i=1; i<size; i++)
        MPI_Recv(message, D, MPI_BYTE, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, status);
    }
  }
  else
  {
    for(int i=0;i<100;i++){
      MPI_Send(message, D, MPI_BYTE, 0, myrank, MPI_COMM_WORLD);
    }
  }

  double elapsed_time = MPI_Wtime() - start;

  double bandwidth = (100*D*(size-1))/(elapsed_time);
  bandwidth = bandwidth/(1L<<20);
  // if(myrank==0) printf("Total time to receive from %lld process: %lf\n", size-1, elapsed_time);
  if(myrank==0) printf("%lld %lf\n", D, bandwidth);

  MPI_Finalize();
  return 0;
}
