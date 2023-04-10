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
  #args=""${VAL}"_host.cpp -o "${VAL}".hipcc -DPOLYBENCH_DUMP_ARRAYS -I. -I"${ROOT_DIR}"/utilities "${ROOT_DIR}"/utilities/polybench.c"
  args=""${VAL}"_host.cpp -o "${VAL}".hipcc -DPOLYBENCH_TIME  -I. -I"${ROOT_DIR}"/utilities "${ROOT_DIR}"/utilities/polybench.cpp"
  echo "=====> hipcc $args"
  hipcc $args
  cd ${ROOT_DIR}
done < utilities/benchmark_dir
