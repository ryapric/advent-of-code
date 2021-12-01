x <- readLines("day3.txt")
x <- strsplit(x, split = " | @ |: |,|x")

# Part 1 ----
x <- lapply(x, function(elem) {
    elem <- list(claim = elem[1],
                 dleft = as.numeric(elem[2]),
                 dtop = as.numeric(elem[3]),
                 w = as.numeric(elem[4]),
                 h = as.numeric(elem[5]))
    elem$hrange <- paste0(elem$dtop,":",(elem$dtop + elem$h - 1))
    elem$wrange <- paste0(elem$dleft,":",(elem$dleft + elem$w - 1))
    elem
})

matrix_master <- matrix(nrow = 1000, ncol = 1000, data = 0)
for (i in 1:length(x)) {
    hrange <- eval(parse(text = x[[i]]$hrange))
    wrange <- eval(parse(text = x[[i]]$wrange))
    matrix_master[hrange, wrange] <- matrix_master[hrange, wrange] + 1
}

print(length(matrix_master[matrix_master > 1]))

# Part 2 ----
for (i in 1:length(x)) {
    hrange <- eval(parse(text = x[[i]]$hrange))
    wrange <- eval(parse(text = x[[i]]$wrange))
    if (all(matrix_master[hrange, wrange] == 1)) {
        print(i)
    }
}
