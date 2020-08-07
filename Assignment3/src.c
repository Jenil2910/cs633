//From https://www.mpi-forum.org/docs/mpi-3.1/mpi31-report.pdf Chap-3

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <time.h>
#include <math.h>
#include <float.h>
#include "mpi.h"

#define log(s) printf("[%d] ", myrank);printf s;
#define d(x, y) ((x[0]-y[0])*(x[0]-y[0]) + (x[1]-y[1])*(x[1]-y[1]) + (x[2]-y[2])*(x[2]-y[2]))
#define min(x,y) (x<y?x:y)
#define up(x,y) ((x+(y)-1)/y)
#define ac(v, i, j, l) v[i + j*l]
#define MAX_LEN 100

int getRandIdx(int n){
  return rand()%n;
}

void readFile(MPI_File fh, int size_double, int size, int myrank, MPI_Status* status, double** datap, int* count){
  MPI_Offset file_size;
  MPI_File_get_size(fh, &file_size);

  MPI_Offset totale = file_size/(4*size_double);
  MPI_Offset epn = (totale+size-1)/size;
  MPI_Offset dpn = epn*4;
  MPI_Offset offset = myrank*dpn*size_double;
  *datap = (double*)malloc(dpn*sizeof(double));
  // log(("%lld %lld %lld %lld %ld\n", totale, epn, dpn, offset, sizeof(double)));
  MPI_File_read_at(fh, offset, *datap, dpn, MPI_DOUBLE, status);
  MPI_Get_count(status, MPI_DOUBLE, count);

  return;
}

void initMean(double* cmean, double* data, int count, int size_double, int K, int myrank, int size){
  int n=count/4;

  double* temp = (double*)malloc(3*K*sizeof(double));
  int i;
  for(i=0;i<3*K;i++){
    temp[i]=0;
  }

  int* idx=(int*)malloc(K*sizeof(int));
  if(myrank==0){
    int i;
    for(i=0;i<K;i++){
      if(size>1){
        idx[i]=getRandIdx(n*(size-1));
      }else{
        idx[i]=getRandIdx(n*size/2);
      }
    }
  }

  MPI_Bcast(idx, K, MPI_INT, 0, MPI_COMM_WORLD);
  
  for(i=0;i<K;i++){
    if(idx[i]>=myrank*n && idx[i]<(myrank+1)*n){
      int dx = idx[i]%n;
      temp[3*i] = data[dx*4 +1];
      temp[3*i+1] = data[dx*4 +2];
      temp[3*i+2] = data[dx*4 +3];
    }else{
      temp[3*i] = 0;
      temp[3*i+1] = 0;
      temp[3*i+2] = 0;
    }
  }

  MPI_Allreduce(temp, cmean, 3*K, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);

  return;
}

void assignMean(double* cmean, int K, double* data, int count, int* cluster, double* my_info, int myrank){
  int n=count/4;
  int minj=-1;
  
  int i;
  for(i=0;i<4*K;i++){
    my_info[i]=0;
  }

  int flag=0;
  
  for(i=0;i<n;i++){
    double mind=DBL_MAX;
    int j;
    for(j=0;j<K;j++){
      double tempd=0;
      int k;
      for(k=0;k<3;k++){
        double diff = (cmean[3*j+k]-data[i*4 + k + 1]);
        tempd = tempd + diff*diff;
      }

      if(mind>tempd){
        mind=tempd;
        minj=j;
      }
    }
    cluster[i]=minj;

    my_info[minj*4] += 1; //data[i*4];
    my_info[minj*4 + 1] += data[i*4 + 1];
    my_info[minj*4 + 2] += data[i*4 + 2];
    my_info[minj*4 + 3] += data[i*4 + 3];
  }

}

int recomputeMean(double* cmean,int K,int size_double,double* my_info,double* global_info, int myrank, double thres){
  MPI_Allreduce(my_info, global_info, 4*K, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);
  double newmean[3];
  int below=0;
  int i;
  for(i=0;i<K;i++){
    double cnt = global_info[4*i];
    if(cnt==0){
      continue;
    }
    newmean[0] = global_info[4*i+1]/cnt;
    newmean[1] = global_info[4*i+2]/cnt;
    newmean[2] = global_info[4*i+3]/cnt;

    double error=0;
    int k;
    for(k=0;k<3;k++){
      error = error + (newmean[k]-cmean[3*i+k])*(newmean[k]-cmean[3*i+k]);
    }
    if(error<=thres){
      // if(myrank==0) printf("%lf %lf\n", error, thres);
      below++;
    }

    cmean[3*i] = newmean[0];
    cmean[3*i+1] = newmean[1];
    cmean[3*i+2] = newmean[2];
  }
  
  return below!=K;
}

void setIndices(double* data, int count, int* id){
  int n=count/4;
  int i;
  for(i=0;i<n;i++){
    id[i] = data[i*4];
  }
}

int main( int argc, char *argv[])
{
  srand(time(0));

  if(argc<6){
    printf("Usage: %s file_prefix no_files K output_file data_file.\n", argv[0]);
    return 0;
  }

  // Take Inputs
  char* file_prefix = argv[1];
  int no_files = atoi(argv[2]);
  int K = atoi(argv[3]);
  char* output_file = argv[4];
  char* data_file = argv[5];

  FILE *of_ptr = fopen(output_file, "a");
  FILE *df_ptr = fopen(data_file, "a");

  // Initialize
  int myrank, size;
  MPI_Status status;
  MPI_Init(0,0);
  MPI_Comm_rank( MPI_COMM_WORLD, &myrank );
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  
  int iteration;
  for(iteration=0;iteration<5;iteration++){
    if(myrank==0){
        printf("ITERATION %d\n", iteration);
    }
    if(myrank==0){
        fprintf(of_ptr, "------\n");
        fprintf(of_ptr, "Number of processes: %d\n", size);
    }
    double g_avgpre=0, g_avgpro=0, g_tot=0;
    char* file_name = (char*)malloc(MAX_LEN*sizeof(char));
    int file_no;
    for(file_no=0;file_no<no_files;file_no++){
        if(myrank==0){
            printf("file%d ", file_no);
        }
        sprintf(file_name, "%s%d", file_prefix, file_no);

        MPI_Barrier(MPI_COMM_WORLD);
        double tot_time=MPI_Wtime();

        double start=MPI_Wtime();
        MPI_File fh;
        MPI_File_open(MPI_COMM_WORLD, file_name, MPI_MODE_RDONLY, MPI_INFO_NULL, &fh);

        int size_double;
        MPI_Type_size(MPI_DOUBLE, &size_double);

        double* data;
        int count;
        
        readFile(fh, size_double, size, myrank, &status, &data, &count);
        MPI_File_close(&fh);

        int num_el = count/4;

        double pre_time = MPI_Wtime() - start;

        start = MPI_Wtime();

        double* cmean = (double*)malloc(3*K*sizeof(double));
        initMean(cmean, data, count, size_double, K, myrank, size);

        int* cluster = (int*)malloc(num_el*sizeof(int));
        double* global_info = (double*)malloc(4*K*sizeof(double));
        double* my_info = (double*)malloc(4*K*sizeof(double));
        
        double thres = 2e-6;
        int iter = 200;
        while(iter--){
            assignMean(cmean,K,data,count,cluster,my_info,myrank);

            MPI_Barrier(MPI_COMM_WORLD);

            int donext = recomputeMean(cmean,K,size_double,my_info,global_info,myrank,thres);
            /*if(donext==0){
            // if(myrank==0) printf("Converge at %d\n", 200-iter);
            break;
            }*/

            MPI_Barrier(MPI_COMM_WORLD);
        }

        double process_time = MPI_Wtime()-start;
        double total_time = MPI_Wtime()-tot_time;

        double proc, tot, prep;

        MPI_Reduce(&total_time, &tot, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
        MPI_Reduce(&pre_time, &prep, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);
        MPI_Reduce(&process_time, &proc, 1, MPI_DOUBLE, MPI_MAX, 0, MPI_COMM_WORLD);

        g_tot = g_tot + tot;
        g_avgpre = g_avgpre + prep;
        g_avgpro = g_avgpro + proc;

        if(myrank==0){
            fprintf(of_ptr, "T%d: %d, ", file_no+1, K);
            int i;
            for(i=0;i<K;i++){
            if(global_info[4*i]!=0){
                fprintf(of_ptr, "<%lf, (%lf, %lf, %lf)>", global_info[4*i], cmean[3*i], cmean[3*i+1], cmean[3*i+2]);
            }
            if(i<K-1){
                fprintf(of_ptr, ", ");
            }else{
                fprintf(of_ptr, " ");
            }
            }fprintf(of_ptr, "\n");
        }

        free(data);
        free(cmean);
        free(cluster);
        free(my_info);
        free(global_info);
    }
    g_avgpre = g_avgpre / no_files;
    g_avgpro = g_avgpro / no_files;
    if(myrank==0){
        fprintf(of_ptr, "Average time to pre-process: %lf\n", g_avgpre);
        fprintf(of_ptr, "Average time to process: %lf\n", g_avgpro);
        fprintf(of_ptr, "Total time: %lf\n", g_tot);
        fprintf(df_ptr, "%d %lf %lf %lf\n", size, g_tot, g_avgpre, g_avgpro);
    }
    free(file_name);
  }
  if(myrank==0){
      fprintf(of_ptr, "------\n");
  }

  return 0;

}
