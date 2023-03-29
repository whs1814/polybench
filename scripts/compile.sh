#!/bin/sh

if [ $# -ne 4 ]; then
    echo "Usage: compile.sh <archive root dir> <compiler command> <input file> <output file>";
    exit 1;
fi;

ROOTDIR="$1";
COMPILER_COMMAND="$2";
INPUT_FILE="$3";
OUTPUT_FILE="$4";

$COMPILER_COMMAND  -lm -I ${ROOTDIR}/utilities ${ROOTDIR}/utilities/instrument.c ${ROOTDIR}/$INPUT_FILE -o $OUTPUT_FILE

echo "$COMPILER_COMMAND  -lm -I ${ROOTDIR}/utilities ${ROOTDIR}/utilities/instrument.c ${ROOTDIR}/$INPUT_FILE -o $OUTPUT_FILE"


exit 0;
