# Cronbach's alpha sets the inter-item covariances into relation to the
# total amount of variation (i.e., a sum of the inter-item covariances
# and the item variances)

# we use the covariance matrix (cov()) for this calculation: it contains
# the coviarances (outside the main diagonal) and the variances in the
# main diagonal
X = cov(data[2:6])
X

# the variances indicate how much any item varies by itself, the
# covariances indicate how much the items vary together
# we first consider the covariances (i.e., their mean)
mean(abs(X[lower.tri(X)]))
# this values is then multiplied with the number of values in the
# covariance matrix (5 variables x 5 variables)
mean(abs(X[lower.tri(X)])) * 5 ^ 2
# and that values is then set in relation to (i.e., divided by) the total
# amount of variation, we first show the value for the total amount of
# variation
sum(abs(X))
# and then we set the inter-item covariances (their mean multiplied by the
# number of possible combination) into relation to the total variation
mean(abs(X[lower.tri(X)])) * 5 ^ 2 / sum(abs(X))
