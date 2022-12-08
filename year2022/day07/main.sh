#!/usr/bin/env bash
set -euo pipefail

input="${1}"

# MAKE THE TREE AND RUN THE ACTUAL SCRIPT LOL. THIS IS SO DANGEROUS -- but I
# checked the total file size created in advance, and it's like 40MB or
# something, so we're fine
workdir='/tmp/AoCY22D07'
rm -rf "${workdir}*"

root="${workdir}_root"

rm -rf "${root}"
mkdir "${root}"

while read -r line ; do
  grep -q -E '^\$ ls' <<< "${line}" && continue

  if grep -q -E '^\$ cd' <<< "${line}" ; then
    dir_i="$(awk '{ print $3 }' <<< "${line}")"

    if [[ "${dir_i}" == '/' ]] ; then
      cd "${root}"
    else
      mkdir -p "${dir_i}"
      cd "${dir_i}"
    fi

  elif grep -q -E '^dir' <<< "${line}" ; then
    dir_i="$(awk '{ print $2 }' <<< "${line}")"
    mkdir -p "${dir_i}"

  elif grep -q -E '^[0-9]+' <<< "${line}" ; then
    file_size="$(awk '{ print $1 }' <<< "${line}")"
    file_name="$(awk '{ print $2 }' <<< "${line}")"
    fallocate -l "${file_size}" "${file_name}"
  fi
done < "${input}"

# NOW, however, we have to do some gross math because (on ext4 FSes) `du`
# reports 4096 bytes for every directory, including the one in question, *and
# every recursive subdirectory*, which does NOT include the file sizes within
# those directories. So, we need to find out how many subdirectories each
# directory has, and subtract 4096*n from the size, where n is the number of
# sudirs

# subdirs_meta will have columns for the path, the recursive subdir count, and
# the pre-adjusted size
all_subdirs='/tmp/AoCY22D07_all_subdirs'
subdirs_meta='/tmp/AoCY22D07_subdirs_meta'

find "${root}"/* -type d > "${all_subdirs}"

rm -f "${subdirs_meta}"
while read -r subdir ; do
  printf '%s %s %s\n' \
    "${subdir}" \
    "$(find "${subdir}" -type d | wc -l)" \
    "$(du --bytes "${subdir}" | awk -v subdir=${subdir} '$2 == subdir { print $1 }')" \
  >> "${subdirs_meta}"
done < "${all_subdirs}"

# Note that the first adjustment is the 4096-per-subdir subtraction, and THEN
# the under-100k check
dirs_under_100k="$(awk '{ $3 -= (4096 * $2) ; if ($3 < 100000) sum += $3 } END { print sum }' "${subdirs_meta}")"
printf 'Sum of dirs & subdirs under 100k each: %s\n' "${dirs_under_100k}"
