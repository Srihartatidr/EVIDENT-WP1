// 18 Juli 2025 //
// Data WHO //

// run Data preparation.do //
// run STARD diagram.do //

// P L U S L I F E   T O N G U E   S W A B //
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
	  
//False positive
browse idsubject interv_dt diag_tb diag_tb_y tcm_result semi_quant cxray tb_treat cult_ident rec_loc if res_sput_pluslife==1 & culture_result3==1

//False negative
browse idsubject cxray tcm_result semi_quant culture_result cult_ident cult_ino_dt culture_res_dt res_xpertultra res_swab_pluslife res_truenant_ul res_portnat_mtc bioarchiveplts if res_swab_pluslife==0 & culture_result3==2

// performance IT vs RS (fresh sample) //
diagtest res_swab_pluslife culture_result2 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result2 if agecat15==1
diagtest res_swab_pluslife culture_result2 if agecat15==2
diagtest res_swab_pluslife culture_result2 if hiv_status==1
diagtest res_swab_pluslife culture_result2 if hiv_status==0

diagtest res_swab_pluslife culture_result3 if (culture_result3==0 | culture_result3==1) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if (culture_result3==0 | culture_result3==1) & res_swab_pluslife~=3 & bioplts==0
diagtest res_swab_pluslife culture_result3 if (culture_result3==0 | culture_result3==1) & res_swab_pluslife~=3 & bioplts==1
diagtest res_swab_pluslife culture_result3 if (culture_result3==0 | culture_result3==1) & res_swab_pluslife~=3 & agecat15==1 & bioplts==0
diagtest res_swab_pluslife culture_result3 if (culture_result3==0 | culture_result3==1) & res_swab_pluslife~=3 & agecat15==2 & bioplts==0
diagtest res_swab_pluslife culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioplts==0
diagtest res_swab_pluslife culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioplts==0
diagtest res_swab_pluslife culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioplts==0
diagtest res_swab_pluslife culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioplts==0
diagtest res_swab_pluslife culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioplts==0
diagtest res_swab_pluslife culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioplts==0
diagtest res_swab_pluslife culture_result3 if bioplts==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if bioplts==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
tab res_swab_pluslife hiv_status, m

// missing reference test & fresh sample //
tab culture_result2 res_swab_pluslife if bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==1 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==2 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==3 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==4 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==5 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if hiv_status==1 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if hiv_status==0 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if hiv_status==2 & bioarchive==0, m

tab culture_result3 res_swab_pluslife, m
tab culture_result3 res_swab_pluslife if agecat5==1, m
tab culture_result3 res_swab_pluslife if agecat5==2, m
tab culture_result3 res_swab_pluslife if agecat5==3, m
tab culture_result3 res_swab_pluslife if agecat5==4, m
tab culture_result3 res_swab_pluslife if agecat5==5, m
tab culture_result3 res_swab_pluslife if hiv_status==1, m
tab culture_result3 res_swab_pluslife if hiv_status==0, m
tab culture_result3 res_swab_pluslife if hiv_status==2, m

// performance CT vs RS //
diagtest xpertsputum2 culture_result2
diagtest xpertsputum2 culture_result2 if agecat15==1
diagtest xpertsputum2 culture_result2 if agecat15==2
diagtest xpertsputum2 culture_result2 if hiv_status==1
diagtest xpertsputum2 culture_result2 if hiv_status==0

diagtest xpertsputum2 culture_result3 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchiveplts==0
diagtest xpertsputum2 culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if bioarchiveplts==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if bioarchiveplts==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3

diagtest trace culture_result2
diagtest trace culture_result2 if agecat15==1
diagtest trace culture_result2 if agecat15==2
diagtest trace culture_result2 if hiv_status==1
diagtest trace culture_result2 if hiv_status==0
diagtest trace culture_result2 if hiv_status==2

diagtest trace culture_result3 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if bioarchiveplts==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if bioarchiveplts==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0

// missing comparator test //
tab xpertsputum2 res_swab_pluslife if bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if agecat5==1 & bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if agecat5==2 & bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if agecat5==3 & bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if agecat5==4 & bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if agecat5==5 & bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if hiv_status==1 & bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if hiv_status==0 & bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if hiv_status==2 & bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if bioarchive==1, m

// performance IT vs CT, sample fresh //
diagtest res_swab_pluslife xpertsputum2 if res_swab_pluslife~=3
diagtest res_swab_pluslife xpertsputum2 if res_swab_pluslife~=3 & bioplts==0
diagtest res_swab_pluslife xpertsputum2 if res_swab_pluslife~=3 & bioplts==0 & agecat15==1
diagtest res_swab_pluslife xpertsputum2 if res_swab_pluslife~=3 & bioplts==0 & agecat15==2
diagtest res_swab_pluslife xpertsputum2 if res_swab_pluslife~=3 & bioplts==1
diagtest res_swab_pluslife xpertsputum2 if agecat5==1 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if agecat5==2 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if agecat5==3 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if agecat5==4 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if agecat5==5 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if hiv_status==1 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if hiv_status==0 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if hiv_status==2 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if bioarchive==0 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if bioarchive==1 & res_swab_pluslife~=3 & bioarchive==0

// IT invalid/error //
tab res_swab_pluslife xpertsputum2, m
tab res_swab_pluslife agecat5, m
tab res_swab_pluslife hiv_status, m
tab res_swab_pluslife bioarchiveplts, m

tab res_swab_pluslife xpertsputum2 if agecat5==1, m
tab res_swab_pluslife xpertsputum2 if agecat5==2, m
tab res_swab_pluslife xpertsputum2 if agecat5==3, m
tab res_swab_pluslife xpertsputum2 if agecat5==4, m
tab res_swab_pluslife xpertsputum2 if agecat5==5, m
tab res_swab_pluslife xpertsputum2 if hiv_status==1, m
tab res_swab_pluslife xpertsputum2 if hiv_status==0, m
tab res_swab_pluslife xpertsputum2 if hiv_status==2, m

diagtest res_swab_pluslife culture_result3 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
tab res_swab_pluslife hiv_status, m

// missing reference test //
tab culture_result2 res_swab_pluslife, m
tab culture_result2 res_swab_pluslife if agecat15==1, m
tab culture_result2 res_swab_pluslife if agecat15==2, m
tab culture_result2 res_swab_pluslife if hiv_status==1, m
tab culture_result2 res_swab_pluslife if hiv_status==0, m

tab culture_result3 res_swab_pluslife, m
tab culture_result3 res_swab_pluslife if agecat5==1, m
tab culture_result3 res_swab_pluslife if agecat5==2, m
tab culture_result3 res_swab_pluslife if agecat5==3, m
tab culture_result3 res_swab_pluslife if agecat5==4, m
tab culture_result3 res_swab_pluslife if agecat5==5, m
tab culture_result3 res_swab_pluslife if hiv_status==1, m
tab culture_result3 res_swab_pluslife if hiv_status==0, m
tab culture_result3 res_swab_pluslife if hiv_status==2, m
tab culture_result3 res_swab_pluslife if bioarchive==0, m
tab culture_result3 res_swab_pluslife if bioarchive==1, m

// performance IT vs RS (fresh & bioarchive sample) //
diagtest res_swab_pluslife culture_result2 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result2 if agecat15==1
diagtest res_swab_pluslife culture_result2 if agecat15==2
diagtest res_swab_pluslife culture_result2 if hiv_status==1
diagtest res_swab_pluslife culture_result2 if hiv_status==0

diagtest res_swab_pluslife culture_result3 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 
diagtest res_swab_pluslife culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 
diagtest res_swab_pluslife culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 
diagtest res_swab_pluslife culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 
diagtest res_swab_pluslife culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 
diagtest res_swab_pluslife culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 
diagtest res_swab_pluslife culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 
diagtest res_swab_pluslife culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 
diagtest res_swab_pluslife culture_result3 if bioarchiveplts==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if bioarchiveplts==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
tab res_swab_pluslife hiv_status, m

//False positive
browse idsubject interv_dt diag_tb diag_tb_y tcm_result semi_quant cxray tb_treat cult_ident if res_swab_pluslife==1 & culture_result3==1

//False negative
browse idsubject tcm_result semi_quant culture_result cult_ident cult_ino_dt culture_res_dt res_xpertultra res_swab_pluslife res_truenant_ul res_portnat_mtc bioarchiveplts if res_swab_pluslife==0 & culture_result3==2

// missing reference test //
tab culture_result2 res_swab_pluslife if bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==1 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==2 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==3 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==4 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==5 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if hiv_status==1 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if hiv_status==0 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if hiv_status==2 & bioarchive==0, m

tab culture_result3 res_swab_pluslife, m
tab culture_result3 res_swab_pluslife if agecat5==1, m
tab culture_result3 res_swab_pluslife if agecat5==2, m
tab culture_result3 res_swab_pluslife if agecat5==3, m
tab culture_result3 res_swab_pluslife if agecat5==4, m
tab culture_result3 res_swab_pluslife if agecat5==5, m
tab culture_result3 res_swab_pluslife if hiv_status==1, m
tab culture_result3 res_swab_pluslife if hiv_status==0, m
tab culture_result3 res_swab_pluslife if hiv_status==2, m

// performance CT vs RS //
diagtest xpertsputum2 culture_result2
diagtest xpertsputum2 culture_result2 if agecat15==1
diagtest xpertsputum2 culture_result2 if agecat15==2
diagtest xpertsputum2 culture_result2 if hiv_status==1
diagtest xpertsputum2 culture_result2 if hiv_status==0

diagtest xpertsputum2 culture_result3 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if bioarchiveplts==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if bioarchiveplts==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3

diagtest trace culture_result2
diagtest trace culture_result2 if agecat15==1
diagtest trace culture_result2 if agecat15==2
diagtest trace culture_result2 if hiv_status==1
diagtest trace culture_result2 if hiv_status==0
diagtest trace culture_result2 if hiv_status==2

diagtest trace culture_result3 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if bioarchiveplts==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if bioarchiveplts==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0

// missing comparator test //
tab xpertsputum2 res_swab_pluslife, m
tab xpertsputum2 res_swab_pluslife if agecat5==1, m
tab xpertsputum2 res_swab_pluslife if agecat5==2, m
tab xpertsputum2 res_swab_pluslife if agecat5==3, m
tab xpertsputum2 res_swab_pluslife if agecat5==4, m
tab xpertsputum2 res_swab_pluslife if agecat5==5, m
tab xpertsputum2 res_swab_pluslife if hiv_status==1, m
tab xpertsputum2 res_swab_pluslife if hiv_status==0, m
tab xpertsputum2 res_swab_pluslife if hiv_status==2, m
tab xpertsputum2 res_swab_pluslife if bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if bioarchive==1, m

// performance IT vs CT //
diagtest res_swab_pluslife xpertsputum2 if res_swab_pluslife~=3
diagtest res_swab_pluslife xpertsputum2 if agecat5==1 & res_swab_pluslife~=3 
diagtest res_swab_pluslife xpertsputum2 if agecat5==2 & res_swab_pluslife~=3 
diagtest res_swab_pluslife xpertsputum2 if agecat5==3 & res_swab_pluslife~=3 
diagtest res_swab_pluslife xpertsputum2 if agecat5==4 & res_swab_pluslife~=3 
diagtest res_swab_pluslife xpertsputum2 if agecat5==5 & res_swab_pluslife~=3 
diagtest res_swab_pluslife xpertsputum2 if hiv_status==1 & res_swab_pluslife~=3
diagtest res_swab_pluslife xpertsputum2 if hiv_status==0 & res_swab_pluslife~=3 
diagtest res_swab_pluslife xpertsputum2 if hiv_status==2 & res_swab_pluslife~=3 
diagtest res_swab_pluslife xpertsputum2 if bioarchive==0 & res_swab_pluslife~=3 
diagtest res_swab_pluslife xpertsputum2 if bioarchive==1 & res_swab_pluslife~=3 

// IT invalid/error //
tab res_swab_pluslife xpertsputum2, m
tab res_swab_pluslife agecat5, m
tab res_swab_pluslife hiv_status, m
tab res_swab_pluslife bioarchiveplts, m

tab res_swab_pluslife xpertsputum2 if agecat5==1, m
tab res_swab_pluslife xpertsputum2 if agecat5==2, m
tab res_swab_pluslife xpertsputum2 if agecat5==3, m
tab res_swab_pluslife xpertsputum2 if agecat5==4, m
tab res_swab_pluslife xpertsputum2 if agecat5==5, m
tab res_swab_pluslife xpertsputum2 if hiv_status==1, m
tab res_swab_pluslife xpertsputum2 if hiv_status==0, m
tab res_swab_pluslife xpertsputum2 if hiv_status==2, m

diagtest res_swab_pluslife culture_result3 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
tab res_swab_pluslife hiv_status, m

// missing reference test //
tab culture_result2 res_swab_pluslife, m
tab culture_result2 res_swab_pluslife if agecat15==1, m
tab culture_result2 res_swab_pluslife if agecat15==2, m
tab culture_result2 res_swab_pluslife if hiv_status==1, m
tab culture_result2 res_swab_pluslife if hiv_status==0, m

tab culture_result3 res_swab_pluslife, m
tab culture_result3 res_swab_pluslife if agecat5==1, m
tab culture_result3 res_swab_pluslife if agecat5==2, m
tab culture_result3 res_swab_pluslife if agecat5==3, m
tab culture_result3 res_swab_pluslife if agecat5==4, m
tab culture_result3 res_swab_pluslife if agecat5==5, m
tab culture_result3 res_swab_pluslife if hiv_status==1, m
tab culture_result3 res_swab_pluslife if hiv_status==0, m
tab culture_result3 res_swab_pluslife if hiv_status==2, m
tab culture_result3 res_swab_pluslife if bioarchive==0, m
tab culture_result3 res_swab_pluslife if bioarchive==1, m

// Pluslife sputum swab //
keep if res_sput_pluslife==0 | res_sput_pluslife==1 | res_sput_pluslife==3

//dropping contamination
drop if idsubject==4100167
drop if idsubject==4100163
drop if idsubject==4100162
drop if idsubject==4100170
drop if idsubject==4100169
drop if idsubject==4100168
drop if idsubject==4100166
// 668 obs //

// performance vs culture //
diagtest res_sput_pluslife culture_result2
diagtest res_sput_pluslife culture_result2 if agecat5==1
diagtest res_sput_pluslife culture_result2 if agecat5==2
diagtest res_sput_pluslife culture_result2 if agecat5==3
diagtest res_sput_pluslife culture_result2 if agecat5==4
diagtest res_sput_pluslife culture_result2 if agecat5==5
diagtest res_sput_pluslife culture_result2 if hiv_status==0
diagtest res_sput_pluslife culture_result2 if hiv_status==1

diagtest res_sput_pluslife culture_result3 if (culture_result3==0 | culture_result3==1) & res_sput_pluslife~=3
diagtest res_sput_pluslife culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest res_sput_pluslife culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest res_sput_pluslife culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest res_sput_pluslife culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest res_sput_pluslife culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest res_sput_pluslife culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest res_sput_pluslife culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest res_sput_pluslife culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3

// missing reference test //
tab culture_result2 res_sput_pluslife, m
tab culture_result2 res_sput_pluslife if agecat15==1, m
tab culture_result2 res_sput_pluslife if agecat15==2, m
tab culture_result2 res_sput_pluslife if hiv_status==0, m
tab culture_result2 res_sput_pluslife if hiv_status==1, m
tab culture_result2 res_sput_pluslife if hiv_status==2, m

tab culture_result3 res_sput_pluslife, m
tab culture_result3 res_sput_pluslife if agecat5==1, m
tab culture_result3 res_sput_pluslife if agecat5==2, m
tab culture_result3 res_sput_pluslife if agecat5==3, m
tab culture_result3 res_sput_pluslife if agecat5==4, m
tab culture_result3 res_sput_pluslife if agecat5==5, m
tab culture_result3 res_sput_pluslife if hiv_status==0, m
tab culture_result3 res_sput_pluslife if hiv_status==1, m
tab culture_result3 res_sput_pluslife if hiv_status==2, m

// comparator //
diagtest xpertsputum2 culture_result2
diagtest xpertsputum2 culture_result2 if agecat15==1
diagtest xpertsputum2 culture_result2 if agecat15==2
diagtest xpertsputum2 culture_result2 if hiv_status==0
diagtest xpertsputum2 culture_result2 if hiv_status==1

diagtest xpertsputum2 culture_result3 if (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest xpertsputum2 culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest xpertsputum2 culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest xpertsputum2 culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest xpertsputum2 culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest xpertsputum2 culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest xpertsputum2 culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest xpertsputum2 culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3
diagtest xpertsputum2 culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_sput_pluslife~=3

diagtest trace culture_result2
diagtest trace culture_result2 if agecat15==1
diagtest trace culture_result2 if agecat15==2
diagtest trace culture_result2 if hiv_status==0
diagtest trace culture_result2 if hiv_status==1

diagtest trace culture_result3
diagtest trace culture_result3 if agecat5==1
diagtest trace culture_result3 if agecat5==2
diagtest trace culture_result3 if agecat5==3
diagtest trace culture_result3 if agecat5==4
diagtest trace culture_result3 if agecat5==5
diagtest trace culture_result3 if hiv_status==0
diagtest trace culture_result3 if hiv_status==1
diagtest trace culture_result3 if hiv_status==2

// IT vs CT //
diagtest res_sput_pluslife xpertsputum2
tab res_sput_pluslife xpertsputum2 if agecat5==1
tab res_sput_pluslife xpertsputum2 if agecat5==2
tab res_sput_pluslife xpertsputum2 if agecat5==3
tab res_sput_pluslife xpertsputum2 if agecat5==4
tab res_sput_pluslife xpertsputum2 if agecat5==5
tab res_sput_pluslife xpertsputum2 if hiv_status==1
tab res_sput_pluslife xpertsputum2 if hiv_status==0
tab res_sput_pluslife xpertsputum2 if hiv_status==2

// missing comparator test //
tab xpertsputum res_sput_pluslife, m
tab xpertsputum res_sput_pluslife if agecat15==1, m
tab xpertsputum res_sput_pluslife if agecat15==2, m
tab xpertsputum res_sput_pluslife if hiv_status==0, m
tab xpertsputum res_sput_pluslife if hiv_status==1, m

tab xpertsputum2 res_sput_pluslife, m
tab xpertsputum2 res_sput_pluslife if agecat15==1, m
tab xpertsputum2 res_sput_pluslife if agecat15==2, m
tab xpertsputum2 res_sput_pluslife if hiv_status==0, m
tab xpertsputum2 res_sput_pluslife if hiv_status==1, m
tab xpertsputum2 res_sput_pluslife if hiv_status==2, m

// P L U S L I F E   T O N G U E   S W A B //
br

//dropping sampel yang samplingnya kurang dari 15 detik!!
drop if idsubject==4100466
drop if idsubject==4100467
drop if idsubject==4100717
drop if idsubject==4100718

// dropping early exclusion //
drop if idsubject==4100074 | idsubject==4100689 | idsubject==4100974 | idsubject==4100455

keep if res_swab_pluslife==0 | res_swab_pluslife==1 | res_swab_pluslife==3
// 831 //

save "D:\EVIDENT WP1 Data\250729_pl ts.dta"

tab sampling30, m
	  
	   sampling30 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |        446       53.67       53.67
          1 |        385       46.33      100.00
------------+-----------------------------------
      Total |        831      100.00

keep if sampling30==0
save as "D:\EVIDENT WP1 Data\250729_pl ts 15s.dta"

keep if sampling30==1 
save as "D:\EVIDENT WP1 Data\250729_pl ts 30s.dta"

tab agecat15, m
	  
   agecat15 |      Freq.     Percent        Cum.
------------+-----------------------------------
       0-14 |        138       35.84       35.84
        15+ |        247       64.16      100.00
------------+-----------------------------------
      Total |        385      100.00

tab bioarchiveplts, m

bioarchivep |
        lts |      Freq.     Percent        Cum.
------------+-----------------------------------
      Fresh |        240       62.34       62.34
 Bioarchive |        145       37.66      100.00
------------+-----------------------------------
      Total |        385      100.00

tab bioarchiveplts agecat15, m	 

bioarchive |       agecat15
      plts |      0-14        15+ |     Total
-----------+----------------------+----------
     Fresh |       119        121 |       240 
Bioarchive |        19        126 |       145 
-----------+----------------------+----------
     Total |       138        247 |       385 
	  
//False positive
browse idsubject interv_dt diag_tb diag_tb_y tcm_result semi_quant cxray tb_treat cult_ident if res_sput_pluslife==1 & culture_result3==1

//False negative
browse idsubject tcm_result semi_quant culture_result cult_ident cult_ino_dt culture_res_dt res_xpertultra res_swab_pluslife res_truenant_ul res_portnat_mtc bioarchiveplts if res_swab_pluslife==0 & culture_result3==2

// performance IT vs RS (fresh sample) //
diagtest res_swab_pluslife culture_result2 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result2 if agecat15==1
diagtest res_swab_pluslife culture_result2 if agecat15==2
diagtest res_swab_pluslife culture_result2 if hiv_status==1
diagtest res_swab_pluslife culture_result2 if hiv_status==0

diagtest res_swab_pluslife culture_result3 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife culture_result3 if bioarchiveplts==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if bioarchiveplts==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
tab res_swab_pluslife hiv_status, m

// missing reference test & fresh sample //
tab culture_result2 res_swab_pluslife if bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==1 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==2 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==3 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==4 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==5 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if hiv_status==1 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if hiv_status==0 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if hiv_status==2 & bioarchive==0, m

tab culture_result3 res_swab_pluslife, m
tab culture_result3 res_swab_pluslife if agecat5==1, m
tab culture_result3 res_swab_pluslife if agecat5==2, m
tab culture_result3 res_swab_pluslife if agecat5==3, m
tab culture_result3 res_swab_pluslife if agecat5==4, m
tab culture_result3 res_swab_pluslife if agecat5==5, m
tab culture_result3 res_swab_pluslife if hiv_status==1, m
tab culture_result3 res_swab_pluslife if hiv_status==0, m
tab culture_result3 res_swab_pluslife if hiv_status==2, m

// performance CT vs RS //
diagtest xpertsputum2 culture_result2
diagtest xpertsputum2 culture_result2 if agecat15==1
diagtest xpertsputum2 culture_result2 if agecat15==2
diagtest xpertsputum2 culture_result2 if hiv_status==1
diagtest xpertsputum2 culture_result2 if hiv_status==0

diagtest xpertsputum2 culture_result3 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if bioarchiveplts==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest xpertsputum2 culture_result3 if bioarchiveplts==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3

diagtest trace culture_result2
diagtest trace culture_result2 if agecat15==1
diagtest trace culture_result2 if agecat15==2
diagtest trace culture_result2 if hiv_status==1
diagtest trace culture_result2 if hiv_status==0
diagtest trace culture_result2 if hiv_status==2

diagtest trace culture_result3 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if bioarchiveplts==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if bioarchiveplts==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0

// missing comparator test //
tab xpertsputum2 res_swab_pluslife if bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if agecat5==1 & bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if agecat5==2 & bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if agecat5==3 & bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if agecat5==4 & bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if agecat5==5 & bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if hiv_status==1 & bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if hiv_status==0 & bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if hiv_status==2 & bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if bioarchive==1, m

// performance IT vs CT, sample fresh //
diagtest res_swab_pluslife xpertsputum2 if res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if agecat5==1 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if agecat5==2 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if agecat5==3 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if agecat5==4 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if agecat5==5 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if hiv_status==1 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if hiv_status==0 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if hiv_status==2 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if bioarchive==0 & res_swab_pluslife~=3 & bioarchive==0
diagtest res_swab_pluslife xpertsputum2 if bioarchive==1 & res_swab_pluslife~=3 & bioarchive==0

// IT invalid/error //
tab res_swab_pluslife xpertsputum2, m
tab res_swab_pluslife agecat5, m
tab res_swab_pluslife hiv_status, m
tab res_swab_pluslife bioarchiveplts, m

tab res_swab_pluslife xpertsputum2 if agecat5==1, m
tab res_swab_pluslife xpertsputum2 if agecat5==2, m
tab res_swab_pluslife xpertsputum2 if agecat5==3, m
tab res_swab_pluslife xpertsputum2 if agecat5==4, m
tab res_swab_pluslife xpertsputum2 if agecat5==5, m
tab res_swab_pluslife xpertsputum2 if hiv_status==1, m
tab res_swab_pluslife xpertsputum2 if hiv_status==0, m
tab res_swab_pluslife xpertsputum2 if hiv_status==2, m

diagtest res_swab_pluslife culture_result3 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
tab res_swab_pluslife hiv_status, m

// missing reference test //
tab culture_result2 res_swab_pluslife, m
tab culture_result2 res_swab_pluslife if agecat15==1, m
tab culture_result2 res_swab_pluslife if agecat15==2, m
tab culture_result2 res_swab_pluslife if hiv_status==1, m
tab culture_result2 res_swab_pluslife if hiv_status==0, m

tab culture_result3 res_swab_pluslife, m
tab culture_result3 res_swab_pluslife if agecat5==1, m
tab culture_result3 res_swab_pluslife if agecat5==2, m
tab culture_result3 res_swab_pluslife if agecat5==3, m
tab culture_result3 res_swab_pluslife if agecat5==4, m
tab culture_result3 res_swab_pluslife if agecat5==5, m
tab culture_result3 res_swab_pluslife if hiv_status==1, m
tab culture_result3 res_swab_pluslife if hiv_status==0, m
tab culture_result3 res_swab_pluslife if hiv_status==2, m
tab culture_result3 res_swab_pluslife if bioarchive==0, m
tab culture_result3 res_swab_pluslife if bioarchive==1, m

// performance IT vs RS (fresh & bioarchive sample) //
diagtest res_swab_pluslife culture_result2 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result2 if agecat15==1
diagtest res_swab_pluslife culture_result2 if agecat15==2
diagtest res_swab_pluslife culture_result2 if hiv_status==1
diagtest res_swab_pluslife culture_result2 if hiv_status==0

diagtest res_swab_pluslife culture_result3 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 
diagtest res_swab_pluslife culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 
diagtest res_swab_pluslife culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 
diagtest res_swab_pluslife culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 
diagtest res_swab_pluslife culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 
diagtest res_swab_pluslife culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 
diagtest res_swab_pluslife culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 
diagtest res_swab_pluslife culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 
diagtest res_swab_pluslife culture_result3 if bioarchiveplts==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if bioarchiveplts==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
tab res_swab_pluslife hiv_status, m

// missing reference test //
tab culture_result2 res_swab_pluslife if bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==1 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==2 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==3 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==4 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if agecat5==5 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if hiv_status==1 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if hiv_status==0 & bioarchive==0, m
tab culture_result2 res_swab_pluslife if hiv_status==2 & bioarchive==0, m

tab culture_result3 res_swab_pluslife, m
tab culture_result3 res_swab_pluslife if agecat5==1, m
tab culture_result3 res_swab_pluslife if agecat5==2, m
tab culture_result3 res_swab_pluslife if agecat5==3, m
tab culture_result3 res_swab_pluslife if agecat5==4, m
tab culture_result3 res_swab_pluslife if agecat5==5, m
tab culture_result3 res_swab_pluslife if hiv_status==1, m
tab culture_result3 res_swab_pluslife if hiv_status==0, m
tab culture_result3 res_swab_pluslife if hiv_status==2, m

// performance CT vs RS //
diagtest xpertsputum2 culture_result2
diagtest xpertsputum2 culture_result2 if agecat15==1
diagtest xpertsputum2 culture_result2 if agecat15==2
diagtest xpertsputum2 culture_result2 if hiv_status==1
diagtest xpertsputum2 culture_result2 if hiv_status==0

diagtest xpertsputum2 culture_result3 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if bioarchiveplts==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest xpertsputum2 culture_result3 if bioarchiveplts==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3

diagtest trace culture_result2
diagtest trace culture_result2 if agecat15==1
diagtest trace culture_result2 if agecat15==2
diagtest trace culture_result2 if hiv_status==1
diagtest trace culture_result2 if hiv_status==0
diagtest trace culture_result2 if hiv_status==2

diagtest trace culture_result3 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if bioarchiveplts==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0
diagtest trace culture_result3 if bioarchiveplts==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3 & bioarchive==0

// missing comparator test //
tab xpertsputum2 res_swab_pluslife, m
tab xpertsputum2 res_swab_pluslife if agecat5==1, m
tab xpertsputum2 res_swab_pluslife if agecat5==2, m
tab xpertsputum2 res_swab_pluslife if agecat5==3, m
tab xpertsputum2 res_swab_pluslife if agecat5==4, m
tab xpertsputum2 res_swab_pluslife if agecat5==5, m
tab xpertsputum2 res_swab_pluslife if hiv_status==1, m
tab xpertsputum2 res_swab_pluslife if hiv_status==0, m
tab xpertsputum2 res_swab_pluslife if hiv_status==2, m
tab xpertsputum2 res_swab_pluslife if bioarchive==0, m
tab xpertsputum2 res_swab_pluslife if bioarchive==1, m

// performance IT vs CT //
diagtest res_swab_pluslife xpertsputum2 if res_swab_pluslife~=3
diagtest res_swab_pluslife xpertsputum2 if agecat5==1 & res_swab_pluslife~=3 
diagtest res_swab_pluslife xpertsputum2 if agecat5==2 & res_swab_pluslife~=3 
diagtest res_swab_pluslife xpertsputum2 if agecat5==3 & res_swab_pluslife~=3 
diagtest res_swab_pluslife xpertsputum2 if agecat5==4 & res_swab_pluslife~=3 
diagtest res_swab_pluslife xpertsputum2 if agecat5==5 & res_swab_pluslife~=3 
diagtest res_swab_pluslife xpertsputum2 if hiv_status==1 & res_swab_pluslife~=3
diagtest res_swab_pluslife xpertsputum2 if hiv_status==0 & res_swab_pluslife~=3 
diagtest res_swab_pluslife xpertsputum2 if hiv_status==2 & res_swab_pluslife~=3 
diagtest res_swab_pluslife xpertsputum2 if bioarchive==0 & res_swab_pluslife~=3 
diagtest res_swab_pluslife xpertsputum2 if bioarchive==1 & res_swab_pluslife~=3 

// IT invalid/error //
tab res_swab_pluslife xpertsputum2, m
tab res_swab_pluslife agecat5, m
tab res_swab_pluslife hiv_status, m
tab res_swab_pluslife bioarchiveplts, m

tab res_swab_pluslife xpertsputum2 if agecat5==1, m
tab res_swab_pluslife xpertsputum2 if agecat5==2, m
tab res_swab_pluslife xpertsputum2 if agecat5==3, m
tab res_swab_pluslife xpertsputum2 if agecat5==4, m
tab res_swab_pluslife xpertsputum2 if agecat5==5, m
tab res_swab_pluslife xpertsputum2 if hiv_status==1, m
tab res_swab_pluslife xpertsputum2 if hiv_status==0, m
tab res_swab_pluslife xpertsputum2 if hiv_status==2, m

diagtest res_swab_pluslife culture_result3 if (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==3 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==4 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if agecat5==5 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if hiv_status==1 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if hiv_status==0 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result3 if hiv_status==2 & (culture_result3==1 | culture_result3==2) & res_swab_pluslife~=3
tab res_swab_pluslife hiv_status, m

// missing reference test //
tab culture_result2 res_swab_pluslife, m
tab culture_result2 res_swab_pluslife if agecat15==1, m
tab culture_result2 res_swab_pluslife if agecat15==2, m
tab culture_result2 res_swab_pluslife if hiv_status==1, m
tab culture_result2 res_swab_pluslife if hiv_status==0, m

tab culture_result3 res_swab_pluslife, m
tab culture_result3 res_swab_pluslife if agecat5==1, m
tab culture_result3 res_swab_pluslife if agecat5==2, m
tab culture_result3 res_swab_pluslife if agecat5==3, m
tab culture_result3 res_swab_pluslife if agecat5==4, m
tab culture_result3 res_swab_pluslife if agecat5==5, m
tab culture_result3 res_swab_pluslife if hiv_status==1, m
tab culture_result3 res_swab_pluslife if hiv_status==0, m
tab culture_result3 res_swab_pluslife if hiv_status==2, m
tab culture_result3 res_swab_pluslife if bioarchive==0, m
tab culture_result3 res_swab_pluslife if bioarchive==1, m
