// Tabel 3 - diagnostic accuracy //
// TB pos = kultur MTB, NTM deemed as negative, TB negative = kultur negative dan NTM //
clear
use "D:\EVIDENT WP1 Data\250703_dataset pl ts ss xpert ts.dta"
diagtest res_swab_pluslife culture_result2 if res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 110 82, wilson
cii proportion 507 499, wilson
diagtest res_swab_pluslife culture_result2 if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 93 66, wilson
cii proportion 327 321, wilson
diagtest res_swab_pluslife culture_result2 if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 17 16, wilson
cii proportion 180 178, wilson

// TB pos = kultur MTB, exclude NTM, TB negative = kultur negative //
drop if cult_ident==2
diagtest res_swab_pluslife culture_result2 if res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 110 82, wilson
cii proportion 492 486, wilson
diagtest res_swab_pluslife culture_result2 if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 93 66, wilson
cii proportion 313 309, wilson
diagtest res_swab_pluslife culture_result2 if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 17 16, wilson
cii proportion 179 177, wilson

// TB pos = xpert positive, trace deemed as positive, TB negative = xpert negative //
clear
use "D:\EVIDENT WP1 Data\250703_dataset pl ts ss xpert ts.dta"
diagtest res_swab_pluslife xpertsputum1 if res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 110 82, wilson
cii proportion 416 413, wilson
diagtest res_swab_pluslife xpertsputum1 if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 107 71, wilson
cii proportion 283 281, wilson
diagtest res_swab_pluslife xpertsputum1 if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 17 16, wilson
cii proportion 133 132, wilson

// TB pos = xpert positive, excluding trace, TB negative = xpert negative //
drop if semi_quant==1 | tcm_result==4 // 15 obs dropped
diagtest res_swab_pluslife xpertsputum1 if res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 119 86, wilson
cii proportion 416 413, wilson
diagtest res_swab_pluslife xpertsputum1 if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 98 70, wilson
cii proportion 283 281, wilson
diagtest res_swab_pluslife xpertsputum1 if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 21 16, wilson
cii proportion 133 132, wilson

// pluslife ts //
// TB pos = kultur MTB, NTM deemed as negative, TB negative=no TB //
gen cultmtb=.
replace cultmtb=1 if culture_result==3 & cult_ident==1
replace cultmtb=0 if culture_result==1 | (culture_result==3 & cult_ident==2)
label define cultmtblab 0 "Negative" 1 "Positive MTB"
label values cultmtb cultmtblab 
sort cultmtb
br culture_result cult_ident cultmtb

drop if subject_cat==6
save "D:\EVIDENT WP1 Data\250703_dataset pl ts ss xpert ts tanpa clinical tb.dta"

// specifity vs no TB //
clear
use "D:\EVIDENT WP1 Data\250703_dataset subject_cat 1 2 3 4 5 6.dta"
gen cultmtb3=.
replace cultmtb3=1 if culture_result==3 & cult_ident==1
replace cultmtb3=0 if subject_cat==4
label define cultmtb3lab 0 "Negative" 1 "Positive MTB"
label values cultmtb3 cultmtb3lab 
sort cultmtb3
br culture_result cult_ident cultmtb3

// TB pos = kultur MTB, NTM deemed as negative)
// diagnostic accuracy by sampling duration //
diagtest res_swab_pluslife cultmtb3 if res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 110 82, wilson
cii proportion 303 302, wilson
diagtest res_swab_pluslife cultmtb3 if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 93 66, wilson
cii proportion 199 198, wilson
diagtest res_swab_pluslife cultmtb3 if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 17 16, wilson
cii proportion 104 104, wilson

// TB-pos = kultur MTB dan excluding NTM, TB negative = no TB //
clear
use "D:\EVIDENT WP1 Data\250703_dataset subject_cat 1 2 3 4 5 6.dta"
drop if cult_ident==2
save "D:\EVIDENT WP1 Data\250703_dataset subject_cat 1 2 3 4 5 6 tanpa ntm.dta"

// pluslife ts //
diagtest res_swab_pluslife cultmtb3 if res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 110 82, wilson
cii proportion 403 398, wilson
diagtest res_swab_pluslife cultmtb3 if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 93 66, wilson
cii proportion 250 246, wilson
diagtest res_swab_pluslife cultmtb3 if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 17 16, wilson
cii proportion 153 152, wilson

// TB-pos = Xpert, trace as positive, TB neg = No TB //
clear
use "D:\EVIDENT WP1 Data\250703_dataset subject_cat 1 2 3 4 5 6.dta"
gen xpertsputum3=.
replace xpertsputum3=1 if xpertsputum1==2
replace xpertsputum3=0 if subject_cat==4
// pluslife ts //
diagtest res_swab_pluslife xpertsputum3 if res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 130 88, wilson
cii proportion 327 325, wilson
diagtest res_swab_pluslife xpertsputum3 if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 107 71, wilson
cii proportion 199 198, wilson
diagtest res_swab_pluslife xpertsputum3 if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 23 17, wilson
cii proportion 104 104, wilson

// TB pos = xpert, excluding trace, TB neg = no TB //
clear
use "D:\EVIDENT WP1 Data\250703_dataset subject_cat 1 2 3 4 5 6.dta"
gen xpertsputum4=.
replace xpertsputum4=1 if xpertsputum2==2
replace xpertsputum4=0 if subject_cat==4
diagtest res_swab_pluslife xpertsputum4 if res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 110 81, wilson
cii proportion 416 413, wilson
diagtest res_swab_pluslife xpertsputum4 if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 91 65, wilson
cii proportion 283 281, wilson
diagtest res_swab_pluslife xpertsputum4 if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 19 16, wilson
cii proportion 107 107, wilson

// TB pos = kultur pos MTB, NTM deemed as negative, TB negative=no TB + clinical TB //
clear
use "D:\EVIDENT WP1 Data\250703_dataset subject_cat 1 2 3 4 5 6.dta"
gen cultmtb1=.
replace cultmtb1=1 if culture_result==3 & cult_ident==1
replace cultmtb1=0 if subject_cat == 4 | subject_cat ==6
label define cultmtb1lab 0 "Negative" 1 "Positive MTB"
label values cultmtb1 cultmtb1lab 
sort cultmtb1
br culture_result cult_ident subject_cat cultmtb1

diagtest res_swab_pluslife cultmtb1 if res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 110 82, wilson
cii proportion 414 407, wilson
diagtest res_swab_pluslife cultmtb1 if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 93 66, wilson
cii proportion 262 261, wilson
diagtest res_swab_pluslife cultmtb1 if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 17 16, wilson
cii proportion 130 129, wilson

// TB pos = kultur dan excluding NTM, TB negative = no TB + clnical TB//
clear
use "D:\EVIDENT WP1 Data\250703_dataset subject_cat 1 2 3 4 5 6.dta"
drop if cult_ident==2
save "D:\EVIDENT WP1 Data\250703_dataset subject_cat 1 2 3 4 5 6 tanpa ntm.dta"
// pluslife ts //
diagtest res_swab_pluslife cultmtb1 if res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 110 82, wilson
cii proportion 492 486, wilson
diagtest res_swab_pluslife cultmtb1 if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 93 66, wilson
cii proportion 313 309, wilson
diagtest res_swab_pluslife cultmtb1 if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 17 16, wilson
cii proportion 179 177, wilson

// TB-pos = Xpert, trace as positive, TB-neg = No TB + clinical TB//
clear
use "D:\EVIDENT WP1 Data\250703_dataset subject_cat 1 2 3 4 5 6.dta"
gen xpertsputum3=.
replace xpertsputum3=1 if xpertsputum1==2
replace xpertsputum3=0 if subject_cat==4 | subject_cat==6
label define xpertsputum3lab 0 "Negative" 1 "Positive Xpert"
label values xpertsputum3 xpertsputum3lab 
sort xpertsputum3
br culture_result cult_ident tcm_result xpertsputum1 xpertsputum3

diagtest res_swab_pluslife xpertsputum3 if res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 130 88, wilson
cii proportion 327 325, wilson
diagtest res_swab_pluslife xpertsputum3 if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 107 71, wilson
cii proportion 220 218, wilson
diagtest res_swab_pluslife xpertsputum3 if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 23 17, wilson
cii proportion 133 132, wilson

// TB-pos = Xpert, excluding trace, TB-neg = No TB + clinical TB//
clear
use "D:\EVIDENT WP1 Data\250703_dataset subject_cat 1 2 3 4 5 6.dta"
gen xpertsputum4=.
replace xpertsputum4=1 if xpertsputum2==2
replace xpertsputum4=0 if subject_cat==4 | subject_cat==6
label define xpertsputum4lab 0 "Negative" 1 "Positive Xpert"
label values xpertsputum4 xpertsputum4lab 
diagtest res_swab_pluslife xpertsputum4 if res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 110 81, wilson
cii proportion 416 413, wilson
diagtest res_swab_pluslife xpertsputum4 if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 91 65, wilson
cii proportion 283 281, wilson
diagtest res_swab_pluslife xpertsputum4 if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 19 16, wilson
cii proportion 107 107, wilson

// pluslife ss //
clear
use "D:\EVIDENT WP1 Data\250703_dataset pl ts ss xpert ts.dta"
// TB pos = kultur MTB, NTM deemed as negative, TB neg = kultur negative //
diagtest res_sput_pluslife culture_result2 if res_sput_pluslife~=3 & res_sput_pluslife~=4 & culture_result~=999
cii proportion 118 99, wilson
cii proportion 550 529, wilson
// TB pos = kultur MTB, excluding NTM, TB neg = kultur negative //
drop if cult_ident==2 // 19 obs
diagtest res_sput_pluslife culture_result2 if res_sput_pluslife~=3 & res_sput_pluslife~=4 & culture_result~=999
cii proportion 118 99, wilson
cii proportion 536 516, wilson
// TB pos = Xpert, trace as positive, TB neg = Xpert negative //
clear
use "D:\EVIDENT WP1 Data\250703_dataset pl ts ss xpert ts.dta"
diagtest res_sput_pluslife xpertsputum1 if res_sput_pluslife~=3 & res_sput_pluslife~=4
cii proportion 141 105, wilson
cii proportion 462 447, wilson
// TB pos = Xpert, excluding trace, TB neg = Xpert negative //
clear
use "D:\EVIDENT WP1 Data\250703_dataset pl ts ss xpert ts.dta"
drop if semi_quant==1 | tcm_result==4 // 15 obs deleted
diagtest res_sput_pluslife xpertsputum1 if res_sput_pluslife~=3 & res_sput_pluslife~=4
cii proportion 130 101, wilson
cii proportion 462 447, wilson
// TB pos = kultur MTB, NTM deemed as negative, TB neg = no TB dan clinical TB //
clear
use "D:\EVIDENT WP1 Data\250703_dataset subject_cat 1 2 3 4 5 6.dta"
gen cultmtb2=.
replace cultmtb2=1 if culture_result2==2
replace cultmtb2=0 if subject_cat==4 | subject_cat==6
diagtest res_sput_pluslife cultmtb2 if res_sput_pluslife~=3 & res_sput_pluslife~=4
cii proportion 118 99, wilson
cii proportion 442 431, wilson
// TB pos = kultur MTB, excluding NTM, TB neg = no TB dan clinical TB //
clear
use "D:\EVIDENT WP1 Data\250703_dataset subject_cat 1 2 3 4 5 6.dta"
drop if cult_ident==2 // 2 obs deleted
diagtest res_sput_pluslife cultmtb2 if res_sput_pluslife~=3 & res_sput_pluslife~=4
cii proportion 118 99, wilson
cii proportion 442 431, wilson
// TB pos = kultur MTB, NTM deemed as negative, TB neg = no TB //
clear
use "D:\EVIDENT WP1 Data\250703_dataset subject_cat 1 2 3 4 5 6.dta"
gen cultmtb4=.
replace cultmtb4=1 if culture_result2==2
replace cultmtb4=0 if subject_cat==4
diagtest res_sput_pluslife cultmtb4 if res_sput_pluslife~=3 & res_sput_pluslife~=4
cii proportion 118 99, wilson
cii proportion 347 337, wilson

// vs MRS 1 //
// TB pos = subject_cat 1, 2, 3. TB neg = no TB //
// recoding //
gen mrs=999
replace mrs=0 if subject_cat==4
replace mrs=1 if subject_cat==1 | subject_cat==2 | subject_cat==3
label define mrslab 0 "Negative" 1 "Positive"
label values mrs mrslab
diagtest res_sput_pluslife mrs if res_sput_pluslife~=3 & res_sput_pluslife~=4
cii proportion 136 105, wilson
cii proportion 347 337, wilson

diagtest res_swab_pluslife mrs if res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 126 86, wilson
cii proportion 303 302, wilson

diagtest res_swab_pluslife mrs if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 107 70, wilson
cii proportion 199 198, wilson

diagtest res_swab_pluslife mrs if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 19 16, wilson
cii proportion 104 104, wilson

// TB pos = subject_cat 1, 2, 3. TB neg = no TB & clinical TB //
// recoding //
gen mrs1=999
replace mrs1=0 if subject_cat==4 | subject_cat==6
replace mrs1=1 if subject_cat==1 | subject_cat==2 | subject_cat==3
label define mrs1lab 0 "Negative" 1 "Positive"
label values mrs1 mrs1lab
diagtest res_sput_pluslife mrs1 if res_sput_pluslife~=3 & res_sput_pluslife~=4
cii proportion 136 105, wilson
cii proportion 442 431, wilson

diagtest res_swab_pluslife mrs1 if res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 126 86, wilson
cii proportion 392 390, wilson

diagtest res_swab_pluslife mrs1 if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 107 70, wilson
cii proportion 199 198, wilson

diagtest res_swab_pluslife mrs1 if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 19 16, wilson
cii proportion 104 104, wilson

// false positive //
list idsubject interv_dt cxray tcm_result semi_quant culture_result cult_ident if res_swab_pluslife==1 & mrs==

// diagnostic accuracy by site //
diagtest res_swab_pluslife mrs if recloc==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 79 57, wilson
cii proportion 68 67, wilson
diagtest res_swab_pluslife mrs if recloc==2 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 36 20, wilson
cii proportion 193 193, wilson
diagtest res_swab_pluslife mrs if recloc==3 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 11 9, wilson
cii proportion 42 42, wilson

// diagnostic accuracy //
diagtest res_swab_pluslife culture_result2 if res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 110 82, wilson
cii proportion 506 498, wilson
diagtest res_swab_pluslife culture_result2 if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 93 66, wilson
cii proportion 326 320, wilson
diagtest res_swab_pluslife culture_result2 if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 17 16, wilson
cii proportion 180 178, wilson

// diagnostic accuracy by age group //
diagtest res_swab_pluslife culture_result2 if agecat14==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 1 1, wilson
cii proportion 139 139, wilson
diagtest res_swab_pluslife culture_result2 if agecat14==0 & sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 1 1, wilson
cii proportion 139 139, wilson
diagtest res_swab_pluslife culture_result2 if agecat14==0 & sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 1 1, wilson
cii proportion 139 139, wilson
diagtest res_swab_pluslife culture_result2 if agecat14==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 109 81, wilson
cii proportion 367 359, wilson
diagtest res_swab_pluslife culture_result2 if agecat14==1 & sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 93 66, wilson
cii proportion 261 255, wilson
diagtest res_swab_pluslife culture_result2 if agecat14==1 & sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 16 15, wilson
cii proportion 106 104, wilson
diagtest res_swab_pluslife culture_result2 if dm_status==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 84 60, wilson
cii proportion 468 462, wilson
diagtest res_swab_pluslife culture_result2 if dm_status==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 26 22, wilson
cii proportion 38 36, wilson
diagtest res_swab_pluslife culture_result2 if dm_status==1 & sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 16 15, wilson
cii proportion 106 104, wilson

// diagnostic accuracy by DM status //
diagtest res_swab_pluslife mrs if dm_status==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 98 64, wilson
cii proportion 282 282, wilson
diagtest res_swab_pluslife mrs if dm_status==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 28 22, wilson
cii proportion 21 20, wilson

// diagnostic accuracy by HIV status //
diagtest res_swab_pluslife mrs if hiv_status==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 102 70, wilson
cii proportion 187 186, wilson
diagtest res_swab_pluslife mrs if hiv_status==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4
cii proportion 28 22, wilson
cii proportion 21 20, wilson

// pluslife ss //
diagtest res_sput_pluslife culture_result2 if res_sput_pluslife~=3 & res_sput_pluslife~=4 & culture_result2~=999
cii proportion 117 98, wilson
cii proportion 545 529, wilson
diagtest res_sput_pluslife culture_result2 if recloc==1 & res_sput_pluslife~=3 & res_sput_pluslife~=4 & culture_result2~=999
cii proportion 70 60, wilson
cii proportion 122 117, wilson
diagtest res_sput_pluslife culture_result2 if recloc==2 & res_sput_pluslife~=3 & res_sput_pluslife~=4 & culture_result2~=999
cii proportion 29 25, wilson
cii proportion 300 293, wilson
diagtest res_sput_pluslife culture_result2 if recloc==3 & res_sput_pluslife~=3 & res_sput_pluslife~=4 & culture_result2~=999
cii proportion 18 13, wilson
cii proportion 123 119, wilson
diagtest res_sput_pluslife culture_result2 if dm_status==0 & res_sput_pluslife~=3 & res_sput_pluslife~=4 & culture_result2~=999
cii proportion 88 70, wilson
cii proportion 500 488, wilson
diagtest res_sput_pluslife culture_result2 if dm_status==1 & res_sput_pluslife~=3 & res_sput_pluslife~=4 & culture_result2~=999
cii proportion 29 28, wilson
cii proportion 45 41, wilson