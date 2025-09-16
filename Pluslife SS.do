// Paper Pluslife SS //

// Pluslife sputum swab //
keep if res_sput_pluslife==0 | res_sput_pluslife==1 | res_sput_pluslife==3

//dropping contamination
drop if idsubject==4100167
drop if idsubject==4100163
drop if idsubject==4100162
drop if idsubject==4100170
drop if idsubject==4100169
drop if idsubject==4100168
drop if idsubject==4100166

use "D:\EVIDENT WP1 Data\250827_pl ss all.dta", clear

// STARD diagram //
// hitung berapa yang dites pluslife ss //
// all //
tab res_sput_pluslife, m
tab res_sput_pluslife, m
//669: 554 neg, 114 pos, 1 invalid/error

// 554 pluslife negative // 
tab res_sput_pluslife cultcmdone if res_sput_pluslife==0, m
tab res_sput_pluslife finaldiag if res_sput_pluslife==0 & cultcmdone==1

// 114 positive //
tab res_sput_pluslife cultcmdone if res_sput_pluslife==1, m
tab res_sput_pluslife finaldiag if res_sput_pluslife==1 & cultcmdone==1

// 1 error //
tab res_sput_pluslife cultcmdone if res_sput_pluslife==3, m
tab res_sput_pluslife finaldiag if res_sput_pluslife==3 & cultcmdone==1

* dari 669 subjek yang ada hasil Pluslife nya, 2 orang anak yang tidak mempunyai reference standard, yaitu ID 4100327 dan 4100379 

tab res_sput_pluslife if agecat15==2
tab res_sput_pluslife finaldiag if agecat15==2

// Table 1 characteristics per site //
tab sex recloc, m col
summarize age, d
summarize age if recloc==1, d
summarize age if recloc==2, d
summarize age if recloc==3, d
tab category recloc, m col
tab hiv_status recloc, m col
tab dm_status recloc, m col
tab diag_tb recloc, m col
tab bmicat recloc if age>=18, m col
tab tst recloc, m col
tab cxray recloc, m col
tab xpertsputum1 recloc if xpertsputum1~=., m col
tab semi_quant recloc if xpertsputum1==2, m col
tab culture_result recloc, m col
tab cult_ident recloc if cult_ident==1 | cult_ident==2, col
br rec_loc if cult_ident==2
tab subjectcat recloc, m col
br idsubject age culture_result cult_ident cxray tcm_result semi_quant xpertsputum1 tb_treat if subject_cat==.
tab finaldiag recloc, m col

// Table 1 characteristics per age //
tab sex agecat15, m col
summarize age, d
summarize age if agecat15==1, d
summarize age if agecat15==2, d
tab category agecat15, m col
tab diag_tb agecat15, m col
tab hiv_status agecat15, m col
tab dm_status agecat15, m col
tab bmicat agecat15 if age>=18, m col
tab tst agecat15, m col
tab cxray agecat15, m col
tab xpertsputum1 agecat15 if xpertsputum1~=., m col
tab semi_quant agecat15 if xpertsputum1==2, m col
tab culture_result agecat15, m col
tab cult_ident agecat15 if cult_ident==1 | cult_ident==2, col
tab subject_cat agecat15 if subject_cat~=., m col
tab subject_cat agecat15, m col // 170 obs uncategorized
br idsubject age culture_result cult_ident cxray tcm_result semi_quant xpertsputum1 tb_treat if subjectcat==.
list idsubject rec_loc res_swab_pluslife cat_tbtest if cat_tbtest==3 | cat_tbtest==5
tab subjectcat agecat15, m col
tab finaldiag agecat15, m col
br idsubject age culture_result cult_ident cxray tcm_result semi_quant xpertsputum1 tb_treat subjectcat if finaldiag==.

// Table 2 agreement //
// trace excluded //
gen res_sput_pluslife2=999
browse res_sput_pluslife res_sput_pluslife2
replace res_sput_pluslife2=2 if res_sput_pluslife==1
replace res_sput_pluslife2=1 if res_sput_pluslife==0
drop if res_sput_pluslife==3
label define res_sput_pluslife2 1 "negative" 2 "positive"
label values res_sput_pluslife2 res_sput_pluslife2

tab res_sput_pluslife2 xpertsputum2 if res_sput_pluslife2~=999
kap res_sput_pluslife2 xpertsputum2 if res_sput_pluslife2~=999
cii proportions 592 554
cii proportions 592 554, wilson

tab res_sput_pluslife2 xpertsputum2 if res_sput_pluslife2~=999 & agecat15==1
kap res_sput_pluslife2 xpertsputum2 if res_sput_pluslife2~=999 & agecat15==1
cii proportions 78 75 

tab res_sput_pluslife2 xpertsputum2 if res_sput_pluslife2~=999 & agecat15==2
kap res_sput_pluslife2 xpertsputum2 if res_sput_pluslife2~=999 & agecat15==2
cii proportions 514 479

// trace included //
tab res_sput_pluslife2 xpertsputum1 if res_sput_pluslife2~=999
kap res_sput_pluslife2 xpertsputum1 if res_sput_pluslife2~=999
cii proportions 603 558
cii proportions 603 558, wilson

tab res_sput_pluslife2 xpertsputum1 if res_sput_pluslife2~=999 & agecat15==1
kap res_sput_pluslife2 xpertsputum1 if res_sput_pluslife2~=999 & agecat15==1
cii proportions 78 75 

tab res_sput_pluslife2 xpertsputum1 if res_sput_pluslife2~=999 & agecat15==2
kap res_sput_pluslife2 xpertsputum1 if res_sput_pluslife2~=999 & agecat15==2
cii proportions 525 483

// head-to-head-comparison PL SS vs Xpert Ultra sputum //
// BD max keluarkan (tcm_type==2) //
tab res_sput_pluslife2 xpertsputum2 if res_sput_pluslife2~=999 & tcm_type==1

br if (res_sput_pluslife==0 & xpertsputum2==1) | (res_sput_pluslife==1 & xpertsputum2==2) | (res_sput_pluslife==0 & xpertsputum2==2) | (res_sput_pluslife==1 & xpertsputum2==1)

// discordant pairs //
br idsubject age sex rec_loc tuberc_res cxray tcm_result semi_quant culture_result cult_ident tb_treat if (res_sput_pluslife==0 & xpertsputum2==2)

br idsubject age sex rec_loc tuberc_res cxray tcm_result semi_quant culture_result cult_ident tb_treat if (res_sput_pluslife==1 & xpertsputum2==1)

// figure 2. semi quantitative result //
// tabel gradasi nilai pluslife ss compared to semi quantitative //
tab semi_quant res_sput_pluslife if tcm_type==1 & semi_quant~=0 & res_sput_pluslife~=4, row
tab tcm_result res_sput_pluslife if tcm_type==1 & tcm_result==0 & res_sput_pluslife~=4, row
tab semi_quant res_sput_pluslife if tcm_type==1 & semi_quant~=0 & res_sput_pluslife~=4, col
