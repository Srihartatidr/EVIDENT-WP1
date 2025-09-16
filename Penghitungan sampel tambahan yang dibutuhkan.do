// open new file //
// run data cleaning //
// run data preparation //
// run drop if willing==0 //

save "D:\EVIDENT WP1 Data\250903_all pasien.dta"
file D:\EVIDENT WP1 Data\250903_all pasien.dta saved

//dropping sampel yang samplingnya kurang dari 15 detik!!
drop if idsubject==4100466
drop if idsubject==4100467
drop if idsubject==4100717
drop if idsubject==4100718

// dropping early exclusion //
drop if idsubject==4100074 | idsubject==4100689 | idsubject==4100974 | idsubject==4100455

// 882 obs //
// save as //

// tabel 2x2 //
tab culture_result2 res_swab_pluslife, m

culture_re |         Hasil pemeriksaan Usap lidah Pluslife
     sult2 |  Negative   Positive  Error/Inv   Not Done          . |     Total
-----------+-------------------------------------------------------+----------
  negative |       647          9          1        149         85 |       891 
  positive |        37         97          0         53         15 |       202 
       999 |        89          3          0         29         19 |       140 
-----------+-------------------------------------------------------+----------
     Total |       773        109          1        231        119 |     1,233 

keep if res_swab_pluslife==0 | res_swab_pluslife==1
tab culture_result2 res_swab_pluslife, m

           |   Hasil pemeriksaan
culture_re |  Usap lidah Pluslife
     sult2 |  Negative   Positive |     Total
-----------+----------------------+----------
  negative |       647          9 |       656 
  positive |        37         97 |       134 
       999 |        89          3 |        92 
-----------+----------------------+----------
     Total |       773        109 |       882 

// ada 882 pemeriksaan pluslife TS, lihat durasi sampling nya
tab res_swab_pluslife sampling30, m

        Hasil |
  pemeriksaan |
   Usap lidah |      sampling30
     Pluslife |      15-s       30-s |     Total
--------------+----------------------+----------
     Negative |       385        388 |       773 
     Positive |        77         32 |       109 
--------------+----------------------+----------
        Total |       462        420 |       882 

// ada 462 sampling 15 detik, cek berapa yang ada hasil kultur nya
tab res_swab_pluslife culture_result2 if sampling30==0, m
		
        Hasil |
  pemeriksaan |
   Usap lidah |         culture_result2
     Pluslife |  negative   positive        999 |     Total
--------------+---------------------------------+----------
     Negative |       330         28         27 |       385 
     Positive |         6         70          1 |        77 
--------------+---------------------------------+----------
        Total |       336         98         28 |       462 

tab res_swab_pluslife culture_result2 if sampling30==0 & culture_result2~=999, m
		
        Hasil |
  pemeriksaan |
   Usap lidah |    culture_result2
     Pluslife |  negative   positive |     Total
--------------+----------------------+----------
     Negative |       330         28 |       358 
     Positive |         6         70 |        76 
--------------+----------------------+----------
        Total |       336         98 |       434 

// ada 434 sampel 15 detik, cek pembagian umur nya:
tab agecat if sampling30==0 & culture_result2~=999

         agecat |      Freq.     Percent        Cum.
----------------+-----------------------------------
Usia 0-14 tahun |         70       16.13       16.13
 Usia 15+ tahun |        364       83.87      100.00
----------------+-----------------------------------
          Total |        434      100.00
		  
// cek fresh-bioarchive pada sampel 15s //

tab bioplts agecat if sampling30==0 & culture_result2~=999, m col

           |        agecat
   bioplts | Usia 0-14  Usia 15+  |     Total
-----------+----------------------+----------
         0 |        69        330 |       399 
           |     98.57      90.66 |     91.94 
-----------+----------------------+----------
         1 |         1         34 |        35 
           |      1.43       9.34 |      8.06 
-----------+----------------------+----------
     Total |        70        364 |       434 
           |    100.00     100.00 |    100.00 

// sekarang, cek yang sampling 30 detik, ada berapa yang ada hasil kultur nya //
tab res_swab_pluslife culture_result2 if sampling30==1, m

        Hasil |
  pemeriksaan |
   Usap lidah |         culture_result2
     Pluslife |  negative   positive        999 |     Total
--------------+---------------------------------+----------
     Negative |       317          9         62 |       388 
     Positive |         3         27          2 |        32 
--------------+---------------------------------+----------
        Total |       320         36         64 |       420 

// ada 420  tes, tapi 64 kultur nya 999, apakah tidak ada sampel, atau gimana?
// dari 64: 40 memang tidak ada kultur, 24 ada sampel tapi belum ada hasil //
tab sputum1_c culture_result2 if culture_result2==999 & sampling30==1, m

                      | culture_re
 Sampel dahak pertama |   sult2
              diambil |       999 |     Total
----------------------+-----------+----------
Tidak bisa mengeluark |        30 |        30 
    Ya, dahak sewaktu |        24 |        24 
      Tidak dilakukan |        10 |        10 
----------------------+-----------+----------
                Total |        64 |        64 

list interv_dt idsubject sputum1_c if culture_result2==999 & sputum1_c==1 & sampling30==1

     +--------------------------------------------------+
     |         interv_dt   idsubj~t           sputum1_c |
     |--------------------------------------------------|
846. |     July 15, 2025    4101330   Ya, dahak sewaktu |
848. |     July 16, 2025    4101245   Ya, dahak sewaktu |
850. |     July 16, 2025    4101247   Ya, dahak sewaktu |
857. |     July 16, 2025    4101303   Ya, dahak sewaktu |
860. |     July 17, 2025    4100987   Ya, dahak sewaktu |
     |--------------------------------------------------|
861. |     July 17, 2025    4101363   Ya, dahak sewaktu |
862. |     July 17, 2025    4101307   Ya, dahak sewaktu |
863. |     July 17, 2025    4101250   Ya, dahak sewaktu |
864. |     July 17, 2025    4101306   Ya, dahak sewaktu |
865. |     July 18, 2025    4101356   Ya, dahak sewaktu |
     |--------------------------------------------------|
866. |     July 18, 2025    4101308   Ya, dahak sewaktu |
867. |     July 18, 2025    4101364   Ya, dahak sewaktu |
869. |     July 21, 2025    4101252   Ya, dahak sewaktu |
870. |     July 21, 2025    4101254   Ya, dahak sewaktu |
871. |     July 21, 2025    4101365   Ya, dahak sewaktu |
     |--------------------------------------------------|
872. |     July 21, 2025    4101253   Ya, dahak sewaktu |
873. |     July 21, 2025    4101366   Ya, dahak sewaktu |
874. |     July 21, 2025    4101255   Ya, dahak sewaktu |
875. |     July 21, 2025    4101332   Ya, dahak sewaktu |
878. |     July 21, 2025    4101345   Ya, dahak sewaktu |
     |--------------------------------------------------|
879. |     July 22, 2025    4101346   Ya, dahak sewaktu |
880. |     July 22, 2025    4101368   Ya, dahak sewaktu |
881. | September 2, 2025    4101347   Ya, dahak sewaktu |
882. | September 2, 2025    4100988   Ya, dahak sewaktu |
     +--------------------------------------------------+

// ada 24 pasien yang ada dahaknya, cek tanggal mengeluarkan dahaknya:
sort sputum1_dt_2
br idsubject age initial rec_loc sputum1_c sputum1_dt_2 if culture_result2==999 & sputum1_c==1
// jadi, ada 24 pasien yang kulturnya belum keluar

// jadi ada 356 pasien yg ada hasil kultur, dan 24 yg potential ada hasil kultur //
// a. cek kategori umur yg 356 //
tab bioplts agecat if sampling30==1 & culture_result2~=999

           |        agecat
   bioplts | Usia 0-14  Usia 15+  |     Total
-----------+----------------------+----------
     Fresh |        81         97 |       178 
Bioarchive |        52        126 |       178 
-----------+----------------------+----------
     Total |       133        223 |       356 

// b. cek kategori umur yg 24 obs //
tab bioplts agecat if sampling30==1 & culture_result2==999 & sputum1_c==1

           |        agecat
   bioplts | Usia 0-14  Usia 15+  |     Total
-----------+----------------------+----------
     Fresh |         0          2 |         2 
Bioarchive |         2         20 |        22 
-----------+----------------------+----------
     Total |         2         22 |        24 

// cek kategori umur yg 40 obs //
tab bioplts agecat if sampling30==1 & culture_result2==999 & sputum1_c~=1

           |        agecat
   bioplts | Usia 0-14  Usia 15+  |     Total
-----------+----------------------+----------
     Fresh |        38          1 |        39 
Bioarchive |         0          1 |         1 
-----------+----------------------+----------
     Total |        38          2 |        40 

// combined both of them //
tab bioplts agecat if (sampling30==1 & culture_result2~=999) | (sampling30==1 & culture_result2==999 & sputum1_c==1), m col

           |        agecat
   bioplts | Usia 0-14  Usia 15+  |     Total
-----------+----------------------+----------
     Fresh |        81         99 |       180 
Bioarchive |        54        146 |       200 
-----------+----------------------+----------
     Total |       135        245 |       380 
