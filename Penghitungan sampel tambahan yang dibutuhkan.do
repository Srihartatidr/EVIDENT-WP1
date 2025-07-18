generate agecat=.
replace agecat=1 if age<15
replace agecat=2 if age>=15
label define agecatlab 1 "Usia 0-14 tahun" 2 "Usia 15+ tahun"
label values agecat agecatlab

// tabel 2x2 //
tab culture_result2 res_swab_pluslife, m

culture_re |         Hasil pemeriksaan Usap lidah Pluslife
     sult2 |  Negative   Positive  Error/Inv   Not Done          . |     Total
-----------+-------------------------------------------------------+----------
  negative |       466          7          1         48         97 |       619 
  positive |        29         81          0         16         24 |       150 
       999 |        99          2          2         31        133 |       267 
-----------+-------------------------------------------------------+----------
     Total |       594         90          3         95        254 |     1,036 

keep if res_swab_pluslife==0 | res_swab_pluslife==1
tab culture_result2 res_swab_pluslife, m

           |   Hasil pemeriksaan
culture_re |  Usap lidah Pluslife
     sult2 |  Negative   Positive |     Total
-----------+----------------------+----------
  negative |       466          7 |       473 
  positive |        29         81 |       110 
       999 |        99          2 |       101 
-----------+----------------------+----------
     Total |       594         90 |       684 

// ada 684 pemeriksaan pluslife TS, lihat durasi sampling nya
tab res_swab_pluslife sampling30, m

        Hasil |
  pemeriksaan |
   Usap lidah |      sampling30
     Pluslife |         0          1 |     Total
--------------+----------------------+----------
     Negative |       375        219 |       594 
     Positive |        72         18 |        90 
--------------+----------------------+----------
        Total |       447        237 |       684 

// ada 447 sampling 15 detik, cek berapa yang ada hasil kultur nya
tab res_swab_pluslife culture_result2 if sampling30==0, m
	
        Hasil |
  pemeriksaan |
   Usap lidah |         culture_result2
     Pluslife |  negative   positive        999 |     Total
--------------+---------------------------------+----------
     Negative |       320         28         27 |       375 
     Positive |         6         65          1 |        72 
--------------+---------------------------------+----------
        Total |       326         93         28 |       447 

tab res_swab_pluslife culture_result2 if sampling30==0 & culture_result2~=999, m

        Hasil |
  pemeriksaan |
   Usap lidah |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       320         28 |       348 
     Positive |         6         65 |        71 
--------------+----------------------+----------
        Total |       326         93 |       419 

// ada 419 sampel 15 detik, cek pembagian umur nya:
tab agecat if sampling30==0 & culture_result2~=999


         agecat |      Freq.     Percent        Cum.
----------------+-----------------------------------
Usia 0-14 tahun |         68       16.23       16.23
 Usia 15+ tahun |        351       83.77      100.00
----------------+-----------------------------------
          Total |        419      100.00

// sekarang, cek yang sampling 30 detik
tab res_swab_pluslife culture_result2 if sampling30==1, m

        Hasil |
  pemeriksaan |
   Usap lidah |         culture_result2
     Pluslife |  negative   positive        999 |     Total
--------------+---------------------------------+----------
     Negative |       146          1         72 |       219 
     Positive |         1         16          1 |        18 
--------------+---------------------------------+----------
        Total |       147         17         73 |       237 

// ada 237  tes, tapi 73 kultur nya 999, apakah ada sampel, atau gimana?
tab sputum1_c res_swab_pluslife if culture_result2==999

                      |   Hasil pemeriksaan
 Sampel dahak pertama |  Usap lidah Pluslife
              diambil |  Negative   Positive |     Total
----------------------+----------------------+----------
Tidak bisa mengeluark |        44          0 |        44 
    Ya, dahak sewaktu |        42          2 |        44 
      Tidak dilakukan |        13          0 |        13 
----------------------+----------------------+----------
                Total |        99          2 |       101 

// ada 44 pasien yang ada dahaknya, cek tanggal mengeluarkan dahaknya:
sort sputum1_dt_2
br idsubject age initial rec_loc sputum1_c sputum1_dt_2 if culture_result2==999 & sputum1_c==1
// dari 44 itu, 13 pasien sepertinya tidak mengumpulkan dahak
// jadi 21 pasien yang kulturnya belum keluar

// cek aja 73 pasien yang 999 itu ketang //
br idsubject age initial rec_loc sputum1_c sputum1_dt_2 if culture_result2==999 & sputum1_c~=1

// ada 237 sampling 30 detik, cek berapa yang ada hasil kultur nya
tab res_swab_pluslife culture_result2 if sampling30==1, m
	
        Hasil |
  pemeriksaan |
   Usap lidah |         culture_result2
     Pluslife |  negative   positive        999 |     Total
--------------+---------------------------------+----------
     Negative |       148          1         70 |       219 
     Positive |         1         16          1 |        18 
--------------+---------------------------------+----------
        Total |       149         17         71 |       237 

tab res_swab_pluslife culture_result2 if sampling30==1 & culture_result2~=999, m

        Hasil |
  pemeriksaan |
   Usap lidah |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       148          1 |       149 
     Positive |         1         16 |        17 
--------------+----------------------+----------
        Total |       149         17 |       166 

// ada 166 sampel 15 detik, cek pembagian umur nya:
tab agecat if sampling30==1 & culture_result2~=999

         agecat |      Freq.     Percent        Cum.
----------------+-----------------------------------
Usia 0-14 tahun |         74       44.58       44.58
 Usia 15+ tahun |         92       55.42      100.00
----------------+-----------------------------------
          Total |        166      100.00

// adari total 237 tes, tapi 71 kultur nya 999, apakah ada sampel, atau gimana?
tab sputum1_c res_swab_pluslife if culture_result2==999 & sampling30==1

                      |   Hasil pemeriksaan
 Sampel dahak pertama |  Usap lidah Pluslife
              diambil |  Negative   Positive |     Total
----------------------+----------------------+----------
Tidak bisa mengeluark |        31          0 |        31 
    Ya, dahak sewaktu |        33          1 |        34 
      Tidak dilakukan |         6          0 |         6 
----------------------+----------------------+----------
                Total |        70          1 |        71 

// ada 34 pasien yang ada dahaknya, cek tanggal mengeluarkan dahaknya:
sort sputum1_dt_2
br idsubject age initial rec_loc sputum1_c sputum1_dt_2 if culture_result2==999 & sputum1_c==1 & sampling30==1
// dari 34 itu, 5 pasien sepertinya tidak mengumpulkan dahak
// jadi 29 pasien yang kulturnya belum keluar

// tabulasi lagi berdasarkan umur nya, pasien yang ada dahak dan potensi hasil kultur nya
// tapi kita perlu recoding dulu hasil dahaknya, supaya mudah pengelompokkannya
replace culture_result2=1 if sputum1_c==1 & culture_result2==999

// ulang lagi tabulasinya:
tab agecat if sampling30==1 & culture_result2~=999

         agecat |      Freq.     Percent        Cum.
----------------+-----------------------------------
Usia 0-14 tahun |         81       40.50       40.50
 Usia 15+ tahun |        119       59.50      100.00
----------------+-----------------------------------
          Total |        200      100.00