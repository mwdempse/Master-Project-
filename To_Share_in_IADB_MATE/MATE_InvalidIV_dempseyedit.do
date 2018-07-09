
version 13 

set more 1 

* Prepared by Xintong Wang; edited by Carlos Flores

capture log close 


* Specify log file to use
log using MATE_InvalidIV.log, replace text 


** This program calculates standard errors for the bounds of MATE, NATE and LATE with an Invalid IV.;
** Use 1000-repetition bootstrap.;
** call InvalidIV_ATEnw.ado;


* Specify data set to be used

use "C:\Users\John\Desktop\JCdata_Dempsey.dta"
qui destring, replace
merge 1:1 mprid using "C:\Users\John\Desktop\JC_data_Maria_8020", gen(mergeMaria)
merge 1:1 mprid using "C:\Users\John\Desktop\impact", gen(mergekid)

*clean data
drop Outcome S

***** Important variables to define
** NOTE: rename old_name new_name

* Outcome Variable

rename kidsr Outcome

* Randomized Treatment (or the Invalid IV)
rename treatmnt treatmnt

* Mechanism Variable (or the Endogenous Treatment):
*Vocational degree d48_voc, College d48_coll, GED d48_ged, HS d48_hs
 
rename d_hsged_voc S

* Weights (Note: If no weights, create a variable with weight=1 (gen W=1))
rename dsgn_wgt W
	
* Identifier (Note: If no identifier, create an index variable (gen mprid=_n)
rename mprid mprid
	
	
*Drop individuals with missing values in each of the variables of interest
	drop if Outcome== . 
	drop if treatmnt==.  
	drop if S==.  
	drop if W==. 
	drop if mprid==.
	
*Keep only the variables of interest
keep mprid S W Outcome treatmnt

*Do the A1 do file 
*program drop InvalidIV_ATEw
do A1
InvalidIV_ATEw Outcome treatmnt S W mprid

*Let's run a bootstrap 
** Start Bootstrap;
bootstrap _b, reps (25) seed (8451) saving (test_A1.dta, double replace): InvalidIV_ATEw Outcome treatmnt S W mprid
display (" Bootstrap finished running")


** NOTE: After running this do file, need to run MATE_InvalidIV_Bounds.do to employ Chernozhukov, Lee and Rosen (2013) methodology to compute the estimated bounds and 95% Confidence Intervals.
do MATE_InvalidIV_Bounds.do 

log close
