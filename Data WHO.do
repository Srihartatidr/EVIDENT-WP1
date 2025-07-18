// 18 Juli 2025 //
// Data WHO //
// Pluslife tongue swab //
br

//dropping sampel yang samplingnya kurang dari 15 detik!!
drop if idsubject==4100466
drop if idsubject==4100467
drop if idsubject==4100717
drop if idsubject==4100718
// 1 deleted

// dropping early exclusion //
drop if idsubject==4100074 | idsubject==4100689 | idsubject==4100974 | idsubject==4100455

// performance //
diagtest res_swab_pluslife culture_result2
diagtest res_swab_pluslife culture_result2 if agecat15==1
diagtest res_swab_pluslife culture_result2 if agecat15==2
diagtest res_swab_pluslife culture_result2 if sampling30==0
diagtest res_swab_pluslife culture_result2 if sampling30==1
diagtest res_swab_pluslife culture_result2 if hiv_status==0
diagtest res_swab_pluslife culture_result2 if hiv_status==1

// missing reference test //
tab culture_result2 res_swab_pluslife, m
tab culture_result2 res_swab_pluslife if agecat15==1, m
tab culture_result2 res_swab_pluslife if agecat15==2, m
tab culture_result2 res_swab_pluslife if sampling30==0, m
tab culture_result2 res_swab_pluslife if sampling30==1, m
tab culture_result2 res_swab_pluslife if hiv_status==0, m
tab culture_result2 res_swab_pluslife if hiv_status==1, m

// comparator //
diagtest xpertsputum2 culture_result2
diagtest xpertsputum2 culture_result2 if agecat15==1
diagtest xpertsputum2 culture_result2 if agecat15==2
diagtest xpertsputum2 culture_result2 if sampling30==0
diagtest xpertsputum2 culture_result2 if sampling30==1
diagtest xpertsputum2 culture_result2 if hiv_status==0
diagtest xpertsputum2 culture_result2 if hiv_status==1

diagtest trace culture_result2
diagtest trace culture_result2 if agecat15==1
diagtest trace culture_result2 if agecat15==2
diagtest trace culture_result2 if sampling30==0
diagtest trace culture_result2 if sampling30==1
diagtest trace culture_result2 if hiv_status==0
diagtest trace culture_result2 if hiv_status==1

// missing comparator test //
tab xpertsputum res_swab_pluslife, m
tab xpertsputum res_swab_pluslife if agecat15==1, m
tab xpertsputum res_swab_pluslife if agecat15==2, m
tab xpertsputum res_swab_pluslife if sampling30==0, m
tab xpertsputum res_swab_pluslife if sampling30==1, m
tab xpertsputum res_swab_pluslife if hiv_status==0, m
tab xpertsputum res_swab_pluslife if hiv_status==1, m

// Pluslife sputum swab //
// 674 obs //
//dropping contamination
drop if idsubject==4100167
drop if idsubject==4100163
drop if idsubject==4100162
drop if idsubject==4100170
drop if idsubject==4100169
drop if idsubject==4100168
drop if idsubject==4100166
// 668 obs //

// performance //
diagtest res_sput_pluslife culture_result2
diagtest res_sput_pluslife culture_result2 if agecat15==1
diagtest res_sput_pluslife culture_result2 if agecat15==2
diagtest res_sput_pluslife culture_result2 if sampling30==0
diagtest res_sput_pluslife culture_result2 if sampling30==1
diagtest res_sput_pluslife culture_result2 if hiv_status==0
diagtest res_sput_pluslife culture_result2 if hiv_status==1

// missing reference test //
tab culture_result2 res_sput_pluslife, m
tab culture_result2 res_sput_pluslife if agecat15==1, m
tab culture_result2 res_sput_pluslife if agecat15==2, m
tab culture_result2 res_sput_pluslife if sampling30==0, m
tab culture_result2 res_sput_pluslife if sampling30==1, m
tab culture_result2 res_sput_pluslife if hiv_status==0, m
tab culture_result2 res_sput_pluslife if hiv_status==1, m

// comparator //
diagtest xpertsputum2 culture_result2
diagtest xpertsputum2 culture_result2 if agecat15==1
diagtest xpertsputum2 culture_result2 if agecat15==2
diagtest xpertsputum2 culture_result2 if sampling30==0
diagtest xpertsputum2 culture_result2 if sampling30==1
diagtest xpertsputum2 culture_result2 if hiv_status==0
diagtest xpertsputum2 culture_result2 if hiv_status==1

diagtest trace culture_result2
diagtest trace culture_result2 if agecat15==1
diagtest trace culture_result2 if agecat15==2
diagtest trace culture_result2 if sampling30==0
diagtest trace culture_result2 if sampling30==1
diagtest trace culture_result2 if hiv_status==0
diagtest trace culture_result2 if hiv_status==1

// missing comparator test //
tab xpertsputum res_swab_pluslife, m
tab xpertsputum res_swab_pluslife if agecat15==1, m
tab xpertsputum res_swab_pluslife if agecat15==2, m
tab xpertsputum res_swab_pluslife if sampling30==0, m
tab xpertsputum res_swab_pluslife if sampling30==1, m
tab xpertsputum res_swab_pluslife if hiv_status==0, m
tab xpertsputum res_swab_pluslife if hiv_status==1, m
