# concatentates your variable names (or a selection, e.g., [8:16])
# (1) for jamovi-functions (e.g., sum) and (2) formulas (e.g., regression)
paste(names(data), collapse = ’, ’)  # Comp. var
paste(names(data[8:16]), collapse = ’ + ’)

# jamovi may store the data internally as factors (if Nominal or Ordinal)
# in order to do calculations they need to be converted to numeric
data2 = as.data.frame(sapply(data, jmvcore::toNumeric))
# compare the unconverted to the converted summary
summary(data[2:5])
summary(data2[2:5])

# we can use sapply to run an operation on all columns of our data frame
# in this case, we apply a z-standardisation
data3 = as.data.frame(sapply(data2[2:26], scale))
