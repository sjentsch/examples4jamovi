# calculate a correlation for all possible combinations of variables
# ===========================================================================
# It is important that you adjust [2:26] in the command underneath to the
# number of columns in your data set; in the bfi_sample dataset (that the code
# was written for), we have first the "ID" (which we don't want to include in
# the calculation), and afterwards the variables "A1" to "O5" (that we need).
# Given that "A1" to "O5" are 25 variables and that we exclude the first
# column ("ID"), we have to calculate correlations for the 2nd to the 26th
# column, i.e., [2:26]
# ===========================================================================
# the following line outputs the column number and the variable name
sprintf("%d: %s", seq(ncol(data)), names(data))
# this information can be used to adjust [2:26] underneath
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
