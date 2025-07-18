//Fujilam urine
clear
use "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250115 WP1-culture complete data.dta"
browse
//345 obs
sort dt_fujilam
browse dt_fujilam

tab res_fujilam culture_result2

  Hasil |
  pemeriksaan |    culture_result2
 Urin FujiLAM |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       207         37 |       244 
     Positive |         9         25 |        34 
Indeterminate |         1          0 |         1 
Error/Invalid |         1          0 |         1 
--------------+----------------------+----------
        Total |       218         62 |       280

sort dt_fujilam
browse res_fujilam dt_fujilam
drop if res_fujilam==2 | res_fujilam==3 | res_fujilam==.
save "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250315 WP1-fujilam urine.dta"
//288 obs

//Characteristics
tab sex, m
summarize age, d
tab agecat, m
tab diag_tb, m
tab dm_status, m
tab hiv_status, m
tab smoke, m

// tabel gradasi nilai pluslife ss compared to semi quantitative //
tab semi_quant res_fujilam if tcm_type==1 & semi_quant~=0, row
tab tcm_result res_fujilam if tcm_type==1 & tcm_result==0, row
tab semi_quant res_fujilam if tcm_type==1 & semi_quant~=0, col

diagtest res_fujilam culture_result2
tab res_fujilam tb_treat if hiv_status==1, m

//False positive
browse idsubject diag_tb diag_tb_y tcm_result semi_quant cxray tb_treat cult_ident if res_fujilam==1 & culture_result2==1

//no date difference between TS and sputum collection

//False negative
sort rec_loc
browse idsubject rec_loc diag_tb diag_tb_y tcm_result semi_quant res_fujilam culture_result2 tcm_dt dt_fujilam cult_ident if res_fujilam==0 & culture_result2==2
sort tcm_result
sort semi_quant

//Alerelam urine
clear
use "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250115 WP1-culture complete data.dta"
browse

tab res_alerelam culture_result2

        Hasil |
  pemeriksaan |    culture_result2
Urin AlereLAM |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       116         33 |       149 
     Positive |        30         12 |        42 
     Not Done |        29         20 |        49 
--------------+----------------------+----------
        Total |       175         65 |       240 

sort dt_alerelam
browse res_alerelam dt_alerelam
keep if res_alerelam==0 | res_alerelam==1
// 191 obs
save

//Characteristics
tab sex, m
summarize age, d
tab agecat, m
tab diag_tb, m
tab dm_status, m
tab hiv_status, m
tab smoke, m

diagtest res_alerelam culture_result2
tab res_alerelam tb_treat if hiv_status==1, m

tab res_fujilam res_alerelam if res_alerelam==0 | res_alerelam==1
kap res_fujilam res_alerelam
cii proportions 95 65