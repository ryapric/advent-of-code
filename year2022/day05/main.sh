#!/usr/bin/env bash
set -euo pipefail

input_file="${1}"
stacks='/tmp/AoCY22D5_stacks'
instructions='/tmp/AoCY22D5_instructions'

stack_count="$(awk '/^ [0-9]+/ { print NF }' "${input_file}")"
awk '/^move/ { print $2 " " $4 " " $6}' "${input_file}" > "${instructions}"

# First, pull out just the stacks, padding out dummy boxes so we don't have any
# parsing misses with awk etc.
sed -E \
  -e 's/\s\s\s\s/\[-\] /g' \
  -e '/^[^\[]/d' \
  "${input_file}" \
> "${stacks}"

# Split out box stacks into their own files, which we'll cat/tac on later. Also
# remove the dummy placeholder boxes, empty lines, etc. from each stack
for stack in $(seq 1 "${stack_count}") ; do
  awk -v stack="${stack}" '{ print $stack }' "${stacks}" > /tmp/"stack${stack}"
  sed -i -E \
    -e 's/\[-\]/   /g' \
    -e '/(^\s+$)|(^$)/d' \
    /tmp/"stack${stack}"
done

# Process the instructions
while read -r instruction ; do
  read -ra instruction_i <<< "${instruction}"
  count="${instruction_i[0]}"
  from="/tmp/stack${instruction_i[1]}"
  to="/tmp/stack${instruction_i[2]}"

  # You'll notice the use of some var intermediaries that aren't files, because
  # reading & writing from the same file at the same time will wipe it

  # Move the boxes from one stack to another, LIFO ...
  from_contents="$(cat "${from}")"
  to_contents="$(cat "${to}")"
  cat \
    <(echo "${from_contents}" | head -n"${count}" | tac) \
    <(echo "${to_contents}") \
  > "${to}"

  # ... And make the old stack look like it should
  starting_stack_height="$(awk '{ print NR }' "${from}" | tail -n1)"
  boxes_left="$((starting_stack_height - count))"
  tail -n"${boxes_left}" <(echo "${from_contents}") > "${from}"
  # And clean up any newlines that showed up because of empty-file `cat`s
  sed -i -E '/^$/d' "${from}"
  sed -i -E '/^$/d' "${to}"
done < "${instructions}"

# Grab the tops of each stack to report on
rm -f /tmp/stack_tops
for stack in $(seq 1 "${stack_count}") ; do
  head -n1 /tmp/stack"${stack}" | sed -E 's/\[|\]//g' >> /tmp/stack_tops
done

printf 'Topmost crates across stacks: %s\n' "$(tr -d '\n' < /tmp/stack_tops)"
