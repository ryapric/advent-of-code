#!/usr/bin/env bash
set -euo pipefail

read -ra input <<< "$(sed 's/./& /g' ./input.txt)"
desired_nonrepeating=4

pos='-1' # Start at -1 so we can increment straight to index 0
for _ in "${input[@]}"; do
  pos="$((pos + 1))"
  if [[ "${pos}" -lt 3 ]]; then continue; fi

  # Buffer loop to put chars on their own lines so they're uniq-able
  for char in $(echo "${input[@]:$((pos-3)):${desired_nonrepeating}}"); do
    echo "${char}"
  done > /tmp/uniq-able
  uniqe_chars="$(sort /tmp/uniq-able | uniq  | wc -l)"
  if [[ "${uniqe_chars}" -eq "${desired_nonrepeating}" ]] ; then
    printf "This many chars processed until a nonrepeating sequence of %s found: %s\n" "${desired_nonrepeating}" "$((pos + 1))"
    break
  fi
done
