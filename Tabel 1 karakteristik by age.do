use "D:\EVIDENT WP1 Data\250630_dataset pluslife ss.dta", clear
merge 1:1 idsubject using "D:\EVIDENT WP1 Data\250630_dataset pluslife ts.dta"

    Result                      Number of obs
    -----------------------------------------
    Not matched                           230
        from master                       169  (_merge==1)
        from using                         61  (_merge==2)

    Matched                               424  (_merge==3)
    -----------------------------------------

tabulate _merge

   Matching result from |
                  merge |      Freq.     Percent        Cum.
------------------------+-----------------------------------
        Master only (1) |        169       25.84       25.84
         Using only (2) |         61        9.33       35.17
            Matched (3) |        424       64.83      100.00
------------------------+-----------------------------------
                  Total |        654      100.00

br
save "D:\EVIDENT WP1 Data\250630_merge pluslife ss ts.dta"

// merge pluslife ts ss dengan xpert ts //
use "D:\EVIDENT WP1 Data\250630_merge pluslife ss ts.dta"
drop _merge
merge 1:1 idsubject using "D:\EVIDENT WP1 Data\250630_dataset xpert ts.dta"

save "D:\EVIDENT WP1 Data\250630_merge pluslife ss ts xpert ts.dta"
// 654 obs

// gunakan dataset yang beda //
clear
use "D:\EVIDENT WP1 Data\250703_dataset pl ts ss xpert ts.dta"

// TABEL 1 //
// characteristics based on age category //
tab sex agecat14, m col
summarize age, d
summarize age if agecat14==0, d
summarize age if agecat14==1, d
tab category agecat14, m col
tab hiv_status agecat14, m col
tab dm_status agecat14, m col
tab diag_tb agecat14, m col
tab bmicat agecat14 if age>=18, m col
tab tst agecat14, m col
tab cxray agecat14, m col
tab xpertsputum1 agecat14, m col
tab semi_quant agecat14 if xpertsputum1==2, m col
tab culture_result agecat14, m col
br interv_dt idsubject age rec_loc sputum1_c culture_result if culture_result==.
tab cult_ident agecat14 if cult_ident==1 | cult_ident==2, col
tab subject_cat agecat14 if subject_cat~=., m col
tab subject_cat agecat14, m col // 170 obs uncategorized
br idsubject age culture_result cult_ident cxray tcm_result semi_quant xpertsputum1 tb_treat if subject_cat==.
list idsubject rec_loc res_swab_pluslife cat_tbtest if cat_tbtest==3 | cat_tbtest==5
     +------------------------------------------------------------------+
     | idsubj~t                                rec_loc       cat_tbtest |
     |------------------------------------------------------------------|
173. |  4100294   Rumah Sakit Paru Dr. H. A. Rotinsulu   Unconfirmed TB | Death
285. |  4100443   Rumah Sakit Paru Dr. H. A. Rotinsulu     Unclassified | Bukan TB
337. |  4100532       Klinik Utama Dr. H. A. Rotinsulu     Unclassified | Death
     +------------------------------------------------------------------+

tab drtb agecat14, m col
// hitung yang limfadenitis TB di anak
tab tb_treat agecat14, m col

// Tabel 2 //
tab unlikely_diag
br interv_dt idsubject age rec_loc initial cat_tbtest unlikely_diag note_ if cat_tbtest==.
br idsubject unlikely_diag note_ 

// menghitung jeda tanggal sputum collection dengan sampling tes indeks //
gen date_part = dofc(dt_swab_pluslife)
format date_part %td
gen durasisampling=date_part-sputum1_dt_2
sort durasisampling
br idsubject interv_dt dt_swab_pluslife sputum1_dt sputum1_dt_2 tcm_dt durasisampling
summarize durasisampling if idsubject~=4100329 & idsubject~=4100442 & idsubject~=4100012 & idsubject~=4100624 & idsubject~=4100180, d

