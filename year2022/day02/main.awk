#!/usr/bin/env -S gawk -f

BEGIN {
  # Map of round matchups where the left letter is their move and the right is mine
  # A & X are rock, B & Y are paper, C & Z are scissors
  matchup["A X"] = "draw" # rock, rock
  matchup["A Y"] = "win"  # rock, paper
  matchup["A Z"] = "loss" # rock, scissors
  matchup["B X"] = "loss" # paper, rock
  matchup["B Y"] = "draw" # paper, paper
  matchup["B Z"] = "win"  # paper, scissors
  matchup["C X"] = "win"  # scissors, rock
  matchup["C Y"] = "loss" # scissors, paper
  matchup["C Z"] = "draw" # scissors, scissors

  # Scoring
  shape_score["X"] = 1
  shape_score["Y"] = 2
  shape_score["Z"] = 3

  # Round score
  draw_points = 3
  win_points  = 6

  # Part 2's logic: col 2 is how the round NEEDS to end: X is lose, Y is draw, Z is win
  # So to get the right shape score, we need to know what to play against the opponent instead
  shape_score2["A X"] = 3 # loss, so play scissors
  shape_score2["A Y"] = 1 # draw, so play rock
  shape_score2["A Z"] = 2 # win, so play paper
  shape_score2["B X"] = 1 # loss, so play rock
  shape_score2["B Y"] = 2 # draw, so play paper
  shape_score2["B Z"] = 3 # win, so play scissors
  shape_score2["C X"] = 2 # loss, so play paper
  shape_score2["C Y"] = 3 # draw, so play scissors
  shape_score2["C Z"] = 1 # win, so play rock
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

  # Part 2
  outcome2 = $2
  if (outcome2 == "Y") { # draw
    score2 += draw_points
  } else if (outcome2 == "Z") { # win
    score2 += win_points
  }
  # Shape score based on
  score2 += shape_score2[$0]
}

END {
  printf("Total score, part 1: %s\n", score)
  printf("Total score, part 2: %s\n", score2)
}
