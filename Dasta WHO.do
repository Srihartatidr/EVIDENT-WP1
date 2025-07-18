// data WHO

diagtest res_swab_pluslife culture_result2 if culture_result2~=999 & res_swab_pluslife~=3
diagtest res_swab_pluslife culture_result2 if culture_result2~=999 & res_swab_pluslife~=3 & agecat15==1
diagtest res_swab_pluslife culture_result2 if culture_result2~=999 & res_swab_pluslife~=3 & agecat15==2
diagtest res_swab_pluslife culture_result2 if culture_result2~=999 & res_swab_pluslife~=3 & hiv_status==0
diagtest res_swab_pluslife culture_result2 if culture_result2~=999 & res_swab_pluslife~=3 & hiv_status==1
diagtest res_swab_pluslife culture_result2 if culture_result2~=999 & res_swab_pluslife~=3 & sampling30==0
diagtest res_swab_pluslife culture_result2 if culture_result2~=999 & res_swab_pluslife~=3 & sampling30==1
diagtest res_swab_pluslife culture_result2 if culture_result2~=999 & res_swab_pluslife~=3 & sampling30==0
diagtest res_swab_pluslife culture_result2 if culture_result2~=999 & res_swab_pluslife~=3 & sampling30==1

tab xpertsputum culture_result2 if agecat15==1, m
tab trace culture_result2 if agecat15==1, m