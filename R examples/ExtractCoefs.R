# downloads a data file, reads it and removes it from the drive
download.file("https://github.com/sjentsch/examples4jamovi/raw/main/Regression%20analysis/Album%20Sales%20-%20Example%20Analysis.omv", "AlbumSales.omv")
data = jmvReadWrite::read_omv("AlbumSales.omv", sveAtt = FALSE, useFlt = TRUE, getSyn = TRUE)
unlink("AlbumSales.omv")
# extracts the syntax and shows it
syntax = attr(data, "syntax")
(syntax)
# we would like to use the model in analysis 3 (where all variables are entered at once)
# and evaluate it, assigning the output to result
eval(parse(text = paste0("result <- ", syntax[3])))
# if you now look what is in result you (not surprisingly) get an output that looks like
# what you get in jamovi, only in text form (as if you had switched on "Syntax mode")
(result)
# names provides us with the "sub-entries" of result, and if you compare the output you
# obtained with the command above, we can figure out that our model-specific results are
# under "models" (otherwise, ??jmv::linReg tells you that too); NB: those names ending in
# OV are output variables and we are not interested in them (at least for now)
names(result)
# we now check the sub-entries under the first model and have a look at the coefficients
names(result$models[[1]])
result$models[[1]]$coef
# in order to manipulate those coefficients, we need to assign them to a variable
resDF <- result$models[[1]]$coef$asDF
# we have a look at what we got and decide that we need the first () and second column
# and that the second column should come first (in principle it doesn't matter, but we
# typically follow the form b1 * x1 (with b1 being a coefficient and x1 a variable)
resDF
resDF[, c(2, 1)]
# we combine these two columns with paste0 and since we don't want to do this for every
# line, we use apply to do this
apply(resDF[, c(2, 1)], 1, paste0, collapse = " * data$")
# the output we got looks not perfect enough yet (it would work though) so we remove the
# column names (uname) and leading / trailing white spaces (trimws)
trimws(unname(apply(resDF[, c(2, 1)], 1, paste0, collapse = " * data$")))
# now, we combine the four strings (3 variables + intercept) using another paste
paste0(trimws(unname(apply(resDF[, c(2, 1)], 1, paste0, collapse = " * data$"))), collapse = " + ")
# we have to remove the "Intercept" since there is no variable with that name
# NB: the "\\" before * and $ are required because * and $ are regular expressions
gsub(" \\* data\\$Intercept", "", paste0(trimws(unname(apply(resDF[, c(2, 1)], 1, paste0, collapse = " * data$"))), collapse = " + "))
# finally, we can add a variable that we would like to use as target and then evaluate
# the string we just created
paste0("data$Pred = ", gsub(" \\* data\\$Intercept", "", paste0(trimws(unname(apply(resDF[, c(2, 1)], 1, paste0, collapse = " * data$"))), collapse = " + ")))
eval(parse(text = paste0("data$Pred = ", gsub(" \\* data\\$Intercept", "", paste0(trimws(unname(apply(resDF[, c(2, 1)], 1, paste0, collapse = " * data$"))), collapse = " + ")))))
# if we now look at data, we see that a column named "Pred" was added to our data
data
# if we now look at the correlation between the outcome variable (Sales) and what we
# predicted (Pred) we get the R from our model fit table (look at my slides, R = corr(Y, Ŷ))
R <- cor(data$Sales, data$Pred)
R
result$modelFit
# and since I adore mathematics and R, there is a nice formula for R² too...
# the amount of variance we can predict with our model (Pred) relative to the total
# variance (Sales)
R2 <- var(data$Pred) / var(data$Sales)
R2
# or alternatively, we could just square R: R ^ 2
# and finally: F; F is the variance that we can explain (divided by the number of
# variables in our model; df1 = 3) / divided by the amount of variance we can't
# explain (again divived by the respective df's = N - 3 - 1 = 188) – N = nrow(data)
# or a formula: (R² / 3) / ((1 - R²) / 188)
F = (R2 / 3) / ((1 - R2) / 188)
F
# to confirm the p-value, we need to convert modelFit into a data frame
pf(q = F, df1 = 3, df2 = 188, lower.tail = FALSE)
result$modelFit$asDF
# =============================================================================
# what we did so far was just confirming that everything was alright, however,
# if you were the executive at the record company that the data came from, you
# could use the infomration for Adverts, Airplay and Image to predict how many
# music you are likely going to sell (or whether throwing money at adverts
# would make sense)
