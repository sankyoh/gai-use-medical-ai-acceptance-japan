<!-- codebook.md -->
# Codebook for Shared Analytic Dataset

## Dataset overview

This codebook describes the shared de-identified analytic dataset used in the archived analysis of routine generative AI use and acceptance of medical AI in Japan.

- **Expected file name:** `df01svy.dta`
- **Observations:** 200
- **Variables in shared analytic dataset:** 15
- **Population represented by analysis target:** Japanese internet users, approximated through calibration weighting
- **Primary subgroups:** Healthcare workers and non-healthcare workers

## Important note on coding

Several variables in the shared Stata dataset use attached **value labels** such as `med`, `mai`, `ny`, `sex`, `expv_comb2`, `educ_cat`, and `income3`. The precise numeric coding should therefore be read from the original Stata value labels in the released `.dta` file.

The interpretations below describe the substantive meaning of each variable based on the manuscript and analysis scripts. They should not be treated as a substitute for the embedded Stata value labels.

## Variables

| Variable | Type | Variable label | Substantive definition | Analytic role | Notes |
|---|---|---|---|---|---|
| `med` | byte | EM: 医療従事者か？ | Occupation subgroup indicator distinguishing healthcare workers from non-healthcare workers | Effect modifier / subgroup variable | The scripts indicate subgroup-specific analyses by occupation |
| `outcome1` | byte | 画像診断補助AI | Acceptance of AI-assisted imaging interpretation | Outcome | Binary outcome derived from a four-point acceptability item |
| `outcome2` | byte | 患者状態予測AI | Acceptance of AI-based health risk prediction | Outcome | Binary outcome |
| `outcome3` | byte | 治療方法提案AI | Acceptance of AI-based treatment recommendations | Outcome | Binary outcome |
| `outcome4` | byte | 緊急度判断AI | Acceptance of AI-enabled triage guidance | Outcome | Binary outcome |
| `outcome5` | byte | 手術支援ロボAI | Acceptance of AI-assisted robotic surgery | Outcome | Binary outcome |
| `disease` | byte | Chronic disease | Current chronic disease requiring regular hospital visits or treatment | Covariate | Derived from self-report |
| `expv_comb2` | byte | Exp: GAI利用 組み合わせ2 | Routine generative AI use, dichotomized as GAI user versus non-GAI user | Primary exposure | Based on two five-point usage items: use at work and in daily life |
| `educ_cat` | byte | Education | Educational attainment in five ordered categories | Covariate | Categories described in manuscript |
| `tech` | byte | Interest in new technologies | Interest in new technologies such as smartphones, apps, or web services | Covariate | Dichotomized from a five-point item |
| `sex` | byte | Sex | Sex category | Covariate / weighting variable | Also used in calibration weighting through sex-by-age groups |
| `age` | byte | Age | Age in years | Covariate / weighting variable | Used as a continuous covariate; quadratic term added in regression models |
| `income3` | byte | Annual income (JPY) | Household annual income in three categories | Covariate / weighting variable | Also used in calibration weighting |
| `w_rake` | double |  | Calibration weight created by raking | Weight variable | Created from external benchmarks for Japanese internet users |
| `w_rake2` | float |  | Normalized calibration weight | Weight variable used in analysis | Used in the regression scripts as the main probability weight |

## Variable definitions in more detail

### Exposure

#### `expv_comb2`

Routine GAI use was derived from two questionnaire items:

- GAI use at work
- GAI use in daily life outside work

Each item used a five-point response scale:

- almost daily
- several times a week
- several times a month
- rarely
- never

Respondents who answered **rarely** or **never** to **both** items were classified as **non-GAI users**. All other respondents were classified as **GAI users**.

### Outcomes

#### `outcome1` to `outcome5`

Acceptance of medical AI was measured separately for five clinical scenarios:

1. AI-assisted imaging interpretation
2. AI-based health risk prediction
3. AI-based treatment recommendations
4. AI-enabled triage guidance
5. AI-assisted robotic surgery

For each scenario, respondents answered a four-point acceptability item:

- acceptable
- somewhat acceptable
- somewhat unacceptable
- unacceptable

The shared analytic dataset contains a dichotomized version of each outcome:

- acceptance
- non-acceptance

### Covariates

#### `sex`

Sex category included as a prespecified covariate and used in calibration weighting.

#### `age`

Age in years. In adjusted regression models, age was modeled using both a linear and quadratic term.

#### `educ_cat`

Educational attainment, described in the manuscript as:

- Junior High School
- High School
- Some College
- University
- Graduate School

#### `income3`

Household annual income grouped into three categories:

- 6 million JPY or less
- over 6 million JPY to 10 million JPY
- over 10 million JPY

#### `disease`

Presence of chronic disease requiring regular treatment or hospital visits.

#### `tech`

Interest in new technologies. In the manuscript, this was defined as “interested” when the participant responded “very interested” or “somewhat interested” to the underlying five-point item.

### Weight variables

#### `w_rake`

Calibration weight generated by iterative proportional fitting (raking), using external benchmark margins for:

- sex-by-age group
- household income category

#### `w_rake2`

Normalized version of the calibration weight. This is the weight used in the archived regression analyses.

## Derived and temporary variables not necessarily retained in the shared dataset

The weighting script also generates temporary or intermediate variables during processing, including variables such as:

- `w0`
- `agecat`
- `sexage`
- `sexageinc`
- `w0s`

These variables are part of the computational workflow but may not appear in the final shared analytic dataset if they were excluded before release.

## Missing data

According to the manuscript, no missing values were present in the variables used for the analysis because the web survey required responses to all items before progression and final submission.

## Interpretation caution

This codebook is intended to document the released analytic dataset. It does not replace:

- the original questionnaire instrument,
- embedded Stata value labels, or
- the manuscript Methods section.

Users should interpret variables in conjunction with the manuscript and the archived Stata scripts.
