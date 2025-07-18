//21 April 2025
//Preliminary analysis

clear
use "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250315 WP1 eligible.dta", clear
//data yang sudah digabung baseline dan follow-up
browse
//770 obs
sort refuse_cat
browse refuse_cat
tab refuse_cat

 refuse_cat                             |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
                        Tidak ada waktu |         19       29.23       29.23
              Merasa sakit/tidak nyaman |          4        6.15       35.38
                                  Takut |          7       10.77       46.15
                       Keluarga menolak |          6        9.23       55.38
Merasa tidak memerlukan pemeriksaan tam |          6        9.23       64.62
tidak berkenan menjadi subjek penelitia |          1        1.54       66.15
                         Tidak terekrut |          3        4.62       70.77
                         Riwayat TB<2th |         19       29.23      100.00
----------------------------------------+-----------------------------------
                                  Total |         65      100.00

// membuat kategori umur //
gen age_group=999
browse age age_group
sort age

//children=0-14 years, adults=15+//
replace age_group=1 if age<15
replace age_group=2 if age>=15
label define age_group 1 "0-14" 2 "15+"
label values age_group age_group
tab age_group

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

// recoding hasil xpert sputum
gen xpertsputum=.
replace xpertsputum=1 if tcm_result==0
replace xpertsputum=2 if tcm_result==1 | tcm_result==2 | tcm_result==3 | tcm_result==4 | tcm_result==5 | tcm_result==6 | tcm_result==7 | tcm_result==8
label variable xpertsputum "Hasil pemeriksaan Xpert Sputum"
label define xpertsputumlab 1 "Negative" 2 "Positive"
label values xpertsputum xpertsputumlab

// recoding xpert ts
gen xpertts=.
replace xpertts=1 if res_xpertultra==0
replace xpertts=2 if res_xpertultra==1 | res_xpertultra==2 | res_xpertultra==3 | res_xpertultra==4 | res_xpertultra==5 | res_xpertultra==6 | res_xpertultra==7 | res_xpertultra==8
label variable xpertts "Hasil pemeriksaan Xpert TS"
label define xperttslab 1 "Negative" 2 "Positive"
label values xpertts xperttslab
tab xpertts, m

// membagi jadi sampling 15s dan 30s
gen sampling30=.
replace sampling30=0 if interv_dt<td(30jan2025)
replace sampling30=1 if interv_dt>=td(30jan2025)

keep if refuse_cat==. 
//65 obs deleted
//705 obs willing and don't have history of TB <2 years
save "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250315 WP1 consent.dta"

tab culture_result, m

          Hasil kultur |      Freq.     Percent        Cum.
-----------------------+-----------------------------------
       Tidak ada hasil |         17        1.68        1.68
               Negatif |        573       56.51       58.19
               Positif |        168       16.57       74.75
       Tidak dilakukan |         67        6.61       81.36
                     . |        189       18.64      100.00
-----------------------+-----------------------------------
                 Total |      1,014      100.00

tab culture_result if sputum1_c==1 | sputum1_c==2, m

          Hasil kultur |      Freq.     Percent        Cum.
-----------------------+-----------------------------------
       Tidak ada hasil |          7        0.75        0.75
               Negatif |        570       61.36       62.11
               Positif |        168       18.08       80.19
       Tidak dilakukan |          2        0.22       80.41
                     . |        182       19.59      100.00
-----------------------+-----------------------------------
                 Total |        929      100.00
		 
keep if culture_result==1 | culture_result==3
tab culture_result, m
tab culture_result
//774 obs
save "D:\EVIDENT WP1 Data\250605_wp1 culture complete.dta"
file D:\EVIDENT WP1 Data\250605_wp1 culture complete.dta saved

//hasil kultur positif tapi MOTT harus diubah jadi negatif
gen culture_result2=999
browse culture_result cult_ident culture_result2
sort culture_result
//negative
replace culture_result2=1 if culture_result==1
replace culture_result2=1 if culture_result==3 & cult_ident==2
browse idsubject if culture_result==3 & cult_ident==2
sort idsubject
//20 MOTT

//positive
replace culture_result2=2 if culture_result==3 & cult_ident==1
replace culture_result2=2 if culture_result==3 & cult_ident==.

label define culture_result2 1 "negative" 2 "positive"
label values culture_result2 culture_result2

tab culture_result culture_result2

                      |    culture_result2
         Hasil kultur |  negative   positive |     Total
----------------------+----------------------+----------
              Negatif |       603          0 |       603 
              Positif |        20        151 |       171 
----------------------+----------------------+----------
                Total |       623        151 |       774

save "D:\EVIDENT WP1 Data\250605_wp1 culture complete.dta", replace
file D:\EVIDENT WP1 Data\250605_wp1 culture complete.dta saved

clear
use "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250315 WP1-culture complete data.dta"
//741 obs

// slide pertama //
//MRS dan comparator				
tab culture_result, m
tab cult_ident, m
sum age, d
tab sex

save "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250212 WP1-culture complete data.dta", replace

// slide data pasien yang diperiksa pluslife ts //
tab res_swab_pluslife, m
keep if res_swab_pluslife==0 | res_swab_pluslife==1
// 687 obs
tab sex, m
tab agecat
tab diag_tb
tab dm_status
tab hiv_status
tab smoke

// performance pluslife tongue swab //
tab res_swab_pluslife culture_result2, m

        Hasil |
  pemeriksaan |
   Usap lidah |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       468         29 |       497 
     Positive |         7         82 |        89 
Error/Invalid |         1          0 |         1 
     Not Done |        48         16 |        64 
            . |        99         24 |       123 
--------------+----------------------+----------
        Total |       623        151 |       774 

keep if res_swab_pluslife==0 | res_swab_pluslife==1
//558 obs
save "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250315 WP1-pluslife ts.dta"

//2x2 table
tab res_swab_pluslife culture_result2,col
sort res_swab_pluslife
browse idsubject res_swab_pluslife

clear
use "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250315 WP1-pluslife ts.dta"

//dropping sampel yang samplingnya kurang dari 15 detik!!
drop if idsubject==4100466
drop if idsubject==4100467
drop if idsubject==4100717
drop if idsubject==4100718

//Characteristics
tab sex, m
tab agecat, m
tab diag_tb, m
tab dm_status, m
tab hiv_status, m
tab smoke, m
// tabel gradasi nilai pluslife ts compared to semi quantitative //
tab semi_quant res_swab_pluslife if tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4, row
tab tcm_result res_swab_pluslife if tcm_type==1 & tcm_result==0 & res_swab_pluslife~=4, row
tab semi_quant res_swab_pluslife if tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4, col

tab res_swab_pluslife culture_result2, m

        Hasil |
  pemeriksaan |
   Usap lidah |         culture_result2
     Pluslife |  negative   positive        999 |     Total
--------------+---------------------------------+----------
     Negative |       467         29         99 |       595 
     Positive |         7         82          2 |        91 
--------------+---------------------------------+----------
        Total |       474        111        101 |       686 

keep if culture_result2~=999
// 585 obs
. save "D:\EVIDENT WP1 Data\250611_dataset pluslife vs kultur.dta"
file D:\EVIDENT WP1 Data\250611_dataset pluslife vs kultur.dta saved
		
// sensitivity specificity //
// overall sensitivity //
diagtest res_swab_pluslife culture_result2 

        Hasil |
  pemeriksaan |
   Usap lidah |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       467         29 |       496 
     Positive |         7         82 |        89 
--------------+----------------------+----------
        Total |       474        111 |       585 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  73.87%      70.31%   77.43%
Specificity                     Pr( -|~D)  98.52%      97.55%   99.50%
Positive predictive value       Pr( D| +)  92.13%      89.95%   94.32%
Negative predictive value       Pr(~D| -)  94.15%      92.25%   96.05%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      18.97%      15.80%   22.15%
-------------------------------------------------------------------------

// sampling 15 detik //
// characteristics
tab sex if sampling30==0, m
summarize age if sampling30==0, d
tab agecat if sampling30==0, m
tab diag_tb if sampling30==0, m
tab dm_status if sampling30==0, m
tab hiv_status if sampling30==0, m
tab smoke if sampling30==0, m
// tabel gradasi nilai pluslife ts compared to semi quantitative //
tab semi_quant res_swab_pluslife if sampling30==0 & tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4, row
tab tcm_result res_swab_pluslife if sampling30==0 & tcm_type==1 & tcm_result==0 & res_swab_pluslife~=4, row
tab semi_quant res_swab_pluslife if sampling30==0 & tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4, col

// performance //
diagtest res_swab_pluslife culture_result2 if sampling30==0

        Hasil |
  pemeriksaan |
   Usap lidah |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       321         28 |       349 
     Positive |         6         65 |        71 
--------------+----------------------+----------
        Total |       327         93 |       420 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  69.89%      65.51%   74.28%
Specificity                     Pr( -|~D)  98.17%      96.88%   99.45%
Positive predictive value       Pr( D| +)  91.55%      88.89%   94.21%
Negative predictive value       Pr(~D| -)  91.98%      89.38%   94.58%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      22.14%      18.17%   26.11%
-------------------------------------------------------------------------

//False positive
browse idsubject diag_tb diag_tb_y tcm_dt dt_swab_pluslife res_swab_pluslife tcm_result semi_quant cxray tb_treat culture_result cult_ident if res_swab_pluslife==1 & culture_result2==1 & sampling30==0
sort idsubject
//4100053 tb history yes: 1 January 2020, Xpert MTB detected Rif not detected, semi_quant no data, CXR active TB, treated yes, culture MOTT
//4100217 tb history no, xpert MTB detected Rifres not detected, semi_quant low, CXR normal, treated yes, culture negative
//4100222 tb history no, xpert MTB detected Rifres not detected, semi_quant very low, CXR active TB, treated yes, culture negative
//4100256 tb history no, xpert MTB detected Rifres indet, semi_quant trace, CXR active TB, treated yes, culture negative
//4100385 tb history yes, 2019, xpert MTB detected Rifres not detected, semi_quant high, CXR active TB, treated yes, culture MOTT

browse cult_ino_dt dt_swab_pluslife if res_swab_pluslife==1 & culture_result2==1
//no date difference between TS and sputum collection

//False negative
browse if res_swab_pluslife==0 & culture_result2==2
browse idsubject rec_loc diag_tb diag_tb_y tcm_result semi_quant cxray tb_treat res_swab_pluslife culture_result cult_ident if res_swab_pluslife==0 & culture_result2==2 & sampling30==0

// sampling 30 detik //
//Characteristics
tab sex if sampling30==1, m
summarize age if sampling30==1, d
tab agecat if sampling30==1, m
tab diag_tb if sampling30==1, m
tab dm_status if sampling30==1, m
tab hiv_status if sampling30==1, m
tab smoke if sampling30==1, m
// tabel gradasi nilai pluslife ts compared to semi quantitative //
tab semi_quant res_swab_pluslife if sampling30==1 & tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4, row
tab tcm_result res_swab_pluslife if sampling30==1 & tcm_type==1 & tcm_result==0 & res_swab_pluslife~=4, row
tab semi_quant res_swab_pluslife if sampling30==1 & tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4, col

// accuracy
diagtest res_swab_pluslife culture_result2 if sampling30==1

        Hasil |
  pemeriksaan |
   Usap lidah |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       118          1 |       119 
     Positive |         1         17 |        18 
--------------+----------------------+----------
        Total |       119         18 |       137 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  94.44%      90.61%   98.28%
Specificity                     Pr( -|~D)  99.16%      97.63%   100.69%
Positive predictive value       Pr( D| +)  94.44%      90.61%   98.28%
Negative predictive value       Pr(~D| -)  99.16%      97.63%   100.69%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      13.14%       7.48%   18.80%
-------------------------------------------------------------------------

// false positive //
browse idsubject diag_tb diag_tb_y tcm_dt dt_swab_pluslife res_swab_pluslife tcm_result semi_quant cxray tb_treat culture_result cult_ident if res_swab_pluslife==1 & culture_result2==1 & sampling30==1

// false negative //
browse idsubject rec_loc diag_tb diag_tb_y tcm_result semi_quant cxray tb_treat res_swab_pluslife culture_result cult_ident if res_swab_pluslife==0 & culture_result2==2 & sampling30==1

//Agreement with xpert tongue swab
//untuk agreement perlu recoding
browse res_swab_pluslife xpertts
gen res_swab_pluslife2=999
replace res_swab_pluslife2=1 if res_swab_pluslife==0
replace res_swab_pluslife2=2 if res_swab_pluslife==1
drop if res_swab_pluslife2==999
tab res_swab_pluslife2 xpertts
kap res_swab_pluslife2 xpertts
cii proportions 536 530

save "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250315 WP1-pluslife ts.dta", replace

//performance genexpert sputum
clear
use "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250315 WP1-culture complete data.dta", clear
gen xpert_sputum=999
browse tcm_type tcm_result xpert_sputum
//mengeluarkan hasil BD Max
keep if tcm_type==1
//82 obs deleted (BD Max atau not done)
//drop if missing or not done
drop if tcm_result==12 | tcm_result==.
//507 obs

gen xpert_sputum=999
replace xpert_sputum=1 if tcm_result==0
replace xpert_sputum=2 if tcm_result==1 | tcm_result==2 | tcm_result==3 | tcm_result==4 | tcm_result==7
replace xpert_sputum=. if tcm_result==.
label define xpert_sputum 1 "negative" 2 "positive"
label values xpert_sputum xpert_sputum

diagtest xpertsputum culture_result2

//Agreement pluslife sputum swab dengan xpert sputum
//untuk agreement perlu recoding
browse res_sput_pluslife xpert_sputum
gen res_sput_pluslife2=999
replace res_sput_pluslife2=1 if res_sput_pluslife==0
replace res_sput_pluslife2=2 if res_sput_pluslife==1
tab res_sput_pluslife2 xpert_sputum if res_sput_pluslife2~=999
kap res_sput_pluslife2 xpert_sputum if res_sput_pluslife2~=999
cii proportions 376 343

save "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250211 WP1-xpert sputum.dta"