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
gen obs = 1
drop if edud ==.

// childlessness
preserve
replace nochild = nochild*100
collapse (mean) nochild [aw = frsuppwt], by(age5 edud)
sort edud age5
gen country = "US"
save "$data/US_childless_edu_detailed",replace
restore

// first birth age

// Prob of having first birth by female age (female of all ages)
drop if fbage5 ==. 
preserve
collapse (sum) obs [aw = frsuppwt], by(fbage5 edud)
bysort edud: egen total = sum(obs)
gen ratio = obs/total*100
sort edud fbage5
gen country = "US"
save "$data/US_fbage_edu_detailed_1549.dta",replace
restore

// Robustness: conditional on female with age 40-49
preserve
keep if age>=40 & age<=49
collapse (sum) obs [aw = frsuppwt], by(fbage5 edud)
bysort edud: egen total = sum(obs)
gen ratio = obs/total*100
sort edud fbage5
gen country = "US"
save "$data/US_fbage_edu_detailed_4049.dta",replace
restore


********************************************************************************
// Mexico
********************************************************************************

use "$data/Mexico_cleaned.dta",clear

drop sex
gen obs = 1
drop if edud ==.

// childlessness
preserve
collapse (mean) nochild , by(age5 edud)
// percentage
replace nochild = nochild*100
keep age5 nochild edu
gen country = "Mexico"
save "$data/Mexico_childless_edu_detailed",replace
restore

// first birth age

// Prob of having first birth by female age (female of all ages)
drop if fbage5 ==.

preserve
collapse (sum) obs , by(fbage5 edud)
bysort edu: egen total = sum(obs)
gen ratio = obs/total*100
sort edud fbage5
gen country = "Mexico"
save "$data/Mexico_fbage_edu_detailed_1549.dta",replace
restore

// Robustness: conditional on female with age 40-49
preserve
keep if age>=40 & age<=49
collapse (sum) obs,  by(fbage5 edud)
bysort edu: egen total = sum(obs)
gen ratio = obs/total*100
sort edud fbage5
gen country = "Mexico"
save "$data/Mexico_fbage_edu_detailed_4049.dta",replace
restore






