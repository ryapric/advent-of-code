#!/usr/bin/env bash
set -euo pipefail

input="${1}"

read -ra input <<< "$(sed 's/./& /g' ./${input})"
start_of_run_length='start_of_run_length' # dummy var for nested-var interpolation
start_of_run_length_packet=4
start_of_run_length_message=14

for signature in packet message ; do
  pos='-1' # Start at -1 so we can increment straight to index 0
  for _ in "${input[@]}"; do
    pos="$((pos + 1))"
    if [[ "${pos}" -lt $((${start_of_run_length}_${signature} - 1)) ]]; then continue; fi

    # Buffer loop to put chars on their own lines so they're uniq-able
    # this is a nasty artihmetic expansion lol
    for char in $(echo "${input[@]:$((pos-(${start_of_run_length}_${signature}-1))):${start_of_run_length}_${signature}}"); do
      echo "${char}"
    done > /tmp/uniq-able

    uniqe_chars="$(sort /tmp/uniq-able | uniq  | wc -l)"
    if [[ "${uniqe_chars}" -eq "${start_of_run_length}_${signature}" ]] ; then
      printf 'This many chars processed until start-of-%s run length of %s found: %s\n' "${signature}" "$((${start_of_run_length}_${signature}))" "$((pos + 1))"
      break
    fi
  done
done
