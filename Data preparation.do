// Data preparation //

br

save "D:\EVIDENT WP1 Data\250707_data awal.dta"

//BASELINE DATA
keep if redcap_event_name=="baseline_arm_1"
//obs=1,185
save 

//FOLLOW-UP
clear "D:\EVIDENT WP1 Data\250703_data baseline.dta"
use "D:\EVIDENT WP1 Data\250703_data awal.dta", clear
keep if redcap_event_name=="fu_arm_2"
//17 obs
save "D:\EVIDENT WP1 Data\250703_data fu.dta"

//MERGING BASELINE AND FOLLOW-UP
clear
use "D:\EVIDENT WP1 Data\250703_data baseline.dta"
merge 1:1 idsubject using "D:\EVIDENT WP1 Data\250703_data fu.dta"
save "D:\EVIDENT WP1 Data\250703_data bl fu.dta"

// membagi pasien jadi rspr, ku cibadak, dan pkm //
gen recloc=.
replace recloc=1 if rec_loc==1
replace recloc=2 if rec_loc==2
replace recloc=3 if rec_loc~=1 & rec_loc~=2
label define recloclab 1 "RSPR" 2 "KU Cibadak" 3 "PKM"
label values recloc recloclab
tab willing recloc, m col

*membagi pasien menjadi 2 kategori umur (cutoff 10 tahun)
generate agecat10=.
replace agecat10=0 if age<10
replace agecat10=1 if age>=10
tab agecat10, m

//children=0-14 years, adults=15+//
gen agecat15=.
replace agecat15=1 if age<15
replace agecat15=2 if age>=15
label define agecatlab 1 "0-14" 2 "15+"
label values agecat15 agecatlab
tab agecat15, m

*membagi pasien menjadi 2 kategori umur (cutoff 14 tahun)
generate agecat14=.
replace agecat14=0 if age<14
replace agecat14=1 if age>=14
tab agecat14, m

*membagi pasien menjadi 4 kategori umur
generate agecat1=.
replace agecat1=1 if age>=0 & age<5
replace agecat1=2 if age>=5 & age<10
replace agecat1=3 if age>=10 & age<15
label define agecat1_lab 1 "Aged 0-4" 2 "Aged 5-9" 3 "Aged 10-14"
label values agecat1 agecat1_lab
tab agecat1, m

// membagi pasien menjadi sampling 30 detik //
gen sampling30= .
replace sampling30=0 if interv_dt<td(30jan2025)
replace sampling30=1 if interv_dt>=td(30jan2025)

//DM status
browse dm poc_hba1c
gen dm_status=0
replace dm_status=1 if dm==1
replace dm_status=1 if poc_hba1c>=6.5 & poc_hba1c~=.
label define dm_status 0 "no" 1 "yes"
label values dm_status dm_status
tab dm_status

//HIV status
gen hiv_status=999
browse hiv hiv_test hiv_status
sort hiv_status
replace hiv_status=0 if (hiv==0 | hiv==2) & hiv_test==0
replace hiv_status=1 if hiv==1 | hiv_test==1
replace hiv_status=2 if (hiv==0 | hiv==2) & (hiv_test==8 | hiv_test==2 | hiv_test==.)
label define hiv_status 0 "negative" 1 "positive" 2 "refused testing"
label values hiv_status hiv_status
tab hiv_status, m

// recoding cxr //
gen cxr=.
replace cxr=1 if cxray==1
replace cxr=0 if cxray==0 | cxray==2 | cxray==3
label define cxrlab 0 "Negative" 1 "Positive"
label values cxr cxrlab

// recoding TST //
gen tubercat=999
replace tubercat=1 if tuberc_res<5
replace tubercat=2 if tuberc_res>=5 & tuberc_res<10
replace tubercat=3 if tuberc_res>=10 & tuberc_res<=50
tab tubercat
sort tuberc_res
br tuberc_res tubercat 
label define tubercatlab 1 "<5 mm" 2 ">=5 mm" 3 ">=10 mm" 
label values tubercat tubercatlab

gen tst=999
br hiv_status tuberc_res tubercat tst
replace tst=0 if tubercat==1 | (tubercat==2 & hiv_status==0) | (tubercat==2 & hiv_status==2)
replace tst=1 if tubercat==3
label define tstlab 0 "Negative" 1 "Positive" 
label values tst tstlab

// recoding hasil xpert sputum //
gen xpertsputum=.
replace xpertsputum=1 if tcm_result==0
replace xpertsputum=2 if tcm_result==1 | tcm_result==2 | tcm_result==3 | tcm_result==4 | tcm_result==5 | tcm_result==6 | tcm_result==7 | tcm_result==8
label variable xpertsputum "Hasil pemeriksaan Xpert Sputum"
label define xpertsputumlab 1 "Negative" 2 "Positive"
label values xpertsputum xpertsputumlab

// recoding hasil xpert sputum1 (melibatkan Mtb trace (4))
gen xpertsputum1=.
replace xpertsputum1=1 if tcm_result==0
replace xpertsputum1=2 if tcm_result==1 | tcm_result==2 | tcm_result==3 | tcm_result==4 | tcm_result==5 | tcm_result==6 | tcm_result==7 | tcm_result==8
label variable xpertsputum1 "Hasil pemeriksaan Xpert Sputum"
label define xpertsputum1lab 1 "Negative" 2 "Positive"
label values xpertsputum1 xpertsputum1lab
tab xpertsputum1, m

// recoding hasil xpert sputum2 (tidak melibatkan Mtb trace (4) dan semi_quant trace (1))
gen xpertsputum2=.
replace xpertsputum2=1 if tcm_result==0
replace xpertsputum2=2 if ((tcm_result==1 | tcm_result==2 | tcm_result==3 | tcm_result==5 | tcm_result==6 | tcm_result==7 | tcm_result==8) & ((semi_quant==2 | semi_quant==3 | semi_quant==4 | semi_quant==5))) | tcm_result==5 | tcm_result==1 | tcm_result==2
label variable xpertsputum2 "Hasil pemeriksaan Xpert Sputum"
label define xpertsputum2lab 1 "Negative" 2 "Positive"
label values xpertsputum2 xpertsputum2lab
tab xpertsputum2, m

// gen mrs //
gen mrs=.
replace mrs=2 if culture_result2==2 | xpertsputum2==2
replace mrs=1 if mrs~=2
label variable mrs "Culture or Xpert positive"
label define mrslab 1 "Negative" 2 "Positive"
label values mrs mrslab
tab mrs

// gen trace //
gen trace=.
replace trace=1 if semi_quant==1 | tcm_result==4
replace trace=0 if trace~=1

// gen tcm not done
gen tcmnotdone=1 if tcm_result==11 | tcm_result==12 | tcm_result==.
replace tcmnotdone=0 if tcmnotdone~=1

// recoding xpert ts
gen xpertts=.
replace xpertts=1 if res_xpertultra==0
replace xpertts=2 if res_xpertultra==1 | res_xpertultra==2 | res_xpertultra==3 | res_xpertultra==4 | res_xpertultra==5 | res_xpertultra==6 | res_xpertultra==7 | res_xpertultra==8
label variable xpertts "Hasil pemeriksaan Xpert TS"
label define xperttslab 1 "Negative" 2 "Positive"
label values xpertts xperttslab
tab xpertts, m

// recoding hasil kultur //
//hasil kultur positif tapi MOTT harus diubah jadi negatif
gen culture_result2=999
browse culture_result cult_ident culture_result2
sort culture_result

//negative
replace culture_result2=1 if culture_result==1
replace culture_result2=1 if culture_result==3 & cult_ident==2
browse idsubject if culture_result==3 & cult_ident==2
sort idsubject
//21 MOTT

//positive
replace culture_result2=2 if culture_result==3 & cult_ident==1
replace culture_result2=2 if culture_result==3 & cult_ident==.

label define culture_result2 1 "negative" 2 "positive"
label values culture_result2 culture_result2

tab culture_result culture_result2

// gen culture not done
gen cultnotdone=.
replace cultnotdone=1 if culture_result==0 | culture_result==5 | culture_result==.
replace cultnotdone=0 if cultnotdone~=1

// recoding hasil kultur //
// NTM di-exclude //

*generating new variable: bmi category
generate bmicat=.
replace bmicat=1 if (bmi<18.5)
replace bmicat=2 if (bmi>=18.5 & bmi<=22.99999)
replace bmicat=3 if (bmi>=23.0 & bmi<=24.99999)
replace bmicat=4 if (bmi>=25.0 & bmi<.)
label define bmicatlabel 1 "Underweight" 2 "Normal" 3 "Overweight" 4 "Obese"
label values bmicat bmicatlabel

// generating new variable: dr-tb
gen drtb=.
replace drtb=0 if tcm_result==1 | tcm_result==5
replace drtb=1 if tcm_result==2 | tcm_result==8 
label define drtblab 0 "DS-TB" 1 "DR-TB"
label values drtb drtblab
tab drtb recloc, m col

// Categories for analysis
// positive MTB only
// excluding trace
gen subjectcat=.
// TB positive //
replace subjectcat=1 if cult_ident==1 & xpertsputum2==2
replace subjectcat=2 if cult_ident==1 & trace==1
replace subjectcat=3 if cult_ident==1 & tcm_result==0
replace subjectcat=4 if cult_ident==2 & xpertsputum2==2
replace subjectcat=5 if culture_result==1 & xpertsputum2==2
replace subjectcat=6 if culture_result==1 & trace==1
replace subjectcat=7 if cultnotdone==1 & xpertsputum2==2
replace subjectcat=8 if cultnotdone==1 & trace==1
// TB negative //
replace subjectcat=9 if culture_result==1 & tcm_result==0 & cxray~=1 & tb_treat==1
replace subjectcat=10 if culture_result==1 & tcm_result==0 & cxray~=1 & (tb_treat==0 | tb_treat==.) 
replace subjectcat=11 if cult_ident==2 & tcm_result==0 & cxr==0 & tb_treat==0
replace subjectcat=12 if cult_ident==2 & tcm_result==0 & cxray==1 & tb_treat==0 // i
replace subjectcat=13 if culture_result==1 & tcm_result==0 & cxray==1 & tb_treat==0 // m
// Uncategorized //
replace subjectcat=14 if cult_ident==2 & tcm_result==0 & cxray==1 & tb_treat==1 // n
replace subjectcat=15 if culture_result==1 & tcm_result==0 & cxray==1 & tb_treat==1 // o
replace subjectcat=16 if culture_result==1 & tcmnotdone==1 & cxray==1 & tb_treat==1 // p
replace subjectcat=17 if culture_result==1 & tcmnotdone==1 & cxr==0 & tb_treat==1 // q
replace subjectcat=18 if cultnotdone==1 & tcm_result==0 & cxray==1 & tb_treat==1 // r
replace subjectcat=19 if cultnotdone==1 & tcmnotdone==1 & cxray==1 & tb_treat==1 // s
replace subjectcat=20 if cultnotdone==1 & tcmnotdone==1 & cxr==0 & tb_treat==1 // t
replace subjectcat=21 if cult_ident==2 & tcmnotdone==1 & cxray==1 & tb_treat==1 // u
replace subjectcat=22 if culture_result==1 & tcmnotdone==1 & cxray==1 & tb_treat==0 // v
replace subjectcat=23 if culture_result==1 & tcmnotdone==1 & cxr==0 & tb_treat==0 // w
replace subjectcat=24 if cultnotdone==1 & tcmnotdone==1 & cxr==1 & tb_treat==0 // x
replace subjectcat=25 if cultnotdone==1 & tcmnotdone==1 & cxr==0 & tb_treat==0 // y
replace subjectcat=26 if cultnotdone==1 & tcm_result==0 & cxr==0 & tb_treat==0 // z


label define subj_cat_lab 1 "Culture pos MTB and Xpert pos (excl trace)" 2 "Culture pos MTB and Xpert trace pos" 3 "Culture pos MTB and Xpert neg" 4 "Culture pos MTB and Xpert pos (no semiquant)" 5 "Culture neg and Xpert pos (excl trace)" 6 "Culture neg and Xpert trace pos" 7 "Culture neg and Xpert neg" 8 "Culture neg and Xpert neg and treated" 9 "Culture nd, Xpert nd, treated" 10 "Culture nd, Xpert nd" 11 "Culture neg, Xpert nd" 12 "Culture neg, Xpert pos (no semiquantitative result)" 13 "Culture nd, Xpert neg" 14 "Culture pos NTM, Xpert nd" 15 "Culture pos NTM, Xpert neg"
label values subject_cat subj_cat_lab

br idsubject age tuberc_res culture_result cult_ident tcm_result trace cxray tb_treat subject_cat

// vs kultur pos mtb, NTM deemed as negative, TB negative=no TB + clinical TB //
gen cultmtb1=.
replace cultmtb1=1 if culture_result==3 & cult_ident==1
replace cultmtb1=0 if culture_result==1 | (culture_result==3 & cult_ident==2) | subject_cat==4 | subject_cat==5 | subject_cat==6
label define cultmtb1lab 0 "Negative" 1 "Positive MTB"
label values cultmtb1 cultmtb1lab 
sort cultmtb1
br culture_result cult_ident subject_cat cultmtb1
