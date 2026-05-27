<!-- code/README.md -->
# Stata analysis scripts

This directory contains the Stata scripts used for data preparation, descriptive analyses, subgroup-specific modified Poisson regression, and interaction analyses for the study on routine generative AI use and acceptance of medical AI in Japan.

## Software

- Recommended software: **StataNow 19.5/MP8**
- User-written command used in the archived workflow: `evalue`

Before rerunning the analyses, confirm that the required Stata version and user-written commands are available in the local environment.

## Files and roles

### `crDataICL02_svyset.do`
Creates the weighted analytic dataset.

Main tasks:
- retain variables required for analysis
- create age-group variables for calibration
- create raking weights using external benchmark margins
- normalize the weights
- calculate Kish effective sample size (ESS)

Typical input:
- `df01.dta`

Typical output:
- `df01svy.dta`

### `anDesStat.do`
Produces descriptive statistics.

Main tasks:
- summarize background characteristics
- summarize outcomes by occupation and exposure group
- export descriptive tables to Excel files

Typical input:
- `df01.dta`

Typical output:
- Excel files in the output folder

### `anPoisson_subg.do`
Fits subgroup-specific modified Poisson regression models.

Main tasks:
- estimate crude prevalence ratios (PRs)
- estimate adjusted prevalence ratios (aPRs)
- calculate E-values
- export model results to Excel

Typical input:
- `df01svy.dta`

Typical output:
- `Table2a_RR_Evalue_svy.xlsx`

### `anPoisson_interact.do`
Fits interaction models in the full sample.

Main tasks:
- estimate multiplicative interaction terms between GAI use and occupation
- export model results to Excel

Typical input:
- `df01svy.dta`

Typical output:
- `Table2b_RR_Evalue_svy.xlsx`

### `anSummaryGraph.do`
Generates the forest plot of adjusted prevalence ratios.

Main tasks:
- manually define adjusted PR estimates and 95% confidence intervals for each outcome and subgroup
- create a log-scale forest plot stratified by occupation group
- export the figure as PNG and TIFF files

Typical input:
- The script uses values entered directly in the `input` block. It does not automatically read the Excel output from the regression scripts.

Typical output:
- `Figure1_forestplot_aPR.png`
- `Figure1_forestplot_aPR.tif`

Important note:
- If the regression results are updated, the values in the `input` block must be updated before regenerating the figure.

### `anPoisson_subg_ordinal.do`
Fits subgroup-specific modified Poisson regression models using the 4-level categorical exposure variable as a sensitivity analysis.

Main tasks:
- use `expv_comb4` instead of the main binary exposure variable
- estimate crude PRs and adjusted PRs for each non-reference exposure level
- calculate E-values for PR estimates
- export model results to Excel

Typical input:
- `df01svy.dta`

Typical output:
- `Table3_RR_Evalue_svy_sens.xlsx`

Important note:
- In the current script, the reference level is set by `local reflevel 1`, and the estimated contrasts are `2 vs 1`, `3 vs 1`, and `4 vs 1`. Confirm that this coding matches the intended exposure definition before rerunning the script.

### `anAbsDiff_subg.do`
Estimates subgroup-specific absolute risk differences for the main binary exposure definition as a sensitivity analysis.

Main tasks:
- fit crude and adjusted modified Poisson regression models by occupation group
- use `margins, dydx()` to estimate risk differences (RDs) and adjusted risk differences (aRDs)
- export RD estimates and 95% confidence intervals to Excel

Typical input:
- `df01svy.dta`

Typical output:
- `Table4_RD_svy_sens.xlsx`

Important note:
- E-values are not calculated for RD or aRD estimates. In the current script, placeholder values are entered for the E-value columns to preserve a consistent output structure.

## Recommended execution order

Run the scripts in the following order for the archived workflow:

1. `crDataICL02_svyset.do`
2. `anDesStat.do`
3. `anPoisson_subg.do`
4. `anPoisson_interact.do`
5. `anSummaryGraph.do`
6. `anPoisson_subg_ordinal.do`
7. `anAbsDiff_subg.do`

The first four scripts correspond to the core analytic workflow from data preparation to descriptive analysis and regression-based inference. The forest plot script should be run after confirming the final adjusted PR estimates. The 4-level exposure analysis and absolute risk difference analysis are sensitivity analyses and can be run after the weighted analytic dataset has been created.

## Notes on paths and directories

The current scripts may expect local paths such as `./data/` and an output directory such as `./excel/`. Before rerunning the code in a clean environment, check and revise path settings as needed.

Recommended checks before execution:
- confirm where the input `.dta` files are stored
- confirm that the output directory exists or can be created
- confirm that write permissions are available
- confirm that relative paths remain valid after repository publication
- confirm that the coding of exposure variables matches the intended reference categories
- confirm that manually entered figure values are consistent with the final regression results
## Reproducibility note

This repository is maintained as a versioned reproducibility package for the archived analyses.
