# delimit ;

set more 1;

program InvalidIV_ATEw, eclass;
/* Calculate Bounds on ATE and ATT with an Invalid IV*/;
/* Calculate a normalized weight,wgt*/;

	marksample touse;
	args y z s wgt sv;
	confirm var `y' `z' `s' `wgt' `sv';

	  /* syntax: depvar treatmentvar selectvar wgt sortvar */;
			  /* depvar is the outcome variable */;
			  /* treatmentvar is the binary treatment variable */;
			  /* selectvar is the binary sample selection indicator */;
			  /* wei1 is the design weight */;
			  /* sortvar is the variable that will break "ties" if the outcome variable is discrete */;
			  
	tempvar y_trim1 y_trim0 swgt1 swgt0; /* outcomevar to be trimmed, accumulative weights in {Z=1,D=1} and {Z=0,D=0}*/;
    tempname pr_at_c pr_nt_c; 
	tempvar at nt at_c nt_c; /* principal strata indicator*/;
	tempvar upid_at lowid_at upid_c1 lowid_c1 upid_nt lowid_nt upid_c0 lowid_c0; /* unconstrained upper and lower bound indicators*/;
	tempname sumw1 sumw0 ; /* sum of weights in {Z=1,D=1} and {Z=0,D=0} */;
	
	quietly keep if `z'~=.; /* delete all observations that don't have a treatment status */;
	
	** Count the total number of observations;  
	count;
	sca Num_obs=r(N) ;
	sca li Num_obs; 
	** Principal Strata ;
	quietly gen `at'=1 if `z'==0 & `s'==1; quietly replace `at'=0 if `at'==.;
    quietly gen `nt'=1 if `z'==1 & `s'==0; quietly replace `nt'=0 if `nt'==.;
    quietly gen `at_c'=1 if `z'==1 & `s'==1; quietly replace `at_c'=0 if `at_c'==.;
    quietly gen `nt_c'=1 if `z'==0 & `s'==0; quietly replace `nt_c'=0 if `nt_c'==.;
	
	**************************************;
	** Proportion of Principal Strata ; 
	quietly sum `at' if `z'==0 [aw=`wgt']; 
	scalar pr_at=r(mean);
	scalar obs_pr_at=r(N);
	quietly sum `nt' if `z'==1 [aw=`wgt']; 
	scalar pr_nt=r(mean);
	scalar obs_pr_nt=r(N);
    quietly sum `at_c' if `z'==1 [aw=`wgt']; scalar `pr_at_c'=r(mean); scalar obs_pr_at_c=r(N); 
	quietly sum `nt_c' if `z'==0 [aw=`wgt']; scalar `pr_nt_c'=r(mean); scalar obs_pr_nt_c=r(N); 
	
	scalar pr_c=`pr_at_c'- pr_at;
	
	scalar c_11=pr_c/`pr_at_c'; /* Trimming Proportions */;
	scalar at_11=pr_at/`pr_at_c'; 
	scalar c_00=pr_c/`pr_nt_c';
	scalar nt_00=pr_nt/`pr_nt_c';
	
	quietly sum `z' [aw=`wgt']; scalar pr_z1=r(mean); scalar obs_pr_z1=r(N); 
	scalar pr_z0=1-r(mean); /*Pr(Z=1) and Pr(Z=0)*/;
	
	****************************************;
	** Mean of outcome for each stratum ;
	quietly sum `y' if `at'==1 [aw=`wgt']; scalar y0_at=r(mean); scalar obs_y0_at=r(N);
	quietly sum `y' if `at_c'==1 [aw=`wgt']; scalar y_at_c=r(mean); scalar obs_y_at_c=r(N); scalar `sumw1'=r(sum_w);
	quietly sum `y' if `nt'==1 [aw=`wgt']; scalar y1_nt=r(mean); scalar obs_y1_nt=r(N);
	quietly sum `y' if `nt_c'==1 [aw=`wgt']; scalar y_nt_c=r(mean); scalar obs_y_nt_c=r(N); scalar `sumw0'=r(sum_w);
	
	quietly sum `y' if `z'==0 [aw=`wgt']; scalar y0=r(mean); scalar obs_y0=r(N);
	quietly sum `y' if `z'==1 [aw=`wgt']; scalar y1=r(mean); scalar obs_y1=r(N);
	
	*********************************************;
	** Trimming the cell {Z=1,S=1} starts: derive bounds for always-takers and compliers when Z=1.;
	quietly gen `y_trim1'=`y' if `at_c'==1 ; 
	sort `y_trim1' `sv' ; /*sort the data.... nonmissing `y' is first */;
	quietly gen `swgt1'=sum(`wgt') if `at_c'==1 ;  /* generate running sum of weights */;
	
	** Lower bound for at;
		quietly gen `lowid_at'=1 if `swgt1'<=at_11*`sumw1'; /* generate variable to indicate lowid_at distribution */;
		quietly sum `y_trim1' if `lowid_at'==1 [aw=`wgt']; scalar LY1_at=r(mean); scalar obs_LY1_at=r(N);

	** Upper bound for at;
		quietly gen `upid_at'=1 if `swgt1'>(1-at_11)*`sumw1'; /* generate variable to indicate upid_at distribution */;
		quietly sum `y_trim1' if `upid_at'==1 [aw=`wgt']; scalar UY1_at=r(mean); scalar obs_UY1_at=r(N); 
	
	** Lower bound for c;
		quietly gen `lowid_c1'=1 if `swgt1'<=c_11*`sumw1'; /* generate variable to indicate lowid_c distribution */;
		quietly sum `y_trim1' if `lowid_c1'==1 [aw=`wgt']; scalar LY1_c=r(mean); scalar obs_LY1_c=r(N);

	** Upper bound for c;
		quietly gen `upid_c1'=1 if `swgt1'>(1-c_11)*`sumw1'; /* generate variable to indicate upid_c distribution */;
		quietly sum `y_trim1' if `upid_c1'==1 [aw=`wgt']; scalar UY1_c=r(mean); scalar obs_UY1_c=r(N);
	
	** Trimming the cell {Z=0,S=0} starts: derive bounds for never-takers and compliers when Z=0.;
	quietly gen `y_trim0'=`y' if `nt_c'==1 ; 
	sort `y_trim0' `sv' ;/*sort the data.... nonmissing `y' is first */;
	quietly gen `swgt0'=sum(`wgt') if `nt_c'==1 ; /* generate running sum of weights */;
	
	** Lower bound for nt;
		quietly gen `lowid_nt'=1 if `swgt0'<=nt_00*`sumw0'; /* generate variable to indicate lowid_nt distribution */;
		quietly sum `y_trim0' if `lowid_nt'==1 [aw=`wgt']; scalar LY0_nt=r(mean); scalar obs_LY0_nt=r(N);

	** Upper bound for nt;
		quietly gen `upid_nt'=1 if `swgt0'>(1-nt_00)*`sumw0'; /* generate variable to indicate upid_nt distribution */;
		quietly sum `y_trim0' if `upid_nt'==1 [aw=`wgt']; scalar UY0_nt=r(mean); scalar obs_UY0_nt=r(N);
	
	** Lower bound for c;
		quietly gen `lowid_c0'=1 if `swgt0'<=c_00*`sumw0'; /* generate variable to indicate lowid_c distribution */;
		quietly sum `y_trim0' if `lowid_c0'==1 [aw=`wgt']; scalar LY0_c=r(mean); scalar obs_LY0_c=r(N);

	** Upper bound for c;
		quietly gen `upid_c0'=1 if `swgt0'>(1-c_00)*`sumw0'; /* generate variable to indicate upid_c distribution */;
		quietly sum `y_trim0' if `upid_c0'==1 [aw=`wgt']; scalar UY0_c=r(mean); scalar obs_UY0_c=r(N);
		
	
	********************************;
	**Prop1;
	quietly sum `y' [aw=`wgt']; 
	scalar miny=r(min); 
	scalar maxy=r(max);
	scalar LB1_0=pr_at*(y0_at-maxy)+`pr_nt_c'*(miny-y_nt_c);
	scalar LB1_1=`pr_at_c'*(y_at_c-maxy)+pr_nt*(miny-y1_nt);
	scalar UB1_0=pr_at*(y0_at-miny)+`pr_nt_c'*(maxy-y_nt_c);
	scalar UB1_1=`pr_at_c'*(y_at_c-miny)+pr_nt*(maxy-y1_nt);
	
	scalar LB1=pr_z0*LB1_0+pr_z1*LB1_1;
	scalar UB1=pr_z0*UB1_0+pr_z1*UB1_1;
	
	**Prop2;
	scalar LB2=0;
	
	scalar UB2_0_1=pr_at*(y0_at-miny)+pr_nt*(maxy-LY0_nt)+y1-y0;
	scalar UB2_0_2=pr_at*(y0_at-miny)+pr_nt*(maxy-LY0_nt)+y1-y0-pr_at*(LY1_at-y0_at);
	scalar UB2_0_3=pr_at*(y0_at-miny)+pr_nt*(maxy-LY0_nt)+y1-y0-pr_nt*(y1_nt-UY0_nt);
	scalar UB2_0_4=pr_at*(y0_at-miny)+pr_nt*(maxy-LY0_nt)+y1-y0-pr_at*(LY1_at-y0_at)-pr_nt*(y1_nt-UY0_nt);
	scalar UB2_0_5=pr_at*(y0_at-miny)-`pr_nt_c'*y_nt_c+pr_nt*maxy+pr_c*UY1_c;
	
	scalar UB2_1_1=pr_at*(UY1_at-miny)+pr_nt*(maxy-y1_nt)+y1-y0;
	scalar UB2_1_2=pr_at*(UY1_at-miny)+pr_nt*(maxy-y1_nt)+y1-y0-pr_at*(LY1_at-y0_at);
	scalar UB2_1_3=pr_at*(UY1_at-miny)+pr_nt*(maxy-y1_nt)+y1-y0-pr_nt*(y1_nt-UY0_nt);
	scalar UB2_1_4=pr_at*(UY1_at-miny)+pr_nt*(maxy-y1_nt)+y1-y0-pr_at*(LY1_at-y0_at)-pr_nt*(y1_nt-UY0_nt);
	scalar UB2_1_5=`pr_at_c'*y_at_c+pr_nt*(maxy-y1_nt)-pr_at*miny-pr_c*LY0_c;
	
	local i=1;
	forvalues g=1(1)5{;
		forvalues h=1(1)5{;
		scalar UB2_`i'=pr_z0*UB2_0_`g'+pr_z1*UB2_1_`h';
		local ++i;
		};
	};
	
	**Prop3; 
	scalar LB3_0=y0_at-y_nt_c ;
	scalar LB3_1=y_at_c-y1_nt;
	scalar UB3_0=pr_at*(y0_at-miny)+pr_nt*maxy-`pr_nt_c'*y_nt_c+pr_c*UY0_nt;
	scalar UB3_1=pr_nt*(maxy-y1_nt)-pr_at*miny+`pr_at_c'*y_at_c-pr_c*LY1_at;
	
	scalar LB3=pr_z0*LB3_0+pr_z1*LB3_1;
	scalar UB3=pr_z0*UB3_0+pr_z1*UB3_1;
	
	**Prop4;
	scalar LB4=0;
	
	scalar UB4_0_1=y1-y_nt_c-pr_nt*(LY0_nt-y_at_c);
	scalar UB4_0_2=y1-y_nt_c-pr_nt*(LY0_nt-y_at_c+y1_nt-y_nt_c);
	scalar UB4_0_3=pr_at*y0_at-y_nt_c+`pr_nt_c'*y_at_c;
	scalar UB4_0_4=pr_at*y0_at-y_nt_c+`pr_nt_c'*y0_at;
	
	scalar UB4_1_1=y_at_c-y0+pr_at*(UY1_at-y_nt_c);
	scalar UB4_1_2=y_at_c-y0+pr_at*(UY1_at-y_nt_c-y_at_c+y0_at);
	scalar UB4_1_3=y_at_c-pr_nt*y1_nt-`pr_at_c'*y1_nt;
	scalar UB4_1_4=y_at_c-pr_nt*y1_nt-`pr_at_c'*y_nt_c;
	
	local i=1;
	forvalues g=1(1)4{;
		forvalues h=1(1)4{;
		scalar UB4_`i'=pr_z0*UB4_0_`g'+pr_z1*UB4_1_`h';
		local ++i;
		};
	};

	**********************************;
	**********************************;
	** Other values used to calculate Bounds on ATT;
	quietly sum `s' [aw=`wgt']; scalar pr_s1=r(mean); scalar obs_pr_s1=r(N); /*Pr(S=1)*/;
	scalar pr_s0=1-r(mean); /*Pr(S=0)*/;
	quietly sum `y' if `s'==1 [aw=`wgt']; scalar ys1=r(mean); /*E[Y|S=1]*/;
	
	**Prop1 on ATT;
	sca lb1=ys1-maxy;
	sca ub1=ys1-miny;
	
	**Prop2 on ATT;
	sca lb2=0;
	sca ub2_1=ys1-(pr_z1/pr_s1)*(`pr_nt_c'*y_nt_c-pr_nt*y1_nt)-(pr_at/pr_s1)*miny;
	sca ub2_2=ys1-(pr_z1/pr_s1)*pr_c*LY0_c-(pr_at/pr_s1)*miny;
	
	**Prop3 on ATT;
	sca lb3=ys1-(pr_z1/pr_s1)*pr_c*UY1_at-(pr_at/pr_s1)*maxy;
	sca ub3=ys1-(pr_z1/pr_s1)*`pr_at_c'*y1_nt-(pr_at/pr_s1)*pr_z0*y_nt_c;
	
	**Prop4 on ATT;
	sca lb4=0;
	sca ub4_1=ys1-(pr_z1/pr_s1)*(`pr_nt_c'*y_nt_c-pr_nt*y1_nt)-(pr_at/pr_s1)*y_nt_c;
	sca ub4_2=ys1-(pr_z1/pr_s1)*`pr_at_c'*y1_nt-(pr_at/pr_s1)*pr_z0*y_nt_c;
	
	
	**for reference;
	sca itt=y1-y0;
	sca late=itt/pr_c;
	
	
	*********************************************;
	*********************************************;
	**Local NATE and MATE;
	**Prop1;
	**LNATE_nt;
	sca lb1_nt=y1_nt-UY0_nt;
	sca ub1_nt=y1_nt-LY0_nt;
    **LNATE_at;
	sca lb1_at=LY1_at-y0_at ;
	sca ub1_at=UY1_at-y0_at ;
	**P1: ATE: never-takers ;
    *Lower bounds ;
    sca lb1_Ant=pr_z0*(miny-UY0_nt)+pr_z1*(miny-y1_nt);
    *Upper bounds ;
    sca ub1_Ant=pr_z0*(maxy-LY0_nt)+pr_z1*(maxy-y1_nt);
	**P1: ATE: always-takers ;
    *Lower bounds ;
    sca lb1_Aat=pr_z0*( y0_at-maxy )+pr_z1*( LY1_at-maxy );
    *Upper bounds ;
    sca ub1_Aat=pr_z0*( y0_at-miny )+pr_z1*( UY1_at-miny );

	**Prop2;
	**LNATE_nt;
	sca lb2_nt_1=0;
	sca lb2_nt_2=y1_nt-UY0_nt;
	sca ub2_nt=y1_nt-LY0_nt;
	**LNATE_at;
	sca lb2_at_1=0;
	sca lb2_at_2=LY1_at-y0_at;
	sca ub2_at=UY1_at-y0_at;
	**LNATE_c0, LNATE_c1, LMATE_c1, LMATE_c0 (they are all the same);
	sca lb2_c=0;
	sca ub2_c=UY1_c-LY0_c; 
	** MATE;
    sca ub2_M_1 = y1 - y0 ; 
    sca ub2_M_2 = y1 - y0 - (pr_at * (LY1_at - y0_at)) ; 
    sca ub2_M_3 = y1 - y0 - (pr_nt * (y1_nt - UY0_nt)) ; 
    sca ub2_M_4 = y1 - y0 - (pr_at * (LY1_at - y0_at)) - (pr_nt * (y1_nt - UY0_nt)) ;
	sca lb2_M = 0; 
	** NATE; 
	sca lb2_N_1 = y1 - y0 - ub2_M_1 ; 
    sca lb2_N_2 = y1 - y0 - ub2_M_2 ; 
    sca lb2_N_3 = y1 - y0 - ub2_M_3 ; 
    sca lb2_N_4 = y1 - y0 - ub2_M_4 ;
	sca ub2_N_4 = y1 - y0 ;  
	** LATE; 
	sca lb2_L = lb2_M /pr_c ; 
    sca ub2_L_1 = ub2_M_1 /pr_c ; 
    sca ub2_L_2 = ub2_M_2 /pr_c ; 
    sca ub2_L_3 = ub2_M_3 /pr_c ; 
    sca ub2_L_4 = ub2_M_4 /pr_c ;
	**LATE_nt ; 
	sca lb2_Ant=0; 
	sca ub2_Ant=pr_z1*(maxy-y1_nt)+pr_z0*(maxy-LY0_nt); 
	**LATE_at ; 
	sca lb2_Aat=0; 
	sca ub2_Aat=pr_z1*(UY1_at-miny)+pr_z0*(y0_at-miny); 
	
	
	**Prop3;
	**LNATE_nt;
	sca lb3_nt = y1_nt-y_nt_c;
	sca ub3_nt = y1_nt-LY0_nt;
	**LNATE_at;
	sca lb3_at = y_at_c-y0_at;
	sca ub3_at = UY1_at-y0_at;
	**LNATE_c0; 
	sca lb3_cN0_1 = y1_nt-UY0_c;
	sca lb3_cN0_2 = y1_nt-y0_at;
	sca ub3_cN0 = UY1_at-y_nt_c;
	**LNATE_c1; 
	sca lb3_cN1_1 = LY1_c-y0_at;
	sca lb3_cN1_2 = y1_nt-y0_at;
	sca ub3_cN1 = y_at_c-LY0_nt;
	**LMATE_c1; 
	sca lb3_cM1_1 = LY1_c-UY1_at;
	sca lb3_cM1_2 = y1_nt-UY1_at;
	sca ub3_cM1 = y_at_c-y1_nt;
	**LMATE_c0;
	sca lb3_cM0_1 = LY0_nt-UY0_c;
	sca lb3_cM0_2 = LY0_nt-y0_at;
	sca ub3_cM0 = y0_at-y_nt_c;
	** MATE;
	sca lb3_M_1 = pr_c * (LY1_c-UY1_at);
    sca lb3_M_2 = pr_c * (y1_nt-UY1_at);
	sca ub3_M = pr_c * (y_at_c-y1_nt);
	** NATE;
	sca lb3_N = y1-y0 - ub3_M; 
    sca ub3_N_1 = y1-y0 - lb3_M_1; 
    sca ub3_N_2 = y1-y0 - lb3_M_2; 
	** LATE; 
	sca lb3_L_1 = lb3_M_1/pr_c; 
    sca lb3_L_2 = lb3_M_2/pr_c;
	sca ub3_L = ub3_M/pr_c;
	**LATE_nt ; 
	sca lb3_Ant=pr_z1*(miny-y1_nt)+pr_z0*(miny-y_nt_c); 
	sca ub3_Ant=pr_z1*(y_at_c-y1_nt)+pr_z0*(y0_at-LY0_nt); 
	**LATE_at ; 
	sca lb3_Aat=pr_z1*(y_at_c-maxy)+pr_z0*(y0_at-maxy); 
	sca ub3_Aat=pr_z1*(UY1_at-y1_nt)+pr_z0*(y0_at-y_nt_c); 
	
	
	
	**Prop4;
	**LNATE_nt;
	sca lb4_nt_1=0;
	sca lb4_nt_2=y1_nt-y_nt_c;
	sca ub4_nt=y1_nt-LY0_nt;
	**LNATE_at;
	sca lb4_at_1=0;
	sca lb4_at_2=y_at_c-y0_at;
	sca ub4_at=UY1_at-y0_at;
	**LNATE_c0; 
	sca lb4_cN0_1=y1_nt-UY0_c;
	sca lb4_cN0_2=y1_nt-y0_at;
	sca lb4_cN0_3=0;
	sca ub4_cN0=y_at_c-y_nt_c;
	**LNATE_c1; 
	sca lb4_cN1_1=LY1_c-y0_at;
	sca lb4_cN1_2=y1_nt-y0_at;
	sca lb4_cN1_3=0;
	sca ub4_cN1=y_at_c-y_nt_c;
	**LMATE_c1; 
	sca lb4_cM1=0;
	sca ub4_cM1_1=y_at_c-y1_nt;
	sca ub4_cM1_2=y_at_c-y_nt_c;
	**LMATE_c0;
	sca lb4_cM0=0;
	sca ub4_cM0_1=y0_at-y_nt_c;
	sca ub4_cM0_2=y_at_c-y_nt_c;
	** MATE; 
	sca lb4_M = 0 ; 
	
    sca ub4_M_1 = y1 - pr_at * y_at_c - pr_nt * y1_nt - pr_c * y1_nt;
	sca ub4_M_2 = y1 - pr_at * y0_at - pr_nt * y1_nt - pr_c * y1_nt;
	sca ub4_M_3 = y1 - pr_at * y_at_c - pr_nt * y1_nt - pr_c * y_nt_c;
	sca ub4_M_4 = y1 - pr_at * y0_at - pr_nt * y1_nt - pr_c * y_nt_c;
	
	sca ub4_M_5 = y1 - y0 - pr_at*0 - pr_nt*0 - pr_c*0;
	sca ub4_M_6 = y1 - y0 - pr_at*lb4_at_2 - pr_nt*0 - pr_c*0;
	sca ub4_M_7 = y1 - y0 - pr_at*0 - pr_nt*lb4_nt_2 - pr_c*0;
	sca ub4_M_8 = y1 - y0 - pr_at*lb4_at_2 - pr_nt*lb4_nt_2- pr_c*0;
	
	sca ub4_M_9 = y1 - y0 - pr_at*0 - pr_nt*0 - pr_c*lb4_cN0_1;
	sca ub4_M_10 = y1 - y0 - pr_at*lb4_at_2 - pr_nt*0 - pr_c*lb4_cN0_1;
	sca ub4_M_11 = y1 - y0 - pr_at*0 - pr_nt*lb4_nt_2 - pr_c*lb4_cN0_1;
	sca ub4_M_12 = y1 - y0 - pr_at*lb4_at_2 - pr_nt*lb4_nt_2- pr_c*lb4_cN0_1;
	
	sca ub4_M_13 = y1 - y0 - pr_at*0 - pr_nt*0 - pr_c*lb4_cN0_2;
	sca ub4_M_14 = y1 - y0 - pr_at*lb4_at_2 - pr_nt*0 - pr_c*lb4_cN0_2;
	sca ub4_M_15 = y1 - y0 - pr_at*0 - pr_nt*lb4_nt_2 - pr_c*lb4_cN0_2;
	sca ub4_M_16 = y1 - y0 - pr_at*lb4_at_2 - pr_nt*lb4_nt_2- pr_c*lb4_cN0_2;
	
	** NATE;
	sca lb4_N_1 = y1 - y0 - ub4_M_1;
	sca lb4_N_2 = y1 - y0 - ub4_M_2;
	sca lb4_N_3 = y1 - y0 - ub4_M_3;
	sca lb4_N_4 = y1 - y0 - ub4_M_4;
	
	sca lb4_N_5 = y1 - y0 - ub4_M_5;
	sca lb4_N_6 = y1 - y0 - ub4_M_6;
	sca lb4_N_7 = y1 - y0 - ub4_M_7;
	sca lb4_N_8 = y1 - y0 - ub4_M_8;
	
	sca lb4_N_9 = y1 - y0 - ub4_M_9;
	sca lb4_N_10 = y1 - y0 - ub4_M_10;
	sca lb4_N_11 = y1 - y0 - ub4_M_11;
	sca lb4_N_12 = y1 - y0 - ub4_M_12;
	
	sca lb4_N_13 = y1 - y0 - ub4_M_13;
	sca lb4_N_14 = y1 - y0 - ub4_M_14;
	sca lb4_N_15 = y1 - y0 - ub4_M_15;
	sca lb4_N_16 = y1 - y0 - ub4_M_16; 
	
	sca ub4_N = y1 - y0; 
	
	** LATE;
	sca lb4_L = lb4_M/pr_c; 
	
    sca ub4_L_1 = ub4_M_1/pr_c;
	sca ub4_L_2 = ub4_M_2/pr_c;
	sca ub4_L_3 = ub4_M_3/pr_c;
	sca ub4_L_4 = ub4_M_4/pr_c;
	
	sca ub4_L_5 = ub4_M_5/pr_c;
	sca ub4_L_6 = ub4_M_6/pr_c;
	sca ub4_L_7 = ub4_M_7/pr_c;
	sca ub4_L_8 = ub4_M_8/pr_c;
	
	sca ub4_L_9 = ub4_M_9/pr_c;
	sca ub4_L_10 = ub4_M_10/pr_c;
	sca ub4_L_11 = ub4_M_11/pr_c;
	sca ub4_L_12 = ub4_M_12/pr_c;
	
	sca ub4_L_13 = ub4_M_13/pr_c;
	sca ub4_L_14 = ub4_M_14/pr_c;
	sca ub4_L_15 = ub4_M_15/pr_c;
	sca ub4_L_16 = ub4_M_16/pr_c;
	
	**LATE_nt ; 
	sca lb4_Ant=pr_z1*0+pr_z0*0; 
	sca ub4_Ant_1=pr_z1*(y_at_c-y1_nt)+pr_z0*(y0_at-LY0_nt); 
	sca ub4_Ant_2=pr_z1*(y_at_c-y1_nt)+pr_z0*(y_at_c-LY0_nt); 
	**LATE_at ; 
	sca lb4_Aat=pr_z1*0+pr_z0*0; 
	sca ub4_Aat_1=pr_z1*(UY1_at-y1_nt)+pr_z0*(y0_at-y_nt_c); 
	sca ub4_Aat_2=pr_z1*(UY1_at-y_nt_c)+pr_z0*(y0_at-y_nt_c);
	
	** Conditional Probabilities ;  
	sca itt=y1-y0; 
	sca li itt;
	
	** Testable implications ;
	sca imp_a=y0_at-y_nt_c;
	sca li imp_a;
	
	sca imp_b=y1_nt-y_at_c;
	sca li imp_b;
	
    sca imp_c=y_at_c-y_nt_c;
	sca li imp_c;
	
	** Mean of y on s; 
	sum `y' if `s'==1 [aw=`wgt']; 
	sca y_s1=r(mean); sca obs_y_s1=r(N);
	sum `y' if `s'==0 [aw=`wgt']; 
	sca y_s0=r(mean); sca obs_y_s0=r(N);
	
	** Percentage of LNATE_nt;  
	sca L_perc_lnate=(y1_nt-UY0_nt)/UY0_nt;
	sca U_perc_lnate=(y1_nt-LY0_nt)/LY0_nt;

	sca li U_perc_lnate; 
    
	matrix b_all_1= (Num_obs, itt, pr_c, late, pr_at, pr_nt, `pr_at_c', `pr_nt_c', 
	               y_at_c, y_nt_c, y0_at, y1_nt, y1, y0, y_s1, y_s0, imp_a, 
				   imp_b, imp_c, miny, maxy, pr_z0, pr_z1, pr_s0, pr_s1, LY1_c, UY1_c, LY1_at, UY1_at, LY0_c, UY0_c, 
				   LY0_nt, UY0_nt, LB1_0, LB1_1, UB1_0, UB1_1, LB1, UB1, LB2, UB2_0_1,
				   UB2_0_2, UB2_0_3, UB2_0_4, UB2_0_5, UB2_1_1, UB2_1_2, UB2_1_3, UB2_1_4, UB2_1_5, UB2_1,
				   UB2_2, UB2_3, UB2_4, UB2_5, UB2_6, UB2_7, UB2_8, UB2_9, UB2_10, UB2_11, 
				   UB2_12, UB2_13, UB2_14, UB2_15, UB2_16, UB2_17, UB2_18, UB2_19, UB2_20, UB2_21,
				   UB2_22, UB2_23, UB2_24, UB2_25, LB3_0, LB3_1, UB3_0, UB3_1, LB3, UB3,
				   LB4, UB4_1, UB4_2, UB4_3, UB4_4, UB4_5, UB4_6, UB4_7, UB4_8, UB4_9, 
				   UB4_10, UB4_11, UB4_12, UB4_13, UB4_14, UB4_15, UB4_16, ys1, lb1,
				   ub1, lb2, ub2_1, ub2_2, lb3, ub3, lb4, ub4_1, ub4_2, lb1_nt, 
				   ub1_nt, lb1_at, ub1_at, lb2_nt_1, lb2_nt_2, ub2_nt, lb2_at_1, lb2_at_2, ub2_at,   
				   lb2_c, ub2_c, lb2_M, ub2_M_1, ub2_M_2, 
				   ub2_M_3, ub2_M_4, lb2_N_1, lb2_N_2, lb2_N_3, lb2_N_4, ub2_N_4, lb2_L, ub2_L_1, ub2_L_2,
				   ub2_L_3, ub2_L_4, lb2_Ant, ub2_Ant, lb2_Aat, ub2_Aat,
				   lb3_nt, ub3_nt, lb3_at, ub3_at, lb3_cN0_1, lb3_cN0_2, ub3_cN0, lb3_cN1_1,
				   lb3_cN1_2, ub3_cN1, lb3_cM1_1, lb3_cM1_2, ub3_cM1, lb3_cM0_1, lb3_cM0_2, ub3_cM0, lb3_M_1, lb3_M_2,
				   ub3_M, lb3_N, ub3_N_1, ub3_N_2, lb3_L_1, lb3_L_2, ub3_L, 
				   lb3_Ant, ub3_Ant, lb3_Aat, ub3_Aat,
				   lb4_nt_1, lb4_nt_2, ub4_nt,
				   lb4_at_1, lb4_at_2, ub4_at, lb4_cN0_1, lb4_cN0_2, lb4_cN0_3, ub4_cN0, lb4_cN1_1, lb4_cN1_2, lb4_cN1_3, 
				   ub4_cN1, lb4_cM1, ub4_cM1_1, ub4_cM1_2, lb4_cM0, ub4_cM0_1, ub4_cM0_2, lb4_M, ub4_M_1, ub4_M_2,
				   ub4_M_3, ub4_M_4, ub4_M_5, ub4_M_6, ub4_M_7, ub4_M_8, ub4_M_9, ub4_M_10, ub4_M_11, ub4_M_12,
				   ub4_M_13, ub4_M_14, ub4_M_15, ub4_M_16, lb4_N_1, lb4_N_2, lb4_N_3, lb4_N_4, lb4_N_5, lb4_N_6,
				   lb4_N_7, lb4_N_8, lb4_N_9, lb4_N_10, lb4_N_11, lb4_N_12, lb4_N_13, lb4_N_14, lb4_N_15, lb4_N_16,
				   ub4_N, lb4_L, ub4_L_1, ub4_L_2, ub4_L_3, ub4_L_4, ub4_L_5, ub4_L_6, ub4_L_7, ub4_L_8, 
				   ub4_L_9, ub4_L_10, ub4_L_11, ub4_L_12, ub4_L_13, ub4_L_14, ub4_L_15, ub4_L_16, 
				   lb4_Ant, ub4_Ant_1, ub4_Ant_2, lb4_Aat, ub4_Aat_1, ub4_Aat_2, lb1_Ant, ub1_Ant, lb1_Aat, ub1_Aat, 
				   L_perc_lnate, U_perc_lnate);
				   
	matrix b_all_2= (  obs_pr_at, obs_pr_nt, obs_pr_at_c, obs_pr_nt_c, obs_pr_z1, 
	                   obs_y0_at,  obs_y_at_c, obs_y1_nt, obs_y_nt_c, obs_y0, 
					   obs_y1, obs_LY1_at, obs_UY1_at, obs_LY1_c, obs_UY1_c, 
					   obs_LY0_nt, obs_UY0_nt,  obs_LY0_c,  obs_UY0_c,  obs_pr_s1,  obs_y_s1, obs_y_s0
					 ); 
				   
				   
	matrix colnames b_all_1 = Num_obs itt pr_c late pr_at pr_nt pr_at_c pr_nt_c  
	               y_at_c y_nt_c y0_at y1_nt y1 y0 y_s1 y_s0 imp_a 
				   imp_b imp_c miny maxy pr_z0 pr_z1 pr_s0 pr_s1 LY1_c UY1_c LY1_at UY1_at LY0_c UY0_c 
				   LY0_nt UY0_nt LB1_0 LB1_1 UB1_0 UB1_1 LB1 UB1 LB2 UB2_0_1
				   UB2_0_2 UB2_0_3 UB2_0_4 UB2_0_5 UB2_1_1 UB2_1_2 UB2_1_3 UB2_1_4 UB2_1_5 UB2_1
				   UB2_2 UB2_3 UB2_4 UB2_5 UB2_6 UB2_7 UB2_8 UB2_9 UB2_10 UB2_11 
				   UB2_12 UB2_13 UB2_14 UB2_15 UB2_16 UB2_17 UB2_18 UB2_19 UB2_20 UB2_21
				   UB2_22 UB2_23 UB2_24 UB2_25 LB3_0 LB3_1 UB3_0 UB3_1 LB3 UB3
				   LB4 UB4_1 UB4_2 UB4_3 UB4_4 UB4_5 UB4_6 UB4_7 UB4_8 UB4_9 
				   UB4_10 UB4_11 UB4_12 UB4_13 UB4_14 UB4_15 UB4_16 ys1 lb1
				   ub1 lb2 ub2_1 ub2_2 lb3 ub3 lb4 ub4_1 ub4_2 lb1_nt 
				   ub1_nt lb1_at ub1_at lb2_nt_1 lb2_nt_2 ub2_nt lb2_at_1 lb2_at_2 ub2_at 
				   lb2_c ub2_c lb2_M ub2_M_1 ub2_M_2 
				   ub2_M_3 ub2_M_4 lb2_N_1 lb2_N_2 lb2_N_3 lb2_N_4 ub2_N_4 lb2_L ub2_L_1 ub2_L_2
				   ub2_L_3 ub2_L_4 lb2_Ant ub2_Ant lb2_Aat ub2_Aat
				   lb3_nt ub3_nt lb3_at ub3_at lb3_cN0_1 lb3_cN0_2 ub3_cN0 lb3_cN1_1
				   lb3_cN1_2 ub3_cN1 lb3_cM1_1 lb3_cM1_2 ub3_cM1 lb3_cM0_1 lb3_cM0_2 ub3_cM0 lb3_M_1 lb3_M_2
				   ub3_M lb3_N ub3_N_1 ub3_N_2 lb3_L_1 lb3_L_2 ub3_L 
				   lb3_Ant ub3_Ant lb3_Aat ub3_Aat
				   lb4_nt_1 lb4_nt_2 ub4_nt
				   lb4_at_1 lb4_at_2 ub4_at lb4_cN0_1 lb4_cN0_2 lb4_cN0_3 ub4_cN0 lb4_cN1_1 lb4_cN1_2 lb4_cN1_3 
				   ub4_cN1 lb4_cM1 ub4_cM1_1 ub4_cM1_2 lb4_cM0 ub4_cM0_1 ub4_cM0_2 lb4_M ub4_M_1 ub4_M_2
				   ub4_M_3 ub4_M_4 ub4_M_5 ub4_M_6 ub4_M_7 ub4_M_8 ub4_M_9 ub4_M_10 ub4_M_11 ub4_M_12
				   ub4_M_13 ub4_M_14 ub4_M_15 ub4_M_16 lb4_N_1 lb4_N_2 lb4_N_3 lb4_N_4 lb4_N_5 lb4_N_6
				   lb4_N_7 lb4_N_8 lb4_N_9 lb4_N_10 lb4_N_11 lb4_N_12 lb4_N_13 lb4_N_14 lb4_N_15 lb4_N_16
				   ub4_N lb4_L ub4_L_1 ub4_L_2 ub4_L_3 ub4_L_4 ub4_L_5 ub4_L_6 ub4_L_7 ub4_L_8 
				   ub4_L_9 ub4_L_10 ub4_L_11 ub4_L_12 ub4_L_13 ub4_L_14 ub4_L_15 ub4_L_16
				   lb4_Ant ub4_Ant_1 ub4_Ant_2 lb4_Aat ub4_Aat_1 ub4_Aat_2 lb1_Ant ub1_Ant lb1_Aat ub1_Aat 
				   L_perc_lnate U_perc_lnate
				   ;
				   
	matrix colnames b_all_2= obs_pr_at obs_pr_nt obs_pr_at_c obs_pr_nt_c obs_pr_z1 
	                   obs_y0_at  obs_y_at_c obs_y1_nt obs_y_nt_c obs_y0 
					   obs_y1 obs_LY1_at obs_UY1_at obs_LY1_c obs_UY1_c 
					   obs_LY0_nt obs_UY0_nt  obs_LY0_c obs_UY0_c obs_pr_s1 obs_y_s1 obs_y_s0
					 ; 
					 
	mat b_all=(b_all_1,b_all_2);  
	
	mat li b_all; 
	
	ereturn post b_all, esample (`touse')properties("b");
		
		

end;





