// 17 Mei 2025 //
use "D:\EVIDENT WP1 Data\250517_WP1 dataset.dta"

br

// tabel 2x2 //
tab res_swab_pluslife tb_treat, m

        Hasil |
  pemeriksaan |     Apakah Anda mendapatkan
   Usap lidah |         pengobatan TBC?
     Pluslife |     Tidak         Ya          . |     Total
--------------+---------------------------------+----------
     Negative |       230        147        215 |       592 
     Positive |         0         66         23 |        89 
     Not Done |        26         32          0 |        58 
            . |        63         35        102 |       200 
--------------+---------------------------------+----------
        Total |       319        280        340 |       939 

keep if res_swab_pluslife==0 | res_swab_pluslife==1
keep if tb_treat~=.
tab res_swab_pluslife tb_treat, m

        Hasil |      Apakah Anda
  pemeriksaan |      mendapatkan
   Usap lidah |    pengobatan TBC?
     Pluslife |     Tidak         Ya |     Total
--------------+----------------------+----------
     Negative |       230        147 |       377 
     Positive |         0         66 |        66 
--------------+----------------------+----------
        Total |       230        213 |       443 

tab res_swab_pluslife tb_treat, m
		
// performance //
diagtest res_swab_pluslife tb_treat if sampling30==0 & agecat==1

        Hasil |      Apakah Anda
  pemeriksaan |      mendapatkan
   Usap lidah |    pengobatan TBC?
     Pluslife |     Tidak         Ya |     Total
--------------+----------------------+----------
     Negative |        25         47 |        72 
--------------+----------------------+----------
        Total |        25         47 |        72 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)      .%          .%       .%
Specificity                     Pr( -|~D)      .%          .%       .%
Positive predictive value       Pr( D| +)      .%          .%       .%
Negative predictive value       Pr(~D| -)  34.72%          .%       .%
-------------------------------------------------------------------------
Prevalence                      Pr(D)          .%          .%       .%
-------------------------------------------------------------------------

diagtest res_swab_pluslife tb_treat if sampling30==0 & agecat==2

        Hasil |      Apakah Anda
  pemeriksaan |      mendapatkan
   Usap lidah |    pengobatan TBC?
     Pluslife |     Tidak         Ya |     Total
--------------+----------------------+----------
     Negative |       165         82 |       247 
     Positive |         0         57 |        57 
--------------+----------------------+----------
        Total |       165        139 |       304 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  41.01%      35.48%   46.54%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  66.80%      61.51%   72.10%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      45.72%      40.12%   51.32%
-------------------------------------------------------------------------

diagtest res_swab_pluslife tb_treat if sampling30==1 & agecat==1

        Hasil |      Apakah Anda
  pemeriksaan |      mendapatkan
   Usap lidah |    pengobatan TBC?
     Pluslife |     Tidak         Ya |     Total
--------------+----------------------+----------
     Negative |        13         10 |        23 
     Positive |         0          1 |         1 
--------------+----------------------+----------
        Total |        13         11 |        24 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)   9.09%      -2.41%   20.59%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  56.52%      36.69%   76.35%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      45.83%      25.90%   65.77%
-------------------------------------------------------------------------

diagtest res_swab_pluslife tb_treat if sampling30==1 & agecat==2

        Hasil |      Apakah Anda
  pemeriksaan |      mendapatkan
   Usap lidah |    pengobatan TBC?
     Pluslife |     Tidak         Ya |     Total
--------------+----------------------+----------
     Negative |        27          8 |        35 
     Positive |         0          8 |         8 
--------------+----------------------+----------
        Total |        27         16 |        43 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  50.00%      35.06%   64.94%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  77.14%      64.59%   89.69%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      37.21%      22.76%   51.66%
-------------------------------------------------------------------------

save "D:\EVIDENT WP1 Data\250517_pluslife ts vs crs.dta"
file D:\EVIDENT WP1 Data\250517_pluslife ts vs crs.dta saved
