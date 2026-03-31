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

## Recommended execution order

Run the scripts in the following order:

1. `crDataICL02_svyset.do`
2. `anDesStat.do`
3. `anPoisson_subg.do`
4. `anPoisson_interact.do`

This order reflects the intended workflow from data preparation to descriptive analysis and then regression-based inference.

## Notes on paths and directories

The current scripts may expect local paths such as `./data/` and an output directory for Excel files. Before rerunning the code in a clean environment, check and revise path settings as needed.

Recommended checks before execution:
- confirm where the input `.dta` files are stored
- confirm that the output directory exists
- confirm that write permissions are available
- confirm that relative paths remain valid after repository publication

## Reproducibility note

This repository is maintained as a versioned reproducibility package for the archived analyses.
