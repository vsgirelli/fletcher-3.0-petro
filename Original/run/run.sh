#!/usr/bin/env bash
# used only for testing modifications in the application code

#echo "running ../ModelagemFletcher.exe TTI 248 248 248 16 12.5 12.5 12.5 0.001 1.0 | tee log.txt"
#time ../ModelagemFletcher.exe TTI 248 248 248 16 12.5 12.5 12.5 0.001 1.0 | tee log.txt

app=ModelagemFletcher.exe
set -o errexit -o nounset -o pipefail -o posix

metrics=(cycles,instructions,L1-dcache-loads,L1-dcache-stores,fp_arith_inst_retired.double
fp_arith_inst_retired.packed,fp_arith_inst_retired.scalar,fp_arith_inst_retired.scalar_double,fp_arith_inst_retired.scalar_single
fp_arith_inst_retired.single,br_inst_exec.all_branches,branches)

threads=16

for (( len=120; len<=504; len+=32 )) ; do
  if [[ $len == 120 ]] ; then
    t=1.4
  elif [[ $len == 152 ]] ; then
    t=0.7
  elif [[ $len == 184 ]] ; then
    t=0.4
  elif [[ $len == 216 ]] ; then
    t=0.24
  elif [[ $len == 248 ]] ; then
    t=0.16
  elif [[ $len == 280 ]] ; then
    t=0.11
  elif [[ $len == 312 ]] ; then
    t=0.08
  elif [[ $len == 344 ]] ; then
    t=0.06
  elif [[ $len == 376 ]] ; then
    t=0.046
  elif [[ $len == 408 ]] ; then
    t=0.036
  elif [[ $len == 440 ]] ; then
    t=0.028
  elif [[ $len == 472 ]] ; then
    t=0.023
  elif [[ $len == 504 ]] ; then
    t=0.020
  fi

  for app  in Der1Der1HM Der1Der1LM Der1Der1Orig Original; do
    for METRIC in "${metrics[@]}"; do
      sbatch -J "$app.$len.$METRIC" run.slurm.msserpa $app $METRIC $threads $len $t 
    done
  done
done
