// 3 Juli 2025 //
// STARD diagram //

clear
use "D:\EVIDENT WP1 Data\250703_data bl fu.dta"

gen tbhistdur=interv_dt-diag_tb_y
sort tbhistdur
gen tbhist2years=.
replace tbhist2years=1 if tbhistdur<=730
replace tbhist2years=0 if tbhist2years!=1
br idsubject initial age birthdate diag_tb_y interv_dt tbhistdur tbhist2years
sort tbhistdur
replace tbhist2years=1 if idsubject==4100068
tab tbhist2years, m 
drop if tbhist2years==1

// dropping early exclusion - on OAT > 7 days //
drop if idsubject==4100074 | idsubject==4100689 | idsubject==4100974 | idsubject==4100455

// dropping could not produce sputum //
drop if tcm_result==12 & culture_result==5 & agecat15==2

tab willing, m
drop if willing==0

save "D:\EVIDENT WP1 Data\250703_dataset consent bl fu.dta"
// 1,234 obs //

keep if res_swab_pluslife==0 | res_swab_pluslife==1 | res_swab_pluslife==3 | res_sput_pluslife==0 | res_sput_pluslife==1 | res_sput_pluslife==3 | xpertts==1 | xpertts==2
// 871 obs

sort interv_dt
br interv_dt idsubject res_swab_pluslife res_sput_pluslife xpertts

save "D:\EVIDENT WP1 Data\250703_dataset pl ts ss xpert ts.dta"

// pluslife ts //
//dropping sampel yang samplingnya kurang dari 15 detik
drop if idsubject==4100466
drop if idsubject==4100467
drop if idsubject==4100717
drop if idsubject==4100718

// 2 deleted

save "D:\EVIDENT WP1 Data\250703_dataset pluslife ts.dta"

// hitung berapa yang dites pluslife ts //
tab res_swab_pluslife, m
drop if res_swab_pluslife==4 | res_swab_pluslife==.

tab res_swab_pluslife, m

        Hasil |
  pemeriksaan |
   Usap lidah |
     Pluslife |      Freq.     Percent        Cum.
--------------+-----------------------------------
     Negative |        599       86.06       86.06
     Positive |         94       13.51       99.57
Error/Invalid |          3        0.43      100.00
--------------+-----------------------------------
        Total |        696      100.00

// 686 ada hasil pluslife ts: 592 neg, 91 pos, 3 error

// in adult //

        Hasil |
  pemeriksaan |
   Usap lidah |
     Pluslife |      Freq.     Percent        Cum.
--------------+-----------------------------------
     Negative |        384       58.90       58.90
     Positive |         90       13.80       72.70
Error/Invalid |          2        0.31       73.01
     Not Done |        102       15.64       88.65
            . |         74       11.35      100.00
--------------+-----------------------------------
        Total |        652      100.00

tab res_swab_pluslife culture_result, m
// 592 pluslife negative // 
list interv_dt idsubject age sputum1_c if culture_result==.
tab res_swab_pluslife culture_result if res_swab_pluslife==0, m
list idsubject age rec_loc sputum1_c tcm_result if sputum1_c==0 | sputum1_c==5 | sputum1_c==.

tab cult_ident res_swab_pluslife if res_swab_pluslife==0 & culture_result==3
// 2 menunggu hasil kultur

// 90 pluslife positive //
tab res_swab_pluslife culture_result if res_swab_pluslife==1, m
tab cult_ident res_swab_pluslife if res_swab_pluslife==1 & culture_result==3
br idsubject age interv_dt rec_loc sputum1_c culture_result if (culture_result==0 | culture_result==5 | culture_result==.) & res_swab_pluslife==1

// 3 error //
tab res_swab_pluslife culture_result if res_swab_pluslife==3, m
tab cult_ident res_swab_pluslife if res_swab_pluslife==3 & culture_result==3
list interv_dt idsubject age sputum1_c if culture_result==. & res_swab_pluslife==3

// jangan disimpan !!!

// in adult //
tab res_swab_pluslife culture_result, m
// 384 pluslife negative // 
list interv_dt idsubject age sputum1_c if culture_result==.
tab res_swab_pluslife culture_result if res_swab_pluslife==0, m
list idsubject age rec_loc sputum1_c tcm_result if sputum1_c==0 | sputum1_c==5 | sputum1_c==.

tab cult_ident res_swab_pluslife if res_swab_pluslife==0 & culture_result==3
// 2 menunggu hasil kultur

// 90 pluslife positive //
tab res_swab_pluslife culture_result if res_swab_pluslife==1, m
tab cult_ident res_swab_pluslife if res_swab_pluslife==1 & culture_result==3
br idsubject age interv_dt rec_loc sputum1_c culture_result if (culture_result==0 | culture_result==5 | culture_result==.) & res_swab_pluslife==1

// 2 error //
tab res_swab_pluslife culture_result if res_swab_pluslife==3, m
tab cult_ident res_swab_pluslife if res_swab_pluslife==3 & culture_result==3
list interv_dt idsubject age sputum1_c if culture_result==. & res_swab_pluslife==3

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

// gen early exclusion //
gen earlyex=.
replace earlyex=1 if cult_ident==2 | culture_result==5
tab agecat15 earlyex, m
// 3 paeds (1 NTM), 13 adult //

// drop if 

// hitung adult dan paeds //
tab agecat15, m
// 531 adult, 137 paeds //

// pilih yg adult //
keep if agecat15==2
save as

// hitung berapa yang dites pluslife ss //
// all //
tab res_sput_pluslife, m
tab res_sput_pluslife, m
//669: 554 neg, 114 pos, 1 invalid/error

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

// D A T A B A S E   X P E R T   T S //
clear
use "D:\EVIDENT WP1 Data\250703_dataset pl ts ss xpert ts.dta"
//dropping sampel yang samplingnya kurang dari 15 detik
drop if idsubject==4100466
drop if idsubject==4100467
drop if idsubject==4100717
drop if idsubject==4100718
// 4 deleted //

save "D:\EVIDENT WP1 Data\250703_dataset xpert ts.dta"

// hitung berapa yang dites xpert ts //
tab xpertts, m
tab xpertts
// in adult //
// 484 ada hasil xpert ts: 396 neg, 88 pos
tab xpertts culture_result, m

// 564 xpert ts negative // 
tab xpertts culture_result if xpertts==1, m
list idsubject age rec_loc sputum1_c tcm_result if culture_result==. & xpertts==1
tab cult_ident xpertts if xpertts==1 & culture_result==3

// 90 xpert ts positive //
tab xpertts culture_result if xpertts==2, m
tab cult_ident xpertts if xpertts==2 & culture_result==3
br idsubject age interv_dt rec_loc sputum1_c culture_result if (culture_result==0 | culture_result==5 | culture_result==.) & xpertts=2

// 396 xpert ts negative // 
tab xpertts culture_result if xpertts==1, m
list idsubject age rec_loc sputum1_c tcm_result if culture_result==. & xpertts==1
tab cult_ident xpertts if xpertts==1 & culture_result==3

// 88 xpert ts positive //
tab xpertts culture_result if xpertts==2, m
tab cult_ident xpertts if xpertts==2 & culture_result==3
br idsubject age interv_dt rec_loc sputum1_c culture_result if (culture_result==0 | culture_result==5 | culture_result==.) & xpertts=2
