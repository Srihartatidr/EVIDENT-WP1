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

// bagi jadi sampel fresh atau bioarchive
gen rentang