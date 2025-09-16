// 12 Juni 2025 //
use "D:\EVIDENT WP1 Data\250611_dataset monthly check-in june.dta"

br
replace tb_treat=1 if idsubject==4100735

// tabel 2x2 //
tab res_swab_pluslife tb_treat, m

        Hasil |
  pemeriksaan |     Apakah Anda mendapatkan
   Usap lidah |         pengobatan TBC?
     Pluslife |     Tidak         Ya          . |     Total
--------------+---------------------------------+----------
     Negative |       338        251          5 |       594 
     Positive |         1         90          1 |        92 
Error/Invalid |         2          1          0 |         3 
     Not Done |        61         63        113 |       237 
            . |        75         37        113 |       225 
--------------+---------------------------------+----------
        Total |       477        442        232 |     1,151 

keep if res_swab_pluslife==0 | res_swab_pluslife==1
keep if tb_treat~=.

tab res_swab_pluslife tb_treat, m

        Hasil |      Apakah Anda
  pemeriksaan |      mendapatkan
   Usap lidah |    pengobatan TBC?
     Pluslife |     Tidak         Ya |     Total
--------------+----------------------+----------
     Negative |       338        251 |       589 
     Positive |         1         90 |        91 
--------------+----------------------+----------
        Total |       339        341 |       680 

save "D:\EVIDENT WP1 Data\250611_dataset pluslife vs crs.dta"
		
// performance //
diagtest res_swab_pluslife tb_treat if sampling30==0 & agecat15==1

        Hasil |      Apakah Anda
  pemeriksaan |      mendapatkan
   Usap lidah |    pengobatan TBC?
     Pluslife |     Tidak         Ya |     Total
--------------+----------------------+----------
     Negative |        30         62 |        92 
--------------+----------------------+----------
        Total |        30         62 |        92 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)      .%          .%       .%
Specificity                     Pr( -|~D)      .%          .%       .%
Positive predictive value       Pr( D| +)      .%          .%       .%
Negative predictive value       Pr(~D| -)  32.61%          .%       .%
-------------------------------------------------------------------------
Prevalence                      Pr(D)          .%          .%       .%
-------------------------------------------------------------------------

diagtest res_swab_pluslife tb_treat if sampling30==0 & agecat15==2

        Hasil |      Apakah Anda
  pemeriksaan |      mendapatkan
   Usap lidah |    pengobatan TBC?
     Pluslife |     Tidak         Ya |     Total
--------------+----------------------+----------
     Negative |       189         94 |       283 
     Positive |         1         72 |        73 
--------------+----------------------+----------
        Total |       190        166 |       356 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  43.37%      38.23%   48.52%
Specificity                     Pr( -|~D)  99.47%      98.72%   100.23%
Positive predictive value       Pr( D| +)  98.63%      97.42%   99.84%
Negative predictive value       Pr(~D| -)  66.78%      61.89%   71.68%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      46.63%      41.45%   51.81%
-------------------------------------------------------------------------

diagtest res_swab_pluslife tb_treat if sampling30==1 & agecat15==1

        Hasil |      Apakah Anda
  pemeriksaan |      mendapatkan
   Usap lidah |    pengobatan TBC?
     Pluslife |     Tidak         Ya |     Total
--------------+----------------------+----------
     Negative |        45         68 |       113 
     Positive |         0          1 |         1 
--------------+----------------------+----------
        Total |        45         69 |       114 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)   1.45%      -0.74%    3.64%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  39.82%      30.84%   48.81%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      60.53%      51.55%   69.50%
-------------------------------------------------------------------------

diagtest res_swab_pluslife tb_treat if sampling30==1 & agecat15==2

        Hasil |      Apakah Anda
  pemeriksaan |      mendapatkan
   Usap lidah |    pengobatan TBC?
     Pluslife |     Tidak         Ya |     Total
--------------+----------------------+----------
     Negative |        74         27 |       101 
     Positive |         0         17 |        17 
--------------+----------------------+----------
        Total |        74         44 |       118 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  38.64%      29.85%   47.42%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  73.27%      65.28%   81.25%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      37.29%      28.56%   46.01%
-------------------------------------------------------------------------

save "D:\EVIDENT WP1 Data\250517_pluslife ts vs crs.dta"
file D:\EVIDENT WP1 Data\250517_pluslife ts vs crs.dta saved

// agreement with xpert ts //
//untuk agreement perlu recoding
browse res_swab_pluslife xpertts
gen res_swab_pluslife2=999
replace res_swab_pluslife2=1 if res_swab_pluslife==0
replace res_swab_pluslife2=2 if res_swab_pluslife==1
tab res_swab_pluslife2 xpertts if res_swab_pluslife2~=999
kap res_swab_pluslife2 xpertts if res_swab_pluslife2~=999
cii proportions 337 331

