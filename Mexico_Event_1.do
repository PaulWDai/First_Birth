/*
Project: Delay of Fertility
US Data (IPUMS-CPS)
Date: Aug 2
*/

// data Mexico: clearance

********************************************************************************
// Directory and Settings
********************************************************************************

global mxfls		"/Users/weifengdai/Documents/Database/MxFLS"
global mxfls1		"$mxfls/MxFLS-1 (2002)"
global mxfls2		"$mxfls/MxFLS-2 (2005-2006)"
global mxfls3		"$mxfls/MxFLS-3 (2009-2012)"

global mxfls1data	"$mxfls1/Data"
global mxfls2data	"$mxfls2/Data"
global mxfls3data	"$mxfls3/Data"


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

use "$mxfls1data/hh02dta_b3a/iiia_tb",clear

preserve
tempfile sex
use "$mxfls1data/hh02dta_bc/c_ls",clear
rename ls04 sex
rename ls02_2 age
rename ls13_1 worked_last_12m
rename ls13_2 income_last_12m


drop if sex== .
replace sex = 2 if sex==3

// keep folio ls ls00i sex age *_12m
keep folio ls sex age *_12m
save `sex'
restore

merge 1:1 folio ls  using `sex',
rename _merge basic_merge

// income info
preserve
tempfile income
use "$mxfls1data/hh02dta_bc/c_portad",clear
drop if folio ==.
drop if ls ==.
save `income'
restore

merge 1:1 folio ls using `income'

rename _merge income_merge


// pregnancy history
merge 1:1 folio ls using "$mxfls1data/hh02dta_b4/iv_res"
rename _merge pregnancy_merge

// birth history
merge 1:1 folio ls using "$mxfls1data/hh02dta_b4/iv_he"
rename _merge birth_history_merge

// first birth info
preserve
tempfile first_birth
use "$mxfls1data/hh02dta_b4/iv_he1",clear

///keep if ///he10a == 1 | 
keep if he10b == 2 
///| he10d ==4

// folio: hhid; ls: indid
bysort folio ls: egen fbage = min(he07) 
duplicates drop folio ls,force
// keep folio ls fbage
gen fbage5 = floor(fbage/5)*5
save `first_birth'
restore

merge 1:1 folio ls using `first_birth'
rename _merge first_birth_merge

// education info
merge 1:1 folio ls using "$mxfls1data/hh02dta_b3a/iiia_ed"
rename _merge education_merge

// control info
preserve
tempfile control
use "$mxfls1data/hh02dta_b4/iv_conpor",clear
bysort folio ls: egen max_sequence = max(secuencia)
keep if secuencia == max_sequence
save `control'
restore

merge 1:1 folio ls using `control'
rename _merge control_merge

////////////////////////////////////////////////////////////////////////////////
// variables of interest
////////////////////////////////////////////////////////////////////////////////

// sex
keep if sex ==2

// year
/*
rename anio year
replace year = year+2000
*/
gen year = 2002
// age
keep if age>=15 & age<=49
gen age5 = floor(age/5)*5

// labor market status
// 3. Attended School 4. Homemaker 5. Was sick 6. Retired 7. Did not work/ nothing 9. Other
// drop if inlist(tb02,3,4,5,6,7,9,.)

gen labor = (inlist(tb02,3,4,5,6,7,9,.))


// total income
gen inc = .
replace inc = tb21_2 if inlist(tb17,3,4) & labor == 1
replace inc = tb222_2 * 12 if inlist(tb17,1,5,6) & labor == 1
replace inc = tb36a_2 if inlist(tb17,2,7,.) & labor == 1
replace inc = tb36a_2 + tb36b_2 if inlist(tb17,2,7,.) & tb36a_2!=. & tb36b_2!=. & labor == 1
// 		use another variable 
replace inc = income_last_12m if inc ==. & worked_last_12m ==1 

// drop if inc<0
winsor inc, gen(inc_censor) p(.05)
// drop if inc_censor==.

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
replace edu = 1 if inlist(ed06,1,2,3,4,5) // w/o instruction, preschool or kinder, elementary, secondary, open secondary
replace edu = 2 if inlist(ed06,6,7,8) // high, open high, normal basic
replace edu = 3 if inlist(ed06,9,10) // college, graduate


gen edud = .
replace edud = 1 if inlist(ed06,1,2,3) // w/o instruction, preschool or kinder, elementary
replace edud = 2 if inlist(ed06,4,5) // secondary, open secondary
replace edud = 3 if inlist(ed06,6,7,8) // high, open high, normal basic
replace edud = 4 if inlist(ed06,9,10) // college, graduate

// nochild
gen nochild = . 

replace nochild = 1 if res01 == 3 // no child ever born alive
replace nochild = 0 if res01 == 1 // have child ever born alive

// first birth age
// see above: pregnancy history and birth history

// keep short-listed variables
keep folio ls  age* year ///
 sex  inc* edu* nochild fbage*

//drop folio ls

foreach var of var *{
rename `var' `var'_1
}



rename folio_1 folio
rename ls_1 ls


save "$data/Mexico_cleaned_1.dta",replace






