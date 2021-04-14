# R-syntax for creating optimally weighted factor scores
# check that we have the correct variables
summary(data[,2:26])

# calculate an EFA, with the selected variables
# Settings: 5 factors, oblique rotation (oblimin)
#           "Bartlett" is the best method for calculating scores
fact = psych::fa(sapply(data[2:26], jmvcore::toNumeric),
                 missing = FALSE,
                 nfactors = 5,
                 rotate = "oblimin",
                 scores = "Bartlett")

# check the loadings and whether they are in accordance with the results
# obtained in the GUI, NOTE: loadings < 0.3 are not filtered here!
loadings(fact)

# now, assuming that the factor solution staid the same
# assign understandable names to the calculated scores
# NOTE: you have to double check where the highest factor loadings
#       are and adjust the names if necessary
#       MR2 → M_N, MR3 → M_C, etc.
colnames(fact$scores) <- c("W_N", "W_C", "W_E", "W_A", "W_O")
# rearrange columns so that they are in "proper" order
# (like the NEO-FFI): N, E, O, A, C
fact$scores = fact$scores[, c("W_N", "W_E", "W_O", "W_A", "W_C")]

# combine them with the existing data and write them to a file
# NOTE: you may give a full path, e.g. 
# on Mac: '/Users/[USERNAME]/bfi_fact.csv'
# on Win: 'C:\Users\[USERNAME]\Documents'
write.csv(cbind(data, fact$scores), 'bfi_fact.csv', row.names = FALSE)
