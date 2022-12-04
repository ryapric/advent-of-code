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
