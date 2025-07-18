// 17 Mei 2025 //
use "D:\EVIDENT WP1 Data\250517_WP1 dataset.dta"

br

//dropping sampel yang samplingnya kurang dari 15 detik!!
drop if idsubject==4100466
drop if idsubject==4100467
drop if idsubject==4100717
drop if idsubject==4100718
// 1 deleted

// dropping early exclusion //
drop if idsubject==4100074 | idsubject==4100689 | idsubject==4100974 | idsubject==4100455

// tabel 2x2 //
tab culture_result, m

          Hasil kultur |      Freq.     Percent        Cum.
-----------------------+-----------------------------------
       Tidak ada hasil |          9        1.32        1.32
               Negatif |        490       71.85       73.17
               Positif |        126       18.48       91.64
       Tidak dilakukan |         56        8.21       99.85
                     . |          1        0.15      100.00
-----------------------+-----------------------------------
                 Total |        682      100.00

keep if culture_result==1 | culture_result==3
				
save "D:\EVIDENT WP1 Data\250517_pluslife ts vs kultur.dta"

// tabel 2x2 //
tab culture_result2 res_swab_pluslife, m

           |   Hasil pemeriksaan
culture_re |  Usap lidah Pluslife
     sult2 |  Negative   Positive |     Total
-----------+----------------------+----------
  negative |       497          8 |       505 
  positive |        29         82 |       111 
-----------+----------------------+----------
     Total |       526         90 |       616 

keep if res_swab_pluslife==0 | res_swab_pluslife==1 | res_swab_pluslife==3
tab culture_result2 res_swab_pluslife, m

           |   Hasil pemeriksaan
culture_re |  Usap lidah Pluslife
     sult2 |  Negative   Positive |     Total
-----------+----------------------+----------
  negative |       497          8 |       505 
  positive |        29         82 |       111 
-----------+----------------------+----------
     Total |       526         90 |       616 

// performance analysis //
// overall sensitivity vs MGIT//
diagtest res_swab_pluslife culture_result2 if culture_result2~=999 & res_swab_pluslife~=3
 
        Hasil |
  pemeriksaan |
   Usap lidah |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       496         29 |       525 
     Positive |         8         82 |        90 
--------------+----------------------+----------
        Total |       504        111 |       615 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  73.87%      70.40%   77.35%
Specificity                     Pr( -|~D)  98.41%      97.42%   99.40%
Positive predictive value       Pr( D| +)  91.11%      88.86%   93.36%
Negative predictive value       Pr(~D| -)  94.48%      92.67%   96.28%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      18.05%      15.01%   21.09%
-------------------------------------------------------------------------

diagtest res_swab_pluslife culture_result2 if sampling30==0 & agecat==1

        Hasil |
  pemeriksaan | culture_re
   Usap lidah |   sult2
     Pluslife |  negative |     Total
--------------+-----------+----------
     Negative |        68 |        68 
--------------+-----------+----------
        Total |        68 |        68 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)      .%          .%       .%
Specificity                     Pr( -|~D)      .%          .%       .%
Positive predictive value       Pr( D| +)      .%          .%       .%
Negative predictive value       Pr(~D| -)      .%          .%       .%
-------------------------------------------------------------------------
Prevalence                      Pr(D)          .%          .%       .%
-------------------------------------------------------------------------

diagtest res_swab_pluslife culture_result2 if sampling30==0 & agecat==2

        Hasil |
  pemeriksaan |
   Usap lidah |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       251         28 |       279 
     Positive |         6         66 |        72 
--------------+----------------------+----------
        Total |       257         94 |       351 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  70.21%      65.43%   75.00%
Specificity                     Pr( -|~D)  97.67%      96.09%   99.25%
Positive predictive value       Pr( D| +)  91.67%      88.78%   94.56%
Negative predictive value       Pr(~D| -)  89.96%      86.82%   93.11%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      26.78%      22.15%   31.41%
-------------------------------------------------------------------------

diagtest res_swab_pluslife culture_result2 if sampling30==1 & agecat==1

        Hasil |
  pemeriksaan |
   Usap lidah |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |        79          0 |        79 
     Positive |         0          1 |         1 
--------------+----------------------+----------
        Total |        79          1 |        80 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  100.00%     100.00%  100.00%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  100.00%     100.00%  100.00%
-------------------------------------------------------------------------
Prevalence                      Pr(D)       1.25%      -1.18%    3.68%
-------------------------------------------------------------------------

diagtest res_swab_pluslife culture_result2 if sampling30==1 & agecat==2

        Hasil |
  pemeriksaan |
   Usap lidah |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |        73          1 |        74 
     Positive |         1         16 |        17 
--------------+----------------------+----------
        Total |        74         17 |        91 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  94.12%      89.28%   98.95%
Specificity                     Pr( -|~D)  98.65%      96.28%   101.02%
Positive predictive value       Pr( D| +)  94.12%      89.28%   98.95%
Negative predictive value       Pr(~D| -)  98.65%      96.28%   101.02%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      18.68%      10.67%   26.69%
-------------------------------------------------------------------------

// false positive (n=1)
list idsubject diag_tb cxray tcm_result res_sput_pluslife culture_result culture_result2 xpertsputum tb_treat if res_swab_pluslife==1 & culture_result2==1 & sampling30==1 & agecat==2

// false negative (n=1)
list idsubject diag_tb cxray tcm_result res_sput_pluslife culture_result culture_result2 xpertsputum tb_treat if res_swab_pluslife==0 & culture_result2==2 & sampling30==1 & agecat==2

// bagaimana jika trace tidak dilibatkan? //
drop if semi_quant==1

diagtest res_swab_pluslife culture_result2 

        Hasil |
  pemeriksaan |
   Usap lidah |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       462         26 |       488 
     Positive |         6         82 |        88 
--------------+----------------------+----------
        Total |       468        108 |       576 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  75.93%      72.43%   79.42%
Specificity                     Pr( -|~D)  98.72%      97.80%   99.64%
Positive predictive value       Pr( D| +)  93.18%      91.12%   95.24%
Negative predictive value       Pr(~D| -)  94.67%      92.84%   96.51%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      18.75%      15.56%   21.94%
-------------------------------------------------------------------------

diagtest res_swab_pluslife culture_result2 if sampling30==0 & agecat==1

        Hasil |
  pemeriksaan | culture_re
   Usap lidah |   sult2
     Pluslife |  negative |     Total
--------------+-----------+----------
     Negative |        68 |        68 
--------------+-----------+----------
        Total |        68 |        68 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)      .%          .%       .%
Specificity                     Pr( -|~D)      .%          .%       .%
Positive predictive value       Pr( D| +)      .%          .%       .%
Negative predictive value       Pr(~D| -)      .%          .%       .%
-------------------------------------------------------------------------
Prevalence                      Pr(D)          .%          .%       .%
-------------------------------------------------------------------------

diagtest res_swab_pluslife culture_result2 if sampling30==0 & agecat==2

        Hasil |
  pemeriksaan |
   Usap lidah |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       248         25 |       273 
     Positive |         5         65 |        70 
--------------+----------------------+----------
        Total |       253         90 |       343 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  72.22%      67.48%   76.96%
Specificity                     Pr( -|~D)  98.02%      96.55%   99.50%
Positive predictive value       Pr( D| +)  92.86%      90.13%   95.58%
Negative predictive value       Pr(~D| -)  90.84%      87.79%   93.89%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      26.24%      21.58%   30.89%
-------------------------------------------------------------------------


diagtest res_swab_pluslife culture_result2 if sampling30==1 & agecat==1

        Hasil |
  pemeriksaan |
   Usap lidah |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |        73          0 |        73 
     Positive |         0          1 |         1 
--------------+----------------------+----------
        Total |        73          1 |        74 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  100.00%     100.00%  100.00%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  100.00%     100.00%  100.00%
-------------------------------------------------------------------------
Prevalence                      Pr(D)       1.35%      -1.28%    3.98%
-------------------------------------------------------------------------


diagtest res_swab_pluslife culture_result2 if sampling30==1 & agecat==2

        Hasil |
  pemeriksaan |
   Usap lidah |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |        73          1 |        74 
     Positive |         1         16 |        17 
--------------+----------------------+----------
        Total |        74         17 |        91 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  94.12%      89.28%   98.95%
Specificity                     Pr( -|~D)  98.65%      96.28%   101.02%
Positive predictive value       Pr( D| +)  94.12%      89.28%   98.95%
Negative predictive value       Pr(~D| -)  98.65%      96.28%   101.02%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      18.68%      10.67%   26.69%
-------------------------------------------------------------------------

save "D:\EVIDENT WP1 Data\250611_dataset pluslife vs kultur exc trace.dta"