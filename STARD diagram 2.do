// D A T A B A S E   P L U S L I F E    S P U T U m   S W A B //

use "D:\EVIDENT WP1 Data\250703_dataset pl ts ss xpert ts.dta"

br

// pluslife ss //
//dropping contamination
drop if idsubject==4100167
drop if idsubject==4100163
drop if idsubject==4100162
drop if idsubject==4100170
drop if idsubject==4100169
drop if idsubject==4100168
drop if idsubject==4100166

save "D:\EVIDENT WP1 Data\250703_dataset pluslife ss.dta"
// hitung adult dan paeds //
tab agecat15, m
// 531 adult, 137 paeds //

// pilih yg adult //
keep if agecat15==2
save as

// gen ref standard available //
gen refavail=1 if tcmavail==1 | cultavail==1
replace refavail=0 if 

// hitung berapa yang dites pluslife ss //
// in adult //
tab res_sput_pluslife, m
drop if res_sput_pluslife==4 | res_sput_pluslife==.
tab res_sput_pluslife, m
//531: 418 neg, 113 pos

// 551 pluslife negative // 
tab res_sput_pluslife culture_result if res_sput_pluslife==0, m
list interv_dt idsubject age rec_loc sputum1_c tcm_result if res_sput_pluslife==0 & culture_result==.
tab cult_ident res_sput_pluslife if res_sput_pluslife==0 & culture_result==3

// 115 positive //
tab res_sput_pluslife culture_result if res_sput_pluslife==1, m
tab cult_ident res_sput_pluslife if res_sput_pluslife==1 & culture_result==3

// 1 error //
tab res_sput_pluslife culture_result if res_sput_pluslife==3, m

// 417 pluslife negative // 
tab res_sput_pluslife culture_result if res_sput_pluslife==0, m
list interv_dt idsubject age rec_loc sputum1_c tcm_result if res_sput_pluslife==0 & culture_result==.
tab cult_ident res_sput_pluslife if res_sput_pluslife==0 & culture_result==3

// 113 positive //
tab res_sput_pluslife culture_result if res_sput_pluslife==1, m
tab cult_ident res_sput_pluslife if res_sput_pluslife==1 & culture_result==3

// jangan disimpan!!!

// gen no microbiological standard //
gen nomicroref=.
replace nomicroref=1 if (culture_result3==1 & tcmnotdone==1) | (cultnotdone==1 & tcm_result==0) | (tcmnotdone==1 & cultnotdone==1) | (tcm_result==0 & culture_result3==1) | (tcm_result==0 & culture_result3==3) | subjectcat==7
replace nomicroref=0 if (culture_result3==2 & xpertsputum2==1) | (culture_result3==2 & xpertsputum2==2) | (culture_result3==1 & xpertsputum2==2)





















