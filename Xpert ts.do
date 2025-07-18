// 12 Juni 2025 //
use "D:\EVIDENT WP1 Data\250611_dataset monthly check-in june.dta"

br

//dropping sampel yang samplingnya kurang dari 15 detik!!
drop if idsubject==4100466
drop if idsubject==4100467
drop if idsubject==4100717
drop if idsubject==4100718

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
drop if xpertts==.
// 655 obs

// characteristics //
tab sex
tab agecat
tab diag_tb
tab dm_status
tab hiv_status

// tabel gradasi nilai pluslife ts compared to semi quantitative //
tab semi_quant res_swab_pluslife if tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4, row
tab tcm_result res_swab_pluslife if tcm_type==1 & tcm_result==0 & res_swab_pluslife~=4, row
tab semi_quant res_swab_pluslife if tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4, col

// xpert ts vs kultur //
tab xpertts culture_result2, m

     Hasil |
pemeriksaa |         culture_result2
n Xpert TS |  negative   positive        999 |     Total
-----------+---------------------------------+----------
  Negative |       483         35         48 |       566 
  Positive |         8         82          1 |        91 
-----------+---------------------------------+----------
     Total |       491        117         49 |       657 

keep if culture_result2~=999 // 49 deleted

     Hasil |
pemeriksaa |    culture_result2
n Xpert TS |  negative   positive |     Total
-----------+----------------------+----------
  Negative |       483         35 |       518 
  Positive |         8         82 |        90 
-----------+----------------------+----------
     Total |       491        117 |       608 


// performance //
diagtest xpertts culture_result2 if sampling30==0 & agecat15==1 & culture_result2~=999

     Hasil |
pemeriksaa |    culture_result2
n Xpert TS |  negative        999 |     Total
-----------+----------------------+----------
  Negative |        68         20 |        88 
  Positive |         1          0 |         1 
-----------+----------------------+----------
     Total |        69         20 |        89 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)   0.00%       0.00%    0.00%
Specificity                     Pr( -|~D)  98.55%      96.07%   101.03%
Positive predictive value       Pr( D| +)   0.00%       0.00%    0.00%
Negative predictive value       Pr(~D| -)  77.27%      68.57%   85.98%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      22.47%      13.80%   31.14%
-------------------------------------------------------------------------

// false positive //
list cxray tcm_result semi_quant idsubject if xpertts==2 & culture_result2==1 & sampling30==0 & agecat==1

diagtest xpertts culture_result2 if sampling30==0 & agecat15==2 & culture_result2~=999

     Hasil |
pemeriksaa |    culture_result2
n Xpert TS |  negative   positive |     Total
-----------+----------------------+----------
  Negative |       282         30 |       312 
  Positive |         7         72 |        79 
-----------+----------------------+----------
     Total |       289        102 |       391 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  70.59%      66.07%   75.10%
Specificity                     Pr( -|~D)  97.58%      96.05%   99.10%
Positive predictive value       Pr( D| +)  91.14%      88.32%   93.96%
Negative predictive value       Pr(~D| -)  90.38%      87.46%   93.31%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      26.09%      21.73%   30.44%
-------------------------------------------------------------------------

// false positive //
list cxray tcm_result semi_quant idsubject if xpertts==2 & culture_result2==1 & sampling30==0 & agecat==2

diagtest xpertts culture_result2 if sampling30==1 & agecat15==1 & culture_result2~=999

     Hasil |
pemeriksaa |    culture_result2
n Xpert TS |  negative   positive |     Total
-----------+----------------------+----------
  Negative |        59          0 |        59 
  Positive |         0          1 |         1 
-----------+----------------------+----------
     Total |        59          1 |        60 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  100.00%     100.00%  100.00%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  100.00%     100.00%  100.00%
-------------------------------------------------------------------------
Prevalence                      Pr(D)       1.67%      -1.57%    4.91%
-------------------------------------------------------------------------

diagtest xpertts culture_result2 if sampling30==1 & agecat15==2 & culture_result2~=999

     Hasil |
pemeriksaa |    culture_result2
n Xpert TS |  negative   positive |     Total
-----------+----------------------+----------
  Negative |        73          5 |        78 
  Positive |         0          9 |         9 
-----------+----------------------+----------
     Total |        73         14 |        87 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  64.29%      54.22%   74.35%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  93.59%      88.44%   98.74%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      16.09%       8.37%   23.81%
-------------------------------------------------------------------------

// false negative //
list idsubject rec_loc cxray tcm_result semi_quant if xpertts==1 & culture_result2==2 & agecat==2 & sampling30==1

// xpert ts vs crs //
use "D:\EVIDENT WP1 Data\250517_xpert ts dataset.dta"

// tabel 2x2 //
tab xpertts tb_treat, m

     Hasil |     Apakah Anda mendapatkan
pemeriksaa |         pengobatan TBC?
n Xpert TS |     Tidak         Ya          . |     Total
-----------+---------------------------------+----------
  Negative |       264        157        125 |       546 
  Positive |         0         74         15 |        89 
-----------+---------------------------------+----------
     Total |       264        231        140 |       635 

drop if tb_treat==.
save "D:\EVIDENT WP1 Data\250517_xpert ts vs crs.dta"

// performance //
diagtest xpertts tb_treat if sampling30==0 & agecat==1

           |      Apakah Anda
     Hasil |      mendapatkan
pemeriksaa |    pengobatan TBC?
n Xpert TS |     Tidak         Ya |     Total
-----------+----------------------+----------
  Negative |        31         57 |        88 
  Positive |         0          1 |         1 
-----------+----------------------+----------
     Total |        31         58 |        89 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)   1.72%      -0.98%    4.43%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  35.23%      25.30%   45.15%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      65.17%      55.27%   75.07%
-------------------------------------------------------------------------

diagtest xpertts tb_treat if sampling30==0 & agecat==2

           |      Apakah Anda
     Hasil |      mendapatkan
pemeriksaa |    pengobatan TBC?
n Xpert TS |     Tidak         Ya |     Total
-----------+----------------------+----------
  Negative |       202         99 |       301 
  Positive |         0         68 |        68 
-----------+----------------------+----------
     Total |       202        167 |       369 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  40.72%      35.71%   45.73%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  67.11%      62.32%   71.90%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      45.26%      40.18%   50.34%
-------------------------------------------------------------------------

diagtest xpertts tb_treat if sampling30==1 & agecat==1

           |      Apakah Anda
     Hasil |      mendapatkan
pemeriksaa |    pengobatan TBC?
n Xpert TS |     Tidak         Ya |     Total
-----------+----------------------+----------
  Negative |         7          7 |        14 
  Positive |         0          1 |         1 
-----------+----------------------+----------
     Total |         7          8 |        15 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  12.50%      -4.24%   29.24%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  50.00%      24.70%   75.30%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      53.33%      28.09%   78.58%
-------------------------------------------------------------------------

diagtest xpertts tb_treat if sampling30==1 & agecat==2

           |      Apakah Anda
     Hasil |      mendapatkan
pemeriksaa |    pengobatan TBC?
n Xpert TS |     Tidak         Ya |     Total
-----------+----------------------+----------
  Negative |        56         16 |        72 
  Positive |         0          6 |         6 
-----------+----------------------+----------
     Total |        56         22 |        78 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  27.27%      17.39%   37.16%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  77.78%      68.55%   87.00%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      28.21%      18.22%   38.19%
-------------------------------------------------------------------------
