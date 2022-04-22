# the covariance matrix (cov()) contains the coviarances (outside the main
# diagonal) and the variances in the main diagonal
X = cov(data[2:6])
X

# there are options to calculate Cronbach's alpha
# one "ingredient" is the sum of the absolute values of all variances and
# covariances (underneath the fraction bar, i.e., divided by)
sum(abs(X))
# the other "ingredient" is the averaged absolute value of the covariances
# of all variables in the scale (A1 - A2, A1 - A3,  A1 - A4,  A1 - A5,
# A2 - A3,  A2 - A4,  A2 - A5,  A3 - A4,  A3 - A5,  A4 - A5)
mean(abs(X[lower.tri(X)]))
mean(abs(X[lower.tri(X)])) * 5 ^ 2 / sum(abs(X))


# the next command extracts and sums up the variances
sum(diag(X))
 mean(abs(X[lower.tri(X)])) * 5 *  5 /
(mean(abs(X[lower.tri(X)])) * 5 * (5 - 1) + sum(diag(X)))
