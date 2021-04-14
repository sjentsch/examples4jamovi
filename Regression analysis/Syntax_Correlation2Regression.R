# from the data (parenthood.omv) we correlate the colunms dan.sleep 
# (how much Dan sleeps) and dan.grump (how grumpy Dan is)
# we first use those columns to calculate a correlation
resCrr = cor.test(data$dan.grump, data$dan.sleep)
# "data = data" looks maybe a little confusing but our variable data is assigned
# to the parameter data of the R-function
# now we "extract" several pieces of information from these results
# [1] ]the correlation
as.double(resCrr$estimate)
# [2] a t-value showing us the strength of the correlation
as.double(resCrr$statistic)
# [3] the p-value derived from that t-value
resCrr$p.value
# now, we try do to the same using a linear regression model
# the syntax for that is lm (linear model) and in the parentheses
# we write a kind of formula: dependent ~ independent
# which reads like dependent PREDICTED BY independent
# given that we, this time are interested in a direction of an effect
# we have to think a little which variable is the one exterting an influence
# (i.e. the independent variable) and on which variable this influence exerts
# its effect (i.e., the dependent variable)
regMdl = lm(dan.grump ~ dan.sleep, data = data)
# next, we assess the parameters of this model, e.g., its significance, etc.
regSmm = summary(regMdl)
# from that summary, we now extract the information, we are interested in
# let's begin with the coefficients: this looks pretty identical to the table
# we get in jamovi when running the linear regression through the user interface
regSmm$coefficients
# now, I would like to replicate the output from the correlation above
# [1] the correlation coefficient, in a linear model this comes as a
# measure R² from which we have to calculate the square root
sqrt(regSmm$r.squared)
# then we use the second line from the coefficients above (dan.sleep)
# and extract the 
# [2] t-value and the
regSmm$coefficients[2, 3]
# [3] p-values
regSmm$coefficients[2, 4]
# those values are numerically identical to those from the correlation
# the one difference is that the correlation is negative when using the
# correlation and positive when using the linear regression
# the reason is that we calculated the equivalent to the correlation correficient
# from the R² value of the linear regression; given that this value is squared
# makes the negative sign disappear -1² = 1
# but, information about the negative direction of this relation can still be
# extracted from the "Estimate" in the coefficients (which is negative)
regSmm$coefficients[2, 1]
# ==============================================================================
# don't worry if you don't understand the next bit
# this is primarily for those of you interested in the "machinery"
# underlying a linear regression
# as shown in the lecture slides and the LSJ-book (p. 296), the formula is:
# Yi = b0 + b1Xi + ei
# (e should be the greek epsilon, denoting the error)
# all the i's, 0's, 1's are subscripts
# when we write this as matrices, we could write
# Y  = bX + e
# some more explanations:
# Y is a vector with our dependent variable
# b contains b0 and b1
# to estimate b0, we have to add a vector with "1" at the very beginning of X
# X contains our independent variable (here, it is only one but it could be more)
# the vector with "1" takes care of subtracting the mean (which b0 does otherwise)
# the values for b can be estimated using this formula (see footnote 5 on p. 297
# of the LSJ-book):
# b = (X'X)-1 · X'y
# the -1 indicating that X'X is inverted which means we could also write
# b = X'y / X'X
# ---
# now, in practice:
# first we add the vector of zeros to X (while our dependent variable is the
# second column) and convert this to a matrix
X = matrix(c(rep(1, length(data$dan.sleep)), data$dan.sleep), ncol = 2)
# our dependent variable is converted into a matrix as well
y = matrix(data$dan.grump, ncol = 1)
# let's try our formula: b = (X'X)-1 · X'y
b = solve(t(X) %*% X) %*% (t(X) %*% y)
# some explanations: ' e.g., in X'X means that X is transposed,
# which again means that rows are made into columns, and columns into rows,
# it is as if the matrix is rotated 90°
# comment out the next two lines if you want to see for yourself
# X
# t(X)
# solve means that the matrix is inverted (this is what is written as -1 in the
# formula)
# finally "%*%" means that a multiplication is applied to a matrix (the rules
# are a bit different from "normal" multiplications: each element is multiplied
# and then added up, i.e., first column, first row * first row, first column + 
# first column, second row * first row, second column + ...
b
# now looking at the b-values, the look splendidly identical to those in the
# coefficients from our linear model
# now, wo would like to calculate R (the linear-regression-equivalent to the
# correlation coefficient)
# it is calculated by setting the variance that we can explain, i.e. predict
# by multiplying b and X, in relation to the total variance in the original
# dependent variable (y) by dividing it - this gives us a value that is
# identical to the R² from the linear regression model from which we then
# take the square root (as we did above, l. 30)
sqrt(as.double(var(X %*% b) / var(y)))
