<!-- README.md -->
# Association Between Routine Generative AI Use and Acceptance of Medical AI in Japan

This repository contains the analysis code and shared documentation for the study:

**Association Between Routine Generative AI Use and Acceptance of Medical AI Across Clinical Applications: A Cross-Sectional Web Survey Comparing Healthcare Workers and Non-Healthcare Workers in Japan**

## Overview

This study examined whether routine generative AI (GAI) use was associated with acceptance of medical AI across five clinical application scenarios in Japan. The study used a cross-sectional web survey of 200 participants, including 100 healthcare workers and 100 non-healthcare workers. The main estimand was the prevalence ratio (PR), estimated using modified Poisson regression with robust standard errors after calibration weighting targeted to Japanese internet users.

This repository is intended to support transparency and reproducibility of the archived analysis. The manuscript describes the study as exploratory and hypothesis-generating. Users should interpret the archived code and outputs in that context.

## Study summary

- **Design:** Cross-sectional web survey
- **Setting:** Rakuten Insight online research panel, Japan
- **Field period:** 2025-11-14 to 2025-11-17
- **Participants:** 200 adults aged 20–69 years
- **Subgroups:** Healthcare workers and non-healthcare workers
- **Exposure:** Routine GAI use
- **Outcomes:** Acceptance of five medical AI applications
- **Primary effect measure:** Prevalence ratio (PR)
- **Software:** StataNow 19.5/MP8
- **User-written Stata package:** `evalue`

## Repository contents

- `README.md`  
  Repository overview and reproduction notes.

- `code/`  
  Stata analysis scripts.

- `data_shared/`  
  Shared de-identified data files, if public release is permitted.

- `codebook.md`  
  Variable definitions for the shared analytic dataset.

- `LICENSE`  
  License for code in this repository.

## Expected analysis workflow

The archived Stata workflow is organized into the following steps.

1. **Create the weighted analysis dataset**
   - Script: `code/crDataICL02_svyset.do`
   - Input: `df01.dta`
   - Output: `df01svy.dta`
   - Main tasks:
     - retain analysis variables
     - construct age categories
     - create raking weights
     - normalize weights
     - calculate Kish effective sample size (ESS)

2. **Create descriptive tables**
   - Script: `code/anDesStat.do`
   - Input: `df01.dta`
   - Output: Excel files in `excel/`
   - Main task:
     - generate descriptive statistics by occupation and GAI-use status

3. **Estimate subgroup-specific crude and adjusted PRs**
   - Script: `code/anPoisson_subg.do`
   - Input: `df01svy.dta`
   - Output: `excel/Table2a_RR_Evalue_svy.xlsx`
   - Main tasks:
     - fit modified Poisson models
     - estimate subgroup-specific PRs
     - calculate E-values

4. **Estimate multiplicative interaction terms**
   - Script: `code/anPoisson_interact.do`
   - Input: `df01svy.dta`
   - Output: `excel/Table2b_RR_Evalue_svy.xlsx`
   - Main task:
     - fit interaction models in the full sample

## Reproduction notes

### File paths

The archived `.do` files currently expect input data in a local directory named `./data/`, not `./data_shared/`. If this public repository stores released data under `data_shared/`, there are two straightforward options:

- create a local `data/` directory and copy the shared `.dta` files there before running the scripts, or
- edit the `local datafolder` macro in each `.do` file.

### Output file names

Some output file names reflect internal working names used during manuscript preparation. Therefore, Excel output names may not exactly match the final table numbering in the manuscript. Users should rely on the manuscript and variable labels when mapping outputs to published tables.

### Validation before public release

This repository is intended as an archival reproducibility package. Before formal public release, the analysis should be rerun from a clean working directory to confirm that:

- all relative paths are correct,
- all user-written dependencies are installed,
- output file names are mapped clearly to manuscript tables, and
- no non-shareable information remains in the data or scripts.

## Data description

The shared dataset is intended to be a **de-identified analytic dataset** used for the archived analyses. It should not be described as unrestricted source data unless that is factually correct for the released files.

The codebook is provided in `codebook.md`.

## Ethical and data-use note

The study received ethical approval from the Ethics Committee of the Okayama University Graduate School of Medicine, Dentistry and Pharmaceutical Sciences and Okayama University Hospital (approval number: K2510-011; approval date: 2025-10-17).

Any shared dataset must remain de-identified. Users must not attempt to re-identify participants, merge the dataset with external sources for re-identification, or use the data in ways that conflict with the original ethical framework.

## Citation

A Zenodo DOI will be added after archival release.

Suggested placeholder citation:

Mitsuhashi T. Analysis code and shared materials for: Association Between Routine Generative AI Use and Acceptance of Medical AI Across Clinical Applications: A Cross-Sectional Web Survey Comparing Healthcare Workers and Non-Healthcare Workers in Japan. Zenodo. DOI: to be added.

## License

The code in this repository is released under the MIT License. See `LICENSE` for details.

**Important:** The code license does **not automatically apply** to shared data, questionnaire text, or third-party materials. If `data_shared/` is released publicly, its reuse conditions should be stated explicitly in the repository metadata and, if needed, in a separate data-specific license or terms-of-use statement.

## Contact

Toshiharu Mitsuhashi
Center for Innovative Clinical Medicine, Medical Development Field, Okayama University
