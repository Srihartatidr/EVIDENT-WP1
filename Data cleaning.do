// cek pasien baseline dan FU
tab redcap_event_name
// 1143 obs
// 17 fu

// drop pasien di arm fu //
drop if redcap_event_name=="fu_arm_2"

sort interv_dt
br

//hitung jumlah pasien yang eligible dan consent //
tab willing, m
// 1170 yes
// 53 no

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

// menghitung pasien yang menolak dan alasannya //
sort willing refusing idsubject

generate refusereason=.
replace refusereason=1 if refusing=="Sedang terburu-buru" | refusing=="Karena sudah ada hasil dan mau pulang " | refusing=="Sedang terburu-buru" | refusing=="Pasien diburu waktu karena harus ke faskes lain" | refusing=="Pasien sudah terlanjur pulang" | refusing=="Pasien tidak mau menunggu lama" | refusing=="Sedang terburu-buru" | refusing=="Takut lama nunggunya, karena mau cepat pulang" | refusing=="Tidak mau menunggu lama" | refusing=="sudah mau pulang " | refusing=="Orang tua sedang terburu-buru kerja" | refusing=="Terburu-buru pulang karena harus merawat orang tua yang sakit di rumah" | refusing=="Terburu-buru pulang karena ada kesibukan lain" | refusing=="Karena ingin cepat pulang, dan meneruma hasil bahwa anaknya terdiagnosis TB" | refusing=="Lagi buru-buru karena suami kerja dan dirumah ada yang sakit" | refusing=="Harus ke faskes selanjutnya" | refusing=="Lagi buru-buru karena suami kerja dan dirumah ada yang sakit" | refusing=="Sedang masa pemulihan dan setelah keluar dari RS banyak kegiatan " | refusing=="Karena sedang buru-buru& menunggu hasil pemeriksaan dokter" | refusing=="Pasien sedang terburu-buru" 
replace refusereason=2 if refusing=="Merasa tidak sehat" | refusing=="Badan terasa lemas dan pusing" | refusing=="Badan terasa lemas dan pusing" | refusing=="sedang masa pemulihan dan setelah keluar dari RS banyak kegiatan " | refusing=="pasien masih banyak tindakan yang dilakukan, takut drop dan kondisi lemas sehabis pungsi" | refusing=="pasien lemas, dari sumedang" | refusing=="pasien lemas, Terburu buru ingin pulang (dari sumedang)"
replace refusereason=3 if refusing=="Takut diambil darah" | refusing=="Pasien merasa kurang nyaman" | refusing=="Takut disuntik" | refusing=="Cemas dan takut " | refusing=="Takut dilakukan pemeriksaan" | refusing=="Karena punya riwayat trauma ketika swab covid-19 jadi tidak mau diperiksa"
replace refusereason=4 if refusing=="Tidak terektrut" | refusing=="pasien datang hampir jam 3 sore, jadi tidak terekrut" | refusing=="sudah mau pulang"
replace refusereason=5 if refusing=="Ingin fokus ke pengobatan. Tidak diizinkan Suami" | refusing=="Keluarga tidak mengizinkan " | refusing=="Keluarga menolak" | refusing=="Ingin fokus ke pengobatan dan tidak boleh sama keluarga ikut dalam penelitian pengambilan sampel" | refusing=="Keluarga tidak menyetujui dan tidak kooperatif"
replace refusereason=6 if refusing=="Takut kesehatan menurun (drop) saat mengetahui hasil"
replace refusereason=7 if refusing=="karena keluhan sudah sembuh, tidak memerlukan pemeriksaan lain" | refusing=="Sudah pernah melakukan pemeriksaan kesehatan lengkap dan hasilnya sehat. Ingin menghabiskan obat dulu dari puskesmas."
replace refusereason=8 if refusing=="Pasien menyerahkan pemeriksaan kepada dokter dan tidak bersedia diambil sampel lagi" | refusing=="Tidak mau dilakukan pemeriksaan tambahan diluar dokter spesialis" | refusing=="Tidak berkenan diikut sertakan dalam kegiatan penelitian" | refusing=="Tidak mau diambil sampel pemeriksaan" | refusing=="Ingin fokus pemeriksaan yang disarankan oleh dokter" |refusing=="Tidak berkenan menjadi subjek penelitian" | refusing=="Tidak mau dilakukan pemeriksaan tambahan diluar prosedur DPJP"
replace refusereason=9 if refusing=="Tidak bersedia menjadi subjek penelitian dan hanya ingin melakukan pemeriksaan dari dokter" | refusing=="Tidak mau dilakukan pemeriksaan tambahan diluar DPJP" | refusing=="Sudah merasa cukup dengan pemeriksaan yang sudah diakukan sebeumnya" | refusing=="Karena sudah cukup dengan pemeriksaan dari dokter." | refusing=="Sudah merasa cukup dengan pemeriksaan yang sudah dilakukan sebelumnya"

br interv_dt idsubject willing rec_loc refusing refusereason
sort refusereason refusing

label define refusereasonlab 1 "Tidak ada waktu" 2 "Merasa tidak sehat" 3 "Takut diperiksa" 4 "Tidak terekrut" 5 "Keluarga menolak" 6 "Takut mengetahui hasil" 7 "Merasa sehat" 8 "Tidak mau diambil sampel" 9 "Tidak mau pemeriksaan tambahan"
label values refusereason refusereasonlab

tab refusereason, m

// drop pasien dgn riw TB 2 tahun //
drop if tbhist2years==1

// drop pasien eksklusi karena on OAT > 1 minggu //
drop if idsubject==4100074 | idsubject==4100455 | idsubject==4100689 | idsubject==4100974

// hitung jumlah pasien per kategori umur //
//membagi pasien menjadi 2 kategori umur (cutoff 15 tahun) //
generate agecat=.
replace agecat=1 if age<15
replace agecat=2 if age>=15
label define agecatlab 1 "Usia 0-14 tahun" 2 "Usia 15+ tahun"
label values agecat agecatlab
tab willing agecat, m col

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

// membagi pasien menjadi sampling 30 detik //
gen sampling30= .
replace sampling30=0 if interv_dt<td(30jan2025)
replace sampling30=1 if interv_dt>=td(30jan2025)

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
replace month=6 in 1059/1121

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
// total
tab willing recloc if agecat==1, col
tab willing recloc if agecat==2, col
tab willing, m
tab willing agecat, m

// rekrutmen per jenis fasyankes lebih rinci //
// total
tab willing rec_loc if agecat==1, col
tab willing rec_loc if agecat==2, col
tab willing, m
tab willing agecat, m

// membuang pasien yang tidak consent // 
drop if willing==0

// membuat kategori sampel fresh atau bioarchive //
describe dt_swab_pluslife dt_resswab_pluslife
gen dtswabpluslife = dofc(dt_swab_pluslife)
gen dtresswabpluslife = dofc(dt_resswab_pluslife)
format dtswabpluslife dtresswabpluslife %td

gen selisih_hari=dtresswabpluslife-dtswabpluslife
gen plts_type=.
br idsubject dt_swab_pluslife dt_resswab_pluslife selisih_hari plts_type
sort selisih_hari
replace plts_type=1 if selisih_hari<=7 & !missing(selisih_hari)
replace plts_type=2 if selisih_hari>7 & !missing(selisih_hari)
label define sampletypelab 1 "Fresh" 2 "Bioarchive"
label values plts_type sampletypelab

// data sources and type of specimen
tab xpertultra, m
tab xpertultra rec_loc, m row
list idsubject if xpertultra==1 & rec_loc==.
tab xpertultra diag_tb, m row
tab res_xpertultra rec_loc
tab res_xpertultra diag_tb

tab fujilam rec_loc, m row
list idsubject initial if fujilam==. & rec_loc==1
tab fujilam diag_tb, m row
tab res_fujilam rec_loc
tab res_fujilam diag_tb

tab swab_pluslife rec_loc, m row
tab swab_pluslife diag_tb, m row
tab res_swab_pluslife rec_loc
tab res_swab_pluslife diag_tb

tab sput_pluslife rec_loc, m row
tab sput_pluslife diag_tb, m row
tab res_sput_pluslife rec_loc
tab res_sput_pluslife diag_tb

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

tab agecat5, m

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
  3. |  4100538        SM     2      . |
  8. |  4100539        SM     1      . |
 10. |  4100738        SM     1      . |
 12. |  4100725        SM     1      . |
 31. |  4100583        SM     4      . |
     |---------------------------------|
 33. |  4100524        SM     2      . |
 35. |  4100708        SM     4     88 |
 43. |  4100553        SM     5      . |
223. |  4100736        SM     9      . |
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
                 Normal |         37        5.60        5.60
      Sugestif TB aktif |        357       54.01       59.61
       Sugestif TB lama |         33        4.99       64.60
Tidak normal - bukan TB |        184       27.84       92.44
   Menolak rontgen dada |          1        0.15       92.59
                      . |         49        7.41      100.00
------------------------+-----------------------------------
                  Total |        661      100.00

sort interv_dt
list idsubject initial interv_dt if cxray==.

     +----------------------------------------+
     | idsubj~t   initial           interv_dt |
     |----------------------------------------|
286. |  4100370        SM    November 6, 2024 |
293. |  4100375        SM    November 7, 2024 |
351. |  4100512       YFH   November 20, 2024 |
352. |  4100509        SM   November 20, 2024 |
378. |  4100288       RVT    December 2, 2024 |
     |----------------------------------------|
392. |  4100295       KDP    December 4, 2024 |
393. |  4100297       RVT    December 4, 2024 |
429. |  4100553        SM   December 16, 2024 |
465. |  4100572       YFH   December 24, 2024 |
492. |  4100443       KDP     January 3, 2025 |
     |----------------------------------------|
520. |  4100455       KDP     January 9, 2025 |
536. |  4100461       KDR    January 13, 2025 |
575. |  4100641       HAR    January 31, 2025 |
580. |  4100644       HAR    February 3, 2025 |
587. |  4100674       AHT    February 3, 2025 |
     |----------------------------------------|
590. |  4100675       ADN    February 4, 2025 |
594. |  4100677       AHT    February 5, 2025 |
598. |  4100646        DR    February 6, 2025 |
601. |  4100678        AT    February 6, 2025 |
605. |  4100679       AHT   February 10, 2025 |
     |----------------------------------------|
607. |  4100647       HAR   February 10, 2025 |
610. |  4100473       RVT   February 11, 2025 |
611. |  4100681       AHT   February 11, 2025 |
614. |  4100680       AHT   February 11, 2025 |
615. |  4100803       ADN   February 11, 2025 |
     |----------------------------------------|
617. |  4100683       AHT   February 12, 2025 |
620. |  4100805       ADN   February 14, 2025 |
623. |  4100807       ADN   February 14, 2025 |
624. |  4100806       ADN   February 14, 2025 |
625. |  4100765        SM   February 17, 2025 |
     |----------------------------------------|
628. |  4100809       ADN   February 17, 2025 |
629. |  4100761        SM   February 17, 2025 |
633. |  4100808       ADN   February 17, 2025 |
634. |  4100684       AHT   February 17, 2025 |
635. |  4100649        DR   February 17, 2025 |
     |----------------------------------------|
639. |  4100685       AHT   February 18, 2025 |
641. |  4100474       RVT   February 18, 2025 |
643. |  4100475       RVT   February 19, 2025 |
644. |  4100686       AHT   February 19, 2025 |
645. |  4100651        DR   February 19, 2025 |
     |----------------------------------------|
646. |  4100810       ADN   February 19, 2025 |
647. |  4100619       KDP   February 19, 2025 |
649. |  4100688       AHT   February 20, 2025 |
650. |  4100812       ADN   February 20, 2025 |
653. |  4100692       AHT   February 24, 2025 |
     |----------------------------------------|
655. |  4100811       ADN   February 24, 2025 |
656. |  4100813       ADN   February 24, 2025 |
657. |  4100690       AHT   February 24, 2025 |
658. |  4100693       AHT   February 25, 2025 |
     +----------------------------------------+

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


 Sampel dahak pertama diambil |      Freq.     Percent        Cum.
------------------------------+-----------------------------------
Tidak bisa mengeluarkan dahak |          8        1.58        1.58
            Ya, dahak sewaktu |        354       69.82       71.40
               Ya, dahak pagi |        108       21.30       92.70
           Ya, induksi sputum |          1        0.20       92.90
              Tidak dilakukan |         36        7.10      100.00
------------------------------+-----------------------------------
                        Total |        507      100.00

list idsubject age initial interv_dt sputum1 sputum1_rfs sputum1_dt sputum2 tcm_result if sputum1==. 
.

tab sputum1_rfs, m
tab sputum1_dt, m
list idsubject initial if sputum1==1 & sputum1_dt==. | sputum1==2 & sputum1_dt==. | sputum1==3 & sputum1_dt==.

tab sputum2, m
list idsubject initial interv_dt tcm_result if sputum2==.

tab sputum2_rfs, m
tab sputum2_dt, m

tab tcm_type, m

        Jenis |
  pemeriksaan |
          TCM |      Freq.     Percent        Cum.
--------------+-----------------------------------
  Xpert Ultra |        428       84.42       84.42
BD Max TB MDR |         35        6.90       91.32
            . |         44        8.68      100.00
--------------+-----------------------------------
        Total |        507      100.00

tab tcm_dt, m
list idsubject if tcm_dt==. & tcm_type!=.

tab tcm_result, m

                  Hasil pemeriksaan TCM |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
                       MTB Not Detected |        393       59.46       59.46
MTB Detected, Rif Resistance Not Detect |        115       17.40       76.85
  MTB Detected, Rif Resistance Detected |         14        2.12       78.97
MTB Detected, Rif Resistance Indetermin |          2        0.30       79.27
MTB Trace Detected, Rif Resistance Inde |         12        1.82       81.09
MTB Detected, Rif Resistance Not Detect |          1        0.15       81.24
MTB Detected, Rif Resistance Detected,  |          1        0.15       81.39
MTB Detected, Rif Resistance Not Detect |          1        0.15       81.54
                               Not Done |         75       11.35       92.89
                                      . |         47        7.11      100.00
----------------------------------------+-----------------------------------
                                  Total |        661      100.00

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

    | idsubj~t   hiv_test   blood_~t |

187. |  4100211          .      Tidak |
189. |  4100215          .      Tidak |
200. |  4100226          .      Tidak |
202. |  4100228          .         Ya |
203. |  4100229          .         Ya |
     |--------------------------------|
204. |  4100230          .         Ya |
205. |  4100231          .         Ya |
206. |  4100232          .         Ya |
207. |  4100233          .         Ya |
208. |  4100234          .         Ya |
     |--------------------------------|
209. |  4100235          .      Tidak |
210. |  4100237          .         Ya |
211. |  4100238          .         Ya |
212. |  4100239          .         Ya |
213. |  4100301          .      Tidak |
     |--------------------------------|
220. |  4100308          .      Tidak |
221. |  4100309          .      Tidak |
222. |  4100310          .      Tidak |
223. |  4100311          .      Tidak |
228. |  4100316          .      Tidak |
     |--------------------------------|
229. |  4100317          .      Tidak |
230. |  4100319          .      Tidak |
237. |  4100326          .      Tidak |
238. |  4100327          .      Tidak |
241. |  4100331          .      Tidak |
     |--------------------------------|
243. |  4100333          .      Tidak |
244. |  4100334          .      Tidak |
246. |  4100336          .         Ya |
247. |  4100337          .      Tidak |
248. |  4100338          .         Ya |
     |--------------------------------|
249. |  4100339          .         Ya |
250. |  4100340          .         Ya |
251. |  4100341          .         Ya |
252. |  4100342          .         Ya |
253. |  4100343          .         Ya |
     |--------------------------------|
254. |  4100344          .         Ya |
255. |  4100345          .      Tidak |
256. |  4100346          .      Tidak |
257. |  4100347          .      Tidak |
258. |  4100348          .      Tidak |
     |--------------------------------|
259. |  4100351          .      Tidak |
     +--------------------------------+


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