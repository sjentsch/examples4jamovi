# The syntax underneath uses the harpo-file from the lsj-data. It can be opened using:
# ☰ → Open → Data Library → learning statistics with jamovi (lsj-data) → Harpo
# After opening the file, you may have to set the variable types correctly: ID to ID,
# and grade to continuous. Afterwards, copy the syntax underneath into a Rj window.

# First we select which rows belong to each tutor and 
# determine the number of participants in each group
# and convert the data into a format (integers) 
# that can be used for calculations
selA = (data[3] == "Anastasia")
selB = (data[3] == "Bernadette")
n_A = sum(selA)
n_B = sum(selB)
raw_A = as.integer(data[2][selA])
raw_B = as.integer(data[2][selB])

# then we calculate mean (AM) and variance (V) for each subgroup
AM_A = mean(raw_A)
AM_B = mean(raw_B)
V_A = var(raw_A)
V_B = var(raw_B)

# now, we calculate two different t-values:
# Student's t if the variances in each group are equal (l. 22 - 36)
# Welch's t if we can't assume similar variances in the two groups (l. 38 - 53)
# =============================================================================
# Student's t
# first, we determine the degrees of freedom
df_S = n_A + n_B - 2
# then, we calculate the variance in the whole sample
# by weighing the variance in the subgroups with the number of
# participants in that subgroup (n_A, n_B) - 1
# the formula is shown on top of p. 256
V_S = ((n_A - 1) * V_A + (n_B - 1) * V_B) / df_S
# afterwards we calculate the standard error by weighing
# V_S with 1 / n_A + 1 / n_B and calculating the square root of that term 
SE_S = sqrt(V_S * (1 / n_A + 1/n_B))
# then we calculate t by weighing the group difference with the standard error
t_S = (AM_A - AM_B) / SE_S
# finally, we print Student's t and the (uncorrected) degrees of freedom 
c(t_S, df_S)
# =============================================================================
# Welch's t
# first we calculate the standard error by adding the variance in each subgroup
# weighed / divided by the group size
# the formula is on the top of p. 262
SE_W = sqrt(V_A / n_A + V_B / n_B)
# afterwards we calculate the corrected degrees of freedom
# the formula is on p. 262
# for (a little) easier readability,
# the following line is the part above the fraction bar  
df_W = (V_A / n_A + V_B / n_B) ^ 2 / 
# and the next line is the part below the fraction bar
      ((V_A / n_A) ^ 2 / (n_A - 1) + (V_B / n_B) ^ 2 / (n_B - 1))
# then we calculate t by weighing the group difference with the standard error
t_W = (AM_A - AM_B) / SE_W
# finally, we print Welch's t and the corrected degrees of freedom 
c(t_W, df_W)

# and here the example how to do the same with two one-liners
# Student's t
t.test(raw_A, raw_B, var.equal=T)
# Welch's t
t.test(raw_A, raw_B, var.equal=F)
# if we did not give the option var.equal, R would use Welch as default
