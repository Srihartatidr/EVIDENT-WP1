// 17 Mei 2025 //

use "D:\EVIDENT WP1 Data\250517_WP1 dataset.dta", clear

br

// recoding hasil xpert sputum //
gen xpertsputum=.
replace xpertsputum=1 if tcm_result==0
replace xpertsputum=2 if tcm_result==1 | tcm_result==2 | tcm_result==3 | tcm_result==4 | tcm_result==5 | tcm_result==6 | tcm_result==7 | tcm_result==8
label variable xpertsputum "Hasil pemeriksaan Xpert Sputum"
label define xpertsputumlab 1 "Negative" 2 "Positive"
label values xpertsputum xpertsputumlab

// tabel 2x2 //
tab res_swab_pluslife xpertsputum, m

        Hasil |
  pemeriksaan |
   Usap lidah |  Hasil pemeriksaan Xpert Sputum
     Pluslife |  Negative   Positive          . |     Total
--------------+---------------------------------+----------
     Negative |       412         42        137 |       591 
     Positive |         3         88          0 |        91 
Error/Invalid |         2          0          1 |         3 
     Not Done |        80         35        120 |       235 
            . |       103         21         99 |       223 
--------------+---------------------------------+----------
        Total |       600        186        357 |     1,143 

keep if res_swab_pluslife==0 | res_swab_pluslife==1
tab res_swab_pluslife xpertsputum, m

keep if xpertsputum~=.
tab res_swab_pluslife xpertsputum, m
// 545 obs

// analisis performance //
diagtest res_swab_pluslife xpertsputum if sampling30==0 & agecat15==1

        Hasil |
  pemeriksaan |   Hasil pemeriksaan
   Usap lidah |     Xpert Sputum
     Pluslife |  Negative   Positive |     Total
--------------+----------------------+----------
     Negative |        36          1 |        37 
--------------+----------------------+----------
        Total |        36          1 |        37 

True D defined as xpertsputum ~= 1                    [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)      .%          .%       .%
Specificity                     Pr( -|~D)      .%          .%       .%
Positive predictive value       Pr( D| +)      .%          .%       .%
Negative predictive value       Pr(~D| -)  97.30%          .%       .%
-------------------------------------------------------------------------
Prevalence                      Pr(D)          .%          .%       .%
-------------------------------------------------------------------------

diagtest res_swab_pluslife xpertsputum if sampling30==0 & agecat15==2

        Hasil |
  pemeriksaan |   Hasil pemeriksaan
   Usap lidah |     Xpert Sputum
     Pluslife |  Negative   Positive |     Total
--------------+----------------------+----------
     Negative |       244         35 |       279 
     Positive |         2         71 |        73 
--------------+----------------------+----------
        Total |       246        106 |       352 

True D defined as xpertsputum ~= 1                    [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  66.98%      62.07%   71.89%
Specificity                     Pr( -|~D)  99.19%      98.25%   100.13%
Positive predictive value       Pr( D| +)  97.26%      95.55%   98.97%
Negative predictive value       Pr(~D| -)  87.46%      83.99%   90.92%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      30.11%      25.32%   34.91%
-------------------------------------------------------------------------

diagtest res_swab_pluslife xpertsputum if sampling30==1 & agecat15==1

        Hasil |
  pemeriksaan |   Hasil pemeriksaan
   Usap lidah |     Xpert Sputum
     Pluslife |  Negative   Positive |     Total
--------------+----------------------+----------
     Negative |        39          1 |        40 
     Positive |         0          1 |         1 
--------------+----------------------+----------
        Total |        39          2 |        41 

True D defined as xpertsputum ~= 1                    [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  50.00%      34.70%   65.30%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  97.50%      92.72%   102.28%
-------------------------------------------------------------------------
Prevalence                      Pr(D)       4.88%      -1.72%   11.47%
-------------------------------------------------------------------------



diagtest res_swab_pluslife xpertsputum if sampling30==1 & agecat==2

        Hasil |
  pemeriksaan |   Hasil pemeriksaan
   Usap lidah |     Xpert Sputum
     Pluslife |  Negative   Positive |     Total
--------------+----------------------+----------
     Negative |        62          3 |        65 
     Positive |         1         15 |        16 
--------------+----------------------+----------
        Total |        63         18 |        81 

True D defined as xpertsputum ~= 1                    [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  83.33%      75.22%   91.45%
Specificity                     Pr( -|~D)  98.41%      95.69%   101.13%
Positive predictive value       Pr( D| +)  93.75%      88.48%   99.02%
Negative predictive value       Pr(~D| -)  95.38%      90.82%   99.95%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      22.22%      13.17%   31.28%
-------------------------------------------------------------------------
