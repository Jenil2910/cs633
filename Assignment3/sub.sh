#PBS -N kMeans3
#PBS -q courses
#PBS -l nodes=8:ppn=8
#PBS -l walltime=01:59:00
#merge output and error into a single job_name.number_of_job_in_queue.
#PBS -j oe
#export fabric infiniband related variables
export I_MPI_FABRICS=shm:tmi
export I_MPI_DEVICE=rdma:OpenIB-cma
#change directory to where the job has been submitted from
cd $PBS_O_WORKDIR
#source paths
source /opt/software/intel17_update4/initpaths intel64
#sort hostnames
sort $PBS_NODEFILE > hostfile
#run the job on required number of cores

make clean
make

mkdir -p ./data/data1
mkdir -p ./data/data2
mkdir -p ./plot/data1
mkdir -p ./plot/data2

mkdir -p hpc/data1
mkdir -p hpc/data2

K=55

#mpiexec -np $1 -hostfile ./allocator/hostsimproved ./src.x ./input/data1/file0 $1
data_file="./plot/data1/data.dat"
echo "" > "$data_file"
for p in 1 2 4 6 8 10 12 14 16 18 20 24 28 32 40 52 64
do
    echo -n "Running $p: "
    output_file="./hpc/data1/output_$p.txt"
    echo "" > "$output_file"
    mpirun -machinefile hostfile -np $p ./src_all.x ./input/data1/file 17 $K $output_file $data_file
    echo ""
    # echo "mpiexec -np $p -ppn 3 -hostfile ../hostfile ./src_all.x ./input/data1/file 17 $K $output_file $data_file"
done;

K=15

#mpiexec -np $1 -hostfile ./allocator/hostsimproved ./src.x ./input/data1/file0 $1
data_file="./plot/data2/data.dat"
echo "" > "$data_file"
for p in 1 2 4 6 8 10 12 14 16 18 20 24 28 32 40 52 64
do
    echo -n "Running $p: "
    output_file="./hpc/data2/output_$p.txt"
    echo "" > "$output_file"
    mpirun -machinefile hostfile -np $p ./src_all.x ./input/data2/file 16 $K $output_file $data_file
    echo ""
    # echo "mpiexec -np $p -ppn 3 -hostfile ../hostfile ./src_all.x ./input/data1/file 17 $K $output_file $data_file"
done;


