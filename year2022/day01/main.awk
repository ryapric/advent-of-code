#!/usr/bin/env -S gawk -f

{
  # Empty lines indicate that we've moved on to the next elf
  if (length($0) > 0) {
    elfCalories += $0
  } else {
    # Does awk have case statements? Eugh.
    if (elfCalories > mostCalories) {
      mostCalories = elfCalories
    } else if (elfCalories > secondMostCalories) {
      secondMostCalories = elfCalories
    } else if (elfCalories > thirdMostCalories) {
      thirdMostCalories = elfCalories
    }
    # Reset if we see a blank line because that means we've moved on to the next elf
    elfCalories = 0
  }
}

END {
  # Part 1
  printf("Elf with the most has this many calories: %d\n", mostCalories)

  # Part 2
  printf("The top three elves have this many calories: %d\n", mostCalories + secondMostCalories + thirdMostCalories)
}
