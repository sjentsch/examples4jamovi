# the very first time, you want to use the pwr-package, you have to install it
install.packages('pwr', dep = TRUE)
install.packages('pwrss', dep = TRUE)
# =================================================

# Power calculations - determining required sample size - for an Independent Samples t-test (undirected hypothesis: µ0 ≠ µ1)
pwr::pwr.t.test(d = 0.5, sig.level = 0.05, power = 0.9, type="two.sample", alternative="two.sided")

# Power calculations - determining required sample size - for an Independent Samples t-test (directed hypothesis: µ0 < µ1)
pwr::pwr.t.test(d = 0.5, sig.level = 0.05, power = 0.9, type="two.sample", alternative="greater")

# Power calculations for an ANOVA (one factor with 4 steps [k = 4] - determining the sample size
eta = 0.2
pwr::pwr.anova.test(k = 4, f = sqrt(eta / (1 - eta)), sig.level = 0.05, power = 0.8, alternative = "two.sided")

# Power calculations for correlation / regression models
R = 0.3
pwr::pwr.r.test(r = R, sig.level = 0.05, power = 0.9, alternative = "greater")

# assigning the sample-size-calculations to an output variable and plotting them
pwr_t = pwr::pwr.t.test(d = 0.5, sig.level = 0.05, power = 0.9, type="two.sample", alternative="greater")
plot(pwr_t, xlab="sample size per group")

# pwr also provides a function to give back Cohen's (1988) recommendations for effect sizes
# NB: Cohen (1988, p. 25) actually recommends to avoid them whenever possible and to treat them just as guidance
pwr::cohen.ES(test="t", size="medium")

# now, we assign the effect size to an variable and inspect the variable
ES = cohen.ES(test="t", size="medium")
str(ES)
# this tells us that within the R-object that is returned, we can find the effect size in the variable "effect.size"
# we use this in turn: "cohen.ES(test="t", size="medium")$effect.size" to directly input the output from cohen.ES in the
# function that calculates the recommended sample size
pwr::pwr.t.test(d = cohen.ES(test="t", size="medium")$effect.size, sig.level = 0.05, power = 0.9, type="two.sample", alternative="greater")
