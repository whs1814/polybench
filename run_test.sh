#!/bin/bash
#Note: This script must be run from the root directory of the archive.

Machine=`uname -m`
CC=gcc
CFLASG="-O3 -fopenmp -lm -DPOLYBENCH_TIME"
export COMPILER_COMMAND="$CC $CFLASG"
#export COMPILER_COMMAND="gcc -O3 -fopenmp -lm"
#export COMPILER_COMMAND="gcc -O3 -fopenmp -lm -DPOLYBENCH_TIME"

test -d data || mkdir data
for DIR in linear-algebra/kernels linear-algebra/solvers datamining image-processing stencils
do
  ./scripts/runall.sh ${DIR} $Machine-$CC
done
