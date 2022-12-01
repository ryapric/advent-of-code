#!/usr/bin/env -S gawk -f

{
  if (length($0) > 0) {
    elfCalories += $0
  } else {
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
  printf("Elf with the most has this many calories: %d\n", mostCalories)

  printf("The top three elves have this many calories: %d\n", mostCalories + secondMostCalories + thirdMostCalories)
}
