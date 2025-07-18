// USING ZSCORER (0-5 YEARS OLD)//

// data preparation //
gen agedays=interv_dt-birthdate
gen agemonths=agedays/30.4375
gen ageyears=agedays/365.25
sort agemonths
generate agemonths1=round(agemonths, 0.1)
br age interv_dt birthdate agedays agemonths agemonths1

// calculating zscore //
sum height, d
gen heightincmm=height*100
zscore06, a(agemonths1) s(sex) h(heightincmm) w(weight) female (0) male(1)
sort agemonths1
br idsubject interv_dt birthdate sex age weight heightincm waz06 haz06 bmiz06
br idsubject sex age weight heightincm waz06 haz06 bmiz06
summarize haz06 if agemonths1<61, d
summarize waz06 if agemonths1<61, d
summarize bmiz06 if agemonths1<61, d
summarize waz06 if waz06!=99, d

replace waz06=-2.25 if idsubject==4100040
replace haz06=-1.86 if idsubject==4100040
replace bmiz06=-1.57 if idsubject==4100040

replace waz06=-1.41 if idsubject==4100345
replace haz06=-1.69 if idsubject==4100345
replace bmiz06=-0.44 if idsubject==4100345

replace waz06=0.64 if idsubject==4100334
replace haz06=-0.22 if idsubject==4100334
replace bmiz06=1.05 if idsubject==4100334

replace waz06=-2.54 if idsubject==4100327
replace haz06=-1.84 if idsubject==4100327
replace bmiz06=2.04 if idsubject==4100327

replace waz06=-1.13 if idsubject==4100400
replace haz06=4.01 if idsubject==4100400
replace bmiz06=-5.46 if idsubject==4100400

*ID 4100370*
replace waz06=0.50 in 20
replace haz06=-1.06 in 20
replace bmiz06=1.51 in 20

*ID 4100379*
replace waz06=-2.07 in 21
replace haz06=-1.64 in 21
replace bmiz06=1.47 in 21

*ID 4100310*
replace waz06=-1.23 in 22
replace haz06=2.47 in 22
replace bmiz06=-4.69 in 22

*ID 4100519*
replace waz06=-1.19 in 23
replace haz06=-1.31 in 23
replace bmiz06=-0.56 in 23

*ID 4100337*
replace waz06=4.04 in 24
replace haz06=-0.96 in 24
replace bmiz06=6.79 in 24

*ID 4100311*
replace waz06=1.59 in 25
replace haz06=1.37 in 25
replace bmiz06=1.14 in 25

*ID 4100510*
replace waz06=1.59 in 26
replace haz06=1.37 in 26
replace bmiz06=1.14 in 26

*ID 4100387*
replace waz06=-0.60 in 27
replace haz06=-0.04 in 27
replace bmiz06=-0.91 in 27

*ID 4100536*
replace waz06=1.23 in 28
replace haz06=-1.82 in 28
replace bmiz06=3.13 in 28

*ID 4100399*
replace waz06=-0.71 in 29
replace haz06=-0.31 in 29
replace bmiz06=-0.82 in 29

*ID 4100347*
replace waz06=0.06 in 30
replace haz06=0.49 in 30
replace bmiz06=-0.37 in 30

*ID 4100347*
replace waz06=0.06 in 30
replace haz06=0.49 in 30
replace bmiz06=-0.37 in 30

*ID 4100393*
replace waz06=0.51 in 31
replace haz06=0.15 in 31
replace bmiz06=0.57 in 31

*ID 4100317*
replace waz06=-0.44 in 32
replace haz06=-0.43 in 32
replace bmiz06=-0.27 in 32

*ID 4100396*
replace waz06=-1.73 in 33
replace haz06=-0.27 in 33
replace bmiz06=-2.51 in 33

*ID 4100253*
replace waz06=-2.07 in 34
replace haz06=-0.61 in 34
replace bmiz06=-2.75 in 34

*ID 4100395*
replace waz06=-1.75 in 35
replace haz06=-0.39 in 35
replace bmiz06=-2.48 in 35

*ID 4100529*
replace waz06=-2.23 in 36
replace haz06=-1.12 in 36
replace bmiz06=-2.36 in 36

*ID 4100319*
replace waz06=-3.17 in 37
replace haz06=-1.70 in 37 
replace bmiz06=-3.20 in 37

*ID 4100391*
replace waz06=-1.02 in 38
replace haz06=-5.15 in 38 
replace bmiz06=2.58 in 38

*ID 4100133*
replace waz06=-1.14 in 39
replace haz06=-1.47 in 39 
replace bmiz06=-0.30 in 39

*ID 4100353*
replace waz06=-0.82 in 40
replace haz06=-1.75 in 40
replace bmiz06=-0.28 in 40

*ID 4100111*
replace waz06=0.11 in 41
replace haz06=-0.52 in 41
replace bmiz06=0.58 in 41

*ID 4100392*
replace waz06=0.34 in 42
replace haz06=-0.57 in 42
replace bmiz06=0.85 in 42

*ID 4100514*
replace waz06=0.98 in 43
replace haz06=0.91 in 43
replace bmiz06=0.71 in 43

*ID 4100375*
replace waz06=
replace haz06=-1.16 in 44
replace bmiz06=-0.24 in 44

*ID 4100308*
replace waz06=
replace haz06=-0.68 in 45
replace bmiz06=-0.88 in 45

*ID 4100215*
replace waz06=
replace haz06=0.48 in 46
replace bmiz06=0.61 in 46

*ID 4100240*
replace waz06=
replace haz06=-0.23 in 47
replace bmiz06=0.20 in 47

*ID 4100535*
replace waz06=
replace haz06=-1.10 in 48
replace bmiz06=0.28 in 48

*ID 4100176*
replace waz06=
replace haz06=-1.73 in 49
replace bmiz06=-2.20 in 49

*ID 4100037*
replace waz06=
replace haz06=-0.46 in 50
replace bmiz06=0.17 in 50

*ID 4100501*
replace waz06=
replace haz06=-0.61 in 51
replace bmiz06=-1.04 in 51

*ID 4100316*
replace waz06=
replace haz06=-2.38 in 52
replace bmiz06=-2.22 in 52

*ID 4100197*
replace waz06=
replace haz06=1.79 in 53
replace bmiz06=2.12 in 53

*ID 4100080*
replace waz06=
replace haz06=-0.75 in 54
replace bmiz06=-0.25 in 54

*ID 4100374*
replace waz06=
replace haz06=-1.13 in 55
replace bmiz06=-1.21 in 55

*ID 4100346*
replace waz06=
replace haz06=-1.49 in 56
replace bmiz06=-1.04 in 56

*ID 4100528*
replace waz06=
replace haz06=-1.73 in 57
replace bmiz06=-1.55 in 57

replace heightincm=81 in 406

*ID 4100538*
replace waz06=-3.14 in 406
replace haz06=-1.58 in 406
replace bmiz06=-3.18 in 406

// USING ZANTHRO //
egen zbmiuk=zanthro(bmi,ba,UK), xvar(age) gender(sex) gencode(female=0, male=1)
egen zbmius=zanthro(bmi,ba,US), xvar(age) gender(sex) gencode(female=0, male=1)

egen zwauk=zanthro(weight,wa,UK), xvar(agemonths1) gender(sex) gencode(male=1, female=0) ageunit(month)
egen zwaus=zanthro(weight,wa,US), xvar(agemonths1) gender(sex) gencode(male=1, female=0) ageunit(month)
egen zwauk=zanthro(weight,wa,UK), xvar(age) gender(sex) gencode(female=0, male=1)
egen zhauk=zanthro(heightincm,ha,UK), xvar(age) gender(sex) gencode(female=0, male=1)

egen zhauk=zanthro(weight,ha,UK), xvar(agemonths1) gender(sex) gencode(male=1, female=0) ageunit(month)
egen zhaus=zanthro(weight,ha,US), xvar(agemonths1) gender(sex) gencode(male=1, female=0) ageunit(month)

// determine the proportion of children who are overweight or obese
egen bmicat=zbmicat(bmi), xvar(age) gender(sex) gencode(female=0, male=1)
br idsubject age agemonths1 sex weight height bmi haz06 waz06 bmiz06 whz06 zbmiuk zbmius bmicat zwauk 

// USING IGROWUP //

// ANALYSIS //
summarize waz06 if waz06!=99, d
summarize haz06 if haz06!=99, d
summarize bmiz06 if bmiz06!=99, d

*prevalensi*
gen nutstatus=.
replace nutstatus=1 if waz06<-3
replace nutstatus=2 if (waz06<-2 & waz06>=-3)
replace nutstatus=3 if (waz06<2 & waz06>=-2)
replace nutstatus=4 if (waz06>2) & agecat15==1
tab nutstatus if agecat15==1, m

replace agecat5=2 if (age>=12 & age<18)
replace agecat5=3 if (age>=18 & age<35)
replace agecat5=4 if (age>=35 & age<65)
replace agecat5=5 if (age>=65 & age<.)