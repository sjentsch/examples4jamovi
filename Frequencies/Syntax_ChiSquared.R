# you need the Randomness file from the LSJ-datasets
# these are the observed frequencies for the different suits (clubs, etc.)
# the data come from the columns [2] and [3] in your data file
# ([1]) is the "id" column
obs_1 = as.double(table(data[2]))
obs_2 = as.double(table(data[3]))
# this command shows you the frequency distribution
summary(data[2:3])
# you have 200 draws / events in your data file (check the number of lines)
# if all suits were equally distributed you would have 50 in each category
# this is what you would expect
exp = c(50, 50, 50, 50)
# we, of course, could also calculate how many values per category we would
# expect; we take the sum of all observations and divide it through the number
# of categories (club, diamond, heart, spade; length(levels()) - gives you the
# number of categories of a factor and length says how many are there
sum(obs_1)
length(levels(data[[2]]))
exp = rep(sum(obs_1) / length(levels(data[[2]])), length(levels(data[[2]])))
exp
# the chi-squared value is calculated by subtracting what you expected
# from what you observed (obs_1 - exp); this difference is squared (^ 2), 
# set into relation to what you expect ( / exp) and summed over
# all four categories
# you can see this in a step-by-step fashion, if you remove the '#' sign
# from the begin of the next lines (ideally, do this one after another)
# remember to do this in the editor ;-), and hit "Play" to run the code 
#(obs_1 - exp)
#(obs_1 - exp) ^ 2
#(obs_1 - exp) ^ 2 / exp
#sum((obs_1 - exp) ^ 2 / exp)
chi_1 = sum((obs_1 - exp) ^ 2 / exp)
chi_2 = sum((obs_2 - exp) ^ 2 / exp)
# print the chi-squared values
print(c(chi_1, chi_2))
# calculate p-value for the chi-squared value
# df = 3 results from that you have four categories / suits (clubs, etc.)
# if lower.tail=F would be left out you would get 1 - p (the probability with
# which this distribution of frequencies is supposed to occur); we, however,
# are interested in the probability to make an error if we reject such hypothesis
print(c(pchisq(chi_1, 3, lower.tail=F), pchisq(chi_2, 3, lower.tail=F)), digits=3)
# if you compare the result with what you get from clicking it together with
# Frequencies → N outcomes (χ² Goodness of fit)
# you will realize that the results are the same
