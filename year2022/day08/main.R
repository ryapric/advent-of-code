#!/usr/bin/env Rscript

forest0 <- read.table(commandArgs(TRUE)[1], colClasses = "character")

# I could do this *way* more elegantly with e.g. a do.call(), but I gave up
# pretty early
forest <- data.frame()
for (r in seq_len(nrow(forest0))) {
  forest <- rbind(forest, as.numeric(unlist(strsplit(forest0[r, ], ""))))
}
colnames(forest) <- paste0("X", seq_len(ncol(forest)))

### Part 2
scenic_scores <- data.frame(matrix(ncol = ncol(forest), nrow = nrow(forest)))
colnames(scenic_scores) <- colnames(forest)

# Loop n' check by storing in another dataframe. We don't need to check the
# outer perimeter of trees since they're always visible, and we set them as such
# before we loop
visible_trees <- data.frame(matrix(ncol = ncol(forest), nrow = nrow(forest)))
colnames(visible_trees) <- colnames(forest)
visible_trees[1, ] <- 1
visible_trees[, 1] <- 1
visible_trees[nrow(visible_trees), ] <- 1
visible_trees[, ncol(visible_trees)] <- 1

for (r in seq(2, nrow(forest) - 1)) {
  for (c in seq(2, ncol(forest) - 1)) {
    # God this is gross, but we have to check this way because of how the
    # treeline visibility is set up. Basically if an immediately-adjacent tree
    # is the same height as the tree of interest, it's NOT visible, and so we
    # need to be explicit about that before we do height comparisons against
    # the rest of the trees along each cardinal direction
    visible_from_top <- ifelse(
      any(forest[r, c] == forest[seq(1, r - 1), c]), FALSE,
      (forest[r, c] > max(forest[seq(1, r - 1), c]))
    )
    visible_from_right <- ifelse(
      any(forest[r, c] == forest[r, seq(c + 1, ncol(forest))]), FALSE,
      (forest[r, c] > max(forest[r, seq(c + 1, ncol(forest))]))
    )
    visible_from_bottom <- ifelse(
      any(forest[r, c] == forest[seq(r + 1, nrow(forest)), c]), FALSE,
      (forest[r, c] > max(forest[seq(r + 1, nrow(forest)), c]))
    )
    visible_from_left <- ifelse(
      any(forest[r, c] == forest[r, seq(1, c - 1)]), FALSE,
      forest[r, c] > max(forest[r, seq(1, c - 1)])
      )
    if (
      visible_from_top ||
      visible_from_right ||
      visible_from_bottom
      || visible_from_left
    ) {
      visible_trees[r, c] <- 1
    } else {
      visible_trees[r, c] <- 0
    }

    ### Part 2
    view_distance_up <- 0
    view_distance_right <- 0
    view_distance_down <- 0
    view_distance_left <- 0

    for (i in seq(r - 1, 1)) { # intentionally decrementing
      view_distance_up <- view_distance_up + 1
      if (forest[i, c] >= forest[r, c]) {
        break
      }
    }

    for (i in seq(c + 1, ncol(forest))) {
      view_distance_right <- view_distance_right + 1
      if (forest[r, i] >= forest[r, c]) {
        break
      }
    }

    for (i in seq(r + 1, nrow(forest))) {
      view_distance_down <- view_distance_down + 1
      if (forest[i, c] >= forest[r, c]) {
        break
      }
    }

    for (i in seq(c - 1, 1)) { # intentionally decrementing
      view_distance_left <- view_distance_left + 1
      if (forest[r, i] >= forest[r, c]) {
        break
      }
    }

    scenic_scores[r, c] <- prod(view_distance_up, view_distance_right, view_distance_down, view_distance_left)
  }
}

print(paste("Visible trees:", sum(visible_trees)))
print(paste("Best scenic score:", max(scenic_scores, na.rm = TRUE)))
