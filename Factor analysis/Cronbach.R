# Cronbach's alpha sets the inter-item covariances into relation to the total
# amount of variation (i.e., a sum of the inter-item covariances and the item
# variances)

# we use the covariance matrix (cov()) for this calculation: it contains the
# coviarances (outside the main diagonal) and the variances in the main
# diagonal
# adjust the columns [2:6] to match the columns / variables included in your
# Reliability Analysis
X <- cov(data[2:6], use = "complete.obs")
X

# the variances indicate how much any item varies by itself, the
# covariances indicate how much the items vary together
# we first consider the covariances (i.e., their mean)
mean(abs(X[lower.tri(X)]))
# this values is then multiplied with the number of values in the
# covariance matrix (number of rows x number of columns)
mean(abs(X[lower.tri(X)])) * nrow(X) * ncol(X)
# and that values is then set in relation to (i.e., divided by) the total
# amount of variation, we first show the value for the total amount of
# variation
sum(abs(X))
# and then we set the inter-item covariances (their mean multiplied by the
# number of possible combination) into relation to the total variation
mean(abs(X[lower.tri(X)])) * nrow(X) * ncol(X) / sum(abs(X))

# -----------------------------------------------------------------------------

# another way to calculate Cronbach's alpha that may be more “intuitive” is:
# we take the variance-covariance-matrix (X) and copy it to a new variable (Y)
Y <- X
# in that new variable, we replace the values in the main diagonal of Y (the
# variances of each of the variables) with the average value of the
# inter-item-covariances (ie., how much the items in the questionnaire on
# average covary with one another)
diag(Y) <- mean(abs(X[lower.tri(X)]))

# we divide that covariance matrix Y (where we replaced the variances by the
# average inter-item covariances) by the original variance-covariance-matrix (X)
sum(abs(Y)) / sum(abs(X))
