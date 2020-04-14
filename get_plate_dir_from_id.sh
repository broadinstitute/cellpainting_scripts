#!/bin/bash

programname=$0

function usage {
    echo "usage:$programname <batch-id> <plate-id>"

    exit 1

}

if [ $# -ne 2 ]; then
    (>&2 echo "Incorrect number of arguments")

    exit

fi

batch_id=$1

plate_id=$2

topdir=../..

image_dir=`readlink -e ${topdir}/images/${batch_id}/`

if ls -d ${image_dir}/${plate_id}* 1> /dev/null 2>&1; then
    plate_dir=`ls -d ${image_dir}/${plate_id}*`
    n_plates=`find ${image_dir} -maxdepth 1 -type d -name "${plate_id}*"|wc -l`

else
    (>&2 echo "No plates with id $plate_id. Exiting. ")

    exit

fi

if [ $n_plates -ne 1 ]; then
    (>&2 echo "Multiple ($n_plates) plates with that id. Exiting.")

    exit

fi

plate_dir=$(basename "$plate_dir")

echo $plate_dir

