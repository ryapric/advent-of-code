#!/usr/bin/env -S gawk -f

{
  direction[NR] = $1
  displacement[NR] = $2
}

END {
  for (i = 1; i <= NR; i++) {
    if (direction[i] == "forward") {
      horizontal += displacement[i]
      depth2 += (aim * displacement[i])
    }
    if (direction[i] == "up") {
      depth1 -= displacement[i]
      aim -= displacement[i]
    }
    if (direction[i] == "down") {
      depth1 += displacement[i]
      aim += displacement[i]
    }
  }

  print "Total horizontal displacement: " horizontal
  print "Total depth (pt. 1): " depth1
  print "Product (pt. 1): " (horizontal * depth1)

  print "Total depth (pt. 2): " depth2
  print "Product (pt. 2): " (horizontal * depth2)
}
