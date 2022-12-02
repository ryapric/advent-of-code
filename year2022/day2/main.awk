#!/usr/bin/env -S gawk -f

BEGIN {
  # Map of round matchups where the left letter is their move and the right is mine
  # A & X are rock, B & Y are paper, C & Z are scissors
  matchup["A X"] = "draw"
  matchup["A Y"] = "win"
  matchup["A Z"] = "loss"
  matchup["B X"] = "draw"
  matchup["B Y"] = "win"
  matchup["B Z"] = "loss"
  matchup["C X"] = "draw"
  matchup["C Y"] = "win"
  matchup["C Z"] = "loss"

  # Scoring
  shape_score["X"] = 1
  shape_score["Y"] = 2
  shape_score["Z"] = 3

  # Round score
  draw_points = 3
  win_points  = 6
}

{
  outcome = matchup[$0]
  if (outcome == "win") {
    score += win_points
  } else if (outcome == "draw") {
    score += draw_points
  }

  # Plus you always get your shape score
  score += shape_score[$2]
}

END {
  printf("Total score, part 1: %s\n", score)
}
