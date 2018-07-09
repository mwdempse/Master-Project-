/*      Bounds Results */ 
clear all
*cd "C:\Users\Xintong Wang\2017 Fall\Bounds_Program_Share_11192017\RLE A1 test"
set more off
set matsize 1000

use test_A1
qui bstat using test_A1

estat bootstrap,per

matrix b = e(b)
mat list b

matrix Vb = e(V)
matrix se = e(se)

mat li Vb

sca N=b[1,1]
sca list N
set more off
qui do CLR_01272015.ado  
qui do mcholx_01272015.ado

*P1: LNATE for never-takers 
matrix blLnt1=b[1,110]'
matrix list blLnt1
matrix buLnt1=b[1,111]'
matrix list buLnt1

mat VblLnt1=Vb[110,110]
matrix list VblLnt1

mat VbuLnt1=Vb[111,111]
matrix list VbuLnt1 

set seed 1989
CLR blLnt1 VblLnt1 buLnt1 VbuLnt1 N 100000 0.05 
mat Lnate_nt1=e(Lstar)
mat list Lnate_nt1
mat Unate_nt1=e(Ustar)
mat list Unate_nt1
mat CILnate_nt1=e(CIL)
mat list CILnate_nt1
mat CIUnate_nt1=e(CIU)
mat list CIUnate_nt1

*P1: LNATE for always-takers 
matrix blLat1=b[1,112]'
matrix list blLat1
matrix buLat1=b[1,113]'
matrix list buLat1

mat VblLat1=Vb[112,112]
matrix list VblLat1

mat VbuLat1=Vb[113,113]
matrix list VbuLat1 

set seed 1989
CLR blLat1 VblLat1 buLat1 VbuLat1 N 100000 0.05
mat Lnate_at1=e(Lstar)
mat list Lnate_at1
mat Unate_at1=e(Ustar)
mat list Unate_at1
mat CILnate_at1=e(CIL)
mat list CILnate_at1
mat CIUnate_at1=e(CIU)
mat list CIUnate_at1

*P1: ATE 
mat LB_Delta1=b[1,38]' 
mat li LB_Delta1
mat UB_Delta1=b[1,39]'
mat li UB_Delta1 

mat VLB_Delta1=Vb[38,38]
mat li VLB_Delta1

mat VUB_Delta1=Vb[39,39]
mat li VUB_Delta1

set seed 1989 
CLR LB_Delta1 VLB_Delta1 UB_Delta1 VUB_Delta1 N 100000 0.05
mat Lb_delta1=e(Lstar)
mat list Lb_delta1
mat Ub_delta1=e(Ustar)
mat list Ub_delta1
mat CILb_delta1=e(CIL)
mat list CILb_delta1
mat CIUb_delta1=e(CIU)
mat list CIUb_delta1

*P1: ATE_nt
mat LB_Delta_nt1=b[1,137]' 
mat li LB_Delta_nt1
mat UB_Delta_nt1=b[1,138]'
mat li UB_Delta_nt1 

mat VLB_Delta_nt1=Vb[137,137]
mat li VLB_Delta_nt1

mat VUB_Delta_nt1=Vb[138,138]
mat li VUB_Delta_nt1

set seed 1989 
CLR LB_Delta_nt1 VLB_Delta_nt1 UB_Delta_nt1 VUB_Delta_nt1 N 100000 0.05
mat Lb_delta_nt1=e(Lstar)
mat list Lb_delta_nt1
mat Ub_delta_nt1=e(Ustar)
mat list Ub_delta_nt1
mat CILb_delta_nt1=e(CIL)
mat list CILb_delta_nt1
mat CIUb_delta_nt1=e(CIU)
mat list CIUb_delta_nt1

*P1: ATE_at
mat LB_Delta_at1=b[1,139]' 
mat li LB_Delta_at1
mat UB_Delta_at1=b[1,140]'
mat li UB_Delta_at1 

mat VLB_Delta_at1=Vb[139,139]
mat li VLB_Delta_at1

mat VUB_Delta_at1=Vb[140,140]
mat li VUB_Delta_at1

set seed 1989 
CLR LB_Delta_at1 VLB_Delta_at1 UB_Delta_at1 VUB_Delta_at1 N 100000 0.05
mat Lb_delta_at1=e(Lstar)
mat list Lb_delta_at1
mat Ub_delta_at1=e(Ustar)
mat list Ub_delta_at1
mat CILb_delta_at1=e(CIL)
mat list CILb_delta_at1
mat CIUb_delta_at1=e(CIU)
mat list CIUb_delta_at1

*P1: ATT 
mat LB_Gamma1=b[1,100]' 
mat li LB_Gamma1
mat UB_Gamma1=b[1,101]'
mat li UB_Gamma1 

mat VLB_Gamma1=Vb[100,100]
mat li VLB_Gamma1

mat VUB_Gamma1=Vb[101,101]
mat li VUB_Gamma1

set seed 1989 
CLR LB_Gamma1 VLB_Gamma1 UB_Gamma1 VUB_Gamma1 N 100000 0.05
mat Lb_gamma1=e(Lstar)
mat list Lb_gamma1
mat Ub_gamma1=e(Ustar)
mat list Ub_gamma1
mat CILb_gamma1=e(CIL)
mat list CILb_gamma1
mat CIUb_gamma1=e(CIU)
mat list CIUb_gamma1

*P2: LNATE_nt
matrix blnt2=b[1,114..115]'
matrix list blnt2
matrix bunt2=b[1, 116]'
matrix list bunt2

matrix Vblnt2=Vb[114..115, 114..115]
matrix list Vblnt2

matrix Vbunt2=Vb[116,116]
matrix list Vbunt2

set seed 1989
CLR blnt2 Vblnt2 bunt2 Vbunt2 N 100000 0.05
mat Lnate_nt2=e(Lstar)
mat list Lnate_nt2
mat Unate_nt2=e(Ustar)
mat list Unate_nt2
mat CILnate_nt2=e(CIL)
mat list CILnate_nt2
mat CIUnate_nt2=e(CIU)
mat list CIUnate_nt2

* P2: LNATE_at
matrix blat2=b[1,117..118]'
matrix list blat2
matrix buat2=b[1,119]'
matrix list buat2

matrix Vblat2=Vb[117..118,117..118]
matrix list Vblat2

matrix Vbuat2=Vb[119,119]
matrix list Vbuat2

set seed 1989
CLR blat2 Vblat2 buat2 Vbuat2 N 100000 0.05
mat Lnate_at2=e(Lstar)
mat list Lnate_at2
mat Unate_at2=e(Ustar)
mat list Unate_at2
mat CILnate_at2=e(CIL)
mat list CILnate_at2
mat CIUnate_at2=e(CIU)
mat list CIUnate_at2

*P2: LNATE_0c
matrix blc02=b[1,120]'
matrix list blc02
matrix buc02=b[1,121]'
matrix list buc02

matrix Vblc02=Vb[120,120]
matrix list Vblc02

matrix Vbuc02=Vb[121,121]
matrix list Vbuc02

set seed 1989
CLR blc02 Vblc02 buc02 Vbuc02 N 100000 0.05
mat Lnate_c02=e(Lstar)
mat list Lnate_c02
mat Unate_c02=e(Ustar)
mat list Unate_c02
mat CILnate_c02=e(CIL)
mat list CILnate_c02
mat CIUnate_c02=e(CIU)
mat list CIUnate_c02

*P2: LNATE_1c
matrix blc12=b[1,120]'
matrix list blc12
matrix buc12=b[1,121]'
matrix list buc12

matrix Vblc12=Vb[120,120]
matrix list Vblc12

matrix Vbuc12=Vb[121,121]
matrix list Vbuc12

set seed 1989
CLR blc12 Vblc12 buc12 Vbuc12 N 100000 0.05
mat Lnate_c12=e(Lstar)
mat list Lnate_c12
mat Unate_c12=e(Ustar)
mat list Unate_c12
mat CILnate_c12=e(CIL)
mat list CILnate_c12
mat CIUnate_c12=e(CIU)
mat list CIUnate_c12

*P2: LMATE_0c
matrix blc02=b[1,120]'
matrix list blc02
matrix buc02=b[1,121]'
matrix list buc02

matrix Vblc02=Vb[120,120]
matrix list Vblc02

matrix Vbuc02=Vb[121,121]
matrix list Vbuc02

set seed 1989
CLR blc02 Vblc02 buc02 Vbuc02 N 100000 0.05
mat Lmate_c02=e(Lstar)
mat list Lmate_c02
mat Umate_c02=e(Ustar)
mat list Umate_c02
mat CILmate_c02=e(CIL)
mat list CILmate_c02
mat CIUmate_c02=e(CIU)
mat list CIUmate_c02

*P2: LMATE_1c
matrix blc12=b[1,120]'
matrix list blc12
matrix buc12=b[1,121]'
matrix list buc12

matrix Vblc12=Vb[120,120]
matrix list Vblc12

matrix Vbuc12=Vb[121,121]
matrix list Vbuc12

set seed 1989
CLR blc12 Vblc12 buc12 Vbuc12 N 100000 0.05
mat Lmate_c12=e(Lstar)
mat list Lmate_c12
mat Umate_c12=e(Ustar)
mat list Umate_c12
mat CILmate_c12=e(CIL)
mat list CILmate_c12
mat CIUmate_c12=e(CIU)
mat list CIUmate_c12

*P2: ATE for nt:  
matrix lb_Delta_nt2=b[1,137]'
matrix list lb_Delta_nt2
matrix ub_Delta_nt2=b[1,138]'
matrix list ub_Delta_nt2

matrix Vlb_Delta_nt2=Vb[137,137]
matrix list Vlb_Delta_nt2

matrix Vub_Delta_nt2=Vb[138,138]
matrix list Vub_Delta_nt2

set seed 1989
CLR lb_Delta_nt2 Vlb_Delta_nt2 ub_Delta_nt2 Vub_Delta_nt2 N 100000 0.05
mat Lb_delta_nt2=e(Lstar)
mat list Lb_delta_nt2
mat Ub_delta_nt2=e(Ustar)
mat list Ub_delta_nt2
mat CILb_delta_nt2=e(CIL)
mat list CILb_delta_nt2
mat CIUb_delta_nt2=e(CIU)
mat list CIUb_delta_nt2

*P2: ATE for at:  
matrix lb_Delta_at2=b[1,139]'
matrix list lb_Delta_at2
matrix ub_Delta_at2=b[1,140]'
matrix list ub_Delta_at2

matrix Vlb_Delta_at2=Vb[139,139]
matrix list Vlb_Delta_at2

matrix Vub_Delta_at2=Vb[140,140]
matrix list Vub_Delta_at2

set seed 1989
CLR lb_Delta_at2 Vlb_Delta_at2 ub_Delta_at2 Vub_Delta_at2 N 100000 0.05
mat Lb_delta_at2=e(Lstar)
mat list Lb_delta_at2
mat Ub_delta_at2=e(Ustar)
mat list Ub_delta_at2
mat CILb_delta_at2=e(CIL)
mat list CILb_delta_at2
mat CIUb_delta_at2=e(CIU)
mat list CIUb_delta_at2

*P2: ATE 
matrix lb_Delta_2=b[1,40]'
matrix list lb_Delta_2
matrix ub_Delta_2=b[1,51..75]'
matrix list ub_Delta_2

matrix Vlb_Delta_2=Vb[40,40]
matrix list Vlb_Delta_2

matrix Vub_Delta_2=Vb[51..75, 51..75]
matrix list Vub_Delta_2

set seed 1989
CLR lb_Delta_2 Vlb_Delta_2 ub_Delta_2 Vub_Delta_2 N 100000 0.05
mat Lb_delta2=e(Lstar)
mat list Lb_delta2
mat Ub_delta2=e(Ustar)
mat list Ub_delta2
mat CILb_delta2=e(CIL)
mat list CILb_delta2
mat CIUb_delta2=e(CIU)
mat list CIUb_delta2

*P2: ATT
matrix lb_Delta_2=b[1,102]'
matrix list lb_Delta_2
matrix ub_Delta_2=b[1,103..104]'
matrix list ub_Delta_2

matrix Vlb_Delta_2=Vb[102,102]
matrix list Vlb_Delta_2

matrix Vub_Delta_2=Vb[103..104,103..104]
matrix list Vub_Delta_2

set seed 1989
CLR lb_Delta_2 Vlb_Delta_2 ub_Delta_2 Vub_Delta_2 N 100000 0.05
mat Lb_gamma2=e(Lstar)
mat list Lb_gamma2
mat Ub_gamma2=e(Ustar)
mat list Ub_gamma2
mat CILb_gamma2=e(CIL)
mat list CILb_gamma2
mat CIUb_gamma2=e(CIU)
mat list CIUb_gamma2


*P2: MATE
matrix blM2=b[1,122]'
matrix list blM2
matrix buM2=b[1,123..126]'
matrix list buM2

matrix VblM2=Vb[122,122]
matrix list VblM2

matrix G=Vb[123..126,123..126]
mcholx  G
mat L=e(L)
mat D=e(D)
mat VbuM2=L*D*L'
matrix list VbuM2

set seed 1989
CLR blM2 VblM2 buM2 VbuM2 N 100000 0.05
mat Lmate2=e(Lstar)
mat list Lmate2
mat Umate2=e(Ustar)
mat list Umate2
mat CILmate2=e(CIL)
mat list CILmate2
mat CIUmate2=e(CIU)
mat list CIUmate2


*P2: NATE
matrix blN2=b[1,127..130]'
matrix list blN2
matrix buN2=b[1,131]'
matrix list buN2

matrix G=Vb[127..130,127..130]
mcholx  G
mat L=e(L)
mat D=e(D)
mat VblN2=L*D*L'
matrix list VblN2

matrix VbuN2=Vb[131,131]
matrix list VbuN2

set seed 1989
CLR blN2 VblN2 buN2 VbuN2 N 100000 0.05
mat Lnate2=e(Lstar)
mat list Lnate2
mat Unate2=e(Ustar)
mat list Unate2
mat CILnate2=e(CIL)
mat list CILnate2
mat CIUnate2=e(CIU)
mat list CIUnate2


*P2: LATE
matrix blL2=b[1,132]'
matrix list blL2
matrix buL2=b[1,133..136]'
matrix list buL2

mat VblL2=Vb[132,132]
matrix list VblL2

matrix G=Vb[133..136,133..136]
mcholx  G
mat L=e(L) 
mat D=e(D)
mat VbuL2=L*D*L'
matrix list VbuL2

set seed 1989
CLR blL2 VblL2 buL2 VbuL2 N 100000 0.05
mat Llate2=e(Lstar)
mat list Llate2
mat Ulate2=e(Ustar)
mat list Ulate2
mat CILlate2=e(CIL)
mat list CILlate2
mat CIUlate2=e(CIU)
mat list CIUlate2


*P3: LNATE_nt
matrix blnt3=b[1,141]'
matrix list blnt3
matrix bunt3=b[1,142]'
matrix list bunt3

matrix Vblnt3=Vb[141,141]
matrix list Vblnt3

matrix Vbunt3=Vb[142,142]
matrix list Vbunt3

set seed 1989
CLR blnt3 Vblnt3 bunt3 Vbunt3 N 100000 0.05
mat Lnate_nt3=e(Lstar)
mat list Lnate_nt3
mat Unate_nt3=e(Ustar)
mat list Unate_nt3
mat CILnate_nt3=e(CIL)
mat list CILnate_nt3
mat CIUnate_nt3=e(CIU)
mat list CIUnate_nt3

*P3: LNATE_at
matrix blat3=b[1,143]'
matrix list blat3
matrix buat3=b[1,144]'
matrix list buat3

matrix Vblat3=Vb[143,143]
matrix list Vblat3

matrix Vbuat3=Vb[144,144]
matrix list Vbuat3

set seed 1989
CLR blat3 Vblat3 buat3 Vbuat3 N 100000 0.05
mat Lnate_at3=e(Lstar)
mat list Lnate_at3
mat Unate_at3=e(Ustar)
mat list Unate_at3
mat CILnate_at3=e(CIL)
mat list CILnate_at3
mat CIUnate_at3=e(CIU)
mat list CIUnate_at3

*P3: LNATE_c0
matrix blnc03=b[1,145..146]'
matrix list blnc03
matrix bunc03=b[1,147]'
matrix list bunc03

matrix Vblnc03=Vb[145..146,145..146]
matrix list Vblnc03

matrix Vbunc03=Vb[147,147]
matrix list Vbunc03

set seed 1989
CLR blnc03 Vblnc03 bunc03 Vbunc03 N 100000 0.05
mat Lnate_c03=e(Lstar)
mat list Lnate_c03
mat Unate_c03=e(Ustar)
mat list Unate_c03
mat CILnate_c03=e(CIL)
mat list CILnate_c03
mat CIUnate_c03=e(CIU)
mat list CIUnate_c03

*P3: LNATE_c1
matrix blnc13=b[1,148..149]'
matrix list blnc13
matrix bunc13=b[1,150]'
matrix list bunc13

matrix Vblnc13=Vb[148..149,148..149]
matrix list Vblnc13

matrix Vbunc13=Vb[150,150]
matrix list Vbunc13

set seed 1989
CLR blnc13 Vblnc13 bunc13 Vbunc13 N 100000 0.05
mat Lnate_c13=e(Lstar)
mat list Lnate_c13
mat Unate_c13=e(Ustar)
mat list Unate_c13
mat CILnate_c13=e(CIL)
mat list CILnate_c13
mat CIUnate_c13=e(CIU)
mat list CIUnate_c13

*P3: LMATE_c1
matrix blmc13=b[1,151..152]'
matrix list blmc13
matrix bumc13=b[1,153]'
matrix list bumc13

matrix Vblmc13=Vb[151..152,151..152]
matrix list Vblmc13

matrix Vbumc13=Vb[153,153]
matrix list Vbumc13

set seed 1989
CLR blmc13 Vblmc13 bumc13 Vbumc13 N 100000 0.05
mat Lmate_c13=e(Lstar)
mat list Lmate_c13
mat Umate_c13=e(Ustar)
mat list Umate_c13
mat CILmate_c13=e(CIL)
mat list CILmate_c13
mat CIUmate_c13=e(CIU)
mat list CIUmate_c13

*P3: LMATE_c0
matrix blmc03=b[1,154..155]'
matrix list blmc03
matrix bumc03=b[1,156]'
matrix list bumc03

matrix Vblmc03=Vb[154..155,154..155]
matrix list Vblmc03

matrix Vbumc03=Vb[156,156]
matrix list Vbumc03

set seed 1989
CLR blmc03 Vblmc03 bumc03 Vbumc03 N 100000 0.05
mat Lmate_c03=e(Lstar)
mat list Lmate_c03
mat Umate_c03=e(Ustar)
mat list Umate_c03
mat CILmate_c03=e(CIL)
mat list CILmate_c03
mat CIUmate_c03=e(CIU)
mat list CIUmate_c03

*P3: ATE for nt  
matrix lb_Delta_nt3=b[1,166]'
matrix list lb_Delta_nt3
matrix ub_Delta_nt3=b[1,167]'
matrix list ub_Delta_nt3

matrix Vlb_Delta_nt3=Vb[166,166]
matrix list Vlb_Delta_nt3

matrix Vub_Delta_nt3=Vb[167,167]
matrix list Vub_Delta_nt3

set seed 1989
CLR lb_Delta_nt3 Vlb_Delta_nt3 ub_Delta_nt3 Vub_Delta_nt3 N 100000 0.05
mat Lb_delta_nt3=e(Lstar)
mat list Lb_delta_nt3
mat Ub_delta_nt3=e(Ustar)
mat list Ub_delta_nt3
mat CILb_delta_nt3=e(CIL)
mat list CILb_delta_nt3
mat CIUb_delta_nt3=e(CIU)
mat list CIUb_delta_nt3

*P3: ATE for at  
matrix lb_Delta_at3=b[1,168]'
matrix list lb_Delta_at3
matrix ub_Delta_at3=b[1,169]'
matrix list ub_Delta_at3

matrix Vlb_Delta_at3=Vb[168,168]
matrix list Vlb_Delta_at3

matrix Vub_Delta_at3=Vb[169,169]
matrix list Vub_Delta_at3

set seed 1989
CLR lb_Delta_at3 Vlb_Delta_at3 ub_Delta_at3 Vub_Delta_at3 N 100000 0.05
mat Lb_delta_at3=e(Lstar)
mat list Lb_delta_at3
mat Ub_delta_at3=e(Ustar)
mat list Ub_delta_at3
mat CILb_delta_at3=e(CIL)
mat list CILb_delta_at3
mat CIUb_delta_at3=e(CIU)
mat list CIUb_delta_at3

*P3: ATE
matrix lb_Delta3=b[1,80]'
matrix list lb_Delta3
matrix ub_Delta3=b[1,81]'
matrix list ub_Delta3

matrix Vlb_Delta3=Vb[80,80]
matrix list Vlb_Delta3

matrix Vub_Delta3=Vb[81,81]
matrix list Vub_Delta3

set seed 1989
CLR lb_Delta3 Vlb_Delta3 ub_Delta3 Vub_Delta3 N 100000 0.05
mat Lb_delta3=e(Lstar)
mat list Lb_delta3
mat Ub_delta3=e(Ustar)
mat list Ub_delta3
mat CILb_delta3=e(CIL)
mat list CILb_delta3
mat CIUb_delta3=e(CIU)
mat list CIUb_delta3

*P3: ATT
matrix lb_Gamma3=b[1,105]'
matrix list lb_Gamma3
matrix ub_Gamma3=b[1,106]'
matrix list ub_Gamma3

matrix Vlb_Gamma3=Vb[105,105]
matrix list Vlb_Gamma3

matrix Vub_Gamma3=Vb[106,106]
matrix list Vub_Gamma3

set seed 1989
CLR lb_Gamma3 Vlb_Gamma3 ub_Gamma3 Vub_Gamma3 N 100000 0.05
mat Lb_gamma3=e(Lstar)
mat list Lb_gamma3
mat Ub_gamma3=e(Ustar)
mat list Ub_gamma3
mat CILb_gamma3=e(CIL)
mat list CILb_gamma3
mat CIUb_gamma3=e(CIU)
mat list CIUb_gamma3

*P3: MATE
matrix blM3=b[1,157..158]'
matrix list blM3
matrix buM3=b[1,159]'
matrix list buM3

matrix G=Vb[157..158,157..158]
mat list G
mcholx  G
mat L=e(L)
mat D=e(D)
mat VblM3=L*D*L'
matrix list VblM3

matrix VbuM3=Vb[159,159]
matrix list VbuM3

set seed 1989
CLR blM3 VblM3 buM3 VbuM3 N 100000 0.05
mat Lmate3=e(Lstar)
mat list Lmate3
mat Umate3=e(Ustar)
mat list Umate3
mat CILmate3=e(CIL)
mat list CILmate3
mat CIUmate3=e(CIU)
mat list CIUmate3

* P3: NATE
matrix blN3=b[1,160]'
matrix list blN3
matrix buN3=b[1,161..162]'
matrix list buN3

matrix VblN3=Vb[160,160]
matrix list VblN3

matrix VbuN3=Vb[161..162,161..162]
matrix list VbuN3

set seed 1989
CLR blN3 VblN3 buN3 VbuN3 N 100000 0.05
mat Lnate3=e(Lstar)
mat list Lnate3
mat Unate3=e(Ustar)
mat list Unate3
mat CILnate3=e(CIL)
mat list CILnate3
mat CIUnate3=e(CIU)
mat list CIUnate3

*P3: LATE
matrix blL3=b[1,163..164]'
matrix list blL3
matrix buL3=b[1,165]'
matrix list buL3

matrix VblL3=Vb[163..164,163..164]
matrix list VblL3

matrix VbuL3=Vb[165,165]
matrix list VbuL3

set seed 1989
CLR blL3 VblL3 buL3 VbuL3 N 100000 0.05
mat Llate3=e(Lstar)
mat list Llate3
mat Ulate3=e(Ustar)
mat list Ulate3
mat CILlate3=e(CIL)
mat list CILlate3
mat CIUlate3=e(CIU)
mat list CIUlate3

*P4: LNATE_nt 
matrix blnt4=b[1,170..171]'
matrix list blnt4
matrix bunt4=b[1,172]'
matrix list bunt4

matrix Vblnt4=Vb[170..171,170..171]
matrix list Vblnt4

matrix Vbunt4=Vb[172,172]
matrix list Vbunt4

set seed 1989
CLR blnt4 Vblnt4 bunt4 Vbunt4 N 100000 0.05
mat Lnate_nt4=e(Lstar)
mat list Lnate_nt4
mat Unate_nt4=e(Ustar)
mat list Unate_nt4
mat CILnate_nt4=e(CIL)
mat list CILnate_nt4
mat CIUnate_nt4=e(CIU)
mat list CIUnate_nt4

* P4: LNATE_at 
matrix blat4=b[1,173..174]'
matrix list blat4
matrix buat4=b[1,175]'
matrix list buat4

matrix Vblat4=Vb[173..174,173..174]
matrix list Vblat4

matrix Vbuat4=Vb[175,175]
matrix list Vbuat4

set seed 1989
CLR blat4 Vblat4 buat4 Vbuat4 N 100000 0.05
mat Lnate_at4=e(Lstar)
mat list Lnate_at4
mat Unate_at4=e(Ustar)
mat list Unate_at4
mat CILnate_at4=e(CIL)
mat list CILnate_at4
mat CIUnate_at4=e(CIU)
mat list CIUnate_at4

* P4: LNATE_c0 
matrix blnc04=b[1,176..178]'
matrix list blnc04
matrix bunc04=b[1,179]'
matrix list bunc04

matrix Vblnc04=Vb[176..178,176..178]
matrix list Vblnc04

matrix Vbunc04=Vb[179,179]
matrix list Vbunc04

set seed 1989
CLR blnc04 Vblnc04 bunc04 Vbunc04 N 100000 0.05
mat Lnate_c04=e(Lstar)
mat list Lnate_c04
mat Unate_c04=e(Ustar)
mat list Unate_c04
mat CILnate_c04=e(CIL)
mat list CILnate_c04
mat CIUnate_c04=e(CIU)
mat list CIUnate_c04

* P4: LNATE_c1
matrix blnc14=b[1,180..182]'
matrix list blnc14
matrix bunc14=b[1,183]'
matrix list bunc14

matrix Vblnc14=Vb[180..182,180..182]
matrix list Vblnc14

matrix Vbunc14=Vb[183,183]
matrix list Vbunc14

set seed 1989
CLR blnc14 Vblnc14 bunc14 Vbunc14 N 100000 0.05
mat Lnate_c14=e(Lstar)
mat list Lnate_c14
mat Unate_c14=e(Ustar)
mat list Unate_c14
mat CILnate_c14=e(CIL)
mat list CILnate_c14
mat CIUnate_c14=e(CIU)
mat list CIUnate_c14

* P4: LMATE_c1
matrix blmc14=b[1,184]'
matrix list blmc14
matrix bumc14=b[1,185..186]'
matrix list bumc14

matrix Vblmc14=Vb[184,184]
matrix list Vblmc14

matrix Vbumc14=Vb[185..186,185..186]
matrix list Vbumc14

set seed 1989
CLR blmc14 Vblmc14 bumc14 Vbumc14 N 100000 0.05
mat Lmate_c14=e(Lstar)
mat list Lmate_c14
mat Umate_c14=e(Ustar)
mat list Umate_c14
mat CILmate_c14=e(CIL)
mat list CILmate_c14
mat CIUmate_c14=e(CIU)
mat list CIUmate_c14

*P4: LMATE_c0
matrix blmc04=b[1,187]'
matrix list blmc04
matrix bumc04=b[1,188..189]'
matrix list bumc04

matrix Vblmc04=Vb[187,187]
matrix list Vblmc04

matrix Vbumc04=Vb[188..189,188..189]
matrix list Vbumc04

set seed 1989
CLR blmc04 Vblmc04 bumc04 Vbumc04 N 100000 0.05
mat Lmate_c04=e(Lstar)
mat list Lmate_c04
mat Umate_c04=e(Ustar)
mat list Umate_c04
mat CILmate_c04=e(CIL)
mat list CILmate_c04
mat CIUmate_c04=e(CIU)
mat list CIUmate_c04

*P4: ATE for nt  
matrix lb_Delta_nt4=b[1,241]'
matrix list lb_Delta_nt4
matrix ub_Delta_nt4=b[1,242..243]'
matrix list ub_Delta_nt4

matrix Vlb_Delta_nt4=Vb[241,241]
matrix list Vlb_Delta_nt4

matrix Vub_Delta_nt4=Vb[242..243,242..243]
matrix list Vub_Delta_nt4

set seed 1989
CLR lb_Delta_nt4 Vlb_Delta_nt4 ub_Delta_nt4 Vub_Delta_nt4 N 100000 0.05
mat Lb_delta_nt4=e(Lstar)
mat list Lb_delta_nt4
mat Ub_delta_nt4=e(Ustar)
mat list Ub_delta_nt4
mat CILb_delta_nt4=e(CIL)
mat list CILb_delta_nt4
mat CIUb_delta_nt4=e(CIU)
mat list CIUb_delta_nt4

*P4: ATE for at  
matrix lb_Delta_at4=b[1,244]'
matrix list lb_Delta_at4
matrix ub_Delta_at4=b[1,245..246]'
matrix list ub_Delta_at4

matrix Vlb_Delta_at4=Vb[244,244]
matrix list Vlb_Delta_at4

matrix Vub_Delta_at4=Vb[245..246,245..246]
matrix list Vub_Delta_at4

set seed 1989
CLR lb_Delta_at4 Vlb_Delta_at4 ub_Delta_at4 Vub_Delta_at4 N 100000 0.05
mat Lb_delta_at4=e(Lstar)
mat list Lb_delta_at4
mat Ub_delta_at4=e(Ustar)
mat list Ub_delta_at4
mat CILb_delta_at4=e(CIL)
mat list CILb_delta_at4
mat CIUb_delta_at4=e(CIU)
mat list CIUb_delta_at4

*P4: ATE
matrix lb_Delta4=b[1,82]'
matrix list lb_Delta4
matrix ub_Delta4=b[1,83..98]'
matrix list ub_Delta4

matrix Vlb_Delta4=Vb[82,82]
matrix list Vlb_Delta4

matrix Vub_Delta4=Vb[83..98,83..98]
matrix list Vub_Delta4

set seed 1989
CLR lb_Delta4 Vlb_Delta4 ub_Delta4 Vub_Delta4 N 100000 0.05
mat Lb_delta4=e(Lstar)
mat list Lb_delta4
mat Ub_delta4=e(Ustar)
mat list Ub_delta4
mat CILb_delta4=e(CIL)
mat list CILb_delta4
mat CIUb_delta4=e(CIU)
mat list CIUb_delta4

*P4: ATT
matrix lb_Gamma4=b[1,107]'
matrix list lb_Gamma4
matrix ub_Gamma4=b[1,108..109]'
matrix list ub_Gamma4

matrix Vlb_Gamma4=Vb[107,107]
matrix list Vlb_Gamma4

matrix Vub_Gamma4=Vb[108..109,108..109]
matrix list Vub_Gamma4

set seed 1989
CLR lb_Gamma4 Vlb_Gamma4 ub_Gamma4 Vub_Gamma4 N 100000 0.05
mat Lb_gamma4=e(Lstar)
mat list Lb_gamma4
mat Ub_gamma4=e(Ustar)
mat list Ub_gamma4
mat CILb_gamma4=e(CIL)
mat list CILb_gamma4
mat CIUb_gamma4=e(CIU)
mat list CIUb_gamma4

*P4: MATE
matrix blM4=b[1,190]'
matrix list blM4
matrix buM4=b[1,191..206]'
matrix list buM4

matrix VblM4=Vb[190,190]
matrix list VblM4

matrix G=Vb[191..206,191..206]
mcholx  G
mat L=e(L)
mat D=e(D)
mat VbuM4=L*D*L'
mat li VbuM4

set seed 1989
CLR blM4 VblM4 buM4 VbuM4 N 100000 0.05
mat Lmate4=e(Lstar)
mat list Lmate4
mat Umate4=e(Ustar)
mat list Umate4
mat CILmate4=e(CIL)
mat list CILmate4
mat CIUmate4=e(CIU)
mat list CIUmate4

*P4: NATE
matrix blN4=b[1,207..222]'
matrix list blN4
matrix buN4=b[1,223]'
matrix list buN4

matrix G=Vb[207..222, 207..222]
mcholx  G
mat L=e(L)
mat D=e(D)
mat VblN4=L*D*L'

matrix VbuN4=Vb[223,223]
mat list VbuN4

set seed 1989
CLR blN4 VblN4 buN4 VbuN4 N 100000 0.05
mat Lnate4=e(Lstar)
mat list Lnate4
mat Unate4=e(Ustar)
mat list Unate4
mat CILnate4=e(CIL)
mat list CILnate4
mat CIUnate4=e(CIU)
mat list CIUnate4

*Full sample P4: LATE 
matrix blL4=b[1,224]'
matrix list blL4
matrix buL4=b[1,225..240]'
matrix list buL4

mat VblL4=Vb[224,224]
matrix list VblL4

matrix G=Vb[225..240,225..240]
mcholx  G
mat L=e(L)
mat D=e(D)
mat VbuL4=L*D*L'
matrix list VbuL4 

set seed 1989
CLR blL4 VblL4 buL4 VbuL4 N 100000 0.05
mat Llate4=e(Lstar)
mat list Llate4
mat Ulate4=e(Ustar)
mat list Ulate4
mat CILlate4=e(CIL)
mat list CILlate4
mat CIUlate4=e(CIU)
mat list CIUlate4


/*             Print results                  */
/*     Mean Estimates     */
qui{ 

 mat Means=J(25,2,.)

 mat rownames Means = "# of observations" "ITT"  ///
         "Compliers" "LATE" "Always-takers"  "Never-takers" "pr_at_c" "pr_nt_c" /// 
		 "Y11" "Y00" "Y01" "Y10" ///
		 "EY[Z1]"  "EY[Z0]"  "EY[D1]" "EY[D0]" "Imp_a" "Imp_b" "Imp_c" ///
		 "Min y" "Max y" "PrZ0" "PrZ1" "PrS0" "PrS1"
	
 mat colnames Means = "Mean" "Standard Errors"

 forval x=1(1)25 { 

	    mat Means[`x',1]=b[1,`x'] 
		mat Means[`x',2]=se[1,`x'] 
		
		}
		
}
mat li Means

/*
/*     Observation of Estimands Report     */
qui{ 

 mat Observations=J(23,1,.)

 mat rownames Observations =  "obs_pr_at" "obs_pr_nt" "obs_pr_at_c" "obs_pr_nt_c" /// 
     "obs_pr_z1" "obs_y0_at" "obs_y_at_c" "obs_y1_nt" "obs_y_nt_c" "obs_y0" /// 
	 "obs_y1" "obs_LY1_at" "obs_UY1_at" "obs_LY1_c" "obs_UY1_c" "obs_LY0_nt" /// 
	 "obs_UY0_nt"  "obs_LY0_c"  "obs_UY0_c" "obs_pr_s1" "obs_y_s1" "obs_y_s0" "Total"
	
 mat colnames Observations = "Num observations" 

 forval x=1(1)22 { 

	    mat Observations[`x',1]=b[1,252+`x'] 
		
		
		}
		
		mat Observations[23,1]=b[1,1] 
}
mat li Observations
*/

/*       The bounds estimation and CIs           */
qui{
mat Results=J(14,8,.)
mat list Results


mat colnames Results = "Ass1&3: Lower bound" "Ass1&3: Upper bound" "Ass1&4: Lower bound" /// 
          "Ass1&4: Upper bound"  "Ass1&5: Lower bound" "Ass1&5: Upper bound" ///
		   "Ass1,4&5: Lower bound" "Ass1,4&5: Upper bound" 
	
mat rownames Results = "Lnate_nt" "CI_Lnate_nt_95%" "Lnate_at" "CI_Lnate_at_95%"   /// 
           "Lnate_c" "CI_Lnate_c_95%"  "Lmate_c" "CI_Lmate_c_95%" /// 
		     "MATE" "CI_MATE_95%" "NATE" "CI_NATE_95%" "LATE" "CI_LATE_95%" ///
		   
		   
forval val=1(2)7{
	    local lower=(`val'+1)/2
		mat Results[1,`val']=Lnate_nt`lower'
		mat Results[2,`val']=CILnate_nt`lower'
		mat Results[3,`val']=Lnate_at`lower'
		mat Results[4,`val']=CILnate_at`lower'
		
		if `val'>1 {
		mat Results[5,`val']=Lnate_c0`lower'
		mat Results[6,`val']=CILnate_c0`lower'
		mat Results[7,`val']=Lmate_c1`lower'
		mat Results[8,`val']=CILmate_c1`lower'
		mat Results[9,`val']=Lmate`lower'
		mat Results[10,`val']=CILmate`lower'
		mat Results[11,`val']=Lnate`lower'
		mat Results[12,`val']=CILnate`lower'
		mat Results[13,`val']=Llate`lower'
		mat Results[14,`val']=CILlate`lower'
		}
		}
		
forval val=2(2)8 {
	    local upper=`val'/2
		mat Results[1,`val']=Unate_nt`upper'
		mat Results[2,`val']=CIUnate_nt`upper'
		mat Results[3,`val']=Unate_at`upper'
		mat Results[4,`val']=CIUnate_at`upper'
		if `val'>2{
		mat Results[5,`val']=Unate_c0`upper'
		mat Results[6,`val']=CIUnate_c0`upper'
		mat Results[7,`val']=Umate_c1`upper'
		mat Results[8,`val']=CIUmate_c1`upper'
		mat Results[9,`val']=Umate`upper'
		mat Results[10,`val']=CIUmate`upper'
		mat Results[11,`val']=Unate`upper'
		mat Results[12,`val']=CIUnate`upper'
		mat Results[13,`val']=Ulate`upper'
		mat Results[14,`val']=CIUlate`upper'
		}
		}
		
	}	
	mat li Results 
	
	
