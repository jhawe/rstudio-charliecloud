#!/bin/bash

# Usage:
# ./export_image.sh <dockerfile> <target-dir>

# the dockerfile to build and export
# NOTE: name of the export will be the basename of this file
df=$1
iname=$(basename ${df})

# the directory to which to copy the image
tdir=$2

# call docker build -> create -> export; zip on the fly
mkdir -p ${tdir}

echo "Building image: ${df}"
docker build -f ${df} -t ${iname} . && \
  echo "Creating and exporting container." && \
  docker export $(docker create ${iname}) | gzip -c > ${tdir}/${iname}.tar.gz
