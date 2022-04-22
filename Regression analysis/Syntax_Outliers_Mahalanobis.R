# this list should contain the names of your INDEPENDENT VARIABLES
# you should not include your dependent variables
VL = c('dan.sleep', 'baby.sleep', 'day')
# the second line calculates the Mahalanobis distance, and the third
# line the critical chi-square value; if the Mahalanobis distance is
# above the critical value, which will find the entry (which finds
# logical TRUE values) and names will output the row number
names(which(
  mahalanobis(data[, VL], colMeans(data[, VL]), cov(data[, VL])) >
  qchisq(p = 0.001, df = length(VL), lower.tail = FALSE)))
