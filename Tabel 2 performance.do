use "D:\EVIDENT WP1 Data\250623_dataset pluslife -paper.dta"

br

// membagi pasien menjadi sampling 30 detik //
gen sampling30= .
replace sampling30=0 if interv_dt<td(30jan2025)
replace sampling30=1 if interv_dt>=td(30jan2025)

//dropping sampel yang samplingnya kurang dari 15 detik!!
drop if idsubject==4100466
drop if idsubject==4100467
drop if idsubject==4100717
drop if idsubject==4100718

//hasil kultur positif tapi MOTT harus diubah jadi negatif
gen culture_result2=999
browse culture_result cult_ident culture_result2
sort culture_result

//negative
replace culture_result2=1 if culture_result==1
replace culture_result2=1 if culture_result==3 & cult_ident==2
browse idsubject if culture_result==3 & cult_ident==2
sort idsubject
//19 MOTT

//positive
replace culture_result2=2 if culture_result==3 & cult_ident==1
replace culture_result2=2 if culture_result==3 & cult_ident==.

label define culture_result2 1 "negative" 2 "positive"
label values culture_result2 culture_result2

tab culture_result culture_result2

// performance //
diagtest res_swab_pluslife culture_result2 if res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
diagtest res_swab_pluslife culture_result2 if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
diagtest res_swab_pluslife culture_result2 if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 99 97, wilson

diagtest res_swab_pluslife culture_result2 if dm_status==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
diagtest res_swab_pluslife culture_result2 if dm_status==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 38 36, wilson

diagtest res_swab_pluslife culture_result2 if hiv_status==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
diagtest res_swab_pluslife culture_result2 if hiv_status==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999

diagtest res_swab_pluslife culture_result2 if sex==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999
cii proportion 154 152, wilson
diagtest res_swab_pluslife culture_result2 if sex==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4 & culture_result2~=999

// performance vs Xpert excluding trace //
diagtest res_swab_pluslife xpertsputum2 if res_swab_pluslife~=3 & res_swab_pluslife~=4
diagtest res_swab_pluslife xpertsputum2 if sampling30==0 & res_swab_pluslife~=3 & res_swab_pluslife~=4
diagtest res_swab_pluslife xpertsputum2 if sampling30==1 & res_swab_pluslife~=3 & res_swab_pluslife~=4

// performance pluslife ss //
// membagi pasien jadi rspr, ku cibadak, dan pkm //
gen recloc=.
replace recloc=1 if rec_loc==1
replace recloc=2 if rec_loc==2
replace recloc=3 if rec_loc~=1 & rec_loc~=2
label define recloclab 1 "RSPR" 2 "KU Cibadak" 3 "PKM"
label values recloc recloclab

//dropping contamination
drop if idsubject==4100167
drop if idsubject==4100163
drop if idsubject==4100162
drop if idsubject==4100170
drop if idsubject==4100169
drop if idsubject==4100168
drop if idsubject==4100166

drop if culture_result2==999
drop if res_sput_pluslife==4

diagtest res_sput_pluslife culture_result2 if res_sput_pluslife~=3 & culture_result2~=999
diagtest res_sput_pluslife culture_result2 if recloc==1 & res_sput_pluslife~=3 & culture_result2~=999
diagtest res_sput_pluslife culture_result2 if recloc==2 & res_sput_pluslife~=3 & culture_result2~=999
diagtest res_sput_pluslife culture_result2 if recloc==3 & res_sput_pluslife~=3 & culture_result2~=999
cii proportion 112 109, wilson

diagtest res_sput_pluslife culture_result2 if dm_status==0 & res_sput_pluslife~=3 & res_sput_pluslife~=4 & culture_result2~=999
diagtest res_sput_pluslife culture_result2 if dm_status==1 & res_sput_pluslife~=3 & res_sput_pluslife~=4 & culture_result2~=999
cii proportion 45 41, wilson

diagtest res_sput_pluslife culture_result2 if hiv_status==0 & res_sput_pluslife~=3 & res_sput_pluslife~=4 & culture_result2~=999
diagtest res_sput_pluslife culture_result2 if hiv_status==1 & res_sput_pluslife~=3 & res_sput_pluslife~=4 & culture_result2~=999

diagtest res_sput_pluslife culture_result2 if sex==0 & res_sput_pluslife~=3 & res_sput_pluslife~=4 & culture_result2~=999
cii proportion 154 152, wilson
diagtest res_sput_pluslife culture_result2 if sex==1 & res_sput_pluslife~=3 & res_sput_pluslife~=4 & culture_result2~=999

// performance xpert ts //
diagtest xpertts culture_result2 if culture_result2~=999
diagtest xpertts culture_result2 if sampling30==0 & culture_result2~=999
diagtest xpertts culture_result2 if sampling30==1 & culture_result2~=999

diagtest xpertts culture_result2 if dm_status==0 & xpertts~=3 & xpertts~=4 & culture_result2~=999
diagtest xpertts culture_result2 if dm_status==1 & xpertts~=3 & xpertts~=4 & culture_result2~=999
cii proportion 42 40, wilson

diagtest xpertts culture_result2 if hiv_status==0 & xpertts~=3 & xpertts~=4 & culture_result2~=999
diagtest xpertts culture_result2 if hiv_status==1 & xpertts~=3 & xpertts~=4 & culture_result2~=999

diagtest xpertts culture_result2 if sex==0 & xpertts~=3 & xpertts~=4 & culture_result2~=999
cii proportion 153 151, wilson
diagtest xpertts culture_result2 if sex==1 & xpertts~=3 & xpertts~=4 & culture_result2~=999