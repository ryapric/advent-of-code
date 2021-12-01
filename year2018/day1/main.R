x <- readLines("day1.txt")
x <- as.numeric(gsub("\\+", "", x))

# Part 1 ----
sum(x)

# Part 2 ----
freq_vec <- numeric()
freq_found <- 0
run_sum <- 0
while (freq_found == 0) {
  for (i in x) {
    run_sum <- run_sum + i
    if (run_sum %in% freq_vec) {
      print(run_sum)
      freq_found <- 1
      break
    } else {
      freq_vec <- c(freq_vec, run_sum)
    }
  }
}
