/*
Project: Delay of Fertility
Date: Aug 6
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

clear

********************************************************************************
********************************************************************************
********************************************************************************
// Empirics: Fertiltiy
********************************************************************************
********************************************************************************
********************************************************************************


********************************************************************************
********************************************************************************
// 			Baseline Results: Childlessness and Age at First Birth
********************************************************************************
********************************************************************************

********************************************************************************
// Childlessness
********************************************************************************
use "$data/US_childless.dta",clear
append using "$data/Mexico_childless.dta"


tw (conn nochild age if country =="US", ///
m(O) msize(large) lp(-.-) lw(thick)) ///
(conn nochild age if country =="Mexico", ///
m(D) msize(large) lp(_##) lw(thick)), ///
xlabel(15 "15-19" 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid) ///
ylabel(0(20)100,grid) ///
ytitle("Percentage") xtitle("Age") title("Percentage of Childlessness") ///
legend(order(1 "US" 2 "Mexico"))
graph export "$figure/childless.pdf", as(pdf) replace


********************************************************************************
// Age at First Birth
********************************************************************************

// Baseline Age: 15-49

use "$data/Mexico_fbage_1549",clear
append using "$data/US_fbage_1549"

// figure
tw (conn ratio fbage if country == "US", ///
m(O) msize(large) lp(-.-) lw(thick) ) ///
(conn ratio fbage if country == "Mexico", ///
m(D) msize(large) lp(_##) lw(thick)), ///
xlabel(10 "10-14" 15 "15-19" 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid) ///
ylabel(0(10)50,grid) ///
legend(order(1 "US" 2 "Mexico")) ///
ytitle("Percentage") xtitle("Age of Having First Birth (Female)") ///
title("Probability of Having First Birth (Aged 15-49)")

graph export "$figure/fbage_1549.pdf", as(pdf) replace

// Robustness: 40-49

use "$data/Mexico_fbage_4049",clear
append using "$data/US_fbage_4049"

// figure
tw (conn ratio fbage if country == "US", ///
m(O) msize(large) lp(-.-) lw(thick)) ///
(conn ratio fbage if country == "Mexico", ///
m(D) msize(large) lp(_##) lw(thick)), ///
xlabel(10 "10-14" 15 "15-19" 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid) ///
ylabel(0(10)50,grid) ///
legend(order(1 "US" 2 "Mexico")) ///
ytitle("Percentage") xtitle("Age of Having First Birth (Female)") ///
title("Probability of Having First Birth (Aged 40-49)")

graph export "$figure/fbage_4049.pdf", as(pdf) replace

********************************************************************************
********************************************************************************
// 			Education Subgroup: Childlessness and Age at First Birth
********************************************************************************
********************************************************************************

********************************************************************************
//						Number of Sugroups = 3
********************************************************************************


********************************************************************************
// Childlessness
********************************************************************************

// US

use "$data/US_childless_edu",clear
tw (conn nochild age if edu == 1 ,m(O) msize(large) lp(-.-) lw(thick) ) ///
(conn nochild age if edu == 2 ,m(D) msize(large) lp(-##) lw(thick) ) ///
(conn nochild age if edu == 3 ,m(T) msize(large) lp() lw(thick) ), ///
xlabel(15 "15-19" 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid) ///
ylabel(0(20)100,grid) ///
ytitle("Percentage") xtitle("Age of Female") ///
title("US: Percentage of Childlessness") ///
legend(order(1 "<High School" 2 "High School" 3 "College" ) rows(1) size(*.8))

graph export "$figure/US_childless_edu.pdf",as(pdf) replace

// Mexico
use "$data/Mexico_childless_edu",clear

tw (conn nochild age if edu == 1 ,m(O) msize(large) lp(-.-) lw(thick) ) ///
(conn nochild age if edu == 2 ,m(D) msize(large) lp(-##) lw(thick) ) ///
(conn nochild age if edu == 3 ,m(T) msize(large) lp() lw(thick) ), ///
xlabel(15 "15-19" 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid) ///
ylabel(0(20)100,grid) ///
ytitle("Percentage") xtitle("Age of Female") ///
title("Mexico: Percentage of Childlessness") ///
legend(order(1 "<High School" 2 "High School" 3 "College" ) rows(1) size(*.8))

graph export "$figure/Mexico_childless_edu.pdf",as(pdf) replace


********************************************************************************
// Age at First Birth
********************************************************************************

// Baseline Age: 15-49

// US 1549
use "$data/US_fbage_edu_1549.dta",clear

// figure
tw (conn ratio fbage5 if edu == 1 ,m(O) msize(large) lp(-.-) lw(thick) ) ///
(conn ratio fbage5 if edu == 2 ,m(D) msize(large) lp(_##) lw(thick) ) ///
(conn ratio fbage5 if edu == 3 ,m(T) msize(large) lp() lw(thick) ), ///
xlabel(15 "15-19" 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid) ylabel(,grid) ///
ylabel(0(10)60,grid) ///
ytitle("Percentage") xtitle("Age of Having First Birth (Female)") ///
title("US: Probability of Having First Birth (Aged 15-49)") ///
legend(order(1 "<High School" 2 "High School" 3 "College" ) rows(1) size(*.8))
graph export "$figure/US_fbage_edu_1549.pdf",as(pdf) replace

// Mexico 1549

use "$data/Mexico_fbage_edu_1549.dta",clear
// figure

tw (conn ratio fbage5 if edu == 1 ,m(O) msize(large) lp(-.-) lw(thick) ) ///
(conn ratio fbage5 if edu == 2 ,m(D) msize(large) lp(_##) lw(thick) ) ///
(conn ratio fbage5 if edu == 3 ,m(T) msize(large) lp() lw(thick) ), ///
xlabel(15 "15-19" 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid) ///
ylabel(0(10)60,grid)  ///
ytitle("Percentage") xtitle("Age of Having First Birth (Female)") ///
title("Mexico: Probability of Having First Birth (Aged 15-49)") ///
legend(order(1 "<High School" 2 "High School" 3 "College" ) rows(1) size(*.8))
graph export "$figure/Mexico_fbage_edu_1549.pdf",as(pdf) replace


// Robustness: 40-49

// US 4049

use "$data/US_fbage_edu_4049.dta",clear
// figure

tw (conn ratio fbage5 if edu == 1 ,m(O) msize(large) lp(-.-) lw(thick) ) ///
(conn ratio fbage5 if edu == 2 ,m(D) msize(large) lp(_##) lw(thick) ) ///
(conn ratio fbage5 if edu == 3 ,m(T) msize(large) lp() lw(thick) ), ///
xlabel(15 "15-19" 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid) ///
ylabel(0(10)50,grid) ///
ytitle("Percentage") xtitle("Age of Having First Birth (Female)") ///
title("US: Probability of Having First Birth (Aged 40-49)") ///
legend(order(1 "<High School" 2 "High School" 3 "College" ) rows(1) size(*.8))
graph export "$figure/US_fbage_edu_4049.pdf",as(pdf) replace


// Mexico 4049

use "$data/Mexico_fbage_edu_4049.dta",clear
// figure

tw (conn ratio fbage5 if edu == 1 ,m(O) msize(large) lp(-.-) lw(thick) ) ///
(conn ratio fbage5 if edu == 2 ,m(D) msize(large) lp(_##) lw(thick) ) ///
(conn ratio fbage5 if edu == 3 ,m(T) msize(large) lp(s) lw(thick) ), ///
xlabel(15 "15-19" 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid)  ///
ylabel(0(10)50,grid) ///
ytitle("Percentage") xtitle("Age of Having First Birth (Female)") ///
title("Mexico: Probability of Having First Birth (Aged 40-49)") ///
legend(order(1 "<High School" 2 "High School" 3 "College" ) rows(1) size(*.8))
graph export "$figure/Mexico_fbage_edu_4049.pdf",as(pdf) replace



********************************************************************************
//						Number of Sugroups = 4
********************************************************************************

********************************************************************************
// Childlessness
********************************************************************************

// US

use "$data/US_childless_edu_detailed",clear
tw (conn nochild age if edud == 1 ,m(O) msize(large) lp(-.-) lw(thick) ) ///
(conn nochild age if edud == 2 ,m(D) msize(large) lp(_##) lw(thick) ) ///
(conn nochild age if edud == 3 ,m(T) msize(large) lp(-_) lw(thick) ) ///
(conn nochild age if edud == 4 ,m(+) msize(large) lp() lw(thick) ), ///
xlabel(15 "15-19" 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid) ///
ylabel(0(20)100,grid) ///
ytitle("Percentage") xtitle("Age of Female") ///
title("US: Percentage of Childlessness") ///
legend(order(1 "Primary" 2 "Middle" 3 "Secondary" 4 "College") rows(1) size(*.8))

graph export "$figure/US_childless_edu_detailed.pdf",as(pdf) replace

// Mexico
use "$data/Mexico_childless_edu_detailed",clear

tw (conn nochild age if edud == 1 ,m(O) msize(large) lp(-.-) lw(thick) ) ///
(conn nochild age if edud == 2 ,m(D) msize(large) lp(_##) lw(thick) ) ///
(conn nochild age if edud == 3 ,m(T) msize(large) lp(-_) lw(thick) ) ///
(conn nochild age if edud == 4 ,m(+) msize(large) lp() lw(thick) ), ///
xlabel(15 "15-19" 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid) ///
ylabel(0(20)100,grid) ///
ytitle("Percentage") xtitle("Age of Female") ///
title("Mexico: Percentage of Childlessness") ///
legend(order(1 "Primary" 2 "Middle" 3 "Secondary" 4 "College") rows(1) size(*.8))

graph export "$figure/Mexico_childless_edu_detailed.pdf",as(pdf) replace


********************************************************************************
// Age at First Birth
********************************************************************************

// Baseline Age: 15-49

// US 1549
use "$data/US_fbage_edu_detailed_1549.dta",clear

// figure
tw (conn ratio fbage5 if edud == 1 ,m(O) msize(large) lp(-.-) lw(thick) ) ///
(conn ratio fbage5 if edud == 2 ,m(D) msize(large) lp(_##) lw(thick) ) ///
(conn ratio fbage5 if edud == 3 ,m(T) msize(large) lp(-_) lw(thick) ) ///
(conn ratio fbage5 if edud == 4 ,m(+) msize(large) lp() lw(thick) ), ///
xlabel(10 "10-14" 15 "15-19" 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid) ylabel(,grid) ///
ylabel(0(10)60,grid) ///
ytitle("Percentage") xtitle("Age of Having First Birth (Female)") ///
title("US: Probability of Having First Birth (Aged 15-49)") ///
legend(order(1 "Primary" 2 "Middle" 3 "Secondary" 4 "College") rows(1) size(*.8))
graph export "$figure/US_fbage_edu_detailed_1549.pdf",as(pdf) replace

// Mexico 1549
use "$data/Mexico_fbage_edu_detailed_1549.dta",clear
// figure

tw (conn ratio fbage5 if edud == 1 ,m(O) msize(large) lp(-.-) lw(thick) ) ///
(conn ratio fbage5 if edud == 2 ,m(D) msize(large) lp(_##) lw(thick) ) ///
(conn ratio fbage5 if edud == 3 ,m(T) msize(large) lp(-_) lw(thick) ) ///
(conn ratio fbage5 if edud == 4 ,m(+) msize(large) lp() lw(thick) ), ///
xlabel(10 "10-14" 15 "15-19" 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid) ///
ylabel(0(10)60,grid)  ///
ytitle("Percentage") xtitle("Age of Having First Birth (Female)") ///
title("Mexico: Probability of Having First Birth (Aged 15-49)") ///
legend(order(1 "<High School" 2 "High School" 3 "College" ) rows(1) size(*.8))
graph export "$figure/Mexico_fbage_edu_detailed_1549.pdf",as(pdf) replace


// Robustness: 40-49

// US 4049

use "$data/US_fbage_edu_detailed_4049.dta",clear
// figure

tw (conn ratio fbage5 if edud == 1 ,m(O) msize(large) lp(-.-) lw(thick) ) ///
(conn ratio fbage5 if edud == 2 ,m(D) msize(large) lp(_##) lw(thick) ) ///
(conn ratio fbage5 if edud == 3 ,m(T) msize(large) lp(-_) lw(thick) ) ///
(conn ratio fbage5 if edud == 4 ,m(+) msize(large) lp() lw(thick) ), ///
xlabel(10 "10-14" 15 "15-19" 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid) ///
ylabel(0(10)50,grid) ///
ytitle("Percentage") xtitle("Age of Having First Birth (Female)") ///
title("US: Probability of Having First Birth (Aged 40-49)") ///
legend(order(1 "Primary" 2 "Middle" 3 "Secondary" 4 "College") rows(1) size(*.8))
graph export "$figure/US_fbage_edu_detailed_4049.pdf",as(pdf) replace


// Mexico 4049

use "$data/Mexico_fbage_edu_detailed_4049.dta",clear
// figure

tw (conn ratio fbage5 if edud == 1 ,m(O) msize(large) lp(-.-) lw(thick) ) ///
(conn ratio fbage5 if edud == 2 ,m(D) msize(large) lp(_##) lw(thick) ) ///
(conn ratio fbage5 if edud == 3 ,m(T) msize(large) lp(-_) lw(thick) ) ///
(conn ratio fbage5 if edud == 4 ,m(+) msize(large) lp() lw(thick) ), ///
xlabel(10 "10-14" 15 "15-19" 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid)  ///
ylabel(0(10)50,grid) ///
ytitle("Percentage") xtitle("Age of Having First Birth (Female)") ///
title("Mexico: Probability of Having First Birth (Aged 40-49)") ///
legend(order(1 "Primary" 2 "Middle" 3 "Secondary" 4 "College") rows(1) size(*.8))
graph export "$figure/Mexico_fbage_edu_detailed_4049.pdf",as(pdf) replace


********************************************************************************
********************************************************************************
********************************************************************************
// Empirics: Life Cycle Income
********************************************************************************
********************************************************************************
********************************************************************************

// Baseline:


/* 

Exchange rate: Mexico to US 2009 2010 2011 2012

0.10410817
0.113481537
0.118791364
0.12064907

*/

use "$data/Mexico_life_cycle_income_female_matched.dta",clear
append using "$data/US_life_cycle_income_female_matched.dta"

replace inc_censor = (0.10410817+0.113481537+0.118791364+0.12064907)/4*inc_censor /// 
		if country == "Mexico"

reshape wide inc_censor obs, i(country) j(age5)

foreach age of numlist 20(5)45{
gen incratio`age' = inc_censor`age' / inc_censor20
}
keep country incratio*
reshape long incratio,i(country) j(age5)


tw (conn incratio age5 if country =="US", ///
m(O) msize(large) lp(-.-) lw(thick)) ///
(conn incratio age5 if country =="Mexico", ///
m(D) msize(large) lp(_##) lw(thick)), ///
xlabel( 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid) ///
ylabel(,grid) ///
ytitle("Relative Total Income") xtitle("Age") /// //title("Total Annual Income: Female") 
legend(order(1 "US" 2 "Mexico"))

graph export "$figure/total_income_female.pdf",as(pdf) replace



// Education subgroups

use "$data/Mexico_life_cycle_income_female_edu.dta",clear
append using "$data/US_life_cycle_income_female_edu.dta"
replace inc_censor = (0.10410817+0.113481537+0.118791364+0.12064907)/4*inc_censor /// 
		if country == "Mexico"

reshape wide inc_censor obs,i(country edu) j(age5)


foreach age of numlist 20(5)45{
gen incratio`age' = inc_censor`age' / inc_censor20
}
keep country incratio* edu

reshape long incratio,i(country edu)  j(age5)
sort country edu age5

// US
preserve
keep if country == "US"
tw (conn incratio age if edu ==1 , m(O) msize(large) lp(-.-) lw(thick) ) ///
(conn incratio age if edu == 2  ,m(D) msize(large) lp(_##) lw(thick) ) ///
(conn incratio age if edu == 3 ,m(S) msize(large) lp(-_) lw(thick) ), ///
xlabel( 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid) ylabel(,grid) ///
ylabel(.5(.5)3,grid) ///
ytitle("Relative Total Income") xtitle("Age") ///
title("US") ///
legend(order(1 "<High School" 2 "High School" 3 "College" ) rows(1) size(*.8))

graph export "$figure/US_life_cycle_income_female_edu.pdf",as(pdf) replace
restore


preserve
keep if country == "Mexico"
tw (conn incratio age if edu ==1 , m(O) msize(large) lp(-.-) lw(thick) ) ///
(conn incratio age if edu == 2  ,m(D) msize(large) lp(_##) lw(thick) ) ///
(conn incratio age if edu == 3 ,m(S) msize(large) lp(-_) lw(thick) ), ///
xlabel( 20 "20~24" 25 "25~29" 30 "30~34" 35 "35~39" 40 "40~44" 45 "45~49",grid) ylabel(,grid) ///
ylabel(.5(.5)3,grid) ///
ytitle("Relative Total Income") xtitle("Age") ///
title("Mexico") ///
legend(order(1 "<High School" 2 "High School" 3 "College" ) rows(1) size(*.8))

graph export "$figure/Mexico_life_cycle_income_female_edu.pdf",as(pdf) replace
restore

********************************************************************************
********************************************************************************
********************************************************************************
// Empirics: Childlessness and Age at First Born with Income Quantile 
********************************************************************************
********************************************************************************
********************************************************************************


// Childlessness Rate
use "$data/US_nochild_income.dta",clear
append using "$data/Mexico_nochild_income.dta"
replace nochild = 100*nochild

tw (conn nochild inc_quan if country =="US", ///
m(O) msize(large) lp(-.-) lw(thick)) ///
(conn nochild inc_quan  if country =="Mexico", ///
m(D) msize(large) lp(_##) lw(thick)), ///
xlabel(,grid) ///
ylabel(25(5)50,grid) ///
ytitle("Percentage") xtitle("Total Income Quantile") title("Childlessness Rate by Income") ///
legend(order(1 "US" 2 "Mexico"))

graph export "$figure/nochild_income.pdf",as(pdf) replace

// Age at First Birth
use "$data/US_fbage_income.dta",clear
append using "$data/Mexico_fbage_income.dta"

tw (conn fbage inc_quan if country =="US", ///
m(O) msize(large) lp(-.-) lw(thick)) ///
(conn fbage inc_quan  if country =="Mexico", ///
m(D) msize(large) lp(_##) lw(thick)), ///
xlabel(,grid) ///
ylabel(20(1)25,grid) ///
ytitle("Age at First Birth") xtitle("Total Income Quantile") title("Age at First Birth by Income") ///
legend(order(1 "US" 2 "Mexico"))

graph export "$figure/fbage_income.pdf",as(pdf) replace











