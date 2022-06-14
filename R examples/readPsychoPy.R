# DEFINITIONS
# variable that contains the participant code
sbjCde = 'participant';
# our target variables
tgtVar = c('keyTrl.keys', 'keyTrl.rt');
# our trial counter (later used as index when arranging the data in columns)
trlCnt = 'repTrl.thisIndex';

# remove the old output file
file.remove('AllRes.csv')
fleLst = list.files('.', '*.csv');
allCSV = data.frame();
for (F in 1:length(fleLst)) {
    crrCSV = read.csv(fleLst[F]);
    # select the fields that we need (defined at the top of the file)
    crrCSV = crrCSV[, c(sbjCde, tgtVar, trlCnt)];
    # remove lines that only contain NAs
    crrCSV = crrCSV[rowSums(is.na(crrCSV)) < ncol(crrCSV), ];
    # if the participant doesn't have a name, assign the index of the loop
    if (all(is.na(crrCSV[, sbjCde]))) { crrCSV[, sbjCde] = F; }
    # increase the index with 1 (it otherwise starts with 0)
    crrCSV[, trlCnt] = crrCSV[, trlCnt] + 1;
    allCSV = rbind(allCSV, crrCSV);
}
allCSV = reshape(allCSV, idvar=sbjCde, timevar=trlCnt, direction = "wide");
write.csv(allCSV, 'AllRes.csv', row.names=FALSE)
