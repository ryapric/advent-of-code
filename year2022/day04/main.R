#!/usr/bin/env Rscript

input <- readLines("./input.txt")

ranges <- lapply(input, function(x) {
  sapply(gsub("-", ":", unlist(strsplit(x, ","))), function(y) eval(parse(text = y)), simplify = FALSE, USE.NAMES = FALSE)
})
all_captured_count <- sum(sapply(ranges, function(x) all(x[[1]] %in% x[[2]]) || all(x[[2]] %in% x[[1]])))
print(paste("How many ranges fully overlap:", all_captured_count))

any_captured_count <- sum(sapply(ranges, function(x) any(x[[1]] %in% x[[2]]) || any(x[[2]] %in% x[[1]])))
print(paste("How many ranges overlap at all:", any_captured_count))
