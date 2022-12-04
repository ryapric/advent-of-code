input <- readLines("./input.txt")

# This splits each line into its rucksack compartment components
compartments <- lapply(strsplit(input, ""), function(x) {
  c(
    paste0(x[1:(length(x) / 2)], collapse = ""),
    paste0(x[((length(x) / 2) + 1):length(x)], collapse = "")
  )
})

# ... finds the items common between each rucksack compartment
overlaps <- lapply(compartments, function(x) intersect(unlist(strsplit(x[1], "")), unlist(strsplit(x[2], ""))))
# ... assigns their priority
overlap_priorities <- lapply(overlaps, function(x) which(x == c(letters, LETTERS)))
# ... and sums those priority numbers
print(paste("Sum of item priorities:", sum(sapply(overlap_priorities, function(x) x))))


# Part 2 makes this a bit wonkier, and we might actually need a real loop
sum_priority <- 0
for (i in seq(1, length(compartments), 3)) {
  # Un-split the compartments first
  rucksacks <- list(
    one = unlist(strsplit(paste0(compartments[[i]][1], compartments[[i]][2]), "")),
    two = unlist(strsplit(paste0(compartments[[i+1]][1], compartments[[i+1]][2]), "")),
    three = unlist(strsplit(paste0(compartments[[i+2]][1], compartments[[i+2]][2]), ""))
  )
  # Get the badge's letter & add its priority
  badge <- Reduce(intersect, rucksacks)
  sum_priority <- sum_priority + which(badge == c(letters, LETTERS))
}

print(paste("Sum of item priorities (pt2):", sum_priority))
