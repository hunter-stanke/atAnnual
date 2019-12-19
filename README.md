AT Summary Analysis & Content Description
================
Hunter Stanke
12/19/2019

The `AT_Summary.zip` file contains all code and data used in our 2019
analysis of the status and trends in forest attributes along the
Appalachian National Scenic Trail and surrounding lands. This document
is intended to provide a brief description of our analyses, and
description of contents of `AT_Summary.zip`. Contact Hunter Stanke at
<stankehu@msu.edu> with questions.

### Analysis Description

We used the `rFIA` package to estimate all forest attributes described
below (see `atAnnual.R` for code). We accessed subsets of the public
Forest Inventory and Analysis database on 10 October 2019 for the
following states: CT, GA, ME, MD, MA, NH, NJ, NY, NC, PA, TN, VT, and
VA.

The FIA program conducts annual (panel) inventories within each state.
For our study region, this is most often a series of 5 annual, spatially
unbiased inventories within each sampling cycle. This panel structure
allows the FIA program to improve the precision of status and change
estimates by leveraging previously collected data within an inventory
cycle (e.g., estimate for 2015 may include data from annual inventories
conducted from 2010-2015). There are many methods available for
combining annual panels using alternative weighting schemes, and we have
implemented a few in our recent updates to `rFIA`.

We produced summaries of the attributes below using 3 unique estimators
(methods for panel combination):

  - **Temporally Indifferent** : The temporally indifferent method
    assumes that all annual panels within an inventory cycle were
    collected simultaneously in the reporting year. This is the flagship
    method used by the FIA program, seen tools like `EVALIDator`, though
    it introduces temporal lag bias and smoothing that limits its
    utility for change detection.

  - **Annual** : The annual method returns estimates produced directly
    from annual panels (no panel combination). Thus only data that is
    measured in a given year is used to produce estimates for that year.
    This method will produce estimates with higher variance (loss of
    precision) as we forgo the opportunity to leverage previous
    information (increase sample size), although it may be the best
    option for assessing inter-annual variation and temporal trends.
    NOTE: This estimator may produce estimates with temporally cyclical
    structure becuase of repeat observations of individual annual panels
    between inventory cycles. For example if plots are measured on 5
    year cycles beginning in 2005, the same plots measured in 2005 will
    be remeasured in 2010, 2015, 2020 and onward. Hence, corresponding
    annual panel estimates are likely to be similar to one another,
    potentially producing results with some odd temporal structure.

  - **Exponential Moving Average** : The exponential moving average
    method falls in the middle ground between the temorally indifferent
    and annual estimators, leveraging all annual panels within an
    inventory cycle to produce estimates, although weighting recent
    panels higher than less recent panels. The relative weights applied
    to each panel declines exponentially as a function of time since
    measurement, but we can control the rate of this decay with a
    parameter called `lambda` (ranges form 0-1). Low lambda values will
    place higher weight on more recent observations, so as lambda
    approaches 0, the exponential moving average will approach the
    annual method for panel combination. For this analysis we used the
    defualt value of 0.94.

We produced estimates for all FIA reporting years which were available
in each state. Some states have different reporting schedules, and thus
there is some missingness in the data. We estimate the following
attributes within ecoregion subsections which intersect the AT:

1.  **Live tree abundance**
      - TPA, BAA, biomass, and carbon by species
2.  **Species diversity of live trees**
      - Shannon’s diversity, eveness, and richness
3.  **Tree vital rates**
      - Annual diameter, basal area, and biomass growth by species
4.  **Forest demographic rates**
      - Annual recruitment, mortality, and harvest totals and rates by
        species
5.  **Regeneration abundance**
      - TPA of regenerating stems (\<5" DBH) by species and size-class
6.  **Snag abundance**
      - TPA, BAA, biomass, carbon, relative fraction
7.  **Down woody debris abundance**
      - Volume, biomass, and carbon by fuel class
8.  **Invasive Plant abundance**
      - % cover by species
9.  **Stand structural stage distributions**
      - % area in pole, mature, and late stage forest

FIA data was not available for each ecoregion subsection defined by the
`ecoregion/at_ecoSub.shp` shapefile. Attributes of ecoregions where FIA
data was unavailable were preserved in results files (see `results/`)
although estimated attributes are listed as `NA` for these rows.

<br>

### File structure

  - **atAnnual.R**: R script containing `rFIA` code required to download
    FIA Data and produce population estimates describing the status and
    trends in forest attributes along the AT.

<br>

  - **ecoregions/**
      - *at\_ecoSub.shp*: Includes polygons for ecological sections and
        subsections within Subregions within the conterminous United
        States clipped to the HUC10 shell surrounding the Appalachian
        National Scenic Trail. This data set contains regional
        geographic delineations for analysis of ecological relationships
        across ecological units.

<br>

  - **FIA/**
      - *Empty on download*: This folder is empty upon download, but
        will be populated with FIA data upon sourcing `at_script.R`. FIA
        data for the following states will be downloaded and saved as
        `.csv` files: CT, GA, ME, MD, MA, NH, NJ, NY, NC, PA, TN, VT,
        and VA.

<br>

  - **ti/ and ema/ amd annual/**
      - ***bio.csv***: Estimates of live tree (DBH \>= 12.7 cm) biomass,
        volume, and carbon on a per forested acre basis
          - *YEAR*: FIA reporting year for current abundance estimates
          - *NETVOL\_ACRE*: estimate of live tree net volume (cu.ft.)
            per acre
          - *SAWVOL\_ACRE*: estimate of live tree merchantable saw
            volume (cu.ft.) per acre
          - *BIO\_AG\_ACRE*: estimate of live tree aboveground biomass
            (tons) per acre
          - *BIO\_BG\_ACRE*: estimate of live tree belowground biomass
            (tons) per acre
          - *BIO\_ACRE*: estimate of live tree total (AG + BG) biomass
            (tons) per acre
          - *CARB\_AG\_ACRE*: estimate of live tree aboveground carbon
            (tons) per acre
          - *CARB\_BG\_ACRE*: estimate of live tree belowground carbon
            (tons) per acre
          - *CARB\_ACRE*: estimate of live tree total (AG + BG) carbon
            (tons) per acre
          - *nPlots\_VOL*: number of non-zero plots used to compute
            volume, biomass, and carbon estimates
          - *nPlots\_AREA*: number of non-zero plots used to compute
            land area estimates
          - columns ending in *SE*: estimates of sampling error (%) of
            the respective variable. All sampling error estimates are
            computed with 68% confidence
          - other columns from `ecoregions/at_ecoSub.shp`
      - ***bioS.csv***: Estimates of live tree biomass (DBH \>= 12.7
        cm), volume, and carbon on a per forested acre basis *grouped by
        species*
          - Same as `bio.csv`, with following additional columns
            relating to species codes and names: *SPCD*,
            *SCIENTIFIC\_NAME*, *COMMON\_NAME*
      - ***div.csv***: Estimates of species diversity indicies for live
        trees (DBH \>= 12.7 cm) at alpha, beta, and gamma levels
          - *YEAR*: FIA reporting year for current abundance estimates
          - *H\_a*: estimate of Shannon’s Diversity Index for live trees
            at the alpha (stand) level
          - *H\_b*: estimate of Shannon’s Diversity Index for live trees
            at the beta (landscape) level
          - *H\_g*: estimate of Shannon’s Diversity Index for live trees
            at the gamma (regional) level  
          - *H\_a*: estimate of Shannon’s Equitability Index for live
            trees at the alpha (stand) level
          - *H\_b*: estimate of Shannon’s Equitability Index for live
            trees at the beta (landscape) level
          - *H\_g*: estimate of Shannon’s Equitability Index for live
            trees at the gamma (regional) level  
          - *S\_a*: estimates of species richness for live trees at the
            alpha (stand) level
          - *S\_b*: estimates of species richness for live trees at the
            beta (landscape) level
          - *S\_g*: estimates of species richness for live trees at the
            gamma (regional) level
          - *nStands*: number of non-zero stands (conditions) used to
            compute alpha-level diversity estimates
          - columns ending in *SE*: estimates of sampling error (%) of
            the respective variable. All sampling error estimates are
            computed with 68% confidence
          - other columns from `ecoregions/at_ecoSub.shp`
      - ***dw.csv***: Estimates of down woody material volume, biomass,
        and carbon by fuel type on a per forested acre basis
          - *YEAR*: FIA reporting year for current abundance estimates
          - *VOL\_DUFF\_ACRE*: Not available for this region
          - *VOL\_LITTER\_ACRE*: Not available for this region
          - *VOL\_1HR\_ACRE*: estimate of 1 HR (small fine woody debris)
            volume (cu.ft.) per forested acre
          - *VOL\_10HR\_ACRE*: estimate of 10 HR (medium fine woody
            debris) volume (cu.ft.) per forested acre
          - *VOL\_100HR\_ACRE*: estimate of 100 HR (large fine woody
            debris) volume (cu.ft.) per forested acre
          - *VOL\_1000HR\_ACRE*: estimate of 1000 HR (coarse woody
            debris) volume (cu.ft.) per forested acre
          - *VOL\_PILE\_ACRE*: estimate of slash pile volume (cu.ft.)
            per forested acre
          - *VOL\_ACRE*: estimate of total down woody debris (duff +
            litter + 1HR + 10HR + 100HR + 1000HR + pile) volume (cu.ft.)
            per forested acre
          - *BIO\_DUFF\_ACRE*: estimate of duff biomass (tons) per
            forested acre
          - *BIO\_LITTER\_ACRE*: estimate of litter biomass (tons) per
            forested acre
          - *BIO\_1HR\_ACRE*: estimate of 1 HR (small fine woody debris)
            biomass (tons) per forested acre
          - *BIO\_10HR\_ACRE*: estimate of 10 HR (medium fine woody
            debris) biomass (tons) per forested acre
          - *BIO\_100HR\_ACRE*: estimate of 100 HR (large fine woody
            debris) biomass (tons) per forested acre
          - *BIO\_1000HR\_ACRE*: estimate of 1000 HR (coarse woody
            debris) biomass (tons) per forested acre
          - *BIO\_PILE\_ACRE*: estimate of slash pile biomass (tons) per
            forested acre
          - *BIO\_ACRE*: estimate of total down woody debris (duff +
            litter + 1HR + 10HR + 100HR + 1000HR + pile) biomass (tons)
            per forested acre
          - *CARB\_DUFF\_ACRE*: estimate of duff carbon (tons) per
            forested acre
          - *CARB\_LITTER\_ACRE*: estimate of litter carbon (tons) per
            forested acre
          - *CARB\_1HR\_ACRE*: estimate of 1 HR (small fine woody
            debris) carbon (tons) per forested acre
          - *CARB\_10HR\_ACRE*: estimate of 10 HR (medium fine woody
            debris) carbon (tons) per forested acre
          - *CARB\_100HR\_ACRE*: estimate of 100 HR (large fine woody
            debris) carbon (tons) per forested acre
          - *CARB\_1000HR\_ACRE*: estimate of 1000 HR (coarse woody
            debris) carbon (tons) per forested acre
          - *CARB\_PILE\_ACRE*: estimate of slash pile carbon (tons) per
            forested acre
          - *CARB\_ACRE*: estimate of total down woody debris (duff +
            litter + 1HR + 10HR + 100HR + 1000HR + pile) carbon (tons)
            per forested acre
          - *nPlots*: number of non-zero plots used to compute down
            woody material abundance and area estimates
          - columns ending in *SE*: estimates of sampling error (%) of
            the respective variable. All sampling error estimates are
            computed with 68% confidence
          - other columns from `ecoregions/at_ecoSub.shp`
      - ***gm.csv***: Estimates of annual tree (DBH \>= 12.7 cm)
        recruitment, mortality, and harvest rates per forested acre and
        relative to population totals (e.g. % mortality / year)
          - *YEAR*: FIA reporting year for growth, removal, and
            mortality estimates
          - *RECR\_TPA*: estimate of annual recruitment (growth beyond
            12.7 cm DBH) as trees per forested acre
          - *MORT\_TPA*: estimate of annual mortality (excluding harvest
            and conversion) as trees per forested acre
          - *REMV\_TPA*: estimate of annual removals (harvest and
            conversion) as trees per forested acre
          - *RECR\_PERC*: estimate of annual recruitment rate, as % of
            individuals recruiting relative to total population
          - *MORT\_PERC*: estimate of annual mortality rate, as % of
            individuals subject to mortality relative to total
            population
          - *REMV\_PERC*: estimate of annual removal rate, as % of
            individuals subject to removal relative to total population
          - *nPlots\_TREE*: number of non-zero plots used to compute
            total tree estimates
          - *nPlots\_RECR*: number of non-zero plots used to compute
            recruitment estimates  
          - *nPlots\_MORT*: number of non-zero plots used to compute
            mortality estimates  
          - *nPlots\_REMV*: number of non-zero plots used to compute
            removal estimates
          - *nPlots\_AREA*: number of non-zero plots used to compute
            land area estimates
          - columns ending in *SE*: estimates of sampling error (%) of
            the respective variable. All sampling error estimates are
            computed with 68% confidence
          - other columns from `ecoregions/at_ecoSub.shp`
      - ***gmS.csv***: Estimates of annual tree (DBH \>= 12.7 cm)
        recruitment, mortality, and harvest rates per forested acre and
        relative to population totals *grouped by species*
          - Same as `gm.csv`, with following additional columns relating
            to species codes and names: *SPCD*, *SCIENTIFIC\_NAME*,
            *COMMON\_NAME*
      - ***inv.csv***: Estimates of areal coverage by invasive plant
        species relative to forested land area
          - *YEAR*: FIA reporting year for current abundance estimates
          - *SYMBOL*: unique species ID from NRCS Plant Reference Guide
          - *SCIENTIFIC\_NAME*: latin name of the species
          - *COMMON\_NAME*: commmon name of the species
          - *COVER\_PCT*: estimate of percent areal coverage with
            respect to total forested land area
          - *nPlots\_INV*: number of non-zero plots used to compute
            species coverage estimates
          - *nPlots\_AREA*: number of non-zero plots used to compute
            land area estimates
          - columns ending in *SE*: estimates of sampling error (%) of
            the respective variable. All sampling error estimates are
            computed with 68% confidence
          - other columns from `ecoregions/at_ecoSub.shp`
      - ***regen.csv***: Estimates of live sapling (2.5 cm \<= DBH \<
        12.7 cm) abundance (TPA & BAA) per forested acre
          - *YEAR*: FIA reporting year for current abundance estimates
          - *TPA*: estimate of saplings per acre
          - *BAA*: estimate of sapling basal area (sq.ft.) per acre
          - *TPA\_PERC*: estimate of proportion of saplings which are
            live, with respect to TPA
          - *BAA\_PERC*: estimate of proportion of saplings which are
            live, with respect to BAA
          - *nPlots\_TREE*: number of non-zero plots used to compute
            tree and basal area estimates
          - *nPlots\_AREA*: number of non-zero plots used to compute
            land area estimates
          - columns ending in *SE*: estimates of sampling error (%) of
            the respective variable. All sampling error estimates are
            computed with 68% confidence
          - other columns from `ecoregions/at_ecoSub.shp`
      - ***regenS.csv***: Estimates of live sapling (2.5 cm \<= DBH \<
        12.7 cm) abundance (TPA & BAA) per forested acre *grouped by
        species*
          - Same as `regen.csv`, with following additional columns
            relating to species codes and names: *SPCD*,
            *SCIENTIFIC\_NAME*, *COMMON\_NAME*
      - ***snag.csv***: Estimates of standing dead tree (DBH \>= 12.7
        cm) abundance (TPA & BAA) per forested acre and relative to
        population totals (e.g. percent snags by TPA)
          - *YEAR*: FIA reporting year for current abundance estimates
          - *TPA*: estimate of snags per acre
          - *BAA*: estimate of snags basal area (sq.ft.) per acre
          - *TPA\_PERC*: estimate of proportion of snags relative to all
            stems (live and dead), with respect to TPA
          - *BAA\_PERC*: estimate of proportion of snags relative to all
            stems (live and dead), with respect to BAA
          - *nPlots\_TREE*: number of non-zero plots used to compute
            tree and basal area estimates
          - *nPlots\_AREA*: number of non-zero plots used to compute
            land area estimates
          - columns ending in *SE*: estimates of sampling error (%) of
            the respective variable. All sampling error estimates are
            computed with 68% confidence
          - other columns from `ecoregions/at_ecoSub.shp`
      - ***snagLD.csv***: Estimates of *large diameter* standing dead
        tree (DBH \>= 30 cm) abundance (TPA & BAA) per forested acre and
        relative to population totals (e.g. percent snags by TPA)
          - *YEAR*: FIA reporting year for current abundance estimates
          - *TPA*: estimate of large snags per acre
          - *BAA*: estimate of large snags basal area (sq.ft.) per acre
          - *TPA\_PERC*: estimate of proportion of large snags relative
            to all stems (live and dead), with respect to TPA
          - *BAA\_PERC*: estimate of proportion of large snags relative
            to all stems (live and dead), with respect to BAA
          - *nPlots\_TREE*: number of non-zero plots used to compute
            tree and basal area estimates
          - *nPlots\_AREA*: number of non-zero plots used to compute
            land area estimates
          - columns ending in *SE*: estimates of sampling error (%) of
            the respective variable. All sampling error estimates are
            computed with 68% confidence
          - other columns from `ecoregions/at_ecoSub.shp`
      - ***snagV.csv***: Estimates of standing dead tree (DBH \>= 12.7
        cm) biomass, volume, and carbon on a per forested acre basis
          - *YEAR*: FIA reporting year for current abundance estimates
          - *NETVOL\_ACRE*: estimate of snag net volume (cu.ft.) per
            acre
          - *SAWVOL\_ACRE*: estimate of snag merchantable saw volume
            (cu.ft.) per acre
          - *BIO\_AG\_ACRE*: estimate of snag aboveground biomass (tons)
            per acre
          - *BIO\_BG\_ACRE*: estimate of snag belowground biomass (tons)
            per acre
          - *BIO\_ACRE*: estimate of snag total (AG + BG) biomass (tons)
            per acre
          - *CARB\_AG\_ACRE*: estimate of snag aboveground carbon (tons)
            per acre
          - *CARB\_BG\_ACRE*: estimate of snag belowground carbon (tons)
            per acre
          - *CARB\_ACRE*: estimate of snag total (AG + BG) carbon (tons)
            per acre
          - *nPlots\_VOL*: number of non-zero plots used to compute
            volume, biomass, and carbon estimates
          - *nPlots\_AREA*: number of non-zero plots used to compute
            land area estimates
          - columns ending in *SE*: estimates of sampling error (%) of
            the respective variable. All sampling error estimates are
            computed with 68% confidence
          - other columns from `ecoregions/at_ecoSub.shp`
      - ***snagVLD.csv***: Estimates of *large diameter* standing dead
        tree (DBH \>= 30 cm) biomass, volume, and carbon on a per
        forested acre basis
          - *YEAR*: FIA reporting year for current abundance estimates
          - *NETVOL\_ACRE*: estimate of large diameter snag net volume
            (cu.ft.) per acre
          - *SAWVOL\_ACRE*: estimate of large diameter snag merchantable
            saw volume (cu.ft.) per acre
          - *BIO\_AG\_ACRE*: estimate of large diameter snag aboveground
            biomass (tons) per acre
          - *BIO\_BG\_ACRE*: estimate of large diameter snag belowground
            biomass (tons) per acre
          - *BIO\_ACRE*: estimate of large diameter snag total (AG + BG)
            biomass (tons) per acre
          - *CARB\_AG\_ACRE*: estimate of large diameter snag
            aboveground carbon (tons) per acre
          - *CARB\_BG\_ACRE*: estimate of large diameter snag
            belowground carbon (tons) per acre
          - *CARB\_ACRE*: estimate of large diameter snag total (AG +
            BG) carbon (tons) per acre
          - *nPlots\_VOL*: number of non-zero plots used to compute
            volume, biomass, and carbon estimates
          - *nPlots\_AREA*: number of non-zero plots used to compute
            land area estimates
          - columns ending in *SE*: estimates of sampling error (%) of
            the respective variable. All sampling error estimates are
            computed with 68% confidence
          - other columns from `ecoregions/at_ecoSub.shp`
      - ***ss.csv***: Estimates of forest structural stage distributions
        as percent forested land area in pole, mature, late, and mosaic
        stages
          - *YEAR*: FIA reporting year for current abundance estimates
          - *POLE\_PERC*: estimate of proportion forested area in pole
            stage forest
          - *MATURE\_PERC*: estimate of proportion forested area in
            mature stage forest
          - *LATE\_PERC*: estimate of proportion forested area in
            late-seral stage forest
          - *MOSAIC\_PERC*: estimate of proportion forested area in
            mosaic stage (unclassified) forest
          - *nPlots*: number of non-zero plots used to compute current
            area estimates
          - columns ending in *SE*: estimates of sampling error (%) of
            the respective variable. All sampling error estimates are
            computed with 68% confidence
          - other columns from `ecoregions/at_ecoSub.shp`
      - ***tpa.csv***: Estimates of live tree (DBH \>= 12.7 cm)
        abundance (TPA & BAA) per forested acre
          - *YEAR*: FIA reporting year for current abundance estimates
          - *TPA*: estimate of trees per acre
          - *BAA*: estimate of tree basal area (sq.ft.) per acre
          - *TPA\_PERC*: estimate of proportion of trees which are live,
            with respect to TPA
          - *BAA\_PERC*: estimate of proportion of trees which are live,
            with respect to BAA
          - *nPlots\_TREE*: number of non-zero plots used to compute
            tree and basal area estimates
          - *nPlots\_AREA*: number of non-zero plots used to compute
            land area estimates
          - columns ending in *SE*: estimates of sampling error (%) of
            the respective variable. All sampling error estimates are
            computed with 68% confidence
          - other columns from `ecoregions/at_ecoSub.shp`
      - ***tpaS.csv***: Estimates of live tree (DBH \>= 12.7 cm)
        abundance (TPA & BAA) per forested acre *grouped by species*
          - Same as `tpa.csv`, with following additional columns
            relating to species codes and names: *SPCD*,
            *SCIENTIFIC\_NAME*, *COMMON\_NAME*
      - ***vr.csv***: Estimates of (1) individual live tree (DBH \>=
        12.7 cm) diameter, basal area, net volume, and biomass growth
        rates, and (2) basal area, net volume, and biomass growth rates
        expressed on a per forested acre basis
          - *YEAR*: FIA reporting year for growth, removal, and
            mortality estimates
          - *DIA\_GROW*: estimate of annual diameter growth (inches)
            rate for live trees (individual growth)
          - *BA\_GROW*: estimate of annual basal area growth (sq.ft.)
            rate for live trees (individual growth)
          - *NETVOL\_GROW*: estimate of annual net volume growth
            (cu.ft.) rate for live trees (individual growth)
          - *BIO\_GROW*: estimate of annual biomass growth (tons) rate
            for live trees (individual growth)
          - *BAA\_GROW*: estimate of annual basal area growth (sq.ft.)
            per forested acre (stand-level growth)
          - *NETVOL\_GROW\_AC*: estimate of annual net volume growth
            (cu.ft.) per forested acre (stand-level growth)
          - *BIO\_GROW\_AC*: estimate of annual biomass growth (tons)
            per forested acre (stand-level growth)
          - *nPlots\_TREE*: number of non-zero plots used to compute
            tree estimates
          - *nPlots\_AREA*: number of non-zero plots used to compute
            land area estimates
          - columns ending in *SE*: estimates of sampling error (%) of
            the respective variable. All sampling error estimates are
            computed with 68% confidence
          - other columns from `ecoregions/at_ecoSub.shp`
      - ***vrS.csv***: Estimates of (1) individual live tree (DBH \>=
        12.7 cm) diameter, basal area, net volume, and biomass growth
        rates, and (2) basal area, net volume, and biomass growth rates
        expressed on a per forested acre basis *grouped by species*
          - Same as `vr.csv`, with following additional columns relating
            to species codes and names: *SPCD*, *SCIENTIFIC\_NAME*,
            *COMMON\_NAME*
