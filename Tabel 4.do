// Tabel 4 //
// tabel gradasi nilai pluslife ts compared to semi quantitative //
tab semi_quant res_swab_pluslife if tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4 & sampling30==0, row
tab tcm_result res_swab_pluslife if tcm_type==1 & tcm_result==0 & res_swab_pluslife~=4 & sampling30==0, row
tab semi_quant res_swab_pluslife if tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4 & sampling30==0, col

tab semi_quant res_swab_pluslife if tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4 & sampling30==1, row
tab tcm_result res_swab_pluslife if tcm_type==1 & tcm_result==0 & res_swab_pluslife~=4 & sampling30==1, row
tab semi_quant res_swab_pluslife if tcm_type==1 & semi_quant~=0 & res_swab_pluslife~=4 & sampling30==1, col

// tabel gradasi nilai pluslife ss compared to semi quantitative //
tab semi_quant res_sput_pluslife if tcm_type==1 & semi_quant~=0 & res_sput_pluslife~=4, row
tab tcm_result res_sput_pluslife if tcm_type==1 & tcm_result==0 & res_sput_pluslife~=4, row
tab semi_quant res_sput_pluslife if tcm_type==1 & semi_quant~=0 & res_sput_pluslife~=4, col

// tabel gradasi nilai xpert ts compared to semi quantitative //
tab semi_quant xpertts if tcm_type==1 & semi_quant~=0 & sampling30==0, row
tab tcm_result xpertts if tcm_type==1 & tcm_result==0 & sampling30==0, row
tab semi_quant xpertts if tcm_type==1 & semi_quant~=0 & sampling30==0, col

tab semi_quant xpertts if tcm_type==1 & semi_quant~=0 & sampling30==1, row
tab tcm_result xpertts if tcm_type==1 & tcm_result==0 & sampling30==1, row
tab semi_quant xpertts if tcm_type==1 & semi_quant~=0 & sampling30==1, col

// tabel gradasi nilai portnat mtc compared to semi quantitative //
tab semi_quant res_portnat_mtc if tcm_type==1 & semi_quant~=0 & res_portnat_mtc~=4, row
tab tcm_result res_portnat_mtc if tcm_type==1 & tcm_result==0 & res_portnat_mtc~=4, row
tab semi_quant res_portnat_mtc if tcm_type==1 & semi_quant~=0 & res_portnat_mtc~=4, col