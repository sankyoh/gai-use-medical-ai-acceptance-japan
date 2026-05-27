*******************************************************
* Figure 1. Forest plot of adjusted prevalence ratios
* Outcome: non-acceptance of medical AI
* Exposure: lower GAI use vs higher GAI use
*******************************************************

clear

input ///
str30 subgroup str45 outcome apr lcl ucl
"Healthcare workers"     "AI-assisted imaging interpretation"  1.741   0.539    5.623
"Healthcare workers"     "AI-based health risk prediction"      6.980   1.412   34.506
"Healthcare workers"     "AI-based treatment recommendations"   4.364   1.331   14.305
"Healthcare workers"     "AI-enabled triage guidance"           2.243   0.821    6.124
"Healthcare workers"     "AI-assisted robotic surgery"          1.986   0.664    5.934
"Non-healthcare workers" "AI-assisted imaging interpretation" 13.906   1.624  119.052
"Non-healthcare workers" "AI-based health risk prediction"      4.861   1.133   20.862
"Non-healthcare workers" "AI-based treatment recommendations"   6.288   1.386   28.530
"Non-healthcare workers" "AI-enabled triage guidance"           1.840   0.521    6.505
"Non-healthcare workers" "AI-assisted robotic surgery"          6.173   1.435   26.561
end

* Subgroup variable for panel display
gen subgroup_id = .
replace subgroup_id = 1 if subgroup == "Healthcare workers"
replace subgroup_id = 2 if subgroup == "Non-healthcare workers"

label define subgroup_id ///
    1 "Healthcare workers" ///
    2 "Non-healthcare workers"
label values subgroup_id subgroup_id

* Outcome order
gen outcome_id = .
replace outcome_id = 5 if outcome == "AI-assisted imaging interpretation"
replace outcome_id = 4 if outcome == "AI-based health risk prediction"
replace outcome_id = 3 if outcome == "AI-based treatment recommendations"
replace outcome_id = 2 if outcome == "AI-enabled triage guidance"
replace outcome_id = 1 if outcome == "AI-assisted robotic surgery"

label define outcome_id ///
    5 "Imaging interpretation" ///
    4 "Health risk prediction" ///
    3 "Treatment recommendations" ///
    2 "Triage guidance" ///
    1 "Robotic surgery"
label values outcome_id outcome_id

* Forest plot
twoway ///
    (rcap lcl ucl outcome_id, horizontal lwidth(medthin)) ///
    (scatter outcome_id apr, msymbol(circle) msize(medlarge)) ///
    , ///
    by(subgroup_id, cols(1) note("") compact legend(off)) ///
    xscale(log range(0.4 150)) ///
    xlabel(0.5 1 2 5 10 20 50 100, format(%9.1g)) ///
    xline(1, lpattern(dash) lwidth(thin)) ///
    ylabel(1(1)5, valuelabel angle(horizontal) labsize(small)) ///
    ytitle("") ///
    xtitle("Adjusted prevalence ratio") ///
    legend(off) ///
    graphregion(color(white)) ///
    plotregion(color(white))

graph export "Figure1_forestplot_aPR.png", replace width(2400)
graph export "Figure1_forestplot_aPR.tif", replace width(2400)