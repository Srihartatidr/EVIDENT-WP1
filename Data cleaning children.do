// data cleaning children//

tab sex, m
tab cough, m
summarize cough_y, d
tab fever, m
tab sweatnight, m
tab weightloss, m
tab chestpain, m
tab weak, m
tab outbreath, m
tab hemoptysis, m
tab dec_appetite, m
tab diag_tb, m
sort birthdate
br idsubject age birthdate diag_tb diag_tb_y interv_dt if diag_tb==1
tab contact, m
br idsubject age initial birthdate contact contact_y interv_dt if contact==1
*ID 517, 636, 955, 956 cek

tab hiv, m
tab hiv_test, m
tab hiv_status, m
summarize weight, d
summarize height, d
summarize bmi, d
summarize upper_armc, d
br idsubject age initial weight height upper_armc tuberc_done tuberc_res crp
summarize pulse, d
summarize resp, d
summarize spo2, d
tab cxray, m
tab tuberc_done, m
tab tuberc_res if tuberc_done==1, m
summarize tuberc_res, d
tab tcm_result, m
tab semi_quant if tcm_result==1 | tcm_result==2, m
tab culture_result, m
tab cult_ident, m
summarize hemoglobin, d
summarize leukocytes, d
summarize platelets, d
summarize hematocrit, d
summarize erythrocytes, d
summarize mcv, d
summarize mch, d
summarize mchc, d
summarize lymphocytes, d
summarize crp, d
tab sc_cont, m
tab sc_cont contact, m

                      |  Apakah anda pernah
                      | kontak dengan pasien
                      |   TB (keluarga atau
                      |     orang dekat)?
           Kontak TBC |     Tidak         Ya |     Total
----------------------+----------------------+----------
          Tidak jelas |        71          8 |        79 
Laporan keluarga, tid |         8         43 |        51 
Terkonfirmasi bakteri |         1         12 |        13 
                    . |        28         21 |        49 
----------------------+----------------------+----------
                Total |       108         84 |       192 

tab sc_tuberc, m
tab tubercat sc_tuberc, m

           |       Uji kulit tuberkulin
  tubercat |   Negatif  Positif (          . |     Total
-----------+---------------------------------+----------
     <5 mm |        52          0          5 |        57 
    >=5 mm |         2          5          0 |         7 
   >=10 mm |         1         63         14 |        78 
       999 |         1          1         48 |        50 
-----------+---------------------------------+----------
     Total |        56         69         67 |       192 

tab sc_lymph, m
tab sc_swelling, m
tab tb_treat, m
