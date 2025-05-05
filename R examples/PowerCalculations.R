# the very first time, you want to use the pwr-package, you have to install it
if (!nzchar(system.file("pwr")))   install.packages('pwr',   dep = TRUE)
if (!nzchar(system.file("pwrss"))) install.packages('pwrss', dep = TRUE)
# =================================================

# Power calculations - determining required sample size - for an Independent Samples t-test (undirected hypothesis: µ0 ≠ µ1)
pwr::pwr.t.test(d = 0.5, sig.level = 0.05, power = 0.9, type="two.sample", alternative="two.sided")
pwrss::pwrss.t.2means(mu1 = 0.5, sd1 = 1, alpha = 0.05, power = 0.9, alternative = "not equal")

# Power calculations - determining required sample size - for an Independent Samples t-test (directed hypothesis: µ0 < µ1)
pwr::pwr.t.test(d = 0.5, sig.level = 0.05, power = 0.9, type="two.sample", alternative="greater")
pwrss::pwrss.t.2means(mu1 = 0.5, sd1 = 1, alpha = 0.05, power = 0.9, alternative = "greater")

# Power calculations for an ANOVA (one factor with 4 steps [k = 4] - determining the sample size
eta2 = 0.06
pwr::pwr.anova.test(k = 4, f = sqrt(eta2 / (1 - eta2)), sig.level = 0.05, power = 0.8)
pwrss::pwrss.f.ancova(eta2 = eta2, n.levels = 4, n.covariates = 0, alpha = 0.05, power = 0.8)
pwrss::pwrss.f.ancova(eta2 = eta2, n.levels = c(4, 2), n.covariates = 0, alpha = 0.05, power = 0.8)

# Power calculations for correlation / regression models
R <- 0.3
pwr::pwr.r.test(r = R, sig.level = 0.05, power = 0.9, alternative = "greater")
pwrss::pwrss.z.corr(r = R, alpha = 0.05, power = 0.9, alternative = "greater")
R2 <- 0.09
pwrss::pwrss.f.reg(r2 = R2, k = 2, alpha = 0.05, power = 0.8)

# assigning the sample-size-calculations to an output variable and plotting them
pwr_t <- pwr::pwr.t.test(d = 0.5, sig.level = 0.05, power = 0.9, type="two.sample", alternative="greater")
plot(pwr_t, xlab="sample size per group")

# pwr also provides a function to give back Cohen's (1988) recommendations for effect sizes
# NB: Cohen (1988, p. 25) actually recommends to avoid them whenever possible and to treat them just as guidance
pwr::cohen.ES(test="t", size="medium")

# now, we assign the effect size to an variable and inspect the variable
ES <- pwr::cohen.ES(test="t", size="medium")
str(ES)
# this tells us that within the R-object that is returned, we can find the effect size in the variable "effect.size"
# we use this in turn: "pwr::cohen.ES(test="t", size="medium")$effect.size" to directly input the output from cohen.ES
# in the function that calculates the recommended sample size
pwr::pwr.t.test(d = pwr::cohen.ES(test="t", size="medium")$effect.size, sig.level = 0.05, power = 0.9, type="two.sample", alternative="greater")
