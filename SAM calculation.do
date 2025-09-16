gen age_months = floor((interv_dt - birthdate) / 30.4375)

gen age_group = .
replace age_group = 1 if age_months < 60       // Under 5
replace age_group = 2 if inrange(age_months, 60, 119)    // 5–9 years
replace age_group = 3 if inrange(age_months, 120, 179)   // 10–14 years
replace age_group = 4 if inrange(age_months, 180, 216)   // 15–18 years
label define agelabel 1 "<5" 2 "5–9" 3 "10–14" 4 "15–18"
label values age_group agelabel

gen muacmm=upper_armc*10

gen sam = 0

// Under 5 years: WHZ < -3 or MUAC < 115
replace sam = 1 if age_group == 1 & (waz06 < -3 | muacmm < 115)

// Age 5–9: BAZ < -3 or MUAC < 135
replace sam = 1 if age_group == 2 & (bmiz06 < -3 | muacmm < 135)

// Age 10–14: BAZ < -3 or MUAC < 145
replace sam = 1 if age_group == 3 & (bmiz06 < -3 | muacmm < 145)

// Age 15–18: BAZ < -3 or MUAC < 160
replace sam = 1 if age_group == 4 & (bmiz06 < -3 | muacmm < 160)



// Under 5 years: WHZ < -3 or MUAC < 115
replace sam = 1 if age_group == 1 & muacmm < 115

// Age 5–9: BAZ < -3 or MUAC < 135
replace sam = 1 if age_group == 2 & muacmm < 135

// Age 10–14: BAZ < -3 or MUAC < 145
replace sam = 1 if age_group == 3 & muacmm < 145

// Age 15–18: BAZ < -3 or MUAC < 160
replace sam = 1 if age_group == 4 & muacmm < 160

gen kids = age < 18
gen sam_in_child = (kids == 1 & sam == 1)

// Numerator: sum of children with TB
// Denominator: total number of children
sum sam_in_child if kids == 1
sum kids if kids == 1

// Or use proportion command:
proportion sam if kids == 1


summarize sam
display "SAM prevalence: " r(mean)*100 "% (" r(N) " observations)"

tabulate age_group sam, row



