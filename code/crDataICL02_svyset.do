/*******************************************************************************
2025/11/17 @sankyoh

The Impact of Generative AI Usage Experience on the Acceptance of Medical AI

P: 200 members of the Rakuten Insight panel (excluding students)
E: more GAI usage
C: less GAI usage
O: acceptance of Medical AI

// Calibration weights & ESS //

*******************************************************************************/
***** Setup

local datafolder "./data/"
local in_file    "df01.dta"
local out_file   "df01svy.dta"

use "`datafolder'`in_file'", clear 
keep expv_comb2 outcome* med age tech sex disease income3 educ_cat 

********************************************************************************

* original weight （start from "1"）
gen w0 = 1

* Create age category variables based on external data (e-Stat[14])
gen     agecat = 0 if inrange(age, 20, 29)
replace agecat = 1 if inrange(age, 30, 39)
replace agecat = 2 if inrange(age, 40, 49)
replace agecat = 3 if inrange(age, 50, 59)
replace agecat = 4 if inrange(age, 60, 69)
label define agecat 0 "20-29" 1 "30-39" 2 "40-49" 3 "50-59" 4 "60-69"
label values agecat agecat

* Create a "Gender × Age" category (2-dimensional)
egen sexage    = group(sex agecat), label
egen sexageinc = group(sexage income3), label

* First, let's assess the current situation
summ w0, meanonly
di "sum(w0)=" r(sum)

* Target population size
scalar N_total = 30542

* Scale w0 to N_total (so that the total equals N_total)
gen double w0s = w0 * (N_total / r(sum))

* Use this as the input weight for "rake" using external data (e-Stat[14])
svyset _n [pw=w0s], ///
    rake(i.sexage i.income3, ///
         totals( ///
             1.sexage  = 2578  2.sexage  = 3080  3.sexage  = 3909 ///
             4.sexage  = 3353  5.sexage  = 3583  6.sexage  = 3142 ///
             7.sexage  = 4011  8.sexage  = 3406  9.sexage  = 3480 ///
             1.income3 = 14521 2.income3 = 12156 3.income3 = 3865 ///
             _cons     = 30542) ///
		ll(0.3) ul(10) )
		 
* Again, let's assess the current situation
summ w0, meanonly
di "sum(w0)=" r(sum)

svy: mean age
svy: poisson outcome1 i.expv_comb2 if med==1, irr

svycal rake i.sexage i.income3 [pw=w0s], ///
    totals( /// use the figures in `totals()` form the population size taken from e-Stat[14]
        1.sexage  = 2578   2.sexage  = 3080   3.sexage  = 3909 ///
        4.sexage  = 3353   5.sexage  = 3583   6.sexage  = 3142 ///
        7.sexage  = 4011   8.sexage  = 3406   9.sexage  = 3480 ///
        1.income3 = 14521  2.income3 = 12156  3.income3 = 3865 ///
        _cons     = 30542 ///
    ) ///
    ll(0.3) ul(10) ///
    gen(w_rake)

su w_rake
gen w_rake2 = w_rake * 1/r(mean)

save "`datafolder'`out_file'", replace

	
* Calculate Kish ESS
preserve 
keep if med==1
tempvar w2
gen double `w2' = w_rake2^2

quietly summarize w_rake2, meanonly
scalar Sw  = r(sum)

quietly summarize `w2', meanonly
scalar Sw2 = r(sum)

scalar ESS = (Sw^2) / Sw2
display "Kish ESS = " %9.2f ESS
display "DEFF_w (weights only) = " %9.4f (_N/ESS)

restore

preserve
keep if med==2
tempvar w2
gen double `w2' = w_rake2^2

quietly summarize w_rake2, meanonly
scalar Sw  = r(sum)

quietly summarize `w2', meanonly
scalar Sw2 = r(sum)

scalar ESS = (Sw^2) / Sw2
display "Kish ESS = " %9.2f ESS
display "DEFF_w (weights only) = " %9.4f (_N/ESS)


exit
/* Rejection Analysis

* もともとの重み（便宜サンプルなら 1 から開始）
gen w0 = 1

* 外部データに合わせた年齢カテゴリ変数を作成
gen     agecat = 0 if inrange(age, 20, 29)
replace agecat = 1 if inrange(age, 30, 39)
replace agecat = 2 if inrange(age, 40, 49)
replace agecat = 3 if inrange(age, 50, 59)
replace agecat = 4 if inrange(age, 60, 69)
label define agecat 0 "20-29" 1 "30-39" 2 "40-49" 3 "50-59" 4 "60-69"
label values agecat agecat

* 性別×年齢 のカテゴリを作る（2次元）
egen sexage    = group(sex agecat), label
egen sexageinc = group(sexage income3), label

* 2) svyset + raking
*    totals() の数値は、通信利用動向調査（e-Stat）から取った母集団人数に置き換える
svyset _n [pw=w0], ///
	rake(i.sexage i.income3, ///
		totals( ///
			1.sexage  = 2578  /// female 20-29
			2.sexage  = 3080  /// female 30-39
			3.sexage  = 3909  /// female 40-49
			4.sexage  = 3353  /// female 50-59
			5.sexage  = 3583  /// female 60-69
			6.sexage  = 3142  /// male 30-39
			7.sexage  = 4011  /// male 40-49
			8.sexage  = 3406  /// male 50-59
			9.sexage  = 3480  /// male 60-69
			1.income3 = 14521 /// -6M
			2.income3 = 12156 /// 6M-10M
			3.income3 = 3865 /// 10M-
			_cons     = 30542 ///
		) ///
		ll(0.3) ul(3) ///
	)

