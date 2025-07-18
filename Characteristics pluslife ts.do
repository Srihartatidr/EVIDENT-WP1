use "D:\EVIDENT WP1 Data\250517_WP1 dataset.dta", clear

br

keep if res_swab_pluslife==0 | res_swab_pluslife==1
save as

tab sex
tab agecat, m
tab diag_tb, m
tab dm_status, m
tab hiv_status, m
tab smoke, m

// tabel gradasi nilai pluslife ts compared to semi quantitative //
tab semi_quant res_swab_pluslife if tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4, row
tab tcm_result res_swab_pluslife if tcm_type==1 & tcm_result==0 & res_swab_pluslife~=4, row
tab semi_quant res_swab_pluslife if tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4, col