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


global wb		"/Users/weifengdai/Documents/Database/WorldBank"

set more off
set scheme s1color

clear

////////////////////////////////////////////////////////////////////////////////
// data importing and merging
////////////////////////////////////////////////////////////////////////////////


// inflation data
import delim using "$wb//Inflation, consumer prices (annual %)/API_FP.CPI.TOTL.ZG_DS2_en_csv_v2_2917215.csv", ///
rowr(4:) clear


rename v1 country 
rename v2 countrycode 

foreach x of num 5(1)66{
local year = `x'+1955
rename v`x' inflation`year'
}

drop if _n==1
drop v3 v4

reshape long inflation, i(country countrycode) j(year)
keep if country =="Mexico"

keep if year >=2002 & year<=2012
replace inflation = 0 if year ==2002 // base year = 2002, so that price ratio is 1.
gen inflation2 = log((inflation + 100)/100)
sort year

// base year = 2002
bysort country (year): gen priceratio = exp(sum(inflation2))
drop inflation2
save "$data/Mexico_inflation.dta",replace



// Merge Mexico Data

// merge the survey
use "$data/Mexico_cleaned_1.dta",clear
merge 1:1 folio ls using "$data/Mexico_cleaned_2.dta"
rename _merge _merge_2002_2005

drop if pid_link ==""

preserve
tempfile Mexico_cleaned_3
use "$data/Mexico_cleaned_3.dta",clear
drop if pid_link == ""
save `Mexico_cleaned_3'
restore

merge 1:1 pid_link using `Mexico_cleaned_3'
rename _merge _merge_2002_2005_2009

// merge with first pregnancy history
merge 1:1 pid_link using "$data/Mexico_IV.dta"
rename _merge _merge_IV


////////////////////////////////////////////////////////////////////////////////
// variable of interests
////////////////////////////////////////////////////////////////////////////////

// age of first birth
gen fbage = .
replace fbage = fbage_1
replace fbage = fbage_2 if fbage ==.
replace fbage = fbage_3 if fbage ==.

// childless
gen nochild = .
replace nochild = nochild_3 

drop if fbage==. & nochild ==.



// select short-listed variable
drop *merge*
keep age_* year* ///
inc_1 inc_2 inc_3 inc_censor_* ///
edu* edud*  pid_link fbage nochild* ///
miscarriage stillbirth loss expect_born 

// income growth
foreach yr of numlist 1 2 3{
rename year_`yr' year
merge m:1 year using "$data/Mexico_inflation.dta", keepusing(priceratio)
drop _merge
rename year year_`yr'
rename priceratio priceratio_`yr'

// real income after deflation
gen r_inc_censor_`yr' = inc_censor_`yr'/priceratio_`yr'
// gen r_inc_`yr' = inc_`yr'/priceratio_`yr'
}

gen g_r_inc_censor_12 = (r_inc_censor_2/r_inc_censor_1)^(1/(year_2-year_1))
gen g_r_inc_censor_23 = (r_inc_censor_3/r_inc_censor_2)^(1/(year_3-year_2))

/*
gen g_r_inc_12 = (r_inc_2/r_inc_1)^(1/(year_2-year_1))
gen g_r_inc_23 = (r_inc_3/r_inc_2)^(1/(year_3-year_2))
*/
gen birth_12 =.
replace birth_12 = 1 if age_1 <= fbage & fbage<age_2
replace birth_12 = 0 if age_1 > fbage | fbage >= age_2
//replace birth_12 = 0 if nochild_2 == 1

gen birth_23 = .
replace birth_23 = 1 if age_2 <= fbage & fbage<age_3
replace birth_23 = 0 if age_2 > fbage | fbage >= age_3
//replace birth_23 = 0 if nochild_3 == 1


rename edu_3 edu
rename edud_3 edud
rename age_3 age


// keep *_12 *_23 pid_link edu_3 edud_3 age_3

drop if pid_link == ""

//keep if birth_12 == 0 & birth_23 ==1
/*
reg g_r_inc_censor_23 birth_23 
reg g_r_inc_censor_23 birth_23 age 
reg g_r_inc_censor_23 birth_23 edu
reg g_r_inc_censor_23 birth_23 age edu

*/

keep pid_link edu edud age miscarriage stillbirth loss expect_born fbage *_12 *_23 

reshape long g_r_inc_censor_ g_r_inc_ birth_, i(pid_link edu edud age miscarriage stillbirth loss expect_born fbage) j(time_win)

rename g_r_inc_censor_ g_r_inc_censor
//rename g_r_inc_ g_r_inc
rename birth_ birth



drop if g_r_inc_censor == .  

replace g_r_inc_censor = g_r_inc_censor-1



// gen pid = real(pid_link)
/*
reg g_r_inc_censor birth i.time_win

reg g_r_inc_censor birth age i.time_win

reg g_r_inc_censor birth age edu i.time_win
*/

ivregress g_r_inc_censor


