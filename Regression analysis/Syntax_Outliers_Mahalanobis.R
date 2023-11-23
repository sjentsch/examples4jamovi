# this list should contain the names of your INDEPENDENT VARIABLES
# you should not include your dependent variables
VL = c('dan.sleep', 'baby.sleep', 'day')
# the lines underneath calculate the Mahalanobis distance (2), and
# whether it is above the critical chi-square value (3); if the
# Mahalanobis distance is above the critical value which(names(...
# will output the row number
outRow <- names(which(
    mahalanobis(data[, VL], colMeans(data[, VL]), cov(data[, VL])) >
    qchisq(p = 0.001, df = length(VL), lower.tail = FALSE)))
# the lines underneath check whether rows with outliers were found
# if so, a string that can be used as filter expression is output,
# otherwise a notice that no outliers were found
if (length(outRow) > 0) {
    # add this output to a filter to exclude
    cat(paste0(paste0("ROW() != ", c("", selRow)), collapse = " and "))
} else {
    cat("There were no outliers found.")
}
