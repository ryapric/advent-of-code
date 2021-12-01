library(dplyr)
library(stringdist)

x_0 <- readLines("day2.txt")

# Part 1 ----
x <- strsplit(x_0, split = "")
y <- lapply(x, function(elem) {as.data.frame(table(elem), stringsAsFactors = FALSE)})
for (elnum in 1:length(y)) {
    y[[elnum]]$upc <- elnum
}

z <- bind_rows(y) %>%
    group_by(upc) %>%
    mutate(
        two = ifelse(Freq == 2, 1, 0),
        three = ifelse(Freq == 3, 1, 0)
    ) %>%
    ungroup() %>%
    distinct(upc, two, three)

# Answer
print(sum(z$two) * sum(z$three))

# Part 2 ----
strdist <- as.data.frame(stringdistmatrix(x_0, x_0, useNames = TRUE))
mindist <- filter_all(strdist, any_vars(. == 1))
mindist <- select_if(mindist, function(x) any(1 %in% x))

# Answer
same <- strsplit(colnames(mindist), split = "")
print(paste(intersect(same[[1]], same[[2]]), collapse = ""))
