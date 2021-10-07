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
gen obs = 1
drop if fbage5 ==.
preserve
drop sex
collapse (sum) obs [aw = frsuppwt], by(fbage5)
egen total = sum(obs)
gen ratio = obs/total*100
gen country = "US"
save "$data/US_fbage_1549",replace

restore


// Robustness: Conditional on female with age 40-49
preserve
keep if age>=40 & age<=49
drop sex
collapse (sum) obs [aw = frsuppwt], by(fbage5)
egen total = sum(obs)
gen ratio = obs/total*100
gen country = "US"
save "$data/US_fbage_4049",replace

restore


********************************************************************************
// Mexico
********************************************************************************
clear

// fbage5 = 15 is the group of age < 20

use "$data/mexico_cleaned.dta",clear

gen obs = 1
drop if fbage5 == .

preserve
collapse (sum) obs, by(fbage5)
egen total = sum(obs)
gen ratio = obs/total*100
gen country = "Mexico"
save "$data/Mexico_fbage_1549",replace
restore

// Robustness: Conditional on female with age 40-44
preserve
keep if age>=40 & age<=49
collapse (sum) obs, by(fbage5)
egen total = sum(obs)
gen ratio = obs/total*100
gen country = "Mexico"
save "$data/Mexico_fbage_4049",replace

restore








