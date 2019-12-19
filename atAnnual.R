#############################################
##
##  Status & Trends in Forest Condition
##        along APPA Corridor
##  UPDATE: ANNUAL ESTIMATORS & ALIKE
##
##
##    Hunter Stanke & Andrew Finley
##          18 December 2019
##
##
#############################################

## Load the rFIA package
library(rFIA)
library(rgdal)

## How many cores do you have?
parallel::detectCores(logical = FALSE)
## How many do you want to use?
cores <- 19

# ## Download and save the FIA data for each state which intersects APPA
# at <- getFIA(states = c('CT', 'GA', 'ME', 'MD', 'MA', 'NH', 'NJ', 'NY', 'NC', 'PA', 'TN', 'VT', 'VA'),
#              dir = './FIA/', nCores = cores)
# ## Load Ecoregion polygons
# eco <- readOGR('/home/hunter/GIS/shell', 'APPA_Ecoregions_USFS_HUC10_Shell_AEA')
#
# ## New updates allow us to run hard spatial clips,
# ## reducing size of the input data and improving run
# ## time substantially
# at <- clipFIA(at, mask = eco, mostRecent = FALSE, nCores = cores)
#
# writeFIA(at, '/home/hunter/NPS/atAnnual/dataClip')

## Above acquires, clips, and saves data we need. Now we bring it back in
at <- readFIA('/home/hunter/NPS/atAnnual/dataClip', nCores = cores)

## Load Ecoregion polygons
eco <- readOGR('/home/hunter/GIS/shell', 'APPA_Ecoregions_USFS_HUC10_Shell_AEA')


#### Temporal Trends ####
start <- lubridate::now()
ss <- standStruct(at, polys = eco, tidy = FALSE, nCores = cores, method = 'ema')
tpaS <- tpa(at, polys = eco, bySpecies = TRUE, treeType = 'live', treeDomain = DIA >= 5, nCores = cores, method = 'ema')
tpa <- tpa(at, polys = eco, treeType = 'live', treeDomain = DIA >= 5, nCores = cores, method = 'ema')
div <- diversity(at, polys = eco, nCores = cores, treeDomain = DIA >= 5, method = 'ema')
gmS <- growMort(at, polys = eco, bySpecies = TRUE, nCores = cores, treeDomain = DIA >= 5, method = 'ema')
gm <- growMort(at, polys = eco, nCores = cores, treeDomain = DIA >= 5, method = 'ema')
vrS  <- vitalRates(at, polys = eco, bySpecies = TRUE, nCores = cores, treeDomain = DIA >= 5, method = 'ema')
vr  <- vitalRates(at, polys = eco, nCores = cores, treeDomain = DIA >= 5, method = 'ema')
bioS <- biomass(at, polys = eco, bySpecies = TRUE, nCores = cores, treeDomain = DIA >= 5, method = 'ema')
bio <- biomass(at, polys = eco, nCores = cores, treeDomain = DIA >= 5, method = 'ema')
regenS <- tpa(at, polys = eco, bySpecies = TRUE, treeType = 'live', treeDomain = DIA < 5, nCores = cores, method = 'ema')
regen <- tpa(at, polys = eco, treeType = 'live', treeDomain = DIA < 5, nCores = cores, method = 'ema')
snag <- tpa(at, polys = eco, treeType = 'dead', treeDomain = DIA >= 5, nCores = cores, method = 'ema')
snagV <- biomass(at, polys = eco, treeType = 'dead', treeDomain = DIA >= 5, nCores = cores, method = 'ema')
snagLD <- tpa(at, polys = eco, treeType = 'dead', treeDomain = DIA >= 11.81102, nCores = cores, method = 'ema')
snagVLD <- biomass(at, polys = eco, treeType = 'dead', treeDomain = DIA >= 11.81102, nCores = cores, method = 'ema')
dw <- dwm(at, polys = eco, tidy = FALSE, nCores = cores, method = 'ema')
inv <- invasive(at, polys = eco, nCores = cores, method = 'ema')
lubridate::now() - start

setwd('/home/hunter/NPS/atAnnual/ema/')

# Save all dataframes as .csv
write.csv(ss, 'ss.csv')
write.csv(div, file = 'div.csv')
write.csv(tpaS, file = 'tpaS.csv')
write.csv(tpa, file = 'tpa.csv')
write.csv(gmS, file = 'gmS.csv')
write.csv(gm, file = 'gm.csv')
write.csv(vrS, file = 'vrS.csv')
write.csv(vr, file = 'vr.csv')
write.csv(bioS, file = 'bioS.csv')
write.csv(bio, file = 'bio.csv')
write.csv(regenS, file = 'regenS.csv')
write.csv(regen, file = 'regen.csv')
write.csv(snag, file = 'snag.csv')
write.csv(snagV, file = 'snagV.csv')
write.csv(snagLD, file = 'snagLD.csv')
write.csv(snagVLD, file = 'snagVLD.csv')
write.csv(dw, file = 'dw.csv')
write.csv(inv, file = 'inv.csv')

