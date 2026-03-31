/*******************************************************************************
2025/11/17 @sankyoh

The Impact of Generative AI Usage Experience on the Acceptance of Medical AI

P: 200 members of the Rakuten Insight panel (excluding students)
E: more GAI usage
C: less GAI usage
O: acceptance of Medical AI

// modified Poisson regression

*******************************************************************************/
***** Setup

local datafolder "./data/"
local in_file    "df01svy.dta"
local xlsx       "Table2b_RR_Evalue_svy.xlsx"

local expv  expv_comb2
local outvs outcome1 outcome2 outcome3 outcome4 outcome5
local effm  med
local covars i.sex c.age##c.age i.educ_cat i.income3 i.disease i.tech

cap mkdir excel

* evalue （install if not exist `evalue`）
capture which evalue
if _rc {
    ssc install evalue, replace
}

********************************************************************************

* Data import
use "`datafolder'`in_file'", clear
keep expv_comb2 outcome* med age tech sex disease income3 educ_cat w_rake2
********************************************************************************
* Count drop participants by missing values
tempvar touse_rr
gen `touse_rr' = 1
replace `touse_rr' = 0 if missing(outcome1, outcome2, outcome3, outcome4, outcome5, `expv', tech, sex, age, educ_cat, income3, disease)

count if `touse_rr'
di as text "N used in modified Poisson = `r(N)'"


* postfile for Results store
tempfile results
tempname mem
postfile `mem' ///
    str12 outcome str60 outcome_lab ///
    str8 model ///
    double product lcl ucl p ///
    str35 product_ci ///
    using `results', replace
	
* Main analysis
forvalues x=1/5 {
	* outcome label
	local ylab : variable label outcome`x'
	
	forvalues adj=0/1 {
		* modified Poisson 
		if `adj'==0 {
			poisson outcome`x' i.`expv'##`effm'          [pw=w_rake2], vce(robust) 
			local adjtxt "Crude"
		}
		else {
			poisson outcome`x' i.`expv'##`effm' `covars' [pw=w_rake2], vce(robust) 
			local adjtxt "Adjusted"
		}
		
		* Extract results
		lincom 1.`expv'#2.`effm', eform
		return list
		
		local product =  r(estimate)
		local p  =  r(p)
		local lcl = r(lb)
		local ucl = r(ub)
		
		local product_s : display %6.3f `product'
		local lcl_s : display %6.3f `lcl'
		local ucl_s : display %6.3f `ucl'
		local product_ci "`product_s' (`lcl_s', `ucl_s')"
		
		* Input postfile
		post `mem' ("outcome`x'") ("`ylab'") ("`adjtxt'") ///
			(`product') (`lcl') (`ucl') (`p') ("`product_ci'")


	}
}

postclose `mem'
use `results', clear
list, sepby(outcome)

********************************************************************************
*
* Display & export Excel file
*
********************************************************************************
format product lcl ucl %6.3f
format p %6.3f
order outcome outcome_lab model product_ci p product lcl ucl

list outcome_lab model product_ci p, noobs sepby(outcome)

export excel using "./excel/`xlsx'", firstrow(variables) replace



