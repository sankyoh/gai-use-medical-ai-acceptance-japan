<!-- data_shared/README.md -->
# Shared analytic data

This directory is intended for de-identified shared analytic data used in this repository.

## Purpose

The files in this directory are provided to support transparency and reproducibility of the archived analyses for the study on routine generative AI use and acceptance of medical AI in Japan.

## Expected contents

Depending on the final public-release decision, this directory may contain one or both of the following:

- **`df01.dta`  
  De-identified input data used to construct the analytic dataset.

- **`df01svy.dta`
  De-identified analytic dataset derived from the input data (`df01.dta` and used in the archived statistical analyses.

## Current release policy (Notes for myself)

Only data that can be shared ethically and legally should be placed in this directory.  
No file should contain direct identifiers or information that would make participant re-identification reasonably likely.

## Relationship to the code

The Stata scripts in `code/` use shared data to reproduce the archived analyses.  
Before rerunning the code, users should confirm that:

- the required `.dta` files are present,
- local file paths are correctly set,
- output directories exist, and
- the released data version matches the archived code version.

## Notes for users

- These files are intended for reproducibility purposes.
- The shared data should be interpreted together with `codebook.md` and the manuscript Methods section.
- Users must not attempt to re-identify participants.
- Reuse of shared data may be subject to ethical, legal, or repository-specific conditions even when the repository code is released under an open-source license.

## Related files

- `../README.md` — repository overview
- `../codebook.md` — variable definitions
- `../code/README.md` — analysis workflow and script descriptions
