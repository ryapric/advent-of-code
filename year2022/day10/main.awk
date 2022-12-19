#!/usr/bin/env -S gawk -f

BEGIN {
  register_x = 1
  screen_contents = ""

  # Starting pixel coverage of the sprite -- pixel 2 is the middle that actually moves
  sprite = "1,2,3"

  # Make array of signal-strength checkpoints, with a dummy upper bound just so
  # we have a stopping point
  for (i = 20 ; i <= 1000 ; i += 40) {
    signal_strength_checkpoints[i] = i
  }
}

function calculate_signal_strength(cycle_number, register_val) {
  if (cycle_number in signal_strength_checkpoints) {
    signal_strength = (cycle_number * register_val)
  } else {
    signal_strength = 0
  }
  return signal_strength
}

function draw_CRT(cycle_number, screen_contents, sprite_coverage) {
  split(sprite_coverage, sprite_coverage_array, ",")

  if (cycle_number == sprite_coverage_array[1] || cycle_number == sprite_coverage_array[2] || cycle_number == sprite_coverage_array[3]) {
    pixel = "#"
  } else {
    pixel = "."
  }

  # Also slap on a newline if we're about to wrap around the 40-pixel screen width
  if (cycle_number % 40 == 0) {
    pixel = pixel "\n"
  }
  return screen_contents pixel
}

/^noop/ {
  cycles += 1
  signal_strength_sum += calculate_signal_strength(cycles, register_x)
  screen_contents = draw_CRT(cycles, screen_contents, sprite)
}

/^addx/ {
  # Two cycles to finish, and each cycle of that could be a signal-strength checkpoint
  for (i = 1 ; i <= 2 ; i++) {
    cycles += 1
    signal_strength_sum += calculate_signal_strength(cycles, register_x)
  }

  screen_contents = draw_CRT(cycles, screen_contents, sprite)

  # Register value isn't updated until the end of the cycle
  register_x += $2

  # Now move the sprite based on the new register value (this is kind of a wonky approach, but)
  split(sprite, sprite_array, ",")
  sprite = (sprite_array[1] + register_x - 1) "," (sprite_array[2] + register_x) "," (sprite_array[3] + register_x + 1)
}

END {
  print "Sum of signal strengths: " signal_strength_sum

  # Part 2 -- not currently working
  print screen_contents
}
