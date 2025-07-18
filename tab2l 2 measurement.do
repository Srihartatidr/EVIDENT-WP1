// MRS //

gen mrs=.
replace mrs=2 if culture_result2==2 | xpertsputum2==2
replace mrs=1 if mrs~=2
label variable mrs "Culture or Xpert positive"
label define mrslab 1 "Negative" 2 "Positive"
label values mrs mrslab
tab mrs

// No TB //
br idsubject culture_result2 xpertsputum cxr res_swab_pluslife if culture_result2==1 & xpertsputum2==1 & cxr==0 & (res_swab_pluslife==0 | res_swab_pluslife==1)

gen notb=.
replace notb=1 if culture_result2==1 & xpertsputum2==1 & cxr==0 & (res_swab_pluslife==0 | res_swab_pluslife==1)
replace notb=0 if notb~=1

gen no_tb=.
replace no_tb=1 if culture_result2==1 & xpertsputum2==1 & cxr==0
replace no_tb=0 if no_tb~=1

// Clinical TB //
br idsubject culture_result2 xpertsputum cxr res_swab_pluslife if culture_result2==1 & xpertsputum2==1 & cxr==1 & (res_swab_pluslife==0 | res_swab_pluslife==1)

gen clinicaltb=.
replace clinicaltb=1 if culture_result2==1 & xpertsputum2==1 & cxr==1 & (res_swab_pluslife==0 | res_swab_pluslife==1)
replace clinicaltb=0 if clinicaltb~=1

gen clintb=.
replace clintb=1 if culture_result2==1 & xpertsputum2==1 & cxr==1
replace clintb=0 if clintb~=1

// 
tab culture_result2 res_swab_pluslife if res_swab_pluslife==0 | res_swab_pluslife==1, m col
tab xpertsputum2 res_swab_pluslife if res_swab_pluslife==0 | res_swab_pluslife==1, m col
tab mrs res_swab_pluslife, m
tab notb res_swab_pluslife, m
tab clinicaltb res_swab_pluslife, m

// adult = 474 obs //br

keep if agecat15==1
keep if res_swab_pluslife==0 | res_swab_pluslife==1
// children = 210 obs //
tab culture_result2 res_swab_pluslife if res_swab_pluslife==0 | res_swab_pluslife==1, m col
tab xpertsputum2 res_swab_pluslife if res_swab_pluslife==0 | res_swab_pluslife==1, m col
tab mrs res_swab_pluslife, m
tab notb res_swab_pluslife, m
tab clinicaltb res_swab_pluslife, m

