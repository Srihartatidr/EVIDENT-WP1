// 17 Mei 2025 //
use "D:\EVIDENT WP1 Data\250517_WP1 dataset.dta"

br

// membagi jadi sampling 15s dan 30s
gen sampling30=.
replace sampling30=0 if interv_dt<td(30jan2025)
replace sampling30=1 if interv_dt>=td(30jan2025)

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

// recoding hasil xpert sputum
gen xpertsputum=.
replace xpertsputum=1 if tcm_result==0
replace xpertsputum=2 if tcm_result==1 | tcm_result==2 | tcm_result==3 | tcm_result==4 | tcm_result==5 | tcm_result==6 | tcm_result==7 | tcm_result==8
label variable xpertsputum "Hasil pemeriksaan Xpert Sputum"
label define xpertsputumlab 1 "Negative" 2 "Positive"
label values xpertsputum xpertsputumlab

// recoding truenat
// label res_truenant_ul_ 0 "MTB Ultima Not Detected" 1 "MTB Ultima Detected Very Low" 2 "MTB Ultima Detected Low" 3 "MTB Ultima Detected Medium" 4 "MTB Ultima Detected High" 5 "Invalid" 6 "No Result" 7 "Not Done"
gen truenat=.
replace truenat=1 if res_truenant_ul==0
replace truenat=2 if res_truenant_ul==1 | res_xpertultra==2 | res_xpertultra==3 | res_xpertultra==4
label variable truenat "Hasil pemeriksaan Truenat"
label define truenatlab 1 "Negative" 2 "Positive"
label values truenat truenatlab

tab truenat, m

      Hasil |
pemeriksaan |
    Truenat |      Freq.     Percent        Cum.
------------+-----------------------------------
   Negative |        391       41.16       41.16
   Positive |         32        3.37       44.53
          . |        527       55.47      100.00
------------+-----------------------------------
      Total |        950      100.00

keep if truenat~=.

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

// tabel gradasi nilai truenat compared to semi quantitative //
tab semi_quant truenat if tcm_type==1 & semi_quant~=0, row
tab tcm_result truenat if tcm_type==1 & tcm_result==0, row
tab semi_quant truenat if tcm_type==1 & semi_quant~=0, col

// truenat vs kultur //
// tabel 2x2 //
tab culture_result, m

          Hasil kultur |      Freq.     Percent        Cum.
-----------------------+-----------------------------------
       Tidak ada hasil |          7        1.65        1.65
               Negatif |        188       44.44       46.10
               Positif |         43       10.17       56.26
       Tidak dilakukan |         45       10.64       66.90
                     . |        140       33.10      100.00
-----------------------+-----------------------------------
                 Total |        423      100.00

keep if culture_result==1 | culture_result==3
tab culture_result, m

//hasil kultur positif tapi MOTT harus diubah jadi negatif
gen culture_result2=999
browse culture_result cult_ident culture_result2
sort culture_result

//negative
replace culture_result2=1 if culture_result==1
replace culture_result2=1 if culture_result==3 & cult_ident==2
browse idsubject if culture_result==3 & cult_ident==2
sort idsubject
//19 MOTT

//positive
replace culture_result2=2 if culture_result==3 & cult_ident==1
replace culture_result2=2 if culture_result==3 & cult_ident==.

label define culture_result2 1 "negative" 2 "positive"
label values culture_result2 culture_result2

tab culture_result culture_result2

save "D:\EVIDENT WP1 Data\250517_truenat vs kultur.dta"
file D:\EVIDENT WP1 Data\250517_truenat vs kultur.dta saved

// tabel 2x2 //
tab culture_result2 truenat, m


           |   Hasil pemeriksaan
culture_re |        Truenat
     sult2 |  Negative   Positive |     Total
-----------+----------------------+----------
  negative |       190          1 |       191 
  positive |        13         27 |        40 
-----------+----------------------+----------
     Total |       203         28 |       231 

// performance analysis //
//dropping sampel yang samplingnya kurang dari 15 detik!!
drop if idsubject==4100466
drop if idsubject==4100467
drop if idsubject==4100717
drop if idsubject==4100718

// overall sensitivity vs MGIT//
diagtest truenat culture_result2 

     Hasil |
pemeriksaa |    culture_result2
 n Truenat |  negative   positive |     Total
-----------+----------------------+----------
  Negative |       187         13 |       200 
  Positive |         1         27 |        28 
-----------+----------------------+----------
     Total |       188         40 |       228 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  67.50%      61.42%   73.58%
Specificity                     Pr( -|~D)  99.47%      98.52%   100.41%
Positive predictive value       Pr( D| +)  96.43%      94.02%   98.84%
Negative predictive value       Pr(~D| -)  93.50%      90.30%   96.70%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      17.54%      12.61%   22.48%
-------------------------------------------------------------------------

diagtest truenat culture_result2 if sampling30==0 & agecat==1

     Hasil | culture_re
pemeriksaa |   sult2
 n Truenat |  negative |     Total
-----------+-----------+----------
  Negative |        16 |        16 
-----------+-----------+----------
     Total |        16 |        16 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)      .%          .%       .%
Specificity                     Pr( -|~D)      .%          .%       .%
Positive predictive value       Pr( D| +)      .%          .%       .%
Negative predictive value       Pr(~D| -)      .%          .%       .%
-------------------------------------------------------------------------
Prevalence                      Pr(D)          .%          .%       .%
-------------------------------------------------------------------------

diagtest truenat culture_result2 if sampling30==0 & agecat==2

     Hasil |
pemeriksaa |    culture_result2
 n Truenat |  negative   positive |     Total
-----------+----------------------+----------
  Negative |        24          4 |        28 
  Positive |         1         20 |        21 
-----------+----------------------+----------
     Total |        25         24 |        49 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  83.33%      72.90%   93.77%
Specificity                     Pr( -|~D)  96.00%      90.51%   101.49%
Positive predictive value       Pr( D| +)  95.24%      89.28%   101.20%
Negative predictive value       Pr(~D| -)  85.71%      75.92%   95.51%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      48.98%      34.98%   62.98%
-------------------------------------------------------------------------

diagtest truenat culture_result2 if sampling30==1 & agecat==1

     Hasil |
pemeriksaa |    culture_result2
 n Truenat |  negative   positive |     Total
-----------+----------------------+----------
  Negative |        58          0 |        58 
  Positive |         0          1 |         1 
-----------+----------------------+----------
     Total |        58          1 |        59 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  100.00%     100.00%  100.00%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  100.00%     100.00%  100.00%
-------------------------------------------------------------------------
Prevalence                      Pr(D)       1.69%      -1.60%    4.99%
-------------------------------------------------------------------------

diagtest truenat culture_result2 if sampling30==1 & agecat==2

     Hasil |
pemeriksaa |    culture_result2
 n Truenat |  negative   positive |     Total
-----------+----------------------+----------
  Negative |        89          9 |        98 
  Positive |         0          6 |         6 
-----------+----------------------+----------
     Total |        89         15 |       104 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  40.00%      30.58%   49.42%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  90.82%      85.27%   96.37%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      14.42%       7.67%   21.18%
-------------------------------------------------------------------------

save "D:\EVIDENT WP1 Data\250517_truenat vs kultur.dta", replace
file D:\EVIDENT WP1 Data\250517_truenat vs kultur.dta saved

// truenat vs xpert //
use "D:\EVIDENT WP1 Data\250517_truenat dataset.dta"
(EVIDENTSTUDIVALIDASI_DATA_NOHDRS_2025-05-19_0910.csv)

tab truenat xpertsputum, m

     Hasil |
pemeriksaa |  Hasil pemeriksaan Xpert Sputum
 n Truenat |  Negative   Positive          . |     Total
-----------+---------------------------------+----------
  Negative |       203         24        164 |       391 
  Positive |         1         29          2 |        32 
-----------+---------------------------------+----------
     Total |       204         53        166 |       423 

keep if xpertsputum~=.
save "D:\EVIDENT WP1 Data\250517_truenat vs xpert.dta"
file D:\EVIDENT WP1 Data\250517_truenat vs xpert.dta saved

// performance //
diagtest truenat xpertsputum if sampling30==0 & agecat==1

           |   Hasil
           | pemeriksaa
     Hasil |  n Xpert
pemeriksaa |   Sputum
 n Truenat |  Negative |     Total
-----------+-----------+----------
  Negative |         7 |         7 
-----------+-----------+----------
     Total |         7 |         7 

True D defined as xpertsputum ~= 1                    [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)      .%          .%       .%
Specificity                     Pr( -|~D)      .%          .%       .%
Positive predictive value       Pr( D| +)      .%          .%       .%
Negative predictive value       Pr(~D| -)      .%          .%       .%
-------------------------------------------------------------------------
Prevalence                      Pr(D)          .%          .%       .%
-------------------------------------------------------------------------

diagtest truenat xpertsputum if sampling30==0 & agecat==2

pemeriksaa |     Xpert Sputum
 n Truenat |  Negative   Positive |     Total
-----------+----------------------+----------
  Negative |        24          6 |        30 
  Positive |         0         21 |        21 
-----------+----------------------+----------
     Total |        24         27 |        51 

True D defined as xpertsputum ~= 1                    [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  77.78%      66.37%   89.19%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  80.00%      69.02%   90.98%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      52.94%      39.24%   66.64%
-------------------------------------------------------------------------

diagtest truenat xpertsputum if sampling30==1 & agecat==1

     Hasil |   Hasil pemeriksaan
pemeriksaa |     Xpert Sputum
 n Truenat |  Negative   Positive |     Total
-----------+----------------------+----------
  Negative |        34          1 |        35 
  Positive |         1          1 |         2 
-----------+----------------------+----------
     Total |        35          2 |        37 

True D defined as xpertsputum ~= 1                    [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  50.00%      33.89%   66.11%
Specificity                     Pr( -|~D)  97.14%      91.77%   102.51%
Positive predictive value       Pr( D| +)  50.00%      33.89%   66.11%
Negative predictive value       Pr(~D| -)  97.14%      91.77%   102.51%
-------------------------------------------------------------------------
Prevalence                      Pr(D)       5.41%      -1.88%   12.69%
-------------------------------------------------------------------------

diagtest truenat xpertsputum if sampling30==1 & agecat==2

     Hasil |   Hasil pemeriksaan
pemeriksaa |     Xpert Sputum
 n Truenat |  Negative   Positive |     Total
-----------+----------------------+----------
  Negative |       138         17 |       155 
  Positive |         0          7 |         7 
-----------+----------------------+----------
     Total |       138         24 |       162 

True D defined as xpertsputum ~= 1                    [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  29.17%      22.17%   36.17%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  89.03%      84.22%   93.84%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      14.81%       9.34%   20.29%
-------------------------------------------------------------------------
list idsubject if truenat==1 & xpertsputum==2 & sampling30==1 & agecat==2

// truenat vs composite //
use "D:\EVIDENT WP1 Data\250517_truenat dataset.dta"

// membuat composite reference standards //
gen composite=.
replace composite=1 if culture_result2==2 | xpertsputum==2
replace composite=0 if composite~=1
label define yesnolab 0 "No" 1 "Yes"
label values composite yesnolab

tab culture_result2 xpertsputum, m

culture_re |  Hasil pemeriksaan Xpert Sputum
     sult2 |  Negative   Positive          . |     Total
-----------+---------------------------------+----------
  negative |       137          9         45 |       191 
  positive |         1         38          1 |        40 
       999 |        66          6        120 |       192 
-----------+---------------------------------+----------
     Total |       204         53        166 |       423 

sort composite
br idsubject age truenat culture_result xpertsputum composite
br idsubject age truenat culture_result2 xpertsputum composite if agecat==1
br idsubject age truenat culture_result2 xpertsputum composite if agecat==2
drop if culture_result2==999 & xpertsputum==.

// tabel 2x2 //
tab truenat composite, m

     Hasil |
pemeriksaa |       composite
 n Truenat |        No        Yes |     Total
-----------+----------------------+----------
  Negative |       247         26 |       273 
  Positive |         1         29 |        30 
-----------+----------------------+----------
     Total |       248         55 |       303 
 	
save "D:\EVIDENT WP1 Data\250517_truenat vs composite.dta"
	
// performance //
diagtest truenat composite if sampling30==0 & agecat==1

     Hasil |
pemeriksaa | composite
 n Truenat |        No |     Total
-----------+-----------+----------
  Negative |        17 |        17 
-----------+-----------+----------
     Total |        17 |        17 

True D defined as composite ~= 0                      [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)      .%          .%       .%
Specificity                     Pr( -|~D)      .%          .%       .%
Positive predictive value       Pr( D| +)      .%          .%       .%
Negative predictive value       Pr(~D| -)      .%          .%       .%
-------------------------------------------------------------------------
Prevalence                      Pr(D)          .%          .%       .%
-------------------------------------------------------------------------

diagtest truenat composite if sampling30==0 & agecat==2

     Hasil |
pemeriksaa |       composite
 n Truenat |        No        Yes |     Total
-----------+----------------------+----------
  Negative |        24          6 |        30 
  Positive |         0         21 |        21 
-----------+----------------------+----------
     Total |        24         27 |        51 

True D defined as composite ~= 0                      [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  77.78%      66.37%   89.19%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  80.00%      69.02%   90.98%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      52.94%      39.24%   66.64%
-------------------------------------------------------------------------

diagtest truenat composite if sampling30==1 & agecat==1

     Hasil |
pemeriksaa |       composite
 n Truenat |        No        Yes |     Total
-----------+----------------------+----------
  Negative |        65          1 |        66 
  Positive |         1          1 |         2 
-----------+----------------------+----------
     Total |        66          2 |        68 

True D defined as composite ~= 0                      [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  50.00%      38.12%   61.88%
Specificity                     Pr( -|~D)  98.48%      95.58%   101.39%
Positive predictive value       Pr( D| +)  50.00%      38.12%   61.88%
Negative predictive value       Pr(~D| -)  98.48%      95.58%   101.39%
-------------------------------------------------------------------------
Prevalence                      Pr(D)       2.94%      -1.07%    6.96%
-------------------------------------------------------------------------

diagtest truenat composite if sampling30==1 & agecat==2

     Hasil |
pemeriksaa |       composite
 n Truenat |        No        Yes |     Total
-----------+----------------------+----------
  Negative |       141         19 |       160 
  Positive |         0          7 |         7 
-----------+----------------------+----------
     Total |       141         26 |       167 

True D defined as composite ~= 0                      [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  26.92%      20.20%   33.65%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  88.12%      83.22%   93.03%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      15.57%      10.07%   21.07%
-------------------------------------------------------------------------


// truenat vs crs //
use "D:\EVIDENT WP1 Data\250517_truenat dataset.dta"
tab truenat tb_treat, m

     Hasil |     Apakah Anda mendapatkan
pemeriksaa |         pengobatan TBC?
 n Truenat |     Tidak         Ya          . |     Total
-----------+---------------------------------+----------
  Negative |        96         55        240 |       391 
  Positive |         0         23          9 |        32 
-----------+---------------------------------+----------
     Total |        96         78        249 |       423 

keep if tb_treat~=.
save "D:\EVIDENT WP1 Data\250517_truenat dataset.dta", replace

// performance //
diagtest truenat tb_treat if sampling30==0 & agecat==1

           |   Apakah
           |    Anda
           | mendapatka
           |     n
     Hasil | pengobatan
pemeriksaa |    TBC?
 n Truenat |        Ya |     Total
-----------+-----------+----------
  Negative |         7 |         7 
-----------+-----------+----------
     Total |         7 |         7 

True D defined as tb_treat ~= 1                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)      .%          .%       .%
Specificity                     Pr( -|~D)      .%          .%       .%
Positive predictive value       Pr( D| +)      .%          .%       .%
Negative predictive value       Pr(~D| -)      .%          .%       .%
-------------------------------------------------------------------------
Prevalence                      Pr(D)          .%          .%       .%
-------------------------------------------------------------------------

diagtest truenat tb_treat if sampling30==0 & agecat==2

           |      Apakah Anda
     Hasil |      mendapatkan
pemeriksaa |    pengobatan TBC?
 n Truenat |     Tidak         Ya |     Total
-----------+----------------------+----------
  Negative |         7          8 |        15 
  Positive |         0         17 |        17 
-----------+----------------------+----------
     Total |         7         25 |        32 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  68.00%      51.84%   84.16%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  46.67%      29.38%   63.95%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      78.12%      63.80%   92.45%
-------------------------------------------------------------------------

diagtest truenat tb_treat if sampling30==1 & agecat==1

           |      Apakah Anda
     Hasil |      mendapatkan
pemeriksaa |    pengobatan TBC?
 n Truenat |     Tidak         Ya |     Total
-----------+----------------------+----------
  Negative |        14         14 |        28 
  Positive |         0          1 |         1 
-----------+----------------------+----------
     Total |        14         15 |        29 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)   6.67%      -2.41%   15.75%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  50.00%      31.80%   68.20%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      51.72%      33.54%   69.91%
-------------------------------------------------------------------------

diagtest truenat tb_treat if sampling30==1 & agecat==2

           |      Apakah Anda
     Hasil |      mendapatkan
pemeriksaa |    pengobatan TBC?
 n Truenat |     Tidak         Ya |     Total
-----------+----------------------+----------
  Negative |        75         26 |       101 
  Positive |         0          5 |         5 
-----------+----------------------+----------
     Total |        75         31 |       106 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  16.13%       9.13%   23.13%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  74.26%      65.93%   82.58%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      29.25%      20.59%   37.90%
-------------------------------------------------------------------------


