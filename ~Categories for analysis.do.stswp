// 2 July //

br

tab redcap_event_name
drop if redcap_event_name=="fu_arm_2"

tab willing, m
drop if willing==0

gen tbhistdur=interv_dt-diag_tb_y
sort tbhistdur
gen tbhist2years=.
replace tbhist2years=1 if tbhistdur<=730
replace tbhist2years=0 if tbhist2years!=1
br idsubject initial age birthdate diag_tb_y interv_dt tbhistdur tbhist2years
sort tbhistdur
replace tbhist2years=1 if idsubject==4100068
tab tbhist2years, m 
drop if tbhist2years==1



tab subject_cat, m
sort subject_cat
br idsubject tcm_result semi_quant xpertsputum1 xpertsputum2 culture_result subject_cat