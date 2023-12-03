#!/usr/bin/env bash
set -euo pipefail

data="${1:-MUST_PROVIDE_INPUT_FILE}"

# Part 1
sum=0
while read -r line ; do
  first_digit="$( { grep -E -o '[0-9]' <<< "${line}" || true ; } | head -n1)"
  second_digit="$( { grep -E -o '[0-9]' <<< "${line}" || true ; } | tail -n1)"
  digits="${first_digit}${second_digit}"
  sum="$((sum + digits))"
done < "${data}"

printf 'Part 1: %s\n' "${sum}"

# Part 2
regex='[0-9]|zero|one|two|three|four|five|six|seven|eight|nine'
zero=0
one=1
two=2
three=3
four=4
five=5
six=6
seven=7
eight=8
nine=9

sum=0
while read -r line ; do
  digits=''
  first_digit="$( { grep -E -o "${regex}" <<< "${line}" || true ; } | head -n1)"
  second_digit="$( { grep -E -o "${regex}" <<< "${line}" || true ; } | tail -n1)"

  if [[ -n "${first_digit}" ]]; then
    if grep -E '[0-9]' > /dev/null <<< "${first_digit}" ; then
      digits="${digits}${first_digit}"
    else
      digits="${digits}${!first_digit}"
    fi
  fi
  if [[ -n "${second_digit}" ]]; then
    if grep -E '[0-9]' > /dev/null <<< "${second_digit}" ; then
      digits="${digits}${second_digit}"
    else
      digits="${digits}${!second_digit}"
    fi
  fi

  if [[ -z "${digits}" ]] ; then
    digits=0
  fi
  sum="$((sum + digits))"
done < "${data}"

printf 'Part 2: %s\n' "${sum}"
