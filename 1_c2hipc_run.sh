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
  #echo "${DIR} ${VAL} ${ROOT_DIR}"
  cd ${DIR}
  #c2hipc ""${VAL}".c -DPOLYBENCH_DUMP_ARRAYS  -DPOLYBENCH_TIME -I. -I"${PWD}"/utilities "${PWD}"/utilities/polybench.c"
  args=""${VAL}".c  -I. -I"${ROOT_DIR}"/utilities -I"${ROOT_DIR}"/utilities/polybench.c"
  #echo ${args}
  c2hipc $args
  cd ${ROOT_DIR}
done < utilities/benchmark_dir
