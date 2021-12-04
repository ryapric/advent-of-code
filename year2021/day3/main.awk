#!/usr/bin/env -S gawk -f

# Empty FS, since there's one "field" but we need them all separate for easier
# processing
BEGIN {
  FS = ""
}

function bin2dec(binary_val) {
  # Binary indices of each value & the power should match range lengths, and be
  # inverse of each other (i.e. where the 12th character is the first,
  # little-endian bit). So, we're gonna loop it starting from that last char for
  # hopefully more clarity
  decimal_val = 0
  num_bits = length(binary_val)
  for (bitpos = num_bits; bitpos >= 1; bitpos--) {
    pwr = (num_bits - bitpos)
    # printf("Running %s * 2^%s\n", substr(binary_val, bitpos, 1), pwr)
    decimal_val += (substr(binary_val, bitpos, 1) * (2 ^ pwr))
  }
  return decimal_val
}

{
  for (field = 1; field <= NF; field++) {
    x[field][NR] = $field
  }
}

END {
  ### PART 1
  for (col = 1; col <= NF; col++) {
    for (row = 1; row <= FNR; row++) {
      sum += x[col][row]
    }
    if ((sum / FNR) > 0.5) {
      most_common_bit[col] = 1
    } else {
      most_common_bit[col] = 0
    }
    sum = 0
  }

  for (b in most_common_bit) {
    gamma_binary = sprintf("%s%s", gamma_binary, most_common_bit[b])
    if (most_common_bit[b] == 0) {
      epsilon_binary = sprintf("%s%s", epsilon_binary, 1)
    } else {
      epsilon_binary = sprintf("%s%s", epsilon_binary, 0)
    }
  }
  print "Gamma binary: " gamma_binary
  print "Epsilon binary: " epsilon_binary

  gamma_decimal = bin2dec(gamma_binary)
  epsilon_decimal = bin2dec(epsilon_binary)

  print "Gamma decimal: " gamma_decimal
  print "Epsilon decimal: " epsilon_decimal

  print "SUBMARINE POWER OUTPUT: " (gamma_decimal * epsilon_decimal)

  ### PART 2
  
}
