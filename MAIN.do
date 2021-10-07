/*
Project: Delay of Fertility
US Data (IPUMS-CPS)
Date: Aug 2
*/

********************************************************************************
// Directory and Settings
********************************************************************************
clear

global workplace 	"/Users/weifengdai/Documents/Master/2021Summer/Delay_Fertility/Empirics"
global code 		"$workplace/code"
global data 		"$workplace/data"
global figure 		"$workplace/figure"
global tex 			"$workplace/tex"

set more off
set scheme s1color

run "$code/data_US.do"
run "$code/data_MExico.do"
run "$code/Baseline"
run "$code/Education.do"
run "$code/Education_Detailed.do"
run "$code/Life_Cycle.do"
run "$code/Income.do"
run "$code/Figure.do"
