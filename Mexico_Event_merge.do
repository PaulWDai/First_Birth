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

foreach yr of numlist 1 2 3{
rename year_`yr' year
merge m:1 year using "$data/Mexico_inflation.dta", keepusing(priceratio)
drop _merge
rename year year_`yr'
rename priceratio priceratio_`yr'
gen r_inc_censor_`yr' = inc_censor_`yr'/priceratio_`yr'
}


foreach x of numlist 1(1)3{
gen birth_`x' =.
replace birth_`x' = 1 if fbage < age_`x'
replace birth_`x' = 0 if fbage >= age_`x'
}


keep age_* year_* edu_* edud_* birth_* r_inc_censor_** ///
 pid_link miscarriage stillbirth loss expect_born fbage 
drop if pid_link == ""

reshape long age_ year_ edu_ edud_ birth_ r_inc_censor_, i(pid_link miscarriage stillbirth loss expect_born fbage) j(survey)

rename age_ age
rename year_ year
rename edu_ edu
rename edud_ edud
rename birth_ birth
rename r_inc_censor_ rincc

gen lnrinc = log(rincc+(1+rincc^2)^0.5)

gen age2 = age^2

keep if birth ==1

drop if rinc ==.

//keep if age>30

// baseline
reg lnrinc fbage i.year
est store reg_base
reg lnrinc fbage age age2 i.year
est store reg_age
reg lnrinc fbage age age2 i.edud i.year
est store reg_age_edud

// IV regression
ivregress 2sls lnrinc  (fbage = loss)
est store iv_base
ivregress 2sls lnrinc age age2 i.year (fbage = loss)
est store iv_age
ivregress 2sls lnrinc age age2 i.edud i.year (fbage = loss)
est store iv_edud

label var fbage "Age at First Birth"
esttab reg_* iv_* ///
		using "$tex/Mexico_income_fbage.tex", replace style(tex) ///
		title("") mtitle("OLS" "OLS" "OLS" "IV" "IV" "IV") ///
		keep(fbage) ///
		label
		
