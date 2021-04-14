# grades of Psychology students in Dr. Zeppos class
psych = c(50, 60, 60, 64, 66, 66, 67, 69, 70, 74, 76, 76, 77, 79, 79, 79, 81, 82, 82, 89)
# calculate the mean of these scores
M = mean(psych)
M
# the standard deviation is taken from the whole sample of Dr. Zeppo
# (cf. LSJ, Ch. 11.1.1); it is quite reassuring to know that this standard
# deviation for the whole sample and the one in our psychology subgroup is
# (more or less) identical: 9.5 vs. 9.52
9.5
sd(psych)
# now, we calculate the standard error which is the standard deviation divided
# the square root of the sample size; the original sample has 20 students
# length(psych) tells us how many elements are contained in the variable psych
# we could as well write SEM = 9.5 / sqrt(20) but then we would have to adapt
# n = 20 each time we add or remove a student from the variable psych
SEM = 9.5 / sqrt(length(psych))
SEM
# let's play a little around with that value and check what happens to
# the standard error of mean when the sample size is varied; 
# we compare how the standard error changes from 5 students, ...
9.5 / sqrt(5)
# over the orginal 20, ...
9.5 / sqrt(20)
# to 100 students
9.5 / sqrt(100)
# What you can see is that the larger the sample gets, the smaller gets
# the standard error of mean: this is logical because, the more measurements
# you collect the more exact will your mean be (and the smaller gets the error
# that you make when measuring)
#
# we continue with substracting the mean in our psychology subgroup from the
# mean in Dr. Zeppo's whole class (67.5) which is then divided by the
# standard error of mean to get a z-score
z = (M - 67.5) / SEM
z
# this z-value can we then compare with a standard normal distribution
# an alpha (error probability) of 0.05 - which means we have 0.025 at 
# the bottom and the top of the distribution (1 - 0.025 → 0.975)
qnorm(0.975)
# we get a critical z-value of about 1.96 which is smaller than our z-value (2.25)
# that is our z-value (2.25) is more extreme than the cut-off (1.96) and we can
# therefore reject H0 and assume that the average scores in the subgroup
# of psychology students are above the average scores in the whole class
# of Dr. Zeppo
