// P L U S L I F E   T S   1 5 s   A D U L T  //
// analisis maksimum reference standard //

gen tb_status=.
replace tb_status=0 if subjectcat==26 | subjectcat==27 | subjectcat==28
replace tb_status=1 if subjectcat==1 | subjectcat==2 | subjectcat==3 | subjectcat==4 | subjectcat==5 | subjectcat==6
label define negposlab 0 "Negative" 1 "Positive"
label values tb_status negposlab
tab tb_status, m

diagtest res_swab_pluslife tb_status if (tb_status==0 | tb_status==1) & res_swab_pluslife~=3

        Hasil |
  pemeriksaan |
   Usap lidah |       tb_status
     Pluslife |  Negative   Positive |     Total
--------------+----------------------+----------
     Negative |       118         38 |       156 
     Positive |         1         71 |        72 
--------------+----------------------+----------
        Total |       119        109 |       228 

True D defined as tb_status ~= 0                      [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  65.14%      58.95%   71.32%
Specificity                     Pr( -|~D)  99.16%      97.97%   100.34%
Positive predictive value       Pr( D| +)  98.61%      97.09%   100.13%
Negative predictive value       Pr(~D| -)  75.64%      70.07%   81.21%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      47.81%      41.32%   54.29%
-------------------------------------------------------------------------

// analisis maksimum reference standard, sensitivity analysis //

gen tb_status2=.
replace tb_status2=0 if subjectcat==26 | subjectcat==27 | subjectcat==28
replace tb_status2=1 if subjectcat==1 | subjectcat==2 | subjectcat==3 | subjectcat==4 | subjectcat==5 | subjectcat==6 | subjectcat==7 | subjectcat==8 | subjectcat==16 | subjectcat==161 | subjectcat==17
label values tb_status2 negposlab
tab tb_status2, m

diagtest res_swab_pluslife tb_status2 if (tb_status2==0 | tb_status2==1) & res_swab_pluslife~=3

        Hasil |
  pemeriksaan |
   Usap lidah |      tb_status2
     Pluslife |  Negative   Positive |     Total
--------------+----------------------+----------
     Negative |       118         40 |       158 
     Positive |         1         72 |        73 
--------------+----------------------+----------
        Total |       119        112 |       231 

True D defined as tb_status2 ~= 0                     [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  64.29%      58.11%   70.46%
Specificity                     Pr( -|~D)  99.16%      97.98%   100.34%
Positive predictive value       Pr( D| +)  98.63%      97.13%   100.13%
Negative predictive value       Pr(~D| -)  74.68%      69.08%   80.29%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      48.48%      42.04%   54.93%
-------------------------------------------------------------------------

// analisis conservative CRS //
gen tb_status3=.
replace tb_status3=0 if subjectcat==26 | subjectcat==27 | subjectcat==28
replace tb_status3=1 if subjectcat==1 | subjectcat==2 | subjectcat==3 | subjectcat==4 | subjectcat==5 | subjectcat==6 | subjectcat==7 | subjectcat==8 | subjectcat==9 | subjectcat==10 | subjectcat==11 | subjectcat==12 | subjectcat==13 | subjectcat==14 | subjectcat==15  
label values tb_status3 negposlab
tab tb_status3, m

diagtest res_swab_pluslife tb_status3 if (tb_status3==0 | tb_status3==1) & res_swab_pluslife~=3

        Hasil |
  pemeriksaan |
   Usap lidah |      tb_status3
     Pluslife |  Negative   Positive |     Total
--------------+----------------------+----------
     Negative |       118         73 |       191 
     Positive |         1         72 |        73 
--------------+----------------------+----------
        Total |       119        145 |       264 

True D defined as tb_status3 ~= 0                     [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  49.66%      43.62%   55.69%
Specificity                     Pr( -|~D)  99.16%      98.06%   100.26%
Positive predictive value       Pr( D| +)  98.63%      97.23%   100.03%
Negative predictive value       Pr(~D| -)  61.78%      55.92%   67.64%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      54.92%      48.92%   60.93%
-------------------------------------------------------------------------

// analisis less conservative CRS //

gen tb_status4=.
replace tb_status4=0 if subjectcat==26 | subjectcat==27 | subjectcat==28 | subjectcat==29 | subjectcat==30 | subjectcat==31
replace tb_status4=1 if subjectcat==1 | subjectcat==2 | subjectcat==3 | subjectcat==4 | subjectcat==5 | subjectcat==6 | subjectcat==7 | subjectcat==8 | subjectcat==9 | subjectcat==10 | subjectcat==11 | subjectcat==12 | subjectcat==13 | subjectcat==14 | subjectcat==15 | subjectcat==16 | subjectcat==161 | (subjectcat==17 & eptb~=1) 
label values tb_status4 negposlab
tab tb_status4, m

diagtest res_swab_pluslife tb_status4 if (tb_status4==0 | tb_status4==1) & res_swab_pluslife~=3

        Hasil |
  pemeriksaan |
   Usap lidah |      tb_status4
     Pluslife |  Negative   Positive |     Total
--------------+----------------------+----------
     Negative |       120         73 |       193 
     Positive |         1         72 |        73 
--------------+----------------------+----------
        Total |       121        145 |       266 

True D defined as tb_status4 ~= 0                     [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  49.66%      43.65%   55.66%
Specificity                     Pr( -|~D)  99.17%      98.09%   100.26%
Positive predictive value       Pr( D| +)  98.63%      97.23%   100.03%
Negative predictive value       Pr(~D| -)  62.18%      56.35%   68.00%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      54.51%      48.53%   60.50%
-------------------------------------------------------------------------

// P L U S L I F E   T S   3 0 s   A D U L T  //
// analisis maksimum reference standard //

gen tb_status=.
replace tb_status=0 if subjectcat==26 | subjectcat==27 | subjectcat==28
replace tb_status=1 if subjectcat==1 | subjectcat==2 | subjectcat==3 | subjectcat==4 | subjectcat==5 | subjectcat==6
label define negposlab 0 "Negative" 1 "Positive"
label values tb_status negposlab
tab tb_status, m

diagtest res_swab_pluslife tb_status if (tb_status==0 | tb_status==1) & res_swab_pluslife~=3

        Hasil |
  pemeriksaan |
   Usap lidah |       tb_status
     Pluslife |         0          1 |     Total
--------------+----------------------+----------
     Negative |        67          6 |        73 
     Positive |         0         18 |        18 
--------------+----------------------+----------
        Total |        67         24 |        91 

True D defined as tb_status ~= 0                      [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  75.00%      66.10%   83.90%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  91.78%      86.14%   97.42%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      26.37%      17.32%   35.43%
-------------------------------------------------------------------------

// False positive //
browse idsubject diag_tb diag_tb_y tcm_dt dt_swab_pluslife tcm_result semi_quant cxray tb_treat cult_ident if res_swab_pluslife==1 & culture_result2==1

// false negative //
browse idsubject rec_loc tcm_dt dt_swab_pluslife res_swab_pluslife tcm_result semi_quant cxray tb_treat culture_result cult_ident tb_status subjectcat if res_swab_pluslife==0 & tb_status==1

// analisis maksimum reference standard, sensitivity analysis //

gen tb_status2=.
replace tb_status2=0 if subjectcat==26 | subjectcat==27 | subjectcat==28
replace tb_status2=1 if subjectcat==1 | subjectcat==2 | subjectcat==3 | subjectcat==4 | subjectcat==5 | subjectcat==6 | subjectcat==7 | subjectcat==8 | subjectcat==16 | subjectcat==161 | subjectcat==17
label values tb_status2 negposlab
tab tb_status2, m

diagtest res_swab_pluslife tb_status2 if (tb_status2==0 | tb_status2==1) & res_swab_pluslife~=3

        Hasil |
  pemeriksaan |
   Usap lidah |      tb_status2
     Pluslife |         0          1 |     Total
--------------+----------------------+----------
     Negative |        67          7 |        74 
     Positive |         0         19 |        19 
--------------+----------------------+----------
        Total |        67         26 |        93 

True D defined as tb_status2 ~= 0                     [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  73.08%      64.06%   82.09%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  90.54%      84.59%   96.49%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      27.96%      18.84%   37.08%
-------------------------------------------------------------------------

// analisis conservative CRS //
gen tb_status3=.
replace tb_status3=0 if subjectcat==26 | subjectcat==27 | subjectcat==28
replace tb_status3=1 if subjectcat==1 | subjectcat==2 | subjectcat==3 | subjectcat==4 | subjectcat==5 | subjectcat==6 | subjectcat==7 | subjectcat==8 | subjectcat==9 | subjectcat==10 | subjectcat==11 | subjectcat==12 | subjectcat==13 | subjectcat==14 | subjectcat==15  
label values tb_status3 negposlab
tab tb_status3, m

diagtest res_swab_pluslife tb_status3 if (tb_status3==0 | tb_status3==1) & res_swab_pluslife~=3

        Hasil |
  pemeriksaan |
   Usap lidah |      tb_status3
     Pluslife |        No        Yes |     Total
--------------+----------------------+----------
     Negative |        67         24 |        91 
     Positive |         0         20 |        20 
--------------+----------------------+----------
        Total |        67         44 |       111 

True D defined as tb_status3 ~= 0                     [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  45.45%      36.19%   54.72%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  73.63%      65.43%   81.82%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      39.64%      30.54%   48.74%
-------------------------------------------------------------------------

// analisis less conservative CRS //

gen tb_status4=.
replace tb_status4=0 if subjectcat==26 | subjectcat==27 | subjectcat==28 | subjectcat==29 | subjectcat==30 | subjectcat==31
replace tb_status4=1 if subjectcat==1 | subjectcat==2 | subjectcat==3 | subjectcat==4 | subjectcat==5 | subjectcat==6 | subjectcat==7 | subjectcat==8 | subjectcat==9 | subjectcat==10 | subjectcat==11 | subjectcat==12 | subjectcat==13 | subjectcat==14 | subjectcat==15 | subjectcat==16 | subjectcat==161 | (subjectcat==17 & eptb~=1) 
label values tb_status4 negposlab
tab tb_status4, m

diagtest res_swab_pluslife tb_status4 if (tb_status4==0 | tb_status4==1) & res_swab_pluslife~=3

        Hasil |
  pemeriksaan |
   Usap lidah |      tb_status4
     Pluslife |        No        Yes |     Total
--------------+----------------------+----------
     Negative |        69         24 |        93 
     Positive |         0         20 |        20 
--------------+----------------------+----------
        Total |        69         44 |       113 

True D defined as tb_status4 ~= 0                     [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  45.45%      36.27%   54.64%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  74.19%      66.13%   82.26%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      38.94%      29.95%   47.93%
-------------------------------------------------------------------------

// P L U S L I F E   S S   A D U L T //

// analisis maksimum reference standard //

gen tb_status=.
replace tb_status=0 if subjectcat==26 | subjectcat==27 | subjectcat==28
replace tb_status=1 if subjectcat==1 | subjectcat==2 | subjectcat==3 | subjectcat==4 | subjectcat==5 | subjectcat==6
label values tb_status negposlab
tab tb_status, m

diagtest res_sput_pluslife tb_status if (tb_status==0 | tb_status==1) & res_sput_pluslife~=3

        Hasil |
  pemeriksaan |
       Sputum |       tb_status
     Pluslife |  Negative   Positive |     Total
--------------+----------------------+----------
     Negative |       216         30 |       246 
     Positive |         4        105 |       109 
--------------+----------------------+----------
        Total |       220        135 |       355 

True D defined as tb_status ~= 0                      [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  77.78%      73.45%   82.10%
Specificity                     Pr( -|~D)  98.18%      96.79%   99.57%
Positive predictive value       Pr( D| +)  96.33%      94.37%   98.29%
Negative predictive value       Pr(~D| -)  87.80%      84.40%   91.21%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      38.03%      32.98%   43.08%
-------------------------------------------------------------------------

// analisis maksimum reference standard, sensitivity analysis //

gen tb_status2=.
replace tb_status2=0 if subjectcat==26 | subjectcat==27 | subjectcat==28
replace tb_status2=1 if subjectcat==1 | subjectcat==2 | subjectcat==3 | subjectcat==4 | subjectcat==5 | subjectcat==6 | subjectcat==7 | subjectcat==8 | subjectcat==16 | subjectcat==161 | subjectcat==17
label values tb_status2 negposlab
tab tb_status2, m

diagtest res_sput_pluslife tb_status2 if (tb_status2==0 | tb_status2==1) & res_sput_pluslife~=3


        Hasil |
  pemeriksaan |
       Sputum |      tb_status2
     Pluslife |  Negative   Positive |     Total
--------------+----------------------+----------
     Negative |       216         33 |       249 
     Positive |         4        107 |       111 
--------------+----------------------+----------
        Total |       220        140 |       360 

True D defined as tb_status2 ~= 0                     [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  76.43%      72.04%   80.81%
Specificity                     Pr( -|~D)  98.18%      96.80%   99.56%
Positive predictive value       Pr( D| +)  96.40%      94.47%   98.32%
Negative predictive value       Pr(~D| -)  86.75%      83.24%   90.25%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      38.89%      33.85%   43.92%
-------------------------------------------------------------------------

// analisis conservative CRS //
gen tb_status3=.
replace tb_status3=0 if subjectcat==26 | subjectcat==27 | subjectcat==28
replace tb_status3=1 if subjectcat==1 | subjectcat==2 | subjectcat==3 | subjectcat==4 | subjectcat==5 | subjectcat==6 | subjectcat==7 | subjectcat==8 | subjectcat==9 | subjectcat==10 | subjectcat==11 | subjectcat==12 | subjectcat==13 | subjectcat==14 | subjectcat==15  
label values tb_status3 negposlab
tab tb_status3, m

diagtest res_sput_pluslife tb_status3 if (tb_status3==0 | tb_status3==1) & res_sput_pluslife~=3

        Hasil |
  pemeriksaan |
       Sputum |      tb_status3
     Pluslife |  Negative   Positive |     Total
--------------+----------------------+----------
     Negative |       216         88 |       304 
     Positive |         4        108 |       112 
--------------+----------------------+----------
        Total |       220        196 |       416 

True D defined as tb_status3 ~= 0                     [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  55.10%      50.32%   59.88%
Specificity                     Pr( -|~D)  98.18%      96.90%   99.47%
Positive predictive value       Pr( D| +)  96.43%      94.65%   98.21%
Negative predictive value       Pr(~D| -)  71.05%      66.69%   75.41%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      47.12%      42.32%   51.91%
-------------------------------------------------------------------------

// analisis less conservative CRS //

gen tb_status4=.
replace tb_status4=0 if subjectcat==26 | subjectcat==27 | subjectcat==28 | subjectcat==29 | subjectcat==30 | subjectcat==31
replace tb_status4=1 if subjectcat==1 | subjectcat==2 | subjectcat==3 | subjectcat==4 | subjectcat==5 | subjectcat==6 | subjectcat==7 | subjectcat==8 | subjectcat==9 | subjectcat==10 | subjectcat==11 | subjectcat==12 | subjectcat==13 | subjectcat==14 | subjectcat==15 | subjectcat==16 | subjectcat==161 | (subjectcat==17 & eptb~=1) 
label values tb_status4 negposlab
tab tb_status4, m

diagtest res_sput_pluslife tb_status4 if (tb_status4==0 | tb_status4==1) & res_sput_pluslife~=3

        Hasil |
  pemeriksaan |
       Sputum |      tb_status4
     Pluslife |  Negative   Positive |     Total
--------------+----------------------+----------
     Negative |       217         88 |       305 
     Positive |         4        108 |       112 
--------------+----------------------+----------
        Total |       221        196 |       417 

True D defined as tb_status4 ~= 0                     [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  55.10%      50.33%   59.88%
Specificity                     Pr( -|~D)  98.19%      96.91%   99.47%
Positive predictive value       Pr( D| +)  96.43%      94.65%   98.21%
Negative predictive value       Pr(~D| -)  71.15%      66.80%   75.50%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      47.00%      42.21%   51.79%
-------------------------------------------------------------------------


