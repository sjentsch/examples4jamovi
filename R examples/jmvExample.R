# determine which file to use
fleOMV = system.file("extdata", "ToothGrowth.omv", package = "jmvReadWrite");
# read the data file with extracting the syntax
data = jmvReadWrite::read_omv(fleNme = fleOMV, getSyn = TRUE);
# show the analyses contained in the data file
attr(data, 'syntax')
# we could do a slight adjustment to the function before we run it (replace partEta with eta)
# and perhaps ask for contrasts for "dose2" and for post-hoc-tests
attr(data, 'syntax')[[1]] = "jmv::ANOVA(formula = len ~ supp + dose2 + supp:dose2, data = data, effectSize = \"eta\", modelTest = TRUE, qq = TRUE, contrasts = list(list(var=\"supp\", type=\"none\"), list(var=\"dose2\", type=\"polynomial\")), postHoc = ~ supp + dose2, emMeans = ~ dose2:supp)"
# assemble a string that runs the first analysis in the syntax and assigns the result to result
eval(parse(text=paste0('result = ', attr(data, 'syntax')[[1]])))
# show the elements contained in the result variable 
names(result)
# show the variable class of those elements
for (crrElm in names(result)) { print(sprintf("%s: %s", crrElm, class(result[[crrElm]])[1])) }
# "main: Table"
# "assump: Group"
# "contrasts: Array"
# "postHoc: Array"
# "emm: Array"
# "residsOV: Output"
# among these elements, "Table" is directly accessible; if the output is a "Group" or
# an "Array", we can use names(...) to access it's elements; "Output" is related to storing
# variables (drop-down-menu "Save" in jamovi and contains routines to output the residuals
# to the jamovi-file   
# please note that the elements are generic (i.e., all entries "main", "assump", etc.
# are generated as part of every ANOVA; from looking at the syntax, we can see that we did
# not ask for post-hoc-tests
names(result$assump)
# shows that "assump" has three elements: "homo", "norm", "qq"
result$assump[[1]]
# brings up the table for the test of homogenity of variances (we would have to set homo = TRUE)
# we did ask for the QQ-plot though which can be shown with
result$assump[[3]]
# if we have results tables (e.g., "main") they are by default shown as formatted table
result$main
# ANOVA - len                                                                                      
# ──────────────────────────────────────────────────────────────────────────────────────────────── 
#                    Sum of Squares    df    Mean Square    F            p             η²p         
# ──────────────────────────────────────────────────────────────────────────────────────────────── 
#   Overall model         2740.1033     5      548.02067    41.557178    < .0000001                
#   supp                   205.3500     1      205.35000    15.571979     0.0002312    0.2238254   
#   dose2                 2426.4343     2     1213.21717    91.999965    < .0000001    0.7731092   
#   supp:dose2             108.3190     2       54.15950     4.106991     0.0218603    0.1320279   
#   Residuals              712.1060    54       13.18715                                           
# ──────────────────────────────────────────────────────────────────────────────────────────────── 
# however, if we want to work with these data, they better are converted into a data frame
tblANOVA = result$main$asDF
# now we can access the different elements of this data frame, e.g., the first line (Overall)
tblANOVA[1, ]
# or the second column (SS)
tblANOVA[, 2]
# or we could output written text formatted according to APA to be taken into our results section
# the gsub replaces p = 0.000 with p < 0.001, the sprint outputs the name (col 1), the dfs (col 3)
# and F, p, and eta (col 5-7)
gsub("p = 0.000", "p < 0.001", sprintf("%s: F(%d,54) = %.2f, p = %.3f, η²p = %.2f", tblANOVA[1:4, 1], tblANOVA[1:4, 3], tblANOVA[1:4, 5], tblANOVA[1:4, 6], tblANOVA[1:4, 7]))

# =================================================================================================

# another option is to read a jamovi-file, manipulate it and write the manipulated file back
# jamovi defines its data columns with a number of attributes (e.g., columnType - "Data" or
# "Recoded", measureType, etc.; we would like to store these attributes to ensure that the
# file that is written back looks similar to the original
data = jmvReadWrite::read_omv("FileName.omv", sveAtt = TRUE)
#
# ... do some manipulation
#
jmvReadWrite::write_omv(data, "FileName.omv")

