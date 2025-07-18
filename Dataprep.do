//5 Juni 2025
//Data preparation

clear
use "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250315 WP1 data.dta", clear

//Cek data total baseline dan follow-up
browse
//obs=1,101

//BASELINE DATA
keep if redcap_event_name=="baseline_arm_1"
//obs=1,084

tab willing
//Ya=1,032, Tidak=52

tab refusing
sort refusing
gen refuse_cat=999
sort refuse_cat
browse refusing refuse_cat if willing==0
//missing
replace refuse_cat=. if refusing==""

//tidak ada waktu
replace refuse_cat=1 if refusing=="Sedang terburu-buru" | refusing=="Pasien diburu waktu karena harus ke faskes lain" | refusing=="sedang masa pemulihan dan setelah keluar dari RS banyak kegiatan " | refusing=="sudah mau pulang "
replace refuse_cat=1 if refusing=="Karena ingin cepat pulang, dan meneruma hasil bahwa anaknya terdiagnosis TB"
replace refuse_cat=1 if refusing=="Karena sudah ada hasil dan mau pulang "
replace refuse_cat=1 if refusing=="Lagi buru-buru karena suami kerja dan dirumah ada yang sakit"
replace refuse_cat=1 if refusing=="Orang tua sedang terburu-buru kerja"
replace refuse_cat=1 if refusing=="Terburu-buru pulang karena harus merawat orang tua yang sakit di rumah"
replace refuse_cat=1 if refusing=="Pasien tidak mau menunggu lama"
replace refuse_cat=1 if refusing=="Terburu-buru pulang karena ada kesibukan lain"
replace refuse_cat=1 if refusing=="Takut lama nunggunya, karena mau cepat pulang"
replace refuse_cat=1 if refusing=="Tidak mau menunggu lama"
replace refuse_cat=1 if refusing=="Harus ke faskes selanjutnya"

//merasa sakit/tidak nyaman
replace refuse_cat=2 if refusing=="Badan terasa lemas dan pusing" | refusing=="Pasien merasa kurang nyaman" | refusing=="Takut kesehatan menurun (drop) saat mengetahui hasil"
replace refuse_cat=2 if refusing=="pasien lemas, dari sumedang"

//takut
replace refuse_cat=3 if refusing=="Takut diambil darah" | refusing=="Takut disuntik" | refusing=="Cemas dan takut "
replace refuse_cat=3 if refusing=="Karena punya riwayat trauma ketika swab covid-19 jadi tidak mau diperiksa"
replace refuse_cat=3 if refusing=="pasien masih banyak tindakan yang dilakukan, takut drop dan kondisi lemas sehabis pungsi"
replace refuse_cat=3 if refusing=="Takut dilakukan pemeriksaan"

//keluarga menolak
replace refuse_cat=4 if refusing=="Keluarga tidak mengizinkan " | refusing=="Ingin fokus ke pengobatan dan tidak boleh sama keluarga ikut dalam penelitian pengambilan sampel"
replace refuse_cat=4 if refusing=="Ingin fokus ke pengobatan. Tidak diizinkan Suami" | refusing=="Keluarga menolak"
replace refuse_cat=4 if refusing=="Keluarga tidak menyetujui dan tidak kooperatif"

//merasa tidak perlu pemeriksaan tambahan
replace refuse_cat=5 if refusing=="karena keluhan sudah sembuh, tidak memerlukan pemeriksaan lain"
replace refuse_cat=5 if refusing=="Pasien menyerahkan pemeriksaan kepada dokter dan tidak bersedia diambil sampel lagi"
replace refuse_cat=5 if refusing=="Tidak mau dilakukan pemeriksaan tambahan diluar dokter spesialis"
replace refuse_cat=5 if refusing=="Sudah pernah melakukan pemeriksaan kesehatan lengkap dan hasilnya sehat. Ingin menghabiskan obat dulu dari puskesmas."
replace refuse_cat=5 if refusing=="Ingin fokus pemeriksaan yang disarankan oleh dokter"
replace refuse_cat=5 if refusing=="Tidak mau diambil sampel pemeriksaan"

//tidak mau ikut penelitian
replace refuse_cat=6 if refusing=="Tidak berkenan menjadi subjek penelitian"

//Tidak terekrut
replace refuse_cat=9 if refusing=="Tidak terektrut" | refusing=="pasien datang hampir jam 3 sore, jadi tidak terekrut" | refusing=="Pasien sudah terlanjur pulang"

//Riwayat TB dalam 2 tahun terakhir
// eksklusi pasien dgn riwayat TB dalam 2 tahun terakhir //
gen tbhistdur=interv_dt-diag_tb_y
sort tbhistdur
gen tbhist2years=.
replace tbhist2years=1 if tbhistdur<=730
replace tbhist2years=0 if tbhist2years!=1
br idsubject initial age birthdate diag_tb_y interv_dt tbhistdur tbhist2years
sort diag_tb_y interv_dt
replace tbhist2years=1 if idsubject==4100068
tab tbhist2years, m 
// 19 obs

label drop refuse_cat
label define refuse_cat 1 "Tidak ada waktu" 2 "Merasa sakit/tidak nyaman" 3 "Takut" 4 "Keluarga menolak" 5 "Merasa tidak memerlukan pemeriksaan tambahan" 6 "tidak berkenan menjadi subjek penelitian" 9 "Tidak terekrut" 10 "Riwayat TB<2th"
label values refuse_cat refuse_cat
tab refuse_cat if willing==0, m
tab refuse_cat, m

save "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250315 WP1 data_baseline.dta"

//FOLLOW-UP
clear
use "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250315 WP1 data.dta", clear
keep if redcap_event_name=="fu_arm_2"
//12 obs
save "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250315 WP1 data_fu.dta"

//MERGING BASELINE AND FOLLOW-UP
clear
use "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250115 WP1 data_baseline.dta"
merge 1:1 idsubject using "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250115 WP1 data_fu.dta"

Result                      Number of obs
    -----------------------------------------
    Not matched                           758
        from master                       758  (_merge==1)
        from using                          0  (_merge==2)

    Matched                                12  (_merge==3)
    -----------------------------------------

save "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250315 WP1 eligible.dta"

//then go to the preliminary results (pluslife) do file

//Table 1
drop if willing==0 | refuse_cat==10

//obs=515
tab sex, m
sktest age
//p=0.09 normal hampir skewed
sum age, d
gen age_group=999
browse age age_group
sort age
//children=0-14 years, adults=15+//
replace age_group=1 if age<15
replace age_group=2 if age>=15
label define age_group 1 "0-14" 2 "15+"
label values age_group age_group
tab age_group, m

//recruitment location and month
sort interv_dt
browse interv_dt age_group rec_loc if rec_loc==1 & age_group==1
browse interv_dt age_group rec_loc if rec_loc==2 & age_group==1
browse interv_dt age_group rec_loc if rec_loc==1 & age_group==2
browse interv_dt age_group rec_loc if rec_loc==2 & age_group==2

save "C:\Users\rcund\Documents\1. EVIDENT\1. WP1 - Clinical Validation Studies\Data\20250212 WP1 data_eligible.dta"

---

tab diag_tb, m
browse idsubject initial if diag_tb==.
tab contact, m
browse idsubject initial if contact==.
tab hiv, m
tab dm, m
browse idsubject initial if dm==.
tab smoke, m

tab cough, m
sktest cough_y
//p<0.001, skewed
sum cough_y, d
browse idsubject initial if cough_y==.
tab fever, m
browse idsubject initial if fever==.
tab sweatnight, m
browse idsubject initial if sweatnight==.
tab weightloss, m
browse idsubject initial if weightloss==.
tab chestpain, m
browse idsubject initial if chestpain==.
tab weak, m
browse idsubject initial if weak==.
tab outbreath, m
browse idsubject initial if outbreath==.
tab oth_hist, m
browse idsubject initial if oth_hist==.

tab bcg_scar, m
browse idsubject initial if bcg_scar==.
sktest weight
//p=0.32
sum weight, d
browse idsubject initial if weight==.
sktest height
//p<0.001
sum height, d
browse idsubject initial if height==.
sktest systolicbp
//p=0.04
sum systolicbp, d
browse idsubject initial if systolicbp==.
sktest diastolicbp
//p=0.036
sum diastolicbp, d
sort diastolicbp
browse diastolicbp initial idsubject

sktest pulse
//p=0.096
sum pulse, d
sort pulse
browse pulse initial idsubject

sktest spo2
//p=0,0003
sum spo2, d
browse idsubject initial if spo2==.

tab cxray, m
browse idsubject initial if cxray==.

tab hiv_test, m

sktest poc_hba1c
p<0.001
sum poc_hba1c, d

sktest hemoglobin
p<0.001
sum hemoglobin, d
browse idsubject initial if hemoglobin==37.5

sktest leukocytes
p<0.001
sum leukocytes, d  
sort leukocytes
browse idsubject leukocytes

sktest platelets
sum platelets, d
sort platelets
browse idsubject platelets 

sktest lymphocytes
p<0.001
sum lymphocytes, d
sum crp_hs, d
sum crp, d

tab sputum1, m
browse idsubject initial if sputum1==.
tab sputum2, m
browse idsubject initial if sputum2==.

tab tcm_result, m
tab semi_quant, m
browse tcm_result semi_quant
sort tcm_result
tab culture_result, m

tab res_xpertultra, m
tab res_fujilam, m
tab tb_treat, m

