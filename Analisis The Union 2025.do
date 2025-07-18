// ANALISIS UNTUK THE UNION //

drop if redcap_event_name=="fu_arm_2"
// 17 obs
drop if willing==0
// 46 obs

// eksklusi pasien dgn riwayat TB dalam 2 tahun terakhir //
gen tbhistdur=interv_dt-diag_tb_y
sort tbhistdur
gen tbhist2years=.
replace tbhist2years=1 if tbhistdur<=730
replace tbhist2years=0 if tbhist2years!=1
br idsubject initial age birthdate diag_tb_y interv_dt tbhistdur tbhist2years
sort diag_tb_y interv_dt
replace tbhist2years=1 if idsubject==4100068
tab tbhist2years, m 
// 19 pasien //
drop if tbhist2years==1

//hasil kultur positif (MOTT) harus diubah jadi negatif //
gen culture_result2=999
browse idsubject culture_result cult_ident culture_result2
sort idsubject
tab cult_ident, m
// 20 MOTT //
sort culture_result

//negative
replace culture_result2=0 if culture_result==1
replace culture_result2=0 if culture_result==3 & cult_ident==2

//positive
replace culture_result2=1 if culture_result==3 & cult_ident==1
replace culture_result2=1 if culture_result==3 & cult_ident==.
br culture_result cult_ident culture_result2

label define culture_result2 0 "Negative" 1 "Positive"
label values culture_result2 culture_result2
tab culture_result culture_result2

// KEEP SUBJEK YANG SUDAH ADA HASIL KULTUR //
tab culture_result2, m
// 753 obs
drop if culture_result2==999
// 574 obs

// 1. ANALISIS HASIL PLUSLIFE TONGUE SWAB //
tab res_swab_pluslife culture_result2, m
keep if res_swab_pluslife==0 | res_swab_pluslife==1
// 558 obs

// membagi jadi sampling 15s dan 30s
gen sampling30=.
replace sampling30=0 if interv_dt<td(30jan2025)
replace sampling30=1 if interv_dt>=td(30jan2025)

// performance sampling <30s
diagtest res_swab_pluslife culture_result2 if sampling30==0
diagtest res_swab_pluslife culture_result2 if sampling30==1

tab sex if sampling30==0
tab sex if sampling30==1
summarize age if sampling30==0, d
summarize age if sampling30==1, d

// 2. ANALISIS HASIL XPERT TONGUE SWAB //
gen xpertts=.
replace xpertts=0 if res_xpertultra==0
replace xpertts=1 if res_xpertultra==1 | res_xpertultra==2 | res_xpertultra==3 | res_xpertultra==4 | res_xpertultra==5 | res_xpertultra==6 | res_xpertultra==7 | res_xpertultra==8
label variable xpertts "Hasil pemeriksaan Xpert TS"
label define xperttslab 0 "Negative" 1 "Positive"
label values xpertts xperttslab
tab xpertts, m

tab xpertts culture_result2, m
keep if xpertts==0 | xpertts==1
// 483 obs

// cek sampling 30 detik //
br
sort interv_dt
gen sampling30=999
label define samplinglab 0 "<30s" 1 "30s"
label value sampling30 samplinglab
replace sampling30=0 in 1/457
replace sampling30=1 in 458/483

// performance sampling <30s
diagtest xpertts culture_result2 if sampling30==0
diagtest xpertts culture_result2 if sampling30==1

tab sex if sampling30==0
tab sex if sampling30==1
summarize age if sampling30==0, d
summarize age if sampling30==1, d

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
     Negative |       382         49 |       431 
     Positive |         1         86 |        87 
--------------+----------------------+----------
        Total |       383        135 |       518 

// performance //
diagtest res_swab_pluslife composite if sampling30==0

        Hasil |
  pemeriksaan |
   Usap lidah |       composite
     Pluslife |        No        Yes |     Total
--------------+----------------------+----------
     Negative |       302         47 |       349 
     Positive |         1         69 |        70 
--------------+----------------------+----------
        Total |       303        116 |       419 

True D defined as composite ~= 0                      [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  59.48%      54.78%   64.18%
Specificity                     Pr( -|~D)  99.67%      99.12%   100.22%
Positive predictive value       Pr( D| +)  98.57%      97.44%   99.71%
Negative predictive value       Pr(~D| -)  86.53%      83.26%   89.80%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      27.68%      23.40%   31.97%
-------------------------------------------------------------------------

diagtest res_swab_pluslife composite if sampling30==1
        Hasil |
  pemeriksaan |
   Usap lidah |       composite
     Pluslife |        No        Yes |     Total
--------------+----------------------+----------
     Negative |        80          2 |        82 
     Positive |         0         17 |        17 
--------------+----------------------+----------
        Total |        80         19 |        99 

True D defined as composite ~= 0                      [95% Conf. Inter.]
-------------------------------------------------------------------------
Sensitivity                     Pr( +| D)  89.47%      83.43%   95.52%
Specificity                     Pr( -|~D)  100.00%     100.00%  100.00%
Positive predictive value       Pr( D| +)  100.00%     100.00%  100.00%
Negative predictive value       Pr(~D| -)  97.56%      94.52%   100.60%
-------------------------------------------------------------------------
Prevalence                      Pr(D)      19.19%      11.43%   26.95%
-------------------------------------------------------------------------
