// Data preparation //

br

save "D:\EVIDENT WP1 Data\250707_data awal.dta"

//BASELINE DATA
keep if redcap_event_name=="baseline_arm_1"
//obs=1,295
save 

//FOLLOW-UP
clear "D:\EVIDENT WP1 Data\250703_data baseline.dta"
use "D:\EVIDENT WP1 Data\250703_data awal.dta", clear
keep if redcap_event_name=="fu_arm_2"
//17 obs
save "D:\EVIDENT WP1 Data\250703_data fu.dta"

//MERGING BASELINE AND FOLLOW-UP
clear
use "D:\EVIDENT WP1 Data\250808_data baseline.dta"
merge 1:1 idsubject using "D:\EVIDENT WP1 Data\250808_data fu.dta"
save "D:\EVIDENT WP1 Data\250808_data bl fu.dta"

//MERGING BASELINE AND FOLLOW-UP
clear
use "D:\EVIDENT WP1 Data\250910_pl ss all.dta"
merge 1:1 idsubject using "D:\EVIDENT WP1 Data\250910_fu pasien.dta"
save "D:\EVIDENT WP1 Data\250910_pl ss all and fu.dta"

clear
use "D:\EVIDENT WP1 Data\250911_Children dataset.dta"
merge 1:1 idsubject using "D:\EVIDENT WP1 Data\250911_all patients.dta"
save "D:\EVIDENT WP1 Data\250911_Children dataset combined .dta"

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

*membagi pasien menjadi 5 kategori umur
generate agecat5=.
replace agecat5=1 if age<1
replace agecat5=2 if age>=1 & age<5
replace agecat5=3 if age>=5 & age<10
replace agecat5=4 if age>=10 & age<15
replace agecat5=5 if age>=15
label define agecat5_lab 1 "Aged <1" 2 "Aged 1-4" 3 "Aged 5-9" 4 "Aged 10-14" 5 "Aged 15+"
label values agecat5 agecat5_lab
tab agecat5, m

*Calculate age in months
gen age_months = (interv_dt - birthdate) / 30.4375   // average month length
gen age_months_int = floor(age_months)     // integer months

// membagi pasien menjadi sampling 30 detik //
gen sampling30= .
replace sampling30=0 if interv_dt<td(30jan2025)
replace sampling30=1 if interv_dt>=td(30jan2025)
label define samplinglab 0 "15-s" 1 "30-s"
label values sampling30 samplinglab

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

// recoding hasil kultur NTM jadi negative //
// hasil kultur positif tapi MOTT harus diubah jadi negatif //
gen culture_result2=999
//negative
replace culture_result2=1 if culture_result==1
replace culture_result2=1 if culture_result==3 & cult_ident==2
//positive
replace culture_result2=2 if culture_result==3 & cult_ident==1
replace culture_result2=2 if culture_result==3 & cult_ident==.
label define culture_result2 1 "negative" 2 "positive"
label values culture_result2 culture_result2

// recoding hasil kultur NTM as no result for MTB //
gen culture_result3=999
//negative
replace culture_result3=0 if culture_result==1
//positive
replace culture_result3=1 if culture_result==3 & cult_ident==1
replace culture_result3=1 if culture_result==3 & cult_ident==.
replace culture_result3=2 if cult_ident==2 | culture_result==5
label define cultresult3lab 0 "Negative" 1 "Positive" 2 "Not done"
label values culture_result3 cultresult3lab

// gen culture not done
gen cultnotdone=.
replace cultnotdone=1 if culture_result==0 | culture_result==5 | culture_result==.
replace cultnotdone=0 if cultnotdone~=1

// gen tcm not done
gen tcmnotdone=1 if tcm_result==11 | tcm_result==12 | tcm_result==.
replace tcmnotdone=0 if tcmnotdone~=1

// gen trace //
gen trace=.
replace trace=1 if semi_quant==1 | tcm_result==4
replace trace=0 if trace~=1

// gen culture/tcm available //
gen cultcmdone=.
replace cultcmdone=0 if tcmnotdone==1 & cultnotdone==1
replace cultcmdone=1 if cultcmdone~=0
label define cultcmdonelab 0 "Not done" 1 "Done"
label values cultcmdone cultcmdonelab 

// recoding xpert ts
gen xpertts=.
replace xpertts=1 if res_xpertultra==0
replace xpertts=2 if res_xpertultra==1 | res_xpertultra==2 | res_xpertultra==3 | res_xpertultra==4 | res_xpertultra==5 | res_xpertultra==6 | res_xpertultra==7 | res_xpertultra==8
label variable xpertts "Hasil pemeriksaan Xpert TS"
label define xperttslab 1 "Negative" 2 "Positive"
label values xpertts xperttslab
tab xpertts, m

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

// C A T E G O R I E S   F O R   A N A L Y S I S //
// positive MTB only
gen subjectcat=.
// TB positive = 1 //
replace subjectcat=1 if cult_ident==1 & xpertsputum2==2
replace subjectcat=2 if cult_ident==1 & trace==1
replace subjectcat=3 if cult_ident==1 & tcm_result==0
replace subjectcat=4 if cult_ident==2 & xpertsputum2==2
replace subjectcat=5 if culture_result==1 & xpertsputum2==2
replace subjectcat=6 if cultnotdone==1 & xpertsputum2==2
// Probable TB = 2 //
replace subjectcat=7 if culture_result==1 & trace==1 & cxray==1
replace subjectcat=8 if cultnotdone==1 & trace==1 & cxray==1
replace subjectcat=9 if cult_ident==2 & tcm_result==0 & cxray==1 & tb_treat==1
replace subjectcat=10 if culture_result==1 & tcm_result==0 & cxray==1 & tb_treat==1
replace subjectcat=11 if culture_result==1 & tcmnotdone==1 & cxray==1 & tb_treat==1
replace subjectcat=12 if culture_result==1 & tcmnotdone==1 & cxr==0 & tb_treat==1
replace subjectcat=13 if cultnotdone==1 & tcm_result==0 & cxray==1 & tb_treat==1
replace subjectcat=14 if cult_ident==2 & tcmnotdone==1 & cxray==1 & tb_treat==1
replace subjectcat=15 if cultnotdone==1 & tcmnotdone==1 & cxray==1 & tb_treat==1
// Possible TB = 3 //
replace subjectcat=16 if culture_result==1 & trace==1 & cxr==0 & tb_treat==.
replace subjectcat=161 if culture_result==1 & trace==1 & cxr==0 & tb_treat==1
replace subjectcat=17 if cultnotdone==1 & trace==1 & cxr==0 & tb_treat==.
replace subjectcat=18 if culture_result==1 & tcm_result==0 & cxr==0 & tb_treat==1
replace subjectcat=19 if cult_ident==2 & tcm_result==0 & cxr==0 & tb_treat==0
replace subjectcat=20 if culture_result==1 & tcmnotdone==1 & cxr==0 & tb_treat==1
replace subjectcat=21 if cultnotdone==1 & tcmnotdone==1 & cxr==0 & tb_treat==1
replace subjectcat=22 if cult_ident==2 & tcm_result==0 & cxr==1 & tb_treat==0
replace subjectcat=23 if culture_result==1 & tcm_result==0 & cxr==1 & tb_treat==0
replace subjectcat=24 if culture_result==1 & tcmnotdone==1 & cxr==1 & tb_treat==0
replace subjectcat=25 if cultnotdone==1 & tcmnotdone==1 & cxr==1 & tb_treat==0
// TB negative = 0 //
replace subjectcat=26 if culture_result==1 & tcm_result==0 & cxr==0 & tb_treat==0
replace subjectcat=27 if culture_result==1 & tcmnotdone==1 & cxr==0 & tb_treat==0 
replace subjectcat=28 if culture_result==1 & tcm_result==0 & (cxray==. | cxray==4) & tb_treat==0
replace subjectcat=29 if culture_result==1 & tcm_result==12 & cxray==4 & tb_treat==0
replace subjectcat=30 if cultnotdone==1 & tcm_result==0 & cxr==0 & tb_treat==0
replace subjectcat=31 if cultnotdone==1 & tcmnotdone==1 & cxr==0 & tb_treat==0
replace subjectcat=32 if (culture_result==1 | cultnotdone==1) & tcmnotdone==1 & cxr==0 & tb_treat==.

label define subjectcatlab 1 "Cat a" 2 "Cat b" 3 "Cat c" 4 "Cat d" 5 "Cat e" 6 "Cat f" 7 "Cat g" 8 "Cat h" 9 "Cat i" 10 "Cat j" 11 "Cat k" 12 "Cat l" 13 "Cat m" 14 "Cat n" 15 "Cat o" 16 "Cat p1" 161 "Cat p2" 17 "Cat q" 18 "Cat r" 19 "Cat s" 20 "Cat t" 21 "Cat u" 22 "Cat v" 23 "Cat w" 24 "Cat x" 25 "Cat y" 26 "Cat z1" 27 "Cat z2" 28 "Cat z3" 29 "Cat z4" 30 "Cat z5" 31 "Cat z6" 32 "Cat z7"
label values subjectcat subjectcatlab

br idsubject age tuberc_res culture_result cult_ident tcm_result trace cxray tb_treat subjectcat

// final diagnosis //
gen finaldiag=.
replace finaldiag=0 if subjectcat==26 | subjectcat==27 | subjectcat==28 | subjectcat==29 | subjectcat==30 | subjectcat==31 | subjectcat==32
replace finaldiag=1 if subjectcat==1 | subjectcat==2 | subjectcat==3 | subjectcat==4 | subjectcat==5 | subjectcat==6
replace finaldiag=2 if subjectcat==7 | subjectcat==8 | subjectcat==9 | subjectcat==10 | subjectcat==11 | subjectcat==12 | subjectcat==13 | subjectcat==14 | subjectcat==15
replace finaldiag=3 if subjectcat==16 | subjectcat==161 | subjectcat==17 | subjectcat==18 | subjectcat==19 | subjectcat==20 | subjectcat==21 | subjectcat==22 | subjectcat==23 | subjectcat==24 | subjectcat==25
label define finaldiaglab 0 "Not TB" 1 "TB Positive" 2 "Probable TB" 3 "Possible TB"
label values finaldiag finaldiaglab

br idsubject age tuberc_res culture_result cult_ident tcm_result trace cxray tb_treat subjectcat finaldiag

// D E F I N I S I   K A S U S   U N T U K   D I A G N O S T I C   A C C U R A C Y //

// membuat definisi TB berdasarkan maximal RS
gen mrs_tb=999
replace mrs_tb=1 if finaldiag==1
replace mrs_tb=0 if subjectcat==26 | subjectcat==27 | subjectcat==28
label define negposlab 0 "Negative" 1 "Positive"
label values mrs_tb negposlab

// membuat definisi TB berdasarkan sensitivity analysis dari maximal RS
gen mrssens_tb=999
replace mrssens_tb=1 if finaldiag==1 | subjectcat==7 | subjectcat==8 | subjectcat==16 | subjectcat==161 | subjectcat==17
replace mrssens_tb=0 if subjectcat==26 | subjectcat==27 | subjectcat==28
label values mrssens_tb negposlab

// membuat definisi TB berdasarkan conservative RS
gen conserv_tb=999
replace conserv_tb=1 if finaldiag==1 | finaldiag==2
replace conserv_tb=0 if subjectcat==26 | subjectcat==27 | subjectcat==28
label values conserv_tb negposlab

// membuat definisi TB berdasarkan sensitivity analysis dari conservative RS
gen conservsens_tb=999
replace conservsens_tb=1 if finaldiag==1 | finaldiag==2 | subjectcat==16 | subjectcat==161 | subjectcat==17
replace conservsens_tb=0 if finaldiag==0
label values conservsens_tb negposlab

// K R I T E R I A   E K S K L U S I //
br idsubject interv_dt tb_treat datetb_treat unlikely_diag note_

// gen on TB treatment < 7 days //
gen onoat=.
replace onoat=1 if idsubject==4100300 | idsubject==4100047 | idsubject==4100005 | idsubject==4100560 | idsubject==4101148 | idsubject==4101149 | idsubject==4100618 | idsubject==4101150 | idsubject==4101146

// gen EPTB //
gen eptb=.
replace eptb=1 if idsubject==4100475 | idsubject==4100303 | idsubject==4100031 | idsubject==4100059 | idsubject==4100462 | idsubject==4100908 | idsubject==4100575 | idsubject==4100012 | idsubject==4100817

// gen on AB other than OAT //
gen onab=.
replace onab=1 if idsubject==4100163
replace onab=1 if idsubject==4100140
replace onab=1 if idsubject==4100289
replace onab=1 if idsubject==4100127
replace onab=1 if idsubject==4100243
replace onab=1 if idsubject==4100237
replace onab=1 if idsubject==4100271
replace onab=1 if idsubject==4100232
replace onab=1 if idsubject==4100069
replace onab=1 if idsubject==4100747
replace onab=1 if idsubject==4100751
replace onab=1 if idsubject==4100265
replace onab=1 if idsubject==4100281
replace onab=1 if idsubject==4100013
replace onab=1 if idsubject==4100469
replace onab=1 if idsubject==4100459
replace onab=1 if idsubject==4100121
replace onab=1 if idsubject==4100141
replace onab=1 if idsubject==4100413
replace onab=1 if idsubject==4100224
replace onab=1 if idsubject==4100268

* Format display to 2 decimal places
format bmi %9.2f

// R E N T A N G   T E S   I N D E K S   K E   R E F E R E N C E //
// Cek durasi tanggal kultur ke hasil kultur //
gen durasikultur=culture_res_dt-cult_ino_dt

// Bagi hasil kultur menjadi 28 hari atau lebih //
gen durasikulturcat=.
replace durasikulturcat=0 if durasikultur<=28
replace durasikulturcat=1 if (durasikultur>28 & durasikultur~=.) & culture_result==3
label define durasikulturlab 0 "<=28 days" 1 ">28 days"
label values durasikulturcat durasikulturlab
tab durasikulturcat, m
sort durasikultur
br idsubject age interv_dt sputum1_c cult_ino_dt culture_res_dt durasikultur durasikulturcat culture_result cult_ident

// hitung durasi tanggal sampel tes indeks ke reference test //

gen durasiic=date_only-sputum1_dt_2
summarize durasiic, d
br idsubject interv_dt sputum1_dt_2 dt_swab_pluslife durasiic
sort durasiic


// hitung durasi tanggal sampel tes indeks ke reference test //
gen date_onlyss = dofc(dt_sput_pluslife)
format date_onlyss %td

//
gen durasiicss=date_onlyss-sputum1_dt_2
summarize durasiicss, d
br idsubject interv_dt sputum1_dt_2 dt_sput_pluslife durasiicss
sort durasiicss

// F R E S H   O R   B I O A R C H I V E //
// P L   T S //
gen date_only_plts = dofc(dt_resswab_pluslife)
format date_only_plts %td

gen date_only2_plts = dofc(dt_swab_pluslife)
format date_only2_plts %td

gen rentangplts=date_only_plts - date_only2_plts

br date_only_plts date_only2_plts rentang
sort rentangplts
gen rentangcat=.
replace rentangcat=0 if rentangplts<14
replace rentangcat=1 if rentangplts>=14 & rentangplts~=.

gen bioplts=.
replace bioplts=0 if rentangplts<14
replace bioplts=1 if rentangplts>=14 & rentangplts~=.
label define bioarchivelab 0 "Fresh" 1 "Bioarchive"
label values bioplts bioarchivelab

br idsubject interv_dt dt_swab_pluslife dt_resswab_pluslife res_swab_pluslife culture_result rentangplts rentangcat bioplts

// X P E R T   T S //
gen date_only_xts = dofc(dt_xpertultra)
format date_only_xts %td

gen date_only2_xts = dofc(dtt_res_xpertu)
format date_only2_xts %td

gen rentangxts=date_only2_xts - date_only_xts

br date_only_xts date_only2_xts rentangxts
sort rentangxts
gen rentangcatxts=.
replace rentangcatxts=0 if rentangxts<14
replace rentangcatxts=1 if rentangxts>=14

gen bioxts=.
replace bioxts=0 if rentangcatxts==0
replace bioxts=1 if rentangcatxts==1
label values bioxts bioarchivelab

br idsubject interv_dt dt_xpertultra dtt_res_xpertu rentangxts rentangcatxts

