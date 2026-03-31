/*******************************************************************************
2025/11/17 @sankyoh

The Impact of Generative AI Usage Experience on the Acceptance of Medical AI

P: 200 members of the Rakuten Insight panel (excluding students)
E: more GAI usage
C: less GAI usage
O: acceptance of Medical AI

// Descriptive Statistics //

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
local in_file    "df01.dta"



local expv expv_comb2
local outvs outcome
local effm  med
local con_vars age
local bin_vars tech sex disease
local cat_vars income3 educ_cat
local des_vars i.sex age i.educ_cat i.income3 i.disease i.tech ///
	i.outcome1 i.outcome2 i.outcome3 i.outcome4 i.outcome5

cap mkdir excel

********************************************************************************

* Data import
use "`datafolder'`in_file'", clear
keep expv_comb2 outcome* med age tech sex disease income3 educ_cat 
********************************************************************************
***** dtable

forvalues x=1/2 {
* Descriptive Table
dtable `des_vars' if med==`x', ///
		by(`expv', nototals) ///
		column(by(hide)) /// 
		sample(, place(seplabels)) ///
		///
		/// define(iqi = q1 q3, delimiter(", ")) ///
		/// sformat("[%s]" iqi) /// 
		///	
		nformat(%16.2fc mean sd q1 q2 q3) ///
		continuous(, test(regress)) ///
		/// continuous(`iqr_vars', statistic(q2 iqi)) ///
		factor(,test(pearson)) ///
		///
		note(Mean(SD) or N(%)) ///
		note(Median[IQR]) ///
		///
		export("./excel/dtab_med`x'.xlsx", as(xlsx) replace)
}

exit
/* Rejection Analysis

* Descriptive Table (weighted analysis)
foreach w of local wt {
	svyset _n [pw=`w']
	dtable `des_vars', ///
			by(`expv', nototals tests) ///
			column(by(hide)) /// 
			sample(, place(seplabels)) ///
			///
			define(iqi = q1 q3, delimiter(", ")) ///
			sformat("[%s]" iqi) /// 
			///	
			nformat(%16.2fc mean sd q1 q2 q3 fvfreq fvper) ///
			continuous(, test(regress)) ///
			continuous(`iqr_vars', statistic(q2 iqi)) ///
			factor(,test(pearson)) ///
			///
			note(Mean(SD) or N(%)) ///
			note(Median[IQR]) ///
			///
			svy ///
			///
			// export("./excel/des_tab_wt1_`w'.xlsx", as(xlsx) replace)
	
	bys age_cat: tabstat stbw1 , s(sum)
}		
