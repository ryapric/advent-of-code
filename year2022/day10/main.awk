#!/usr/bin/env -S gawk -f

function calculate_signal_strength(cycle_number, register_val) {
  if (cycles in signal_strength_checkpoints) {
    signal_strength = (cycle_number * register_val)
  } else {
    signal_strength = 0
  }
  return signal_strength
}

BEGIN {
  register_x = 1

  # Make array of signal-strength checkpoints, with a dummy upper bound just so
  # we have a stopping point
  for (i = 20 ; i <= 1000 ; i += 40) {
    signal_strength_checkpoints[i] = i
  }
}

/^noop/ {
  cycles += 1
  signal_strength_sum += calculate_signal_strength(cycles, register_x)
}

/^addx/ {
  # Two cycles to finish, and each cycle of that could be a signal-strength checkpoint
  for (i = 1 ; i <= 2 ; i++) {
    cycles += 1
    signal_strength_sum += calculate_signal_strength(cycles, register_x)
  }

  # Register value isn't updated until the end of the cycle
  register_x += $2
}

END {
  print "Sum of signal strengths: " signal_strength_sum
}
