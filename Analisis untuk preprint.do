diagtest res_swab_pluslife culture_result2 
diagtest res_swab_pluslife culture_result2 if agecat==2
diagtest res_swab_pluslife tb_treat if agecat==1

diagtest res_swab_pluslife culture_result2 if sampling30==0 & agecat==2
diagtest res_swab_pluslife tb_treat if sampling30==0 & agecat==1

diagtest res_swab_pluslife culture_result2 if sampling30==1 & agecat==2
diagtest res_swab_pluslife tb_treat if sampling30==1 & agecat==1