// analisis sementara //

*membagi pasien menjadi 2 kategori umur (cutoff 15 tahun)
generate agecat15=.
replace agecat15=1 if age<15
replace agecat15=2 if age>=15
tab agecat15, m

*membagi pasien menjadi 5 kategori umur 
generate agecat5=.
replace agecat5=1 if age<12
replace agecat5=2 if (age>=12 & age<18)
replace agecat5=3 if (age>=18 & age<35)
replace agecat5=4 if (age>=35 & age<65)
replace agecat5=5 if (age>=65 & age<.)
codebook agecat5

// characteristics based on recruitment sites //
tab sex recloc, m col
summarize age, d
summarize age if recloc==1, d
summarize age if recloc==2, d
summarize age if recloc==3, d

//DM status
browse dm poc_hba1c
gen dm_status=0
replace dm_status=1 if dm==1
replace dm_status=1 if poc_hba1c>=6.5 & poc_hba1c~=.
label define dm_status 0 "no" 1 "yes"
label values dm_status dm_status
tab dm_status recloc, m col

//HIV status
tab hiv, m
tab hiv_test, m
gen hiv_status=999
browse hiv hiv_test hiv_status
sort hiv_status
replace hiv_status=0 if (hiv==0 | hiv==2) & hiv_test==0
replace hiv_status=1 if hiv==1 | hiv_test==1
replace hiv_status=2 if (hiv==0 | hiv==2) & (hiv_test==8 | hiv_test==2 | hiv_test==.)
label define hiv_status 0 "negative" 1 "positive" 2 "refused testing"
label values hiv_status hiv_status
tab hiv_status recloc if hiv_status~=2 & hiv_status~=., m col
list idsubject age initial rec_loc hiv hiv_tes if hiv==1 | hiv_test==1

// recoding hasil xpert sputum //
codebook tcm_result
gen xpertsputum=.
replace xpertsputum=1 if tcm_result==0
replace xpertsputum=2 if tcm_result==1 | tcm_result==2 | tcm_result==3 | tcm_result==4 | tcm_result==5 | tcm_result==6 | tcm_result==7 | tcm_result==8
replace xpertsputum=3 if tcm_result==11 | tcm_result==12
replace xpertsputum=4 if tcm_result==.
label variable xpertsputum "Hasil pemeriksaan Xpert Sputum"
label define xpertsputum_lab 1 "Negative" 2 "Positive" 3 "Not done" 4 "Pending"
label values xpertsputum xpertsputum_lab

tab xpertsputum recloc, m col
tab xpertsputum recloc, col
tab tcm_result recloc, m col

br idsubject interv_dt initial rec_loc age sputum1 sputum2 tcm_result if tcm_result==.
sort interv_dt

tab semi_quant recloc if semi_quant~=0, col
tab culture_result recloc if culture_result~=0, m col
tab culture_result recloc if culture_result~=0, col
tab cult_ident, m
tab tb_treat recloc, m col

// characteristics patients aged 0-14 years old //
tab sex if month!=1 & agecat15==1, m
histogram age if agecat15==1, normal
sktest age if agecat15==1
summarize age if agecat15==1 & month!=1, d
generate agegroup3=.
replace agegroup3=1 if (age>=0 & age<5)
replace agegroup3=2 if (age>=5 & age<10)
replace agegroup3=3 if (age>=10 & age<15)
tab agegroup3 if agecat15==1 & month!=1, m
tab diag_tb if agecat15==1 & month!=1, m
tab cough if agecat15==1 & month!=1, m
tab cough_y if cough==1 & agecat15==1 & month!=1, m
summarize cough_y if cough==1 & agecat15==1 & month!=1, d
tab cxray if agecat15==1 & month!=1, m
list idsubject initial if cxray==. & agecat15==1
tab tcm_result if agecat15==1 & month!=1, m
list idsubject age sex tcm_result if agecat==1
tab culture_result if agecat15==1 & month!=1, m
tab culture_result if agecat15==1 & month!=1

// characteristics patients aged >= 15 years old //
tab category if agecat15==2 & month!=1, m
tab sex if agecat15==2 & month!=1, m
histogram age if agecat15==2, normal
sktest age if agecat15==2
summarize age if agecat15==2 & month!=1, d
tab diag_tb if agecat15==2 & month!=1, m
tab cough if agecat15==2, m
summarize cough_y if cough==1 & agecat15==2, d
generate bmicat=.
replace bmicat=1 if (bmi<18.5)
replace bmicat=2 if (bmi>=18.5 & bmi<=22.99999)
replace bmicat=3 if (bmi>=23.0 & bmi<=24.99999)
replace bmicat=4 if (bmi>=25.0 & bmi<.)
label define bmicatlab 1 "Underweight" 2 "Normal" 3 "Overweight" 4 "Obesity"
label values bmicat bmicatlab
tab bmicat if age>=18 & month!=1, m
tab cxray if agecat15==2 & month!=1, m
tab cxray if agecat15==2 & month!=1
list idsubject i nterv_dt rec_loc if (cxray==. | cxray==4) & agecat15==2
tab hiv if agecat15==2 & month!=1, m
list idsubject hiv if hiv==1
tab hiv_test if agecat15==2 & hiv_test!=., m
tab hiv_test if agecat15==2 & (hiv_test==0 | hiv_test==1), m
list idsubject age hiv hiv_test if hiv==1 | hiv_test==1

     +--------------------------------------------------------------------------------------------+
     | idsubj~t   age   initial                            rec_loc          hiv          hiv_test |
     |--------------------------------------------------------------------------------------------|
227. |  4100344    35        SM   Klinik Utama Dr. H. A. Rotinsulu           Ya           Positif |
287. |  4100381    71       YFH   Klinik Utama Dr. H. A. Rotinsulu   Tidak tahu           Positif |
290. |  4100383    30       YFH   Klinik Utama Dr. H. A. Rotinsulu   Tidak tahu           Positif |
369. |  4100533    22       YFH   Klinik Utama Dr. H. A. Rotinsulu   Tidak tahu           Positif |
385. |  4100540    25       YFH   Klinik Utama Dr. H. A. Rotinsulu   Tidak tahu           Positif |
     |--------------------------------------------------------------------------------------------|
389. |  4100544    20        SM   Klinik Utama Dr. H. A. Rotinsulu   Tidak tahu           Positif |
391. |  4100542    51       YFH   Klinik Utama Dr. H. A. Rotinsulu   Tidak tahu           Positif |
394. |  4100545    29       YFH   Klinik Utama Dr. H. A. Rotinsulu   Tidak tahu           Positif |
446. |  4100574    64       YFH   Klinik Utama Dr. H. A. Rotinsulu   Tidak tahu           Positif |
909. |  4100866    55       YFH                       PKM Pagarsih           Ya                 . |
     |--------------------------------------------------------------------------------------------|
914. |  4100492    80       KDP                    PKM Ciumbuleuit   Tidak tahu           Positif |
950. |  4101006    49       AHT                   PKM Astana Anyar           Ya   Tidak diperiksa |
     +--------------------------------------------------------------------------------------------+
 
gen hivstatus=.
replace hivstatus=0 if (hiv==0 & hiv_test==0) | (hiv==2 & hiv_test==0)
replace hivstatus=1 if (hiv==1 | hiv_test==1)
tab hivstatus, m
sort hivstatus
br hivstatus hiv hiv_test
tab hivstatus if hivstatus!=., m
tab hiv_test if agecat15==2 & month!=1, m
list idsubject hiv hiv_test hivstatus if hiv==1 | hiv_test==1

summarize poc_hba1c if agecat15==2 & poc_hba1c!=. & month!=1, d

codebook dm
0  Tidak
1  Ya
2  Tidak tahu

generate dmstatus=.
replace dmstatus=1 if dm==1 | poc_hba1c>=6.5
replace dmstatus=0 if (dm==0 & poc_hba1c<6.5) | (dm==2 & poc_hba1c<6.5)
tab dmstatus if agecat==2, m
list idsubject dm poc_hba1c dmstatus if agecat==2

gen dmhba1c=.
replace dmhba1c=0 if poc_hba1c<6.5
replace dmhba1c=1 if poc_hba1c>=6.5
tab dmhba1c if agecat==2 & poc_hba1c!=., m

tab tcm_result, m
gen xpertsputum=.
replace xpertsputum=0 if tcm_result==0
replace xpertsputum=1 if tcm_result==1 | tcm_result==2 | tcm_result==3 | tcm_result==4 | tcm_result==5 | tcm_result==6 | tcm_result==7 | tcm_result==8
label variable xpertsputum "Hasil pemeriksaan Xpert sputum"
label define xpertsputumlab 0 "Negative" 1 "Positive"
label values xpertsputum xpertsputumlab
tab xpertsputum if agecat15==2 & xpertsputum!=. & month!=1, m
list idsubject interv_dt sputum1 sputum2 initial if agecat15==2 & xpertsputum==.
list idsubject interv_dt initial if agecat15==2 & xpertsputum==.

tab tb_treat recloc, m col

// slide 2 //
tab culture_result, m
tab cult_ident
tab culture_result agecat, m col

// slide 2 //
//hasil kultur positif tapi MOTT harus diubah jadi negatif
gen culture_result2=999
browse culture_result cult_ident culture_result2
sort culture_result

//negative
replace culture_result2=1 if culture_result==1
replace culture_result2=1 if culture_result==3 & cult_ident==2
browse idsubject if culture_result==3 & cult_ident==2
sort idsubject
//20 MOTT

//positive
replace culture_result2=2 if culture_result==3 & cult_ident==1
replace culture_result2=2 if culture_result==3 & cult_ident==.

label define culture_result2 1 "negative" 2 "positive"
label values culture_result2 culture_result2

tab culture_result2 agecat, m col
tab culture_result2 agecat if culture_result2~=999, m col
list idsubject age rec_loc tcm_result semi_quant if culture_result2==2 & agecat==1
summarize age if culture_result2==1 | culture_result2==2, d
tab sex if culture_result2~=999, m
