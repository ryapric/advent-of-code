#!/usr/bin/awk -f

{
  # Store the whole file in an array so we can index it later
  x[NR] = $1
}

END {
  # Part 1 - single-value changes
  for (i = 2; i <= NR ; i++) {
    if ((x[i] - x[i-1]) > 0) {
      changes++
    }
  }

  # Part 2 - sliding window of 3-value changes
  for (i=4; i <= NR; i++) {
    if ((x[i] + x[i-1] + x[i-2]) - (x[i-1] + x[i-2] + x[i-3]) > 0) {
      window_changes++
    }
  }

  print "Number of times depth increased: " changes
  print "Number of times windowed depth increased: " window_changes
}
