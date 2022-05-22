# define directory where the data are stored
# please note that you may have to change "/" into "\"
# if you are on a Windows machine
dirDta = 'NeoCard/'
# create a list with a subject / participant codes / IDs
sbjLst = c('NC_3398-201111Nov14', 'NC_3398-201111Nov14', 'NC_3409-201111Nov18', 'NC_3418-201111Nov17', 'NC_3428-201111Nov21', 'NC_3439-201112Dec02', 'NC_3448-201112Dec05',
           'NC_3458-201112Dec05', 'NC_3469-201112Dec16', 'NC_3479-201112Dec16', 'NC_3489-201202Feb24')
# define which item belongs to which NEO-scale and whether the item
# is normal or reverted
neoItm = list(N1 = list(name = "Anxiety (N1)",            item = c( -1, +31, -61,  +91, -121, +151, -181, +211)),
              N2 = list(name = "Angry Hostility (N2)",    item = c( +6, -36, +66,  -96, +126, -156, +186, +216)),
              N3 = list(name = "Depression (N3)",         item = c(-11, +41, -71, +101, +131, +161, +191, +221)),
              N4 = list(name = "Self-Consciousness (N4)", item = c(+16, -46, +76, -106, +136, -166, +196, +226)),
              N5 = list(name = "Impulsiveness (N5)",      item = c(-21, +51, -81, +111, -141, +171, +201, -231)),
              N6 = list(name = "Vulnerability (N6)",      item = c(+26, -56, +86, -116, +146, -176, -206, -236)))

# generate an empty variable to be replaced with the first data set that is read 
dtaFrm = NULL

for (crrSbj in sbjLst) {
    # read the raw data from the output file, there is no header in the file and the columns 
    # are separated with tabs (\t)
    rawDta <- read.csv(paste0(dirDta, crrSbj, '_NEO-PI.log'), header = FALSE, sep = "\t")
    # we are only interested in events where an questionnaire ITEM was presented
    rawDta <- rawDta[rawDta$V3 == "ITEM", ]

    # extract the values / responses to the item, transpose them (in the original file,
    # the are in rows, we need them in columns) and then convert the values into a data.frame
    valVar <- as.data.frame(t(rawDta$V5))
    # give the variables a name
    names(valVar) <- rawDta$V4

    # produce another column with the subject code and add them together
    sbjCde = as.data.frame(crrSbj)
    names(sbjCde) = "ID"
    valVar = cbind(sbjCde, valVar)

    # do some magic summarizing the NEO-scales
    # go through the different subscales
    for (crrScl in names(neoItm)) {
        # assemble a command to calculate the sum for the different NEO-scales
        # if the questionnaire is using mean scale scores instead mean sum scores,
        # just replace "sum(" by "mean("
        crrCmd = paste0('valVar$NEO_', crrScl, ' = sum(')
        for (crrItm in neoItm[[crrScl]][["item"]]) {
            # depending on whether the item was defined as "normal" or "reverted"
            # a respective string is added; the scale has 5 response options, thus
            # if an item has to be reverted, the item response has to be subtracted
            # from 6: 6 - 1 → 5, ..., 6 - 5 → 1
            if (crrItm > 0) {
                crrCmd = paste0(crrCmd, sprintf(    'valVar$NEO_%03d, ', abs(crrItm)))
            } else {
                crrCmd = paste0(crrCmd, sprintf('6 - valVar$NEO_%03d, ', abs(crrItm)))
            }
        }
        # evaluate the assembled command
        eval(parse(text = paste0(sub(", $", "", crrCmd), ')')))
    }

    # for the first participant, assign the valVar to dtaFrm
    # for the following participants, add a row
    if (is.null(dtaFrm)) {
        dtaFrm = valVar
    } else {
        if (all(names(dtaFrm) == names(valVar))) {
            dtaFrm = rbind(dtaFrm, valVar)
        } else {
            stop('Column names in the existing data frame and the data of ', crrSbj, ' are not matching up.')
        }
    }
}

# check whether jmvReadWrite is installed, if yes, store the resulting data frame in jamovi format (.omv)
# otherwise as RData-file
if (nzchar(system.file(package = "jmvReadWrite"))) {
    # adding variable labels
    for (crrScl in names(neoItm)) attr(dtaFrm[[paste0("NEO_", crrScl)]], "jmv-desc") <- neoItm[[crrScl]][["name"]]
    # we could further assign other attributes such as measurement type: attr(,"measureType")
    # NB: You can get an idea which attributes can be used by reading a jamovi-file with sveAtt = TRUE
    #     trlDta = jmvReadWrite::read_omv("[...].omv", sveAtt = TRUE)
    for (crrCol in seq_along(dtaFrm)) attr(dtaFrm[[crrCol]], "measureType") <- ifelse(crrCol == 1, "ID", "Continuous")
    jmvReadWrite::write_omv(dtaFrm = dtaFrm, fleOut = "NeoCard.omv")
} else {
    save(list = 'dtaFrm', file = paste0(dirDta, 'NeoCard.RData'))
}

