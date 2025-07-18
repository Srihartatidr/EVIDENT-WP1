// 17 Mei 2025 //
use "D:\EVIDENT WP1 Data\250517_WP1 dataset.dta"

br

//Cek data baseline dulu
browse
//583 obs
tab culture_result, m

          Hasil kultur |      Freq.     Percent        Cum.
-----------------------+-----------------------------------
       Tidak ada hasil |         18        1.89        1.89
               Negatif |        530       55.79       57.68
               Positif |        166       17.47       75.16
       Tidak dilakukan |         60        6.32       81.47
                     . |        176       18.53      100.00
-----------------------+-----------------------------------
                 Total |        950      100.00

keep if culture_result==1 | culture_result==3
tab culture_result, m
//696 obs

//hasil kultur positif tapi MOTT harus diubah jadi negatif
gen culture_result2=999
browse culture_result cult_ident culture_result2
sort culture_result
//negative
replace culture_result2=1 if culture_result==1
replace culture_result2=1 if culture_result==3 & cult_ident==2
//16 MOTT
//positive
replace culture_result2=2 if culture_result==3 & cult_ident==1

label define culture_result2 1 "negative" 2 "positive"
label values culture_result2 culture_result2

tab culture_result culture_result2

                      |    culture_result2
         Hasil kultur |  negative   positive |     Total
----------------------+----------------------+----------
              Negatif |       530          0 |       530 
              Positif |        19        147 |       166 
----------------------+----------------------+----------
                Total |       549        147 |       696 

//4100076 sampling error, pasien dirawat, dilakukan sampling setelah transfusi, kondisi lemas, sulit menjulurkan lidah
drop if idsubject==4100076

//harus dicari lagi yang ada di video samplingnya kurang dari 15 detik!!
drop if idsubject==4100466
drop if idsubject==4100467
drop if idsubject==4100717
drop if idsubject==4100718

save "D:\EVIDENT WP1 Data\250517_pluslife ss vs kultur.dta", replace

use "D:\EVIDENT WP1 Data\250517_WP1 dataset.dta"

tab res_sput_pluslife, m

        Hasil |
  pemeriksaan |
       Sputum |
     Pluslife |      Freq.     Percent        Cum.
--------------+-----------------------------------
     Negative |        542       57.05       57.05
     Positive |        121       12.74       69.79
Error/Invalid |          2        0.21       70.00
     Not done |          2        0.21       70.21
            . |        283       29.79      100.00
--------------+-----------------------------------
        Total |        950      100.00

keep if res_sput_pluslife==0 | res_sput_pluslife==1
// jangan di-save !!!

//Characteristics
tab sex, m
tab agecat, m
tab diag_tb, m

//DM status
browse dm poc_hba1c
gen dm_status=0
replace dm_status=1 if dm==1
replace dm_status=1 if poc_hba1c>=6.5 & poc_hba1c~=.
label define dm_status 0 "no" 1 "yes"
label values dm_status dm_status
tab dm_status

//HIV status
gen hiv_status=999
browse hiv hiv_test hiv_status
sort hiv_status
replace hiv_status=0 if (hiv==0 | hiv==2) & hiv_test==0
replace hiv_status=1 if hiv==1 | hiv_test==1
replace hiv_status=2 if (hiv==0 | hiv==2) & (hiv_test==8 | hiv_test==2)
replace hiv_status=. if (hiv==0 | hiv==2) & hiv_test==.
label define hiv_status 0 "negative" 1 "positive" 2 "refused testing"
label values hiv_status hiv_status
tab hiv_status, m

tab smoke, m
tab semi_quant res_swab_pluslife if tcm_type==1, m 

//sensitivity specificity
diagtest res_swab_pluslife culture_result2

Hasil |
  pemeriksaan |
   Usap lidah |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       252         23 |       275 
     Positive |         6         60 |        66 
--------------+----------------------+----------
        Total |       258         83 |       341 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  72.29%      67.54%   77.04%
Specificity                     Pr( -|~D)  97.67%      96.07%   99.27%
Positive predictive value       Pr( D| +)  90.91%      87.86%   93.96%
Negative predictive value       Pr(~D| -)  91.64%      88.70%   94.57%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      24.34%      19.79%   28.89%
-------------------------------------------------------------------------


//False positive
browse idsubject diag_tb diag_tb_y tcm_dt dt_swab_pluslife tcm_result semi_quant cxray tb_treat cult_ident if res_swab_pluslife==1 & culture_result2==1

list idsubject diag_tb diag_tb_y tcm_dt dt_swab_pluslife tcm_result semi_quant cxray tb_treat cult_ident if res_swab_pluslife==1 & culture_result2==1

sort idsubject
//4100050 tb history no, xpert MTB trace Rifres indet, cxr active TB, treated yes, culture negative
//4100217 tb history no, xpert MTB low Rifres ND, CXR normal, treated yes, culture negative
//4100222 tb history no, xpert MTB very low Rifres ND, cxr active TB, treated yes, culture negative
//4100256 tb history no, xpert MTB trace Rifres indet, cxr active TB, treated yes, culture negative
//4100385 tb history yes, 2019, xpert MTB high Rifres ND, cxr active TB, treated yes, culture MOTT

browse cult_ino_dt dt_swab_pluslife if res_swab_pluslife==1 & culture_result2==1
//no date difference between TS and sputum collection

//False negative
browse if res_swab_pluslife==0 & culture_result2==2
browse idsubject rec_loc diag_tb diag_tb_y tcm_dt dt_swab_pluslife tcm_result semi_quant cxray tb_treat cult_ident if res_swab_pluslife==0 & culture_result2==2

sort tcm_result
sort semi_quant
sort res_xpertultra
sort rec_loc
sort idsubject
//11 di RSPR 10 di KU Cibadak
sort semi_quant
//1 not done, 6 MTB not detected, 3 trace, 3 very low, 6 low, 1 medium, 3 high

//Agreement with xpert tongue swab
gen xpert_ts=999
sort xpert_ts
replace xpert_ts=1 if res_xpertultra==0
replace xpert_ts=2 if res_xpertultra==1 | res_xpertultra==2 | res_xpertultra==4 | res_xpertultra==7
browse res_xpertultra xpert_ts
replace xpert_ts=. if res_xpertultra==.
//masih ada yang 999: MTB trace detected, Rif Resistance indeterminate. Mau dianggap positif atau negatif? Mestinya sih positif ya, karena kan sama2 TCM.
//jadi dianggap positif
label define xpert_ts 1 "negative" 2 "positive"
label values xpert_ts xpert_ts

tab res_swab_pluslife xpert_ts
//untuk agreement perlu recoding
browse res_swab_pluslife xpert_ts
gen res_swab_pluslife2=999
replace res_swab_pluslife2=1 if res_swab_pluslife==0
replace res_swab_pluslife2=2 if res_swab_pluslife==1
tab res_swab_pluslife2 xpert_ts
kap res_swab_pluslife2 xpert_ts
cii proportions 337 331

save "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250212 WP1-pluslife ts.dta", replace

//gimana hasil Xpert?
clear
use "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250212 WP1-culture complete data.dta", clear
gen xpert_ts=999
sort xpert_ts
replace xpert_ts=1 if res_xpertultra==0
replace xpert_ts=2 if res_xpertultra==1 | res_xpertultra==2 | res_xpertultra==4 | res_xpertultra==7
browse res_xpertultra xpert_ts
replace xpert_ts=. if res_xpertultra==.
//masih ada yang 999: MTB trace detected, Rif Resistance indeterminate. Mau dianggap positif atau negatif? Mestinya sih positif ya, karena kan sama2 TCM.
//jadi dianggap positif
label define xpert_ts 1 "negative" 2 "positive"
label values xpert_ts xpert_ts

diagtest xpert_ts culture_result2


//What is the results before October?
clear
use "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250115 WP1-pluslife ts.dta"
sort dt_swab_pluslife
browse dt_swab_pluslife
//There was only 14 pluslife samples

//Pluslife sputum
clear
use "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250212 WP1-culture complete data.dta"
browse
//421 obs
keep if res_sput_pluslife~=.
//303 obs
//dropping contamination
drop if idsubject==4100167
drop if idsubject==4100163
drop if idsubject==4100162
drop if idsubject==4100170
drop if idsubject==4100169
drop if idsubject==4100168
drop if idsubject==4100166
//298 obs
save "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250212 WP1-pluslife sputum.dta", replace

tab res_sput_pluslife culture_result2, m
Hasil |
  pemeriksaan |
       Sputum |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       216         11 |       227 
     Positive |         9         61 |        70 
Error/Invalid |         1          0 |         1 
--------------+----------------------+----------
        Total |       226         72 |       298 

//menghapus hasil invalid		
drop if res_sput_pluslife==3
//297 obs

//Characteristics
tab sex, m
tab age_group, m
tab diag_tb, m

//DM status
browse dm poc_hba1c
gen dm_status=0
replace dm_status=1 if dm==1
replace dm_status=1 if poc_hba1c>=6.5 & poc_hba1c~=.
label define dm_status 0 "no" 1 "yes"
label values dm_status dm_status
tab dm_status

//HIV status
gen hiv_status=999
browse hiv hiv_test hiv_status
sort hiv_status
replace hiv_status=0 if (hiv==0 | hiv==2) & hiv_test==0
replace hiv_status=1 if hiv==1 | hiv_test==1
replace hiv_status=2 if (hiv==0 | hiv==2) & (hiv_test==8 | hiv_test==2 | hiv_test==.)
label define hiv_status 0 "negative" 1 "positive" 2 "refused testing"
label values hiv_status hiv_status
tab hiv_status, m

tab smoke, m
tab semi_quant res_sput_pluslife, m

//sensitivity & specificity compared to MGIT culture
tab res_sput_pluslife culture_result2
diagtest res_sput_pluslife culture_result2

//False positive
browse res_sput_pluslife culture_result2
browse idsubject diag_tb diag_tb_y tcm_result semi_quant cxray tb_treat cult_ident if res_sput_pluslife==1 & culture_result2==1
sort idsubject
//4100174 tb history yes 2021, xpert MTB ND, CXR abnormal not TB, treated no, culture negative
//4100185 tb history yes 2021, xpert MTB ND, CXR active TB, treated pending, culture negative
//4100188 tb history no, xpert MTB ND, CXR active TB, treated yes, culture negative
//4100217 tb history no, xpert MTB det low, CXR normal, treated yes, culture negative
//4100252 tb history no, xpert MTB det low, CXR active TB, treated yes, culture negative
//4100255 tb history no, xpert MTB det trace, CXR active TB, treated yes, culture negative
//4100366 tb history yes 2010, xpert MTB ND, CXR abnormal not TB, treated pending, culture negative
//4100385 tb history yes 2019, xpert MTB det high, CXR active TB, treated yes, culture MOTT (sudah diulang tetap MOTT)
//4100558 tb history no, xpert MTB ND, CXR abnormal not TB, treated pending

sort tcm_result
sort cxray
browse cult_ino_dt dt_sput_pluslife if res_sput_pluslife==1 & culture_result==1
//no date difference between TS and sputum collection

//False negative
browse res_sput_pluslife culture_result
browse idsubject rec_loc diag_tb diag_tb_y tcm_result semi_quant res_sput_pluslife culture_result2 tcm_dt dt_sput_pluslife if res_sput_pluslife==0 & culture_result2==2
sort rec_loc
//7 di RSPR, 4 di KU Cibadak
sort semi_quant
sort idsubject
browse idsubject dt_sput_pluslife if res_sput_pluslife==0 & culture_result2==2

//Sensitivity & specificity compared to composite bacteriology
gen bact_confirm=999
browse res_sput_pluslife tcm_result culture_result2 bact_confirm
sort bact_confirm
//negative
replace bact_confirm=1 if tcm_result==0 & culture_result2==1
replace bact_confirm=1 if tcm_result==12 & culture_result2==1
replace bact_confirm=1 if tcm_result==. & culture_result2==1

//positive
replace bact_confirm=2 if culture_result2==2
replace bact_confirm=2 if culture_result2==1 & tcm_result==1
replace bact_confirm=2 if culture_result2==1 & tcm_result==4

diagtest res_sput_pluslife bact_confirm


//Agreement with Xpert (variabel tcm_result untuk sputum, res_xpertultra untuk TS) //
clear
use "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250212 WP1-pluslife sputum.dta"
browse tcm_type tcm_result
//mengeluarkan BD Max dan not done
keep if tcm_type==1
//33 obs deleted

gen xpert_sputum=999
sort tcm_result
browse tcm_result xpert_sputum
replace xpert_sputum=1 if tcm_result==0
replace xpert_sputum=2 if tcm_result==1 | tcm_result==2 | tcm_result==3 | tcm_result==4 | tcm_result==5 | tcm_result==7 | tcm_result==8
drop if tcm_result==. | tcm_result==12
save "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250212 WP1-pluslife sputum.dta", replace

gen res_sput_pluslife2=999
browse res_sput_pluslife res_sput_pluslife2
replace res_sput_pluslife2=2 if res_sput_pluslife==1
replace res_sput_pluslife2=1 if res_sput_pluslife==0
drop if res_sput_pluslife==3
label define res_sput_pluslife2 1 "negative" 2 "positive"
label values res_sput_pluslife2 res_sput_pluslife2

tab res_sput_pluslife2 xpert_sputum if res_sput_pluslife2~=999
kap res_sput_pluslife2 xpert_sputum if res_sput_pluslife2~=999
cii proportions 261 240
save "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250212 WP1-pluslife sputum.dta", replace

// PERFORMANCE XPERT SPUTUM //
clear
use "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250212 WP1-culture complete data.dta", clear
gen xpert_sputum=999
browse tcm_type tcm_result xpert_sputum
//mengeluarkan hasil BD Max
keep if tcm_type==1
//48 obs deleted (BD Max atau not done)
//373 obs
//drop if missing or not done
drop if tcm_result==12 | tcm_result==.

replace xpert_sputum=1 if tcm_result==0
replace xpert_sputum=2 if tcm_result==1 | tcm_result==2 | tcm_result==3 | tcm_result==4 | tcm_result==7
replace xpert_sputum=. if tcm_result==.
label define xpert_sputum 1 "negative" 2 "positive"
label values xpert_sputum xpert_sputum
diagtest xpert_sputum culture_result2

save "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250211 WP1-xpert sputum.dta"

// XPERT TS VS XPERT SPUTUM SEMI QUANT //
tab culture_result2 xpertts, m
tab tcm_result xpertts, m
tab semi_quant xpertts, m

keep if tcm_type==1
keep if tcm_result~=.
sort tcm_result
br tcm_result semi_quant
drop if tcm_result~=0 & semi_quant==.
drop if semi_quant==0
drop if xpertts==.

tab semi_quant xpertts, m row

// PERFORMANCE FUJILAM URINE
clear
use "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250115 WP1-culture complete data.dta"
browse
//345 obs
tab res_fujilam culture_result2
  Hasil |
  pemeriksaan |    culture_result2
 Urin FujiLAM |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       207         37 |       244 
     Positive |         9         25 |        34 
Indeterminate |         1          0 |         1 
Error/Invalid |         1          0 |         1 
--------------+----------------------+----------
        Total |       218         62 |       280

sort res_fujilam
browse res_fujilam
drop if res_fujilam==2 | res_fujilam==3 | res_fujilam==.
save "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250212 WP1-fujilam urine.dta"
//278 obs
tab semi_quant res_fujilam, m
diagtest res_fujilam culture_result2
tab res_fujilam tb_treat if hiv_status==1, m

clear
sort interv_dt
browse interv_dt res_truenant_ul
