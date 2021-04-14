# calculate a correlation for all possible combinations of variables
crrMtx = abs(cor(sapply(data[2:26], jmvcore::toNumeric), use = "pairwise"))
# the correlation with itself is always 1, we don't want to include that
diag(crrMtx) <- NA
# check for correlations above 0.3 - it should be
# larger than 0; depending on number of variables
# and number of assumed factors a rule of thumbs to
# raise concerns is if fewer than ~10% of the variables
# have so low correlations
print('Number of correlations above 0.3 - should be more than 0')
sort(apply(crrMtx > 0.3, 2, sum, na.rm = TRUE))
# check for correlations above 0.9 - it should be
# 0 throughout
print('Number of correlations above 0.9 - should be 0 for all')
sort(apply(crrMtx > 0.9, 2, sum, na.rm = TRUE))
