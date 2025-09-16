// progress report mingguan //

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
tab hiv_status recloc if hiv_status~=2 & hiv_status~=999, m col
list idsubject age initial rec_loc hiv hiv_tes if hiv==1 | hiv_test==1

