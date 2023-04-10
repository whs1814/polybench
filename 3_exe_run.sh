#!/bin/bash
mypwd=`pwd`
while read LINE; do
  #Split into arrays
  OLD_IFS="$IFS"
  IFS=","
  array=($LINE)
  IFS="$OLD_IFS"
  DIR=${array[0]}
  VAL=${array[1]}
  ROOT_DIR=`pwd`
  cd ${DIR}
  bin_name=""${VAL}".hipcc"
  echo "runing "${DIR}"/"${bin_name}"  ..."
#  HIP_VISIBLE_DEVICES=0 time -p	./$bin_name  #2>out_hip.log
  ./$bin_name  #2>out_hip.log
  cd ${ROOT_DIR}
done < utilities/benchmark_dir
