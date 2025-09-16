// Monthly check-in //

// Run weekly report.do //
// Run data preparation.do //
// Run 

*membagi pasien menjadi 2 kategori umur (cutoff 15 tahun)
generate agecat15=.
replace agecat15=1 if age<15
replace agecat15=2 if age>=15
tab agecat15, m

*membagi pasien menjadi 5 kategori umur 
generate agecat5=.
replace agecat5=1 if age<12
replace agecat5=2 if (age>=12 & age<18)
replace agecat5=3 if (age>=18 & age<35)
replace agecat5=4 if (age>=35 & age<65)
replace agecat5=5 if (age>=65 & age<.)
codebook agecat5

// characteristics based on recruitment sites //
tab sex recloc, m col
summarize age, d
summarize age if recloc==1, d
summarize age if recloc==2, d
summarize age if recloc==3, d
tab dm_status recloc, m col
tab hiv_status recloc if hiv_status~=2 & hiv_status~=999, m col
list idsubject age initial rec_loc hiv hiv_tes if hiv==1 | hiv_test==1

br idsubject interv_dt initial rec_loc age sputum1 sputum2 tcm_result note_ if tcm_result==.
sort interv_dt

tab xpertsputum1 recloc, m col
tab tcm_result recloc, m col
tab semi_quant recloc if semi_quant~=0, col
tab culture_result recloc, m col
tab culture_result recloc if culture_result~=0 & culture_result~=5, col
tab cult_ident, m
tab culture_result agecat15, m col
sort interv_dt
br idsubject age interv_dt sputum1_c if culture_result==.

// P L U S L I F E   T O N G U E   S W A B //
// diagnostic accuracy vs culture //
br

//dropping sampel yang samplingnya kurang dari 15 detik!!
drop if idsubject==4100466
drop if idsubject==4100467
drop if idsubject==4100717
drop if idsubject==4100718

// dropping early exclusion //
drop if idsubject==4100074 | idsubject==4100689 | idsubject==4100974 | idsubject==4100455

keep if res_swab_pluslife==0 | res_swab_pluslife==1 | res_swab_pluslife==3
// 923 //

save "D:\EVIDENT WP1 Data\250729_pl ts.dta"

tab sampling30, m
	  
 sampling30 |      Freq.     Percent        Cum.
------------+-----------------------------------
       15-s |        447       48.53       48.53
       30-s |        474       51.47      100.00
------------+-----------------------------------
      Total |        921      100.00

keep if sampling30==0
save as "D:\EVIDENT WP1 Data\250729_pl ts 15s.dta"

keep if sampling30==1 
save as "D:\EVIDENT WP1 Data\250729_pl ts 30s.dta"

tab agecat15, m
	  
       agecat15 |      Freq.     Percent        Cum.
----------------+-----------------------------------
Usia 0-14 tahun |        187       39.45       39.45
 Usia 15+ tahun |        287       60.55      100.00
----------------+-----------------------------------
          Total |        474      100.00

tab bioplts, m

    bioplts |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        272       57.38       57.38
          1 |        202       42.62      100.00
------------+-----------------------------------
      Total |        474      100.00

tab bioplts agecat15, m	 

           |       agecat15
   bioplts | Usia 0-14  Usia 15+  |     Total
-----------+----------------------+----------
         0 |       133        139 |       272 
         1 |        54        148 |       202 
-----------+----------------------+----------
     Total |       187        287 |       474 
	  
// diagnostic accuracy vs culture //
diagtest res_swab_pluslife culture_result3 if (culture_result3==0 | culture_result3==1) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if (culture_result3==0 | culture_result3==1) & res_swab_pluslife~=3 & bioplts==0
diagtest res_swab_pluslife culture_result3 if (culture_result3==0 | culture_result3==1) & res_swab_pluslife~=3 & agecat15==1 & bioplts==0
diagtest res_swab_pluslife culture_result3 if (culture_result3==0 | culture_result3==1) & res_swab_pluslife~=3 & agecat15==2 & bioplts==0
diagtest res_swab_pluslife culture_result3 if (culture_result3==0 | culture_result3==1) & res_swab_pluslife~=3 & bioplts==1

//False positive
browse idsubject interv_dt diag_tb diag_tb_y tcm_result semi_quant cxray tb_treat cult_ident rec_loc if res_sput_pluslife==1 & culture_result3==1

//False negative
browse idsubject cxray tcm_result semi_quant culture_result cult_ident cult_ino_dt culture_res_dt res_xpertultra res_swab_pluslife res_truenant_ul res_portnat_mtc bioarchiveplts if res_swab_pluslife==0 & culture_result3==2

// diagnostic accuracy vs xpert sputum (excluding trace) //
diagtest res_swab_pluslife xpertsputum2 if res_swab_pluslife~=3
diagtest res_swab_pluslife xpertsputum2 if res_swab_pluslife~=3 & bioplts==0
diagtest res_swab_pluslife xpertsputum2 if agecat15==1 & res_swab_pluslife~=3 & bioplts==0
diagtest res_swab_pluslife xpertsputum2 if agecat15==2 & res_swab_pluslife~=3 & bioplts==0
diagtest res_swab_pluslife xpertsputum2 if bioplts==1 & res_swab_pluslife~=3

//False positive
browse idsubject interv_dt diag_tb diag_tb_y tcm_result semi_quant cxray tb_treat cult_ident bioarchiveplts if res_swab_pluslife==1 & culture_result3==1

// tabel gradasi nilai pluslife ts compared to semi quantitative //
// 15s //
tab semi_quant res_swab_pluslife if tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4 & sampling30==0, row
tab tcm_result res_swab_pluslife if tcm_type==1 & tcm_result==0 & res_swab_pluslife~=4 & sampling30==0, row
tab semi_quant res_swab_pluslife if tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4 & sampling30==0, col

// 30s //
tab semi_quant res_swab_pluslife if tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4 & sampling30==1, row
tab tcm_result res_swab_pluslife if tcm_type==1 & tcm_result==0 & res_swab_pluslife~=4 & res_swab_pluslife~=3 & sampling30==1, row
tab semi_quant res_swab_pluslife if tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4 & sampling30==1, col



// P L U S L i F E  S P U T U M  S W A B //
// diagnostic accuracy vs culture //
diagtest res_sput_pluslife culture_result3 if (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest res_sput_pluslife culture_result3 if agecat15==1 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest res_sput_pluslife culture_result3 if agecat15==2 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3

// diagnostic accuracy vs xpert sputum (excluding trace) //
diagtest res_sput_pluslife xpertsputum2 if res_sput_pluslife~=3
diagtest res_sput_pluslife xpertsputum2 if agecat15==1 & res_sput_pluslife~=3
diagtest res_sput_pluslife xpertsputum2 if agecat15==2 & res_sput_pluslife~=3

//False positive
browse idsubject interv_dt tcm_result semi_quant cxray tb_treat cult_ident if res_sput_pluslife==1 & culture_result3==1

tab res_sput_pluslife2 xpertsputum2 if res_sput_pluslife2~=999
kap res_sput_pluslife2 xpertsputum2 if res_sput_pluslife2~=999