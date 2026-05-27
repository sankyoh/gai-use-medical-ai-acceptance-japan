/*******************************************************************************
2025/11/17 @sankyoh

The Impact of Generative AI Usage Experience on the Acceptance of Medical AI

P: 200 members of the Rakuten Insight panel (excluding students)
E: more GAI usage
C: less GAI usage
O: acceptance of Medical AI

// modified Poisson regression

Modified:
- Exposure changed from binary expv_comb2 to 4-level categorical expv_comb4
- Reference category: expv_comb4 = 0
- Estimates are extracted for:
    expv_comb4 = 1 vs 0
    expv_comb4 = 2 vs 0
    expv_comb4 = 3 vs 0

*******************************************************************************/
***** Setup
* Argument
if ("`1'"==""){
	local ch 1 // if `1' is null, channel==med==1 (healthcare worker)
}
else {
	local ch `1' // if `1' isn't null, channel==`1'
}

* Define local macros
local datafolder "./data/"
local in_file    "df01svy.dta"
local xlsx       "Table3_RR_Evalue_svy_sens.xlsx"

local expv  expv_comb4 // For Sensitivity Analysis
local outvs outcome1 outcome2 outcome3 outcome4 outcome5
local effm  med
local covars i.sex c.age##c.age i.educ_cat i.income3 i.disease i.tech

* Reference and comparison levels for the 4-level exposure
local reflevel 1
local levs 2 3 4

cap mkdir excel

* evalue （install if not exist `evalue`）
capture which evalue
if _rc {
    ssc install evalue, replace
}

********************************************************************************
*
* Data import
*
********************************************************************************
use "`datafolder'`in_file'", clear
keep expv_comb4 outcome* med age tech sex disease income3 educ_cat w_rake2

* Count drop participants by missing values
tempvar touse_rr
gen `touse_rr' = 1
replace `touse_rr' = 0 if missing(outcome1, outcome2, outcome3, outcome4, outcome5, `expv', tech, sex, age, educ_cat, income3, disease)

count if `touse_rr'
di as text "N used in modified Poisson = `r(N)'"

********************************************************************************
*
* postfile for Results store
*
********************************************************************************
tempfile results
tempname mem
postfile `mem' ///
    int ch str30 subgroup ///
    str12 outcome str60 outcome_lab ///
    str8 model ///
	byte exp_level str40 contrast ///
    double rr lcl ucl p ///
    double e_point e_ci ///
    str35 rr_ci ///
    using `results', replace

********************************************************************************
*
* Main analysis
*
********************************************************************************
forvalues ch=1/2 {
	preserve
	keep if `effm'==`ch'
	* subgroup label
	local subgroup : label (`effm') `ch'
	forvalues x=1/5 {
		* outcome label
		local ylab : variable label outcome`x'
		
		forvalues adj=0/1 {
			* modified Poisson 
			 * ib0.`expv' explicitly sets expv_comb4=0 as the reference category
			if `adj'==0 {
				poisson outcome`x' ib`reflevel'.`expv'          [pw=w_rake2], robust
				local adjtxt "0 Crude"
			}
			else {
				poisson outcome`x' ib`reflevel'.`expv' `covars' [pw=w_rake2], robust
				local adjtxt "1 Adjusted"
			}
			
			* Extract results for each exposure level:
			* expv_comv4 = 1 vs 0
			* expv_comv4 = 2 vs 0
			* expv_comv4 = 3 vs 0
			
			foreach lev of local levs {
				local contrast "`lev' vs `reflevel'"
				
				lincom `lev'.`expv', eform
							
				local rr =  r(estimate)
				local p  =  r(p)
				local lcl = r(lb)
				local ucl = r(ub)
			
				evalue rr `rr', lcl(`lcl')
			
				local ep = r(eval_est) 
				local ec = r(eval_ci)
			
				local rr_s  : display %6.3f `rr'
				local lcl_s : display %6.3f `lcl'
				local ucl_s : display %6.3f `ucl'
				local rr_ci "`rr_s' (`lcl_s', `ucl_s')"
				local ep_s  : display %6.3f `ep' 
				local ec_s  : display %6.3f `ec'
			
				* Input postfile
				post `mem' ///
					(`ch') ("`subgroup'") ///
					("outcome`x'") ("`ylab'") ///
					("`adjtxt'") (`lev') ("`contrast'") ///
					(`rr') (`lcl') (`ucl') (`p') ///
					(`ep_s') (`ec_s') ("`rr_ci'")
			}

		}
	}
	restore
}

postclose `mem'
use `results', clear
list, sepby(outcome)

********************************************************************************
*
* Display & export Excel file
*
********************************************************************************
format rr lcl ucl %6.3f
format p %6.3f
format e_point e_ci %6.3f

order ch subgroup outcome outcome_lab model exp_level contrast rr_ci p e_point e_ci rr lcl ucl
sort ch outcome model exp_level

list subgroup outcome_lab model contrast rr_ci p e_point e_ci, noobs sepby(ch outcome)

export excel using "./excel/`xlsx'", firstrow(variables) replace



