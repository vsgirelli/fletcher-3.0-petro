#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --partition=draco
#SBATCH --nodelist=draco1
#SBATCH --reservation=vsgirelli_32

#export ACC_DEVICE_TYPE=HOST

printf "\t Running on $SLURM_JOB_NODELIST \n\n"
date
hostnamectl

#source /home/intel/bin/compilervars.sh intel64

app=$1
METRIC=$2
threads=$3
len=$4
t=$5
date=`date +"%m-%d-%y.%H:%M:%S"`

cd ~/fletcher-3.0-petro/$app/
make clean
make backend=OpenMP

cp ModelagemFletcher.exe $SCRATCH

export OMP_NUM_THREADS=$threads
export GOMP_CPU_AFFINITY="0-14:2"
export LD_PRELOAD=/usr/lib/libhugetlbfs.so
export HUGETLB_MORECORE=1G

echo Start

cd $SCRATCH

for iter in {1..10}; do
  # -a all-cpus -A no-aggregate
  # however, if we use the -a option, perf will collect from literally all the cpus, not only
  # from the cpus used by the application
  perf stat -a -e $METRIC ./ModelagemFletcher.exe TTI $len $len $len 16 12.5 12.5 12.5 0.001 $t 2> /tmp/perf 1> /dev/null
  cp /tmp/perf ~/perf/${app}${len}${METRIC}$SLURM_JOB_NODELIST.txt
  OUTMETRIC=`echo $METRIC | sed 's/\./-/g' | sed 's/\_/-/g'`
  outfile=~/fletcher-3.0-petro/Original/run/results/fletcher.$app.$OUTMETRIC.$len.$SLURM_JOB_NODELIST.csv
  if [ ! -f $outfile ]; then
    echo Creating file $outfile
    echo 'app,len,t,metric,value' > $outfile
  fi
  VALUE=`cat /tmp/perf | grep $METRIC | awk '{print $1}' | sed 's/\.//g'`
  echo $app,$len,$t,$OUTMETRIC,$VALUE >> $outfile
done
date

echo Done
