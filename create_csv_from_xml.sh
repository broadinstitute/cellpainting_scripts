#!/bin/bash
source ./util.sh

progname=`basename $0`

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -b|--batchid)
    batch_id="$2"
    shift
    ;;
    --plate)
    plate_id="$2"
    shift
    ;;
    --illum_pipeline_name)
    illum_pipeline_name="$2"
    shift
    ;;
    --dir_above_project_dir)
    dir_above_project_dir="$2"
    shift
    ;;
    --dont_overwrite_datafile)
    dont_overwrite_datafile=YES
    ;;
    --delete_empty_illum_dir)
    delete_empty_illum_dir=YES
    ;;
    --match_full_plate_id)
    match_full_plate_id=YES
    ;;
    *)
    echo "unknown option"
    ;;
esac
shift
done

delete_empty_illum_dir="${delete_empty_illum_dir:-unspecified}"

dont_overwrite_datafile="${dont_overwrite_datafile:-unspecified}"

match_full_plate_id="${match_full_plate_id:-unspecified}"

illum_pipeline_name="${illum_pipeline_name:-illum}"

dir_above_project_dir="${dir_above_project_dir:-/home/ubuntu/bucket/projects}"

# Match full plate id, or allow substring matches? 
# Allowing substring matches is useful when the plate names are long e.g. cmqtlpl261-2019-mt__2019-06-10T10_44_25-Measurement2
# However if plate names are short, and there is ambiguity with substrings e.g. Replicate_1 and Replicate_10 then use `match_full_plate_id` = `YES`

if [[ ${match_full_plate_id} == "YES" ]]; then
    plate_dir=${plate_id}

else
    plate_dir=`./get_plate_dir_from_id.sh ${batch_id} ${plate_id}`

fi


echo $plate_dir

info "creating csv for ${plate_id}"

base_dir=../..

pe2loaddata_dir=`readlink -m ${base_dir}/software/pe2loaddata`

check_path exists ${pe2loaddata_dir}

image_dir=`readlink -m ${base_dir}/images/$batch_id/"${plate_dir}"/Images/`

check_path exists "${image_dir}"

datafile_dir=${base_dir}/load_data_csv/${batch_id}/${plate_id}

datafile_dir=$(create_and_check_dir $datafile_dir)

datafile=${datafile_dir}/load_data.csv

datafile_with_illum=${datafile_dir}/load_data_with_illum.csv

illum_base_dir=../../..

project_name=$(basename $(readlink -m $illum_base_dir))

illum_dir=`readlink -m ${dir_above_project_dir}`/${project_name}/${batch_id}/illum/${plate_id}

illum_dir=$(create_and_check_dir $illum_dir)

echo Using ${illum_dir} as the directory for illumination correction outputs

if [[ ${dont_overwrite_datafile} == "YES" ]]; then
    echo "n" | check_path not_exists ${datafile}

else
    check_path not_exists ${datafile}

fi

check_result=$?

if [[ $check_result = 0 || $check_result = 1 ]]; then
    rm -rf ${datafile}

    pe2loaddata \
        --index-directory "${image_dir}" \
        config.yml \
        ${datafile} \
        --illum --illum-directory ${illum_dir} --plate-id ${plate_id} --illum-output ${datafile_with_illum}

fi

check_path exists ${datafile}

check_path exists ${datafile_with_illum}

if [[ ${delete_empty_illum_dir} == "YES" ]]; then

    if [ ! "$(ls -A ${illum_dir})" ]; then
        rmdir ${illum_dir}

    fi
fi
