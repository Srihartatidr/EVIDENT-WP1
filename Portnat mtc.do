// 17 Mei 2025 //
use "D:\EVIDENT WP1 Data\250517_WP1 dataset.dta"

br

// membagi jadi sampling 15s dan 30s
gen sampling30=.
replace sampling30=0 if interv_dt<td(30jan2025)
replace sampling30=1 if interv_dt>=td(30jan2025)

tab res_portnat_mtc, m

      Hasil |
Pemeriksaan |
PortNAT MTC |      Freq.     Percent        Cum.
------------+-----------------------------------
    Negatif |         89        9.37        9.37
    Positif |         17        1.79       11.16
    Invalid |          1        0.11       11.26
   Not done |        151       15.89       27.16
          . |        692       72.84      100.00
------------+-----------------------------------
      Total |        950      100.00

keep if res_portnat_mtc==0 | res_portnat_mtc==1
save "D:\EVIDENT WP1 Data\250517_portnat dataset.dta"

tab res_portnat_mtc, m
// 106 obs

//Characteristics
tab sex, m
tab agecat, m
tab diag_tb, m
tab dm_status
tab hiv_status, m
tab smoke, m

// tabel gradasi nilai truenat compared to semi quantitative //
tab semi_quant res_portnat_mtc if tcm_type==1 & semi_quant~=0, row
tab tcm_result res_portnat_mtc if tcm_type==1 & tcm_result==0, row
tab semi_quant res_portnat_mtc if tcm_type==1 & semi_quant~=0, col

// portnat vs kultur //
// tabel 2x2 //
tab culture_result, m

          Hasil kultur |      Freq.     Percent        Cum.
-----------------------+-----------------------------------
       Tidak ada hasil |          2        1.89        1.89
               Negatif |          5        4.72        6.60
               Positif |         10        9.43       16.04
       Tidak dilakukan |         12       11.32       27.36
                     . |         77       72.64      100.00
-----------------------+-----------------------------------
                 Total |        106      100.00

keep if culture_result==1 | culture_result==3
tab culture_result, m

save "D:\EVIDENT WP1 Data\250517_portnat vs kultur.dta"
// 15 obs

// tabel 2x2 //
tab culture_result2 res_portnat_mtc, m

           |   Hasil Pemeriksaan
culture_re |      PortNAT MTC
     sult2 |   Negatif    Positif |     Total
-----------+----------------------+----------
  negative |         3          2 |         5 
  positive |         3          7 |        10 
-----------+----------------------+----------
     Total |         6          9 |        15 

// performance analysis //
//dropping sampel yang samplingnya kurang dari 15 detik!!
drop if idsubject==4100466
drop if idsubject==4100467
drop if idsubject==4100717
drop if idsubject==4100718

// overall sensitivity vs MGIT//
diagtest res_portnat_mtc culture_result2

     Hasil |
Pemeriksaa |
 n PortNAT |    culture_result2
       MTC |  negative   positive |     Total
-----------+----------------------+----------
   Negatif |         3          3 |         6 
   Positif |         2          7 |         9 
-----------+----------------------+----------
     Total |         5         10 |        15 

True D defined as culture_result2 ~= 1                [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  70.00%      46.81%   93.19%
Specificity                     Pr( -|~D)  60.00%      35.21%   84.79%
Positive predictive value       Pr( D| +)  77.78%      56.74%   98.82%
Negative predictive value       Pr(~D| -)  50.00%      24.70%   75.30%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      66.67%      42.81%   90.52%
-------------------------------------------------------------------------

// portnat vs xpert //
use "D:\EVIDENT WP1 Data\250517_portnat dataset.dta"
br
// 106 obs

tab res_portnat_mtc, m
tab res_portnat_mtc xpertsputum, m

     Hasil |
Pemeriksaa |
 n PortNAT |  Hasil pemeriksaan Xpert Sputum
       MTC |  Negative   Positive          . |     Total
-----------+---------------------------------+----------
   Negatif |        42          6         41 |        89 
   Positif |         3          9          5 |        17 
-----------+---------------------------------+----------
     Total |        45         15         46 |       106 

drop if xpertsputum==.

     Hasil |
Pemeriksaa |   Hasil pemeriksaan
 n PortNAT |     Xpert Sputum
       MTC |  Negative   Positive |     Total
-----------+----------------------+----------
   Negatif |        42          6 |        48 
   Positif |         3          9 |        12 
-----------+----------------------+----------
     Total |        45         15 |        60 

// performance 
diagtest res_portnat_mtc xpertsputum

     Hasil |
Pemeriksaa |   Hasil pemeriksaan
 n PortNAT |     Xpert Sputum
       MTC |  Negative   Positive |     Total
-----------+----------------------+----------
   Negatif |        42          6 |        48 
   Positif |         3          9 |        12 
-----------+----------------------+----------
     Total |        45         15 |        60 

True D defined as xpertsputum ~= 1                    [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  60.00%      47.60%   72.40%
Specificity                     Pr( -|~D)  93.33%      87.02%   99.65%
Positive predictive value       Pr( D| +)  75.00%      64.04%   85.96%
Negative predictive value       Pr(~D| -)  87.50%      79.13%   95.87%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      25.00%      14.04%   35.96%
-------------------------------------------------------------------------

diagtest res_portnat_mtc xpertsputum if agecat==1
diagtest res_portnat_mtc xpertsputum if agecat==2

// portnat vs composite //
use "D:\EVIDENT WP1 Data\250517_portnat dataset.dta"
br

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
  negative |         2          3          0 |         5 
  positive |         0         10          0 |        10 
       999 |        43          2         46 |        91 
-----------+---------------------------------+----------
     Total |        45         15         46 |       106 

br idsubject age culture_result2 xpertsputum composite
drop if culture_result2==999 & xpertsputum==.
tab res_portnat_mtc composite, m

     Hasil |
Pemeriksaa |
 n PortNAT |       composite
       MTC |        No        Yes |     Total
-----------+----------------------+----------
   Negatif |        42          6 |        48 
   Positif |         3          9 |        12 
-----------+----------------------+----------
     Total |        45         15 |        60 

diagtest res_portnat_mtc composite, m

     Hasil |
Pemeriksaa |
 n PortNAT |       composite
       MTC |        No        Yes |     Total
-----------+----------------------+----------
   Negatif |        42          6 |        48 
   Positif |         3          9 |        12 
-----------+----------------------+----------
     Total |        45         15 |        60 

True D defined as composite ~= 0                      [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  60.00%      47.60%   72.40%
Specificity                     Pr( -|~D)  93.33%      87.02%   99.65%
Positive predictive value       Pr( D| +)  75.00%      64.04%   85.96%
Negative predictive value       Pr(~D| -)  87.50%      79.13%   95.87%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      25.00%      14.04%   35.96%
-------------------------------------------------------------------------

save "D:\EVIDENT WP1 Data\250517_portnat vs composite.dta"

// portnat vs crs //
use "D:\EVIDENT WP1 Data\250517_portnat dataset.dta"

tab res_portnat tb_treat, m

     Hasil |
Pemeriksaa |     Apakah Anda mendapatkan
 n PortNAT |         pengobatan TBC?
       MTC |     Tidak         Ya          . |     Total
-----------+---------------------------------+----------
   Negatif |        14          6         69 |        89 
   Positif |         1          6         10 |        17 
-----------+---------------------------------+----------
     Total |        15         12         79 |       106 

keep if tb_treat~=.
tab res_portnat tb_treat, m
diagtest res_portnat_mtc tb_treat

     Hasil |      Apakah Anda
Pemeriksaa |      mendapatkan
 n PortNAT |    pengobatan TBC?
       MTC |     Tidak         Ya |     Total
-----------+----------------------+----------
   Negatif |        14          6 |        20 
   Positif |         1          6 |         7 
-----------+----------------------+----------
     Total |        15         12 |        27 

True D defined as tb_treat ~= 0                       [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  50.00%      31.14%   68.86%
Specificity                     Pr( -|~D)  93.33%      83.92%   102.74%
Positive predictive value       Pr( D| +)  85.71%      72.52%   98.91%
Negative predictive value       Pr(~D| -)  70.00%      52.71%   87.29%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      44.44%      25.70%   63.19%
-------------------------------------------------------------------------

save "D:\EVIDENT WP1 Data\250517_portnat vs crs.dta"