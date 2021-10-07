/*
Project: Delay of Fertility
US Data (IPUMS-CPS)
Date: Aug 2
*/

********************************************************************************
// Directory and Settings
********************************************************************************

global ipums 		"/Users/weifengdai/Documents/Database/CPS/FertilitySupplement"
/*
global dsd 			"$raw/UNData/Demographic Statistics Database"
global ginfo 		"$raw/UNData/Gender Info"
global pwt 			"$raw/PWT"
*/

global workplace 	"/Users/weifengdai/Documents/Master/2021Summer/Delay_Fertility/Empirics"
global code 		"$workplace/code"
global data 		"$workplace/data"
global figure 		"$workplace/figure"
global tex 			"$workplace/tex"

set more off
set scheme s1color

********************************************************************************
// US
********************************************************************************

use "$data/US_cleaned.dta",clear
drop sex
drop if edu ==.
gen obs = 1

// childlessness
preserve
drop if edu ==.
replace nochild = nochild*100
collapse (mean) nochild [aw = frsuppwt], by(age5 edu)
gen country = "US"
save "$data/US_childless_edu",replace
restore

// first birth age

drop if fbage5 ==.
// Prob of having first birth by female age (female of all ages)
preserve
collapse (sum) obs [aw = frsuppwt], by(fbage5 edu)
bysort edu: egen total = sum(obs)
gen ratio = obs/total*100
sort edu fbage5
gen country = "US"
save "$data/US_fbage_edu_1549.dta",replace
restore


// Robustness: conditional on female with age 40-49
preserve
keep if age>=40 & age<=49
collapse (sum) obs [aw = frsuppwt], by(fbage5 edu)
bysort edu: egen total = sum(obs)
gen ratio = obs/total*100
sort edu fbage5
gen country = "US"
save "$data/US_fbage_edu_4049.dta",replace
restore



********************************************************************************
// Mexico
********************************************************************************
use "$data/Mexico_cleaned.dta",clear
drop sex
drop if edu ==.
gen obs = 1

// childlessness
preserve
replace nochild = nochild*100
collapse (mean) nochild , by(age5 edu)
gen country = "Mexico"
save "$data/Mexico_childless_edu",replace
restore


// first brith age
drop if fbage5 == .
// Prob of having first birth by female age (female of all ages)
preserve
collapse (sum) obs , by(fbage5 edu)
bysort edu: egen total = sum(obs)
gen ratio = obs/total*100
sort edu fbage5
gen country = "Mexico"
save "$data/Mexico_fbage_edu_1549.dta",replace
restore

// Robustness: conditional on female with age 40-49
preserve
keep if age>=40 & age<=49
collapse (sum) obs,  by(fbage5 edu)
bysort edu: egen total = sum(obs)
gen ratio = obs/total*100
sort edu fbage5
gen country = "Mexico"
save "$data/Mexico_fbage_edu_4049.dta",replace
restore







