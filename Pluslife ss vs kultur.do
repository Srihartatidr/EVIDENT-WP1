// 12 Juni 2025 //
use "D:\EVIDENT WP1 Data\250611_dataset monthly check-in june.dta", clear
br

//dropping contamination
drop if idsubject==4100167
drop if idsubject==4100163
drop if idsubject==4100162
drop if idsubject==4100170
drop if idsubject==4100169
drop if idsubject==4100168
drop if idsubject==4100166
// 1,145 obs

// pluslife vs kultur
tab res_sput_pluslife, m

        Hasil |
  pemeriksaan |
       Sputum |
     Pluslife |      Freq.     Percent        Cum.
--------------+-----------------------------------
     Negative |        553       48.30       48.30
     Positive |        116       10.13       58.43
Error/Invalid |          1        0.09       58.52
     Not done |          2        0.17       58.69
            . |        473       41.31      100.00
--------------+-----------------------------------
        Total |      1,145      100.00

keep if res_sput_pluslife==0 | res_sput_pluslife==1
// 669 obs

save "D:\EVIDENT WP1 Data\250612_dataset pluslife ss.dta"

//Characteristics
tab sex, m
tab agecat, m
tab diag_tb, m
tab dm_status
tab hiv_status, m
tab smoke, m

// tabel gradasi nilai pluslife ss compared to semi quantitative //
tab semi_quant res_sput_pluslife if tcm_type==1 & semi_quant~=0 & res_sput_pluslife~=4, row
tab tcm_result res_sput_pluslife if tcm_type==1 & tcm_result==0 & res_sput_pluslife~=4, row
tab semi_quant res_sput_pluslife if tcm_type==1 & semi_quant~=0 & res_sput_pluslife~=4, col

// tabel 2x2 //
tab res_sput_pluslife culture_result2, m

        Hasil |
  pemeriksaan |
       Sputum |         culture_result2
     Pluslife |  negative   positive        999 |     Total
--------------+---------------------------------+----------
     Negative |       505         19         27 |       551 
     Positive |        14         99          3 |       116 
--------------+---------------------------------+----------
        Total |       519        118         30 |       667 
 
keep if culture_result2~=999
save "D:\EVIDENT WP1 Data\250611_dataset pluslife ss vs kultur.dta"

// performance //
diagtest res_sput_pluslife culture_result2
diagtest res_sput_pluslife culture_result2 if agecat15==1 & culture_result2~=999

        Hasil |
  pemeriksaan |
       Sputum |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       132          1 |       133 
     Positive |         0          1 |         1 
--------------+----------------------+----------
        Total |       132          2 |       134 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  50.00%      41.53%   58.47%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  99.25%      97.79%   100.71%
-------------------------------------------------------------------------
Prevalence                      Pr(D)       1.49%      -0.56%    3.55%
-------------------------------------------------------------------------

// false negative in paediatric
list age diag_tb cxray tcm_result semi_quant culture_result2 tb_treat if res_sput_pluslife==0 & culture_result2==2 & agecat==1
     +-------------------------------------------------------------------------------------+
     |             cxray                                  tcm_result   semi_q~t   cultur~2 |
     |-------------------------------------------------------------------------------------|
292. | Sugestif TB aktif   MTB Detected, Rif Resistance Not Detected       High   positive |
     +-------------------------------------------------------------------------------------+

diagtest res_sput_pluslife culture_result2 if agecat15==2 & culture_result2~=999

        Hasil |
  pemeriksaan |
       Sputum |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       399         18 |       417 
     Positive |        15         99 |       114 
--------------+----------------------+----------
        Total |       414        117 |       531 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  84.62%      81.55%   87.68%
Specificity                     Pr( -|~D)  96.38%      94.79%   97.97%
Positive predictive value       Pr( D| +)  86.84%      83.97%   89.72%
Negative predictive value       Pr(~D| -)  95.68%      93.95%   97.41%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      22.03%      18.51%   25.56%
-------------------------------------------------------------------------

// false positive
list diag_tb cxray tcm_result semi_quant tb_treat culture_result cult_ident if res_sput_pluslife==1 & agecat==2 & culture_result2==1

// exclude trace //
tab semi_quant, m

     Hasil semi |
   quantitative |      Freq.     Percent        Cum.
----------------+-----------------------------------
Tidak dilakukan |         73       11.46       11.46
          Trace |          9        1.41       12.87
       Very low |         11        1.73       14.60
            Low |         48        7.54       22.14
         Medium |         17        2.67       24.80
           High |         43        6.75       31.55
              . |        436       68.45      100.00
----------------+-----------------------------------
          Total |        637      100.00

keep if semi_quant~=1
// 628 obs 

// performance //
diagtest res_sput_pluslife culture_result2

        Hasil |
  pemeriksaan |
       Sputum |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       500         18 |       518 
     Positive |        13         97 |       110 
--------------+----------------------+----------
        Total |       513        115 |       628 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  84.35%      81.51%   87.19%
Specificity                     Pr( -|~D)  97.47%      96.24%   98.70%
Positive predictive value       Pr( D| +)  88.18%      85.66%   90.71%
Negative predictive value       Pr(~D| -)  96.53%      95.09%   97.96%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      18.31%      15.29%   21.34%
-------------------------------------------------------------------------

diagtest res_sput_pluslife culture_result2 if agecat==1

        Hasil |
  pemeriksaan |
       Sputum |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       127          1 |       128 
     Positive |         0          1 |         1 
--------------+----------------------+----------
        Total |       127          2 |       129 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  50.00%      41.37%   58.63%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  99.22%      97.70%   100.74%
-------------------------------------------------------------------------
Prevalence                      Pr(D)       1.55%      -0.58%    3.68%
-------------------------------------------------------------------------

diagtest res_sput_pluslife culture_result2 if agecat==2

        Hasil |
  pemeriksaan |
       Sputum |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       373         17 |       390 
     Positive |        13         96 |       109 
--------------+----------------------+----------
        Total |       386        113 |       499 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  84.96%      81.82%   88.09%
Specificity                     Pr( -|~D)  96.63%      95.05%   98.21%
Positive predictive value       Pr( D| +)  88.07%      85.23%   90.92%
Negative predictive value       Pr(~D| -)  95.64%      93.85%   97.43%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      22.65%      18.97%   26.32%
-------------------------------------------------------------------------

list idsubject age tcm_result semi_quant cxray  if res_sput_pluslife==1 & culture_result==1 & cxr==1

     +-------------------------------------------------------------------------------------------------+
     | idsubj~t   age                                  tcm_result   semi_q~t                     cxray |
     |-------------------------------------------------------------------------------------------------|
 32. |  4100174    21                            MTB Not Detected          .   Tidak normal - bukan TB |
 65. |  4100217    49   MTB Detected, Rif Resistance Not Detected        Low                    Normal |
260. |  4100467    70                            MTB Not Detected          .   Tidak normal - bukan TB |
310. |  4100558    21                            MTB Not Detected          .   Tidak normal - bukan TB |
320. |  4100576    30   MTB Detected, Rif Resistance Not Detected        Low   Tidak normal - bukan TB |
     |-------------------------------------------------------------------------------------------------|
363. |  4100635    58                            MTB Not Detected          .   Tidak normal - bukan TB |
     +-------------------------------------------------------------------------------------------------+


//Agreement pluslife sputum swab dengan xpert sputum

use "D:\EVIDENT WP1 Data\250612_dataset pluslife ss.dta"

gen xpert_sputum=999
replace xpert_sputum=1 if tcm_result==0
replace xpert_sputum=2 if tcm_result==1 | tcm_result==2 | tcm_result==3 | tcm_result==4 | tcm_result==7
replace xpert_sputum=. if tcm_result==.
label define xpert_sputum 1 "negative" 2 "positive"
label values xpert_sputum xpert_sputum
browse res_sput_pluslife xpert_sputum

//untuk agreement perlu recoding
gen res_sput_pluslife2=999
replace res_sput_pluslife2=1 if res_sput_pluslife==0
replace res_sput_pluslife2=2 if res_sput_pluslife==1
drop if xpert_sputum==999
tab res_sput_pluslife2 xpert_sputum if res_sput_pluslife2~=999
kap res_sput_pluslife2 xpert_sputum if res_sput_pluslife2~=999
cii proportions 587 542

// pluslife vs xpert sputum
use "D:\EVIDENT WP1 Data\250517_WP1 dataset.dta"

//dropping contamination
drop if idsubject==4100167
drop if idsubject==4100163
drop if idsubject==4100162
drop if idsubject==4100170
drop if idsubject==4100169
drop if idsubject==4100168
drop if idsubject==4100166

// tabel 2x2 //
tab res_sput_pluslife xpertsputum, m

        Hasil |
  pemeriksaan |
       Sputum |  Hasil pemeriksaan Xpert Sputum
     Pluslife |  Negative   Positive          . |     Total
--------------+---------------------------------+----------
     Negative |       420         35         87 |       542 
     Positive |         9        102          4 |       115 
Error/Invalid |         2          0          0 |         2 
     Not done |         2          0          0 |         2 
            . |        90         37        156 |       283 
--------------+---------------------------------+----------
        Total |       523        174        247 |       944 

keep if res_sput_pluslife==0 | res_sput_pluslife==1

// tabel 2x2 //
tab res_sput_pluslife xpertsputum

        Hasil |
  pemeriksaan |   Hasil pemeriksaan
       Sputum |     Xpert Sputum
     Pluslife |  Negative   Positive |     Total
--------------+----------------------+----------
     Negative |       420         35 |       455 
     Positive |         9        102 |       111 
--------------+----------------------+----------
        Total |       429        137 |       566 

save "D:\EVIDENT WP1 Data\250517_pluslife ss vs xpert.dta"

// performance //
diagtest res_sput_pluslife xpertsputum
diagtest res_sput_pluslife xpertsputum if agecat15==1

        Hasil |
  pemeriksaan |   Hasil pemeriksaan
       Sputum |     Xpert Sputum
     Pluslife |  Negative   Positive |     Total
--------------+----------------------+----------
     Negative |        72          3 |        75 
     Positive |         0          1 |         1 
--------------+----------------------+----------
        Total |        72          4 |        76 

True D defined as xpertsputum ~= 1                    [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  25.00%      15.26%   34.74%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  96.00%      91.59%   100.41%
-------------------------------------------------------------------------
Prevalence                      Pr(D)       5.26%       0.24%   10.28%
-------------------------------------------------------------------------

diagtest res_sput_pluslife xpertsputum if agecat15==2

        Hasil |
  pemeriksaan |   Hasil pemeriksaan
       Sputum |     Xpert Sputum
     Pluslife |  Negative   Positive |     Total
--------------+----------------------+----------
     Negative |       378         33 |       411 
     Positive |        10        103 |       113 
--------------+----------------------+----------
        Total |       388        136 |       524 

True D defined as xpertsputum ~= 1                    [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  75.74%      72.06%   79.41%
Specificity                     Pr( -|~D)  97.42%      96.07%   98.78%
Positive predictive value       Pr( D| +)  91.15%      88.72%   93.58%
Negative predictive value       Pr(~D| -)  91.97%      89.64%   94.30%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      25.95%      22.20%   29.71%
-------------------------------------------------------------------------

// pluslife ss vs composite //
use "D:\EVIDENT WP1 Data\250517_WP1 dataset.dta"
(EVIDENTSTUDIVALIDASI_DATA_NOHDRS_2025-05-19_0910.csv)

//dropping contamination
drop if idsubject==4100167
drop if idsubject==4100163
drop if idsubject==4100162
drop if idsubject==4100170
drop if idsubject==4100169
drop if idsubject==4100168
drop if idsubject==4100166
// 944 obs

// membuat composite reference standards //
gen composite=.
sort res_sput_pluslife
br res_sput_pluslife culture_result2 xpertsputum composite
replace composite=1 if culture_result2==2 | xpertsputum==2
replace composite=0 if (culture_result2==1 & xpertsputum==1) | (culture_result2==999 & xpertsputum==1) | (culture_result2==1 & xpertsputum==.)
label define yesnolab 0 "No" 1 "Yes"
label values composite yesnolab

tab composite, m
  composite |      Freq.     Percent        Cum.
------------+-----------------------------------
         No |        583       61.76       61.76
        Yes |        190       20.13       81.89
          . |        171       18.11      100.00
------------+-----------------------------------
      Total |        944      100.00

tab composite
  composite |      Freq.     Percent        Cum.
------------+-----------------------------------
         No |        583       75.42       75.42
        Yes |        190       24.58      100.00
------------+-----------------------------------
      Total |        773      100.00

br interv_dt age res_sput_pluslife culture_result2 xpertsputum composite if composite==.
drop if composite==. // 171 obs deleted

// tabel 2x2 //
tab res_sput_pluslife composite, m

        Hasil |
  pemeriksaan |
       Sputum |       composite
     Pluslife |        No        Yes |     Total
--------------+----------------------+----------
     Negative |       472         40 |       512 
     Positive |         5        107 |       112 
Error/Invalid |         2          0 |         2 
     Not done |         2          0 |         2 
            . |       102         43 |       145 
--------------+----------------------+----------
        Total |       583        190 |       773 

keep if res_sput_pluslife==0 | res_sput_pluslife==1 // 149 obs deleted

tab agecat

         agecat |      Freq.     Percent        Cum.
----------------+-----------------------------------
Usia 0-14 tahun |        123       19.71       19.71
 Usia 15+ tahun |        501       80.29      100.00
----------------+-----------------------------------
          Total |        624      100.00

save "D:\EVIDENT WP1 Data\250517_pluslife ss vs composite.dta", replace

// performance //
diagtest res_sput_pluslife composite if agecat==1

        Hasil |
  pemeriksaan |
       Sputum |       composite
     Pluslife |        No        Yes |     Total
--------------+----------------------+----------
     Negative |       119          3 |       122 
     Positive |         0          1 |         1 
--------------+----------------------+----------
        Total |       119          4 |       123 

True D defined as composite ~= 0                      [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  25.00%      17.35%   32.65%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  97.54%      94.80%   100.28%
-------------------------------------------------------------------------
Prevalence                      Pr(D)       3.25%       0.12%    6.39%
-------------------------------------------------------------------------

diagtest res_sput_pluslife composite if agecat==2

        Hasil |
  pemeriksaan |
       Sputum |       composite
     Pluslife |        No        Yes |     Total
--------------+----------------------+----------
     Negative |       353         37 |       390 
     Positive |         5        106 |       111 
--------------+----------------------+----------
        Total |       358        143 |       501 

True D defined as composite ~= 0                      [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  74.13%      70.29%   77.96%
Specificity                     Pr( -|~D)  98.60%      97.58%   99.63%
Positive predictive value       Pr( D| +)  95.50%      93.68%   97.31%
Negative predictive value       Pr(~D| -)  90.51%      87.95%   93.08%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      28.54%      24.59%   32.50%
-------------------------------------------------------------------------

// pluslife ss vs crs //
use "D:\EVIDENT WP1 Data\250517_WP1 dataset.dta", clear
(EVIDENTSTUDIVALIDASI_DATA_NOHDRS_2025-05-19_0910.csv)

//dropping contamination
drop if idsubject==4100167
drop if idsubject==4100163
drop if idsubject==4100162
drop if idsubject==4100170
drop if idsubject==4100169
drop if idsubject==4100168
drop if idsubject==4100166

// tabel 2x2 //
tab res_sput_pluslife tb_treat, m

        Hasil |
  pemeriksaan |     Apakah Anda mendapatkan
       Sputum |         pengobatan TBC?
     Pluslife |     Tidak         Ya          . |     Total
--------------+---------------------------------+----------
     Negative |       361        190          2 |       553 
     Positive |         5        110          1 |       116 
--------------+---------------------------------+----------
        Total |       366        300          3 |       669 

keep if res_sput_pluslife==0 | res_sput_pluslife==1
keep if tb_treat~=.
tab res_sput_pluslife tb_treat, m
save "D:\EVIDENT WP1 Data\250517_pluslife ss vs crs.dta"

// tabel 2x2 //
diagtest res_sput_pluslife tb_treat if agecat15==1

        Hasil |      Apakah Anda
  pemeriksaan |      mendapatkan
       Sputum |    pengobatan TBC?
     Pluslife |     Tidak         Ya |     Total
--------------+----------------------+----------
     Negative |        57         76 |       133 
     Positive |         0          2 |         2 
--------------+----------------------+----------
        Total |        57         78 |       135 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)   2.56%      -0.10%    5.23%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  42.86%      34.51%   51.20%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      57.78%      49.45%   66.11%
-------------------------------------------------------------------------

diagtest res_sput_pluslife tb_treat if agecat15==2

        Hasil |      Apakah Anda
  pemeriksaan |      mendapatkan
       Sputum |    pengobatan TBC?
     Pluslife |     Tidak         Ya |     Total
--------------+----------------------+----------
     Negative |       304        114 |       418 
     Positive |         5        108 |       113 
--------------+----------------------+----------
        Total |       309        222 |       531 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  48.65%      44.40%   52.90%
Specificity                     Pr( -|~D)  98.38%      97.31%   99.46%
Positive predictive value       Pr( D| +)  95.58%      93.83%   97.32%
Negative predictive value       Pr(~D| -)  72.73%      68.94%   76.52%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      41.81%      37.61%   46.00%
-------------------------------------------------------------------------

//Agreement with Xpert (variabel tcm_result untuk sputum, res_xpertultra untuk SS)
clear
use "D:\EVIDENT WP1 Data\250517_pluslife ss vs xpert.dta"
browse tcm_type tcm_result
//mengeluarkan BD Max dan not done
keep if tcm_type==1
//80 obs deleted

gen xpert_sputum=999
sort tcm_result
browse tcm_result xpert_sputum
replace xpert_sputum=1 if tcm_result==0
replace xpert_sputum=2 if tcm_result==1 | tcm_result==2 | tcm_result==3 | tcm_result==4 | tcm_result==5 | tcm_result==7 | tcm_result==8
drop if tcm_result==. | tcm_result==12

gen res_sput_pluslife2=999
browse res_sput_pluslife res_sput_pluslife2
replace res_sput_pluslife2=2 if res_sput_pluslife==1
replace res_sput_pluslife2=1 if res_sput_pluslife==0
drop if res_sput_pluslife==3
label define res_sput_pluslife2 1 "negative" 2 "positive"
label values res_sput_pluslife2 res_sput_pluslife2

tab res_sput_pluslife2 xpertsputum if res_sput_pluslife2~=999
kap res_sput_pluslife2 xpertsputum if res_swab_pluslife2~=999
cii proportions 606 555

// tabel gradasi nilai pluslife ts compared to semi quantitative //
tab semi_quant res_swab_pluslife if sampling30==0 & tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4, row
tab tcm_result res_swab_pluslife if sampling30==0 & tcm_type==1 & tcm_result==0 & res_swab_pluslife~=4, row
tab semi_quant res_swab_pluslife if sampling30==0 & tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4, col

tab semi_quant res_swab_pluslife if sampling30==1 & tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4, row
tab tcm_result res_swab_pluslife if sampling30==1 & tcm_type==1 & tcm_result==0 & res_swab_pluslife~=4, row
tab semi_quant res_swab_pluslife if sampling30==1 & tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4, col
