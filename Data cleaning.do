// cek pasien baseline dan FU
tab redcap_event_name
// 1357 obs
// 1340 baseline
// 17 fu

// drop pasien di arm fu //
drop if redcap_event_name=="fu_arm_2"

sort interv_dt
br

//hitung jumlah pasien yang eligible//
tab willing, m
// total 1352 obs
// 1293 yes
// 55 no

// eksklusi pasien dgn riwayat TB dalam 2 tahun terakhir //
gen tbhistdur=interv_dt-diag_tb_y
sort tbhistdur
gen tbhist2years=.
replace tbhist2years=1 if tbhistdur<=730
replace tbhist2years=0 if tbhist2years!=1
br idsubject initial age birthdate diag_tb_y interv_dt tbhistdur tbhist2years
sort tbhistdur
replace tbhist2years=1 if idsubject==4100068
tab tbhist2years, m 
// 18 obs

// drop pasien eksklusi karena on OAT > 1 minggu //
drop if idsubject==4100074 | idsubject==4100455 | idsubject==4100689 | idsubject==4100974

// menghitung pasien yang menolak dan alasannya //
sort willing refusing idsubject

generate refusereason=.
replace refusereason=1 if refusing=="Sedang terburu-buru" | refusing=="Karena sudah ada hasil dan mau pulang " | refusing=="Sedang terburu-buru" | refusing=="Pasien diburu waktu karena harus ke faskes lain" | refusing=="Pasien sudah terlanjur pulang" | refusing=="Pasien tidak mau menunggu lama" | refusing=="Sedang terburu-buru" | refusing=="Takut lama nunggunya, karena mau cepat pulang" | refusing=="Tidak mau menunggu lama" | refusing=="sudah mau pulang " | refusing=="Orang tua sedang terburu-buru kerja" | refusing=="Terburu-buru pulang karena harus merawat orang tua yang sakit di rumah" | refusing=="Terburu-buru pulang karena ada kesibukan lain" | refusing=="Karena ingin cepat pulang, dan meneruma hasil bahwa anaknya terdiagnosis TB" | refusing=="Lagi buru-buru karena suami kerja dan dirumah ada yang sakit" | refusing=="Harus ke faskes selanjutnya" | refusing=="Lagi buru-buru karena suami kerja dan dirumah ada yang sakit" | refusing=="Sedang masa pemulihan dan setelah keluar dari RS banyak kegiatan " | refusing=="Karena sedang buru-buru& menunggu hasil pemeriksaan dokter" | refusing=="Pasien sedang terburu-buru" | refusing=="Karena ingin cepat pulang, dan menerima hasil bahwa anaknya terdiagnosis TB" | refusing=="Orang tua pasien sedang terburu-buru dan merasa sudah cukup dengan pemeriksaan DPJP" 
replace refusereason=2 if refusing=="Merasa tidak sehat" | refusing=="Badan terasa lemas dan pusing" | refusing=="Badan terasa lemas dan pusing" | refusing=="sedang masa pemulihan dan setelah keluar dari RS banyak kegiatan " | refusing=="pasien masih banyak tindakan yang dilakukan, takut drop dan kondisi lemas sehabis pungsi" | refusing=="pasien lemas, dari sumedang" | refusing=="pasien lemas, Terburu buru ingin pulang (dari sumedang)" | refusing=="Pasien masih banyak tindakan yang dilakukan, takut drop dan kondisi lemas sehabis pungsi"
replace refusereason=3 if refusing=="Takut diambil darah" | refusing=="Pasien merasa kurang nyaman" | refusing=="Takut disuntik" | refusing=="Cemas dan takut " | refusing=="Takut dilakukan pemeriksaan" | refusing=="Karena punya riwayat trauma ketika swab covid-19 jadi tidak mau diperiksa" | refusing=="Takut kesehatan menurun (drop) saat mengetahui hasil"
replace refusereason=4 if refusing=="Tidak terektrut" | refusing=="pasien datang hampir jam 3 sore, jadi tidak terekrut" | refusing=="sudah mau pulang" | refusing=="Pasien datang hampir jam 3 sore, jadi tidak terekrut"
replace refusereason=5 if refusing=="Ingin fokus ke pengobatan. Tidak diizinkan Suami" | refusing=="Keluarga tidak mengizinkan " | refusing=="Keluarga menolak" | refusing=="Ingin fokus ke pengobatan dan tidak boleh sama keluarga ikut dalam penelitian pengambilan sampel" | refusing=="Keluarga tidak menyetujui dan tidak kooperatif"
replace refusereason=7 if refusing=="karena keluhan sudah sembuh, tidak memerlukan pemeriksaan lain" | refusing=="Sudah pernah melakukan pemeriksaan kesehatan lengkap dan hasilnya sehat. Ingin menghabiskan obat dulu dari puskesmas."
replace refusereason=8 if refusing=="Pasien menyerahkan pemeriksaan kepada dokter dan tidak bersedia diambil sampel lagi" | refusing=="Tidak mau dilakukan pemeriksaan tambahan diluar dokter spesialis" | refusing=="Tidak berkenan diikut sertakan dalam kegiatan penelitian" | refusing=="Tidak mau diambil sampel pemeriksaan" | refusing=="Ingin fokus pemeriksaan yang disarankan oleh dokter" |refusing=="Tidak berkenan menjadi subjek penelitian" | refusing=="Tidak mau dilakukan pemeriksaan tambahan diluar prosedur DPJP"
replace refusereason=9 if refusing=="Tidak bersedia menjadi subjek penelitian dan hanya ingin melakukan pemeriksaan dari dokter" | refusing=="Tidak mau dilakukan pemeriksaan tambahan diluar DPJP" | refusing=="Sudah merasa cukup dengan pemeriksaan yang sudah diakukan sebeumnya" | refusing=="Karena sudah cukup dengan pemeriksaan dari dokter." | refusing=="Sudah merasa cukup dengan pemeriksaan yang sudah dilakukan sebelumnya" | refusing=="Tidak berkenan diikut sertakan dalam kegiatan penelitian."

br interv_dt idsubject willing rec_loc refusing refusereason
sort refusereason refusing

label define refusereasonlab 1 "Tidak ada waktu" 2 "Merasa tidak sehat" 3 "Takut diperiksa" 4 "Tidak terekrut" 5 "Keluarga menolak" 6 "Takut mengetahui hasil" 7 "Merasa sehat" 8 "Tidak mau diambil sampel" 9 "Tidak mau pemeriksaan tambahan"
label values refusereason refusereasonlab

tab refusereason, m

// drop pasien dgn riw TB 2 tahun //
drop if tbhist2years==1

// hitung jumlah pasien per kategori umur //
//membagi pasien menjadi 2 kategori umur (cutoff 15 tahun) //
generate agecat15=.
replace agecat15=1 if age<15
replace agecat15=2 if age>=15
label define agecat15lab 1 "Usia 0-14 tahun" 2 "Usia 15+ tahun"
label values agecat15 agecat15lab
tab willing agecat15, m col

br
sort interv_dt

// membagi pasien jadi rspr, ku cibadak, dan pkm //
gen recloc=.
replace recloc=1 if rec_loc==1
replace recloc=2 if rec_loc==2
replace recloc=3 if rec_loc~=1 & rec_loc~=2
label define recloclab 1 "RSPR" 2 "KU Cibadak" 3 "PKM"
label values recloc recloclab
tab willing recloc, m col

tab recloc agecat, m

// membuat bulan dan tahun //
gen month = ym(year(interv_dt), month(interv_dt))
format month %tm

// membuat tahun dan hitung rekrutmen per tahun //
gen year = year(interv_dt)
tab willing rec_loc if year==2024 & agecat==1
tab willing rec_loc if year==2024 & agecat==2
tab willing rec_loc if year==2024
tab willing rec_loc if year==2025 & agecat==1
tab willing rec_loc if year==2025 & agecat==2
tab willing rec_loc if year==2025

// membagi pasien per bulan //
generate month=.
replace month=8 in 1/43
replace month=9 in 44/129
replace month=10 in 130/268
replace month=11 in 269/395
replace month=12 in 396/501
replace month=1 in 502/596
replace month=2 in 597/696
replace month=3 in 697/788
replace month=4 in 789/934
replace month=5 in 935/1058
replace month=6 in 1059/1166
replace month=7 in 1167/1272
replace month=19 in 1273/1317

// hitung rekrutmen pasien per bulan //
// agustus
tab willing recloc if month==8 & agecat==1
tab willing recloc if month==8 & agecat==2
tab willing recloc if month==8
// september
tab willing recloc if month==9 & agecat==1
tab willing recloc if month==9 & agecat==2
tab willing recloc if month==9
// oktober
tab willing recloc if month==10 & agecat==1
tab willing recloc if month==10 & agecat==2
tab willing recloc if month==10
// november
tab willing recloc if month==11 & agecat==1
tab willing recloc if month==11 & agecat==2
tab willing recloc if month==11
// desember
tab willing recloc if month==12 & agecat==1
tab willing recloc if month==12 & agecat==2
tab willing recloc if month==12
// januari
tab willing recloc if month==1 & agecat==1
tab willing recloc if month==1 & agecat==2
tab willing recloc if month==1
// februari
tab willing recloc if month==2 & agecat==1
tab willing recloc if month==2 & agecat==2
tab willing recloc if month==2
// maret
tab willing recloc if month==3 & agecat==1
tab willing recloc if month==3 & agecat==2
tab willing recloc if month==3
// april
tab willing recloc if month==4 & agecat==1
tab willing recloc if month==4 & agecat==2
tab willing recloc if month==4
// mei
tab willing recloc if month==5 & agecat==1
tab willing recloc if month==5 & agecat==2
tab willing recloc if month==5
// juni
tab willing recloc if month==6 & agecat==1
tab willing recloc if month==6 & agecat==2
tab willing recloc if month==6
// juli
tab willing recloc if month==7 & agecat==1
tab willing recloc if month==7 & agecat==2
tab willing recloc if month==7
// september
tab willing recloc if month==19 & agecat==1
tab willing recloc if month==19 & agecat==2
tab willing recloc if month==19
// total
tab willing recloc if agecat==1, col
tab willing recloc if agecat==2, col
tab willing, m
tab willing agecat, m

// aug 2024 - apr 2025
tab willing recloc if (month==8 | month==9 | month==10 | month==11 | month==12 | month==1 | month==2 | month==3 | month==4) & agecat==1
tab willing recloc if (month==8 | month==9 | month==10 | month==11 | month==12 | month==1 | month==2 | month==3 | month==4) & agecat==2
tab willing recloc if (month==8 | month==9 | month==10 | month==11 | month==12 | month==1 | month==2 | month==3 | month==4)

// rekrutmen per jenis fasyankes lebih rinci //
// total
tab willing rec_loc if agecat==1, col
tab willing rec_loc if agecat==2, col
tab willing, m
tab willing agecat, m

// membuang pasien yang tidak consent // 
drop if willing==0

// data cleaning //
tab sex willing, m
tab marital, m
// ID 4100055 dan 4100056 tidak terekrut jadi tidak ada datanya
tab children, m
list idsubject if children==.
tab hh_member, m
list idsubject if hh_member==.
tab educ, m
list idsubject if educ==.
tab job, m
list idsubject initial if job==.
tab othjob if job==1, m
tab rec_loc, m
tab referr_hc, m
tab category, m
tab willing, m

*normalitas checking for age variable
*visually
histogram age, normal
sktest age

summarize age, d
codebook age

tab agecat15, m

drop if willing==0
tab cough, m
tab cough_y if cough==1, m
summarize cough_y if cough==1, d
tab sweatnight, m
tab fever, m
tab chestpain, m
tab weak, m
tab outbreath, m
tab weightloss, m
tab hemoptysis, m
tab dec_appetite, m

tab diag_tb, m
tab diag_tb_y if diag_tb==1
sort diag_tb_y
list idsubject diag_tb_y interv_dt if diag_tb==1

tab contact, m
tab contact_y if contact==1
sort contact_y
list idsubject initial birthdate contact_y interv_dt if contact==1
gen kontak_sebelum_lahir = contact_y < birthdate
list idsubject initial birthdate contact_y if kontak_sebelum_lahir == 1
tab hiv, m
tab dm, m
tab smoke, m
tab bcg_scar, m
tab weight, m
summarize weight, d
sort weight
list idsubject weight height upper_armc if weight>60
tab height, m
summarize height, d
tab bmi, m
list idsubject age weight height bmi if bmi<=15
list idsubject age weight height bmi if bmi>=30
generate bmicat=.
replace bmicat=1 if (bmi<18.5)
replace bmicat=2 if (bmi>=18.5 & bmi<=22.99999)
replace bmicat=3 if (bmi>=23.0 & bmi<=24.99999)
replace bmicat=4 if (bmi>=25.0 & bmi<.)
tab agecat2
tab bmicat if age>=18, m

tab upper_armc, m
summarize upper_armc, d
sort upper_armc
list idsubject weight upper_armc if upper_armc>25 & upper_armc!=.
tab systolicbp, m
list idsubject age initial systolicbp if (systolicbp<60 | systolicbp >190) & systolicbp!=. & systolicbp!=0
list idsubject initial systolicbp if (systolicbp<60 | systolicbp >190) & systolicbp!=. & systolicbp!=0
list idsubject age initial if systolicbp==.

     | idsubj~t   age   initial |
     |--------------------------|
  1. |  4100327     5        SM |
 16. |  4100735     1        SM |
 17. |  4100738     1        SM |
 21. |  4100764     2        SM |
 24. |  4100524     2        SM |
     |--------------------------|
 26. |  4100380     3        SM |
 27. |  4100773     1        SM |
 29. |  4100550     1        SM |
 38. |  4100725     1        SM |
 42. |  4100727     1       SDL |
     |--------------------------|
 43. |  4100564     7        SM |
 48. |  4100553     5        SM |
 51. |  4100771     2        SM |
 54. |  4100753     1        SM |
 56. |  4100770     1        SM |
     |--------------------------|
 59. |  4100355     1        SM |
 69. |  4100726     1        SM |
 97. |  4100352     4        SH |
182. |  4100538     2        SM |
548. |  4100539     1        SM |
     |--------------------------|
578. |  4100111     9       YFH |
588. |  4100101     1        SH |
597. |  4100133     8       YFH |
626. |  4100583     4        SM |
648. |  4100040     5        SM |
     +--------------------------+

summarize systolicbp , d
tab diastolicbp, m
summarize diastolicbp , d
list idsubject age initial if diastolicbp==.

 
     +--------------------------+
     | idsubj~t   age   initial |
     |--------------------------|
  1. |  4100327     5        SM |
 16. |  4100735     1        SM |
 17. |  4100738     1        SM |
 21. |  4100764     2        SM |
 24. |  4100524     2        SM |
     |--------------------------|
 26. |  4100380     3        SM |
 27. |  4100773     1        SM |
 29. |  4100550     1        SM |
 38. |  4100725     1        SM |
 42. |  4100727     1       SDL |
     |--------------------------|
 43. |  4100564     7        SM |
 48. |  4100553     5        SM |
 51. |  4100771     2        SM |
 54. |  4100753     1        SM |
 56. |  4100770     1        SM |
     |--------------------------|
 59. |  4100355     1        SM |
 69. |  4100726     1        SM |
 97. |  4100352     4        SH |
182. |  4100538     2        SM |
548. |  4100539     1        SM |
     |--------------------------|
578. |  4100111     9       YFH |
588. |  4100101     1        SH |
597. |  4100133     8       YFH |
626. |  4100583     4        SM |
648. |  4100040     5        SM |
     +--------------------------+

tab pulse, m
list idsubject initial age if pulse==.
summarize pulse, d
histogram pulse, normal
sktest pulse
list idsubject initial age pulse if pulse<60

     | idsubj~t   initial   age   pulse |
     |----------------------------------|
 32. |  4100038        SM    19      46 |
 54. |  4100065        SM    42      20 |
140. |  4100163       YFH    48      54 |
366. |  4100403       ADR    58      49 |


tab resp, m
list idsubject initial age if resp==.

     | idsubj~t   age   initial |
     |--------------------------|
265. |  4100299    19       RVT |
438. |  4100524     2        SM |
451. |  4100538     2        SM |
452. |  4100539     1        SM |
466. |  4100553     5        SM |
     |--------------------------|
483. |  4100571     8        SM |
494. |  4100583     4        SM |
     +--------------------------+

summarize resp, d
histogram resp, normal
sktest resp
list idsubject initial age resp if resp>=40

      +---------------------------------+
      | idsubj~t   initial   age   resp |
      |---------------------------------|
 504. |  4101024        SM     6      . |
1205. |  4100958       HAR     0     40 |
1268. |  4101453               .      . |
1269. |  4101304       HAR    65      . |
1270. |  4101270        SM     1      . |
      |---------------------------------|
1271. |  4101271        SM     1      . |
1272. |  4101440               .      . |
1273. |  4101339               .      . |
1274. |  4101452               .      . |
      +---------------------------------+

tab spo2, m
list idsubject initial age if spo2==. & age>=4

     | idsubj~t   initial   age |
     |--------------------------|
265. |  4100299       RVT    19 |
451. |  4100538        SM     2 |
452. |  4100539        SM     1 |
466. |  4100553        SM     5 |
494. |  4100583        SM     4 |

summarize spo2, d
hist spo2, normal
sktest spo2

tab cxray, m

Hasil pembacaan rontgen |
                   dada |      Freq.     Percent        Cum.
------------------------+-----------------------------------
                 Normal |        152       12.05       12.05
      Sugestif TB aktif |        597       47.34       59.40
       Sugestif TB lama |         50        3.97       63.36
Tidak normal - bukan TB |        408       32.36       95.72
   Menolak rontgen dada |         13        1.03       96.75
                      . |         41        3.25      100.00
------------------------+-----------------------------------
                  Total |      1,261      100.00

sort interv_dt
list idsubject initial interv_dt if cxray==.

tab tuberc_done if age<=18, m
list idsubject age initial if tuberc_done==.
tab tuberc_dt if tuberc_done==1, m
list idsubject initial age tuberc_done tuberc_dt if tuberc_dt==. & tuberc_done==1

     +------------------------------------------------+
     | idsubj~t   initial   age   tuberc~e   tuberc~t |
     |------------------------------------------------|
470. |  4100538        SM     2         Ya          . |
523. |  4100593        SM    11         Ya          . |
567. |  4100733        SM    11         Ya          . |
     +------------------------------------------------+

tab tuberc_read, m	
tab tuberc_read if tuberc_done==1, m 
list idsubject if tuberc_done==1 & tuberc_read==.
     +----------+
     | idsubj~t |
     |----------|
470. |  4100538 |
523. |  4100593 |
567. |  4100733 |
     +----------+

tab tuberc_res, m
tab tuberc_res if tuberc_done==1, m
sort interv_dt 
list idsubject initial interv_dt if tuberc_done==1 & tuberc_res==.

     | idsubj~t   initial           interv_dt |
     |----------------------------------------|
160. |  4100176        SM     October 7, 2024 |
219. |  4100317        SH    October 18, 2024 |
242. |  4100215       KDP    October 23, 2024 |
244. |  4100327        SM    October 24, 2024 |
284. |  4100346        SM    October 31, 2024 |
     |----------------------------------------|
298. |  4100356        SH    November 4, 2024 |
311. |  4100370        SM    November 6, 2024 |
319. |  4100377        SM    November 7, 2024 |
335. |  4100253       RVT   November 11, 2024 |
361. |  4100399        SM   November 18, 2024 |
     |----------------------------------------|
395. |  4100515       SM    November 25, 2024 |
407. |  4100519        SM   November 28, 2024 |
409. |  4100520        SM   November 28, 2024 |
433. |  4100535        SM    December 5, 2024 |
457. |  4100538        SM   December 11, 2024 |

tab sputum1, m

list idsubject age initial interv_dt sputum1 sputum1_rfs sputum1_dt sputum2 tcm_result if sputum1==. 
.

tab sputum1_rfs, m
tab sputum1_dt, m
list idsubject initial if sputum1==1 & sputum1_dt==. | sputum1==2 & sputum1_dt==. | sputum1==3 & sputum1_dt==.

tab sputum2, m
list idsubject initial interv_dt tcm_result if sputum2==.

tab sputum2_rfs, m
tab sputum2_dt, m

tab tcm_type if tcm_result~=., m
sort tcm_result
br idsubject interv_dt rec_loc tcm_type tcm_result if (tcm_type==. & tcm_result~=.) | (tcm_type~=. & tcm_result==.)
tab tcm_dt, m
list idsubject if tcm_dt==. & tcm_type!=.

tab tcm_result, m

list idsubject age initial interv_dt sputum1 sputum2 if tcm_result==.
list idsubject age initial interv_dt if tcm_result==.

     +--------------------------------------------------------------------------------------+
     | idsubj~t   age   initial           interv_dt             sputum1             sputum2 |
     |--------------------------------------------------------------------------------------|
346. |  4100507    63       YFH   November 19, 2024   Ya, dahak sewaktu   Ya, dahak sewaktu |
347. |  4100508    59        SM   November 19, 2024   Ya, dahak sewaktu   Ya, dahak sewaktu |
493. |  4100592    27       YFH     January 6, 2025   Ya, dahak sewaktu   Ya, dahak sewaktu |
497. |  4100590    16        SM     January 6, 2025   Ya, dahak sewaktu   Ya, dahak sewaktu |
498. |  4100593    11        SM     January 6, 2025   Ya, dahak sewaktu   Ya, dahak sewaktu |
     |--------------------------------------------------------------------------------------|
502. |  4100595    64        SM     January 7, 2025   Ya, dahak sewaktu   Ya, dahak sewaktu |
503. |  4100596    65        SM     January 7, 2025   Ya, dahak sewaktu   Ya, dahak sewaktu |
504. |  4100594    51       YFH     January 7, 2025   Ya, dahak sewaktu   Ya, dahak sewaktu |
506. |  4100442    45       KDP     January 7, 2025      Ya, dahak pagi      Ya, dahak pagi |

// BLOOD EXAMINATION //
tab blood_test, m
list idsubject if blood_test==1 & hemoglobin==.
tab hemoglobin, m
summarize hemoglobin, d
list idsubject hemoglobin if hemoglobin>15 & hemoglobin!=.
tab leukocytes
summarize leukocytes, d
tab platelets
summarize platelets, d
tab hematocrit
summarize hematocrit, d
tab hiv_test, m
list idsubject initial hiv hiv_test if hiv==1 | hiv_test==1
list idsubject hiv_test blood_test if hiv_test==.

tab poc_hba1c, m
list idsubject if poc_hba1c==.
sum poc_hba1c, d
generate dmstatus=.
replace dmstatus=0 if poc_hba1c<6.5 & poc_hba1c>1
replace dmstatus=1 if poc_hba1c>=6.5 & poc_hba1c<15
tab dmstatus if poc_hba1c!=., m
list idsubject rec_loc dm poc_hba1c if poc_hba1c >6.5 & poc_hba1c!=. & dm==0

     | idsubj~t                                rec_loc      dm   poc_h~1c |
     |--------------------------------------------------------------------|
 20. |  4100025   Rumah Sakit Paru Dr. H. A. Rotinsulu   Tidak        8.9 |
 37. |  4100043   Rumah Sakit Paru Dr. H. A. Rotinsulu   Tidak          9 |
 96. |  4100115       Klinik Utama Dr. H. A. Rotinsulu   Tidak       12.4 |
114. |  4100136       Klinik Utama Dr. H. A. Rotinsulu   Tidak        6.9 |
162. |  4100185       Klinik Utama Dr. H. A. Rotinsulu   Tidak       12.8 |
     |--------------------------------------------------------------------|
166. |  4100189       Klinik Utama Dr. H. A. Rotinsulu   Tidak       11.9 |
177. |  4100200       Klinik Utama Dr. H. A. Rotinsulu   Tidak       10.3 |
259. |  4100325       Klinik Utama Dr. H. A. Rotinsulu   Tidak        8.4 

sort age
list idsubject age dmstatus poc_hba1c if dmstatus==1
tab leukocytes, m
list idsubject if leukocytes==.
sum leukocytes, d
sum platelets, d
sum lymphocytes, d
sort lymphocytes
list idsubject lymphocytes if lymphocytes<20 &lymphocytes!=.

// SPUTUM EXAMINATION //
generate produce_sputum=.
replace produce_sputum=1 if sputum1==1 | sputum1==2 | sputum1==3 | sputum2==1 | sputum2==2 | sputum2==3
replace produce_sputum=0 if produce_sputum!=1

tab tcm_result, m
sort idsubject
list idsubject initial interv_dt rec_loc age sputum1 sputum2 if tcm_result==.
 
tab tcm_na
Jika Not Done pemeriksaan TCM, sebutkan |
                              alasannya |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
Pasien mengeluarkan air liur bukan da.. |          1       25.00       25.00
   Pasien tidak bisa mengeluarkan dahak |          1       25.00       50.00
         Tidak dapat mengeluarkan dahak |          1       25.00       75.00
          tidak bisa mengeluarkan dahak |          1       25.00      100.00
----------------------------------------+-----------------------------------
                                  Total |          4      100.00
tab tcm_result, m
tab tcm_result agecat2, m
                      |        agecat2
Hasil pemeriksaan TCM |         1          2 |     Total
----------------------+----------------------+----------
     MTB Not Detected |         3         72 |        75 
MTB Detected, Rif Res |         0         23 |        23 
MTB Detected, Rif Res |         0          6 |         6 
MTB Detected, Rif Res |         0          1 |         1 
MTB Trace Detected, R |         1          3 |         4 
             Not Done |         3          1 |         4 
                    . |         0         15 |        15 
----------------------+----------------------+----------
                Total |         7        121 |       128 

list idsubject if tcm_result==8 & agecat2==2
*3 pasien anak, 1 pasien dewasa mengeluarkan air liur

generate mtbdetected=.
replace mtbdetected=0 if tcm_result==0 | tcm_result==9 | tcm_result==10 | tcm_result==11 | tcm_result==12
replace mtbdetected=1 if tcm_result==1 | tcm_result==2 | tcm_result==3 | tcm_result==4 | tcm_result==5 | tcm_result==6 | tcm_result==7 | tcm_result==3 | tcm_result==8

tab mtbdetected, m

tab semi_quant if mtbdetected==1, m


     Hasil semi |
   quantitative |      Freq.     Percent        Cum.
----------------+-----------------------------------
          Trace |         13        8.90        8.90
       Very low |         13        8.90       17.81
            Low |         38       26.03       43.84
         Medium |         15       10.27       54.11
           High |         47       32.19       86.30
              . |         20       13.70      100.00
----------------+-----------------------------------
          Total |        146      100.00

list idsubject initial if semi_quant==. & mtbdetected==1		  
		  
tab culture_result if produce_sputum==1, m
list idsubject age initial interv_dt if culture_result==. & produce_sputum==1
tab res_xpertultra, m
tab res_fujilam, m
tab cat_tbtest, m
tab tb_treat, m

// pemeriksaan tes indeks //
tab res_xpertultra
sort res_xpertultra
br res_xpertultra
tab res_fujilam
tab res_sput_pluslife
tab res_swab_pluslife