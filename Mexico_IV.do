/*
Project: Delay of Fertility
MExio Data: Miscarriage, Still Birth IV
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

use "$mxfls3data/hh09dta_b4/iv_he1",clear
drop if he07a==.
bysort folio ls: egen f_preg_age = min(he07a)
keep if he07a == f_preg_age

bysort folio ls: egen min_seq = min(secuencia)
keep if secuencia == min_seq

gen miscarriage = .
replace miscarriage = 1 if he10c == 3
replace miscarriage = 0 if he10a == 1 | he10b == 2 | he10d == 4

gen stillbirth = .
replace stillbirth = 1 if he10d == 4
replace stillbirth = 0 if he10a == 1 | he10b == 2 | he10c == 3

gen loss =.
replace loss = 1 if he10c == 3 | he10d == 4
replace loss = 0 if he10a == 1 | he10b == 2

 
gen expect_born = .
replace expect_born = 1 if he08 == 1
replace expect_born = 0 if he08 == 3



gen pid_link_3 = substr(pid_link,1,6) + substr(pid_link,9,4)
drop pid_link
rename pid_link_3 pid_link

keep miscarriage stillbirth loss expect_born pid_link

save "$data/Mexico_IV.dta",replace




