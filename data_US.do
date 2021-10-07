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

clear

////////////////////////////////////////////////////////////////////////////////
// data importing and merging
////////////////////////////////////////////////////////////////////////////////


use "$ipums/fertility_supplement.dta",clear
// keep if year == 2012
drop if cpsid == 0 | cpsid == . 

preserve
tempfile other_var
use "$ipums/fertility_supplement_other_variables.dta",clear
keep if month == 3
//keep if year == 2012
drop if cpsid == 0 | cpsid ==.
save `other_var'
restore

merge 1:1  cpsid pernum year using `other_var'
keep if year ==2012

////////////////////////////////////////////////////////////////////////////////
// variables of interest
////////////////////////////////////////////////////////////////////////////////

// sex
keep if sex==2 // female

// year
// nothing to adjust

// age
keep if age>=15 & age<=49
gen age5 = floor(age/5)*5

// labor market status
gen labor = (labforce ==2)


// total income
gen inc = .
replace inc = inctot if labor == 1

// drop if inctot<0
winsor inc, gen(inc_censor) p(.025)
// drop if inctot_censor==.


// income quantile

foreach q of numlist 25 50 75{
egen inc_`q' = pctile(inc_censor) ,p(`q')
}

gen inc_quan = .
replace inc_quan = 1 if inc_censor<inc_25
replace inc_quan = 2 if inc_censor>=inc_25 & inc_censor<inc_50
replace inc_quan = 3 if inc_censor>=inc_50 & inc_censor<inc_75
replace inc_quan = 4 if inc_censor>=inc_75 


// education
gen edu = .
replace edu = 1 if educ <=40 // middle
replace edu = 2 if educ >= 50 & educ<=73 // secondary
replace edu = 3 if educ > 73 // college

gen edud = .
replace edud = 1 if educ <=22 // primary
replace edud = 2 if educ >=30 & educ <=40 // middle
replace edud = 3 if educ >= 50 & educ<=73 // secondary
replace edud = 4 if educ > 73 // college

// nochild

gen nochild = .
replace nochild = 1 if frever == 0
replace nochild = 0 if frever >0 & frever<99

count if frbirthy1 == 9999 & nochild!=1
// frbirthy1 = 9999 (no child individual)

// first birth age
gen byr = year-age
gen fbage = frbirthy1 - byr if nochild ==0
gen fbage5 = floor(fbage/5)*5

// keep short-listed variables
keep year serial hwtfinl cpsid pernum wtfinl cpsidp age* sex ///
	inc* fbage* nochild edu* frsuppwt
		
save "$data/US_cleaned.dta",replace
