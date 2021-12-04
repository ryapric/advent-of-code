#!/usr/bin/env -S gawk -f

# Empty FS, since there's one "field" but we need them all separate for easier
# processing
BEGIN {
  FS = ""
}

# Awk can't return arrays, but it WILL treat array params as pass-by-reference
function get_most_common_bits(data, most_common_bits_raw) {
  for (col = 1; col <= NF; col++) {
    sum = 0
    for (row = 1; row <= FNR; row++) {
      sum += data[col][row]
    }
    if ((sum / FNR) > 0.5) {
      most_common_bits_raw[col] = 1
    } else {
      most_common_bits_raw[col] = 0
    }
  }
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
    data_colwise[field][NR] = $field
  }
  data_rowwise[NR] = $0
}

END {
  ### PART 1
  get_most_common_bits(data_colwise, most_common_bits)

  for (b in most_common_bits) {
    gamma_binary = sprintf("%s%s", gamma_binary, most_common_bits[b])
    if (most_common_bits[b] == 0) {
      epsilon_binary = sprintf("%s%s", epsilon_binary, 1)
    } else {
      epsilon_binary = sprintf("%s%s", epsilon_binary, 0)
    }
  }

  gamma_decimal = bin2dec(gamma_binary)
  epsilon_decimal = bin2dec(epsilon_binary)

  print "Gamma binary: " gamma_binary
  print "Epsilon binary: " epsilon_binary
  print "Gamma decimal: " gamma_decimal
  print "Epsilon decimal: " epsilon_decimal
  print "SUBMARINE POWER OUTPUT: " (gamma_decimal * epsilon_decimal)

  # ### PART 2
  # get_most_common_bits(data_colwise, most_common_bits)
  # for (b in most_common_bits) {
  #   if (most_common_bits[b] == 0) {
  #     least_common_bits[b] = 1
  #   } else {
  #     least_common_bits[b] = 0
  #   }
  # }

  # # Arrays that hold full row data, and will be filtered according to the
  # # bit-conditions
  # for (i in data_rowwise) {
  #   oxygen_filtered[i] = data_rowwise[i]
  #   co2_filtered[i] = data_rowwise[i]
  # }

  # # Column range of *_common_bits and data_colwise should match
  # for (col = 1; col <= NF; col++) {
  #   for (row = 1; row <= FNR; row++) {
  #     if (data_colwise[col][row] != most_common_bits[col]) {
  #       delete oxygen_filtered[row]
  #       printf("What's left in oxygen_filtered after processing col %s, row %s:\n", col, row)
  #       for (i in oxygen_filtered) {
  #         print oxygen_filtered[i]
  #       }
  #     } else if (data_colwise[col][row] != least_common_bits[col]) {
  #       delete co2_filtered[row]
  #     } else {
  #       continue
  #     }
  #   }
  # }

  # # If there's a tie once you're on the last bit comparison, keep the
  # # value with a 1 in the right place for the oxygen rating, and the value
  # # with a 0 in the right place for the co2 rating
  # if (length(oxygen_filtered) > 1) {
  #   for (tiebreak in oxygen_filtered) {
  #     if (substr(oxygen_filtered[tiebreak], NF, 1) != 1) {
  #       delete oxygen_filtered[tiebreak]
  #     }
  #   }
  # }

  # # Array indices are strings and NOT mutable int locations, so we can't just
  # # pull e.g. oxygen_filtered[0] at the end
  # for (whats_left in oxygen_filtered) {
  #   oxygen_binary = oxygen_filtered[whats_left]
  # }
  # for (whats_left in co2_filtered) {
  #   co2_binary = co2_filtered[whats_left]
  # }

  # oxygen_decimal = bin2dec(oxygen_binary)
  # co2_decimal = bin2dec(co2_binary)

  # print "Oxygen Generator binary: " oxygen_binary
  # print "CO2 Scrubber binary: " co2_binary
  # print "Oxygen Generator decimal: " oxygen_decimal
  # print "CO2 Scrubber decimal: " co2_decimal
  # print "SUBMARINE LIFE SUPPORT RATING: " (oxygen_decimal * co2_decimal)
}
