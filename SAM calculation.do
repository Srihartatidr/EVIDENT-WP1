gen age_group = .
replace age_group = 1 if age_months < 60       // Under 5
replace age_group = 2 if inrange(age_months, 60, 119)    // 5–9 years
replace age_group = 3 if inrange(age_months, 120, 179)   // 10–14 years
replace age_group = 4 if inrange(age_months, 180, 216)   // 15–18 years
label define agelabel 1 "<5" 2 "5–9" 3 "10–14" 4 "15–18"
label values age_group agelabel

gen sam = 0

// Under 5 years: WHZ < -3 or MUAC < 115
replace sam = 1 if age_group == 1 & (waz06 < -3 | muacmm < 115)

// Age 5–9: BAZ < -3 or MUAC < 135
replace sam = 1 if age_group == 2 & (bmiz06 < -3 | muacmm < 135)

// Age 10–14: BAZ < -3 or MUAC < 145
replace sam = 1 if age_group == 3 & (bmiz06 < -3 | muacmm < 145)

// Age 15–18: BAZ < -3 or MUAC < 160
replace sam = 1 if age_group == 4 & (bmiz06 < -3 | muacmm < 160)

summarize sam
display "SAM prevalence: " r(mean)*100 "% (" r(N) " observations)"

tabulate age_group sam, row
