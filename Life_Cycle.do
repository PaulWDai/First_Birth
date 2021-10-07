/*
Project: Delay of Fertility
US Data (IPUMS-CPS)
Date: Aug 2
*/

********************************************************************************
// Directory and Settings
********************************************************************************

global ipums 		"/Users/weifengdai/Documents/Database/CPS/FertilitySupplement"

global workplace 	"/Users/weifengdai/Documents/Master/2021Summer/Delay_Fertility/Empirics"
global code 		"$workplace/code"
global data 		"$workplace/data"
global figure 		"$workplace/figure"
global tex 			"$workplace/tex"

set more off
set scheme s1color


////////////////////////////////////////////////////////////////////////////////
// US
////////////////////////////////////////////////////////////////////////////////
use "$data/US_cleaned.dta",clear

gen obs = 1
preserve
collapse (mean) inc_censor (sum) obs, by(age5)
gen country = "US"
save "$data/US_life_cycle_income_female_matched.dta",replace
restore

// Baseline: Female by Education Group

preserve
drop if edu ==.
collapse (mean) inc_censor (sum) obs, by(sex age5 edu)
sort edu age
gen country = "US"
save "$data/US_life_cycle_income_female_edu.dta",replace
restore


////////////////////////////////////////////////////////////////////////////////
// Mexico
////////////////////////////////////////////////////////////////////////////////
use "$data/Mexico_cleaned.dta",clear
gen obs =1 

preserve
collapse (mean) inc_censor (sum) obs, by(age5)
gen country = "Mexico"
save "$data/Mexico_life_cycle_income_female_matched.dta",replace
restore


// Baseline: Female by Education Group


// merge with education data
preserve
drop if edu ==.
collapse (mean) inc_censor (sum) obs, by(sex age5 edu)
sort edu age
gen country = "Mexico"
save "$data/Mexico_life_cycle_income_female_edu.dta",replace
restore



