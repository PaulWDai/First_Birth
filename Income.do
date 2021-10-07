/*
Project: Delay of Fertility
US Data (IPUMS-CPS)
Date: Aug 20
*/

********************************************************************************
// Directory and Settings
********************************************************************************

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
gen obs =1 
drop if inc_quan == . 
********************************************************************************
// Nochild and income
********************************************************************************

preserve
collapse (mean) nochild (sum) obs, by(inc_quan)
gen country = "US"
save "$data/US_nochild_income.dta",replace
restore


********************************************************************************
// First Birth Age and Income
********************************************************************************

preserve
keep if nochild ==0
collapse (mean) fbage (sum) obs, by(inc_quan)
gen country = "US"
save "$data/US_fbage_income.dta",replace
restore

////////////////////////////////////////////////////////////////////////////////
// Mexico
////////////////////////////////////////////////////////////////////////////////


use "$data/Mexico_cleaned.dta",clear
gen obs = 1
drop if inc_quan == .

********************************************************************************
// Nochild and Income
********************************************************************************

preserve
collapse (mean) nochild (sum) obs, by(inc_quan)
gen country = "Mexico"
save "$data/Mexico_nochild_income.dta",replace
restore


********************************************************************************
// First Birth Age and Income
********************************************************************************
preserve
collapse (mean) fbage (sum) obs, by(inc_quan)
gen country = "Mexico"
save "$data/Mexico_fbage_income.dta",replace
restore




