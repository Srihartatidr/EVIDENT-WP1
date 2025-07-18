// 17 Mei 2025 //
use "D:\EVIDENT WP1 Data\250517_WP1 dataset.dta"
(EVIDENTSTUDIVALIDASI_DATA_NOHDRS_2025-05-17_1204.csv)

br

//hasil kultur positif tapi MOTT harus diubah jadi negatif //
gen culture_result2=999
browse culture_result cult_ident culture_result2
sort culture_result

//negative
replace culture_result2=1 if culture_result==1
replace culture_result2=1 if culture_result==3 & cult_ident==2
browse idsubject if culture_result==3 & cult_ident==2
sort idsubject
//18 MOTT

//positive
replace culture_result2=2 if culture_result==3 & cult_ident==1
replace culture_result2=2 if culture_result==3 & cult_ident==.

label define culture_result2 1 "negative" 2 "positive"
label values culture_result2 culture_result2

tab culture_result culture_result2

// membuat composite reference standards //
gen composite=.
replace composite=1 if culture_result2==2 | xpertsputum==2
replace composite=0 if composite~=1
label define yesnolab 0 "No" 1 "Yes"
label values composite yesnolab

// tabel 2x2 //
tab res_swab_pluslife composite, m

        Hasil |
  pemeriksaan |
   Usap lidah |       composite
     Pluslife |        No        Yes |     Total
--------------+----------------------+----------
     Negative |       542         52 |       594 
     Positive |         2         88 |        90 
Error/Invalid |         2          0 |         2 
     Not Done |        38         20 |        58 
            . |       175         31 |       206 
--------------+----------------------+----------
        Total |       759        191 |       950 

keep if res_swab_pluslife==0 | res_swab_pluslife==1
br culture_result2 xpertsputum composite
drop if culture_result2==999 & xpertsputum==.
save "D:\EVIDENT WP1 Data\250517_pluslife ts vs composite.dta", replace

// performance //
diagtest res_swab_pluslife composite if sampling30==0 & agecat==1

        Hasil |
  pemeriksaan |
   Usap lidah |       composite
     Pluslife |        No        Yes |     Total
--------------+----------------------+----------
     Negative |        69          1 |        70 
--------------+----------------------+----------
        Total |        69          1 |        70 

True D defined as composite ~= 0                      [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)      .%          .%       .%
Specificity                     Pr( -|~D)      .%          .%       .%
Positive predictive value       Pr( D| +)      .%          .%       .%
Negative predictive value       Pr(~D| -)  98.57%          .%       .%
-------------------------------------------------------------------------
Prevalence                      Pr(D)          .%          .%       .%
-------------------------------------------------------------------------

diagtest res_swab_pluslife composite if sampling30==0 & agecat==2

        Hasil |
  pemeriksaan |
   Usap lidah |       composite
     Pluslife |        No        Yes |     Total
--------------+----------------------+----------
     Negative |       237         47 |       284 
     Positive |         1         70 |        71 
--------------+----------------------+----------
        Total |       238        117 |       355 

True D defined as composite ~= 0                      [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  59.83%      54.73%   64.93%
Specificity                     Pr( -|~D)  99.58%      98.91%   100.25%
Positive predictive value       Pr( D| +)  98.59%      97.37%   99.82%
Negative predictive value       Pr(~D| -)  83.45%      79.58%   87.32%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      32.96%      28.07%   37.85%
-------------------------------------------------------------------------

diagtest res_swab_pluslife composite if sampling30==1 & agecat==1

        Hasil |
  pemeriksaan |
   Usap lidah |       composite
     Pluslife |        No        Yes |     Total
--------------+----------------------+----------
     Negative |        67          1 |        68 
     Positive |         0          1 |         1 
--------------+----------------------+----------
        Total |        67          2 |        69 

True D defined as composite ~= 0                      [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  50.00%      38.20%   61.80%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  98.53%      95.69%   101.37%
-------------------------------------------------------------------------
Prevalence                      Pr(D)       2.90%      -1.06%    6.86%
-------------------------------------------------------------------------

diagtest res_swab_pluslife composite if sampling30==1 & agecat==2

        Hasil |
  pemeriksaan |
   Usap lidah |       composite
     Pluslife |        No        Yes |     Total
--------------+----------------------+----------
     Negative |        63          3 |        66 
     Positive |         1         16 |        17 
--------------+----------------------+----------
        Total |        64         19 |        83 

True D defined as composite ~= 0                      [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  84.21%      76.37%   92.06%
Specificity                     Pr( -|~D)  98.44%      95.77%   101.11%
Positive predictive value       Pr( D| +)  94.12%      89.06%   99.18%
Negative predictive value       Pr(~D| -)  95.45%      90.97%   99.94%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      22.89%      13.85%   31.93%
-------------------------------------------------------------------------

save "D:\EVIDENT WP1 Data\250417_pluslife ts vs composite.dta"
file D:\EVIDENT WP1 Data\250417_pluslife ts vs composite.dta saved
