# this demonstration aims to visually “explain” (or illustrate) the central limit theorem (https://en.wikipedia.org/wiki/Central_limit_theorem)

# definitions
N <- c(5, 20, 80, 320)
M <- 50
s <- 10
#s <- c(5, 10, 20)
numRep <- 1e6

trlSmp <- array(NA, dim = c(numRep, length(N), 2));
for (crrRep in seq(numRep)) {
    for (i in seq_along(N)) {
        crrSmp <- rnorm(n = N[i], mean = M, sd = s);
        trlSmp[crrRep, i, ] <- c(mean(crrSmp), sd(crrSmp))
    }
    if (crrRep %% 1e4 == 0) cat(ifelse(crrRep %% 1e5 == 0, "*", "."))
}

par(mfrow = c(1, length(N)))
for (i in seq_along(N)) hist(trlSmp[, i, 1], breaks = 100, main = sprintf("Sample means (N = %d per sample, %d repetitions)", N[i], numRep))
