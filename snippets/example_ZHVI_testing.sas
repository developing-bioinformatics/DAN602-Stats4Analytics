%web_drop_table(STAT_IMP.ZHVI);


FILENAME REFFILE 'C:/Users/rharbert/OneDrive - Stonehill College/DAN602/modules/m2/Neighborhood_zhvi_uc_sfrcondo_tier_0.33_0.67_sm_sa_mon.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=STAT_IMP.ZHVI;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=STAT_IMP.ZHVI; RUN;


proc sql noprint;
	create table WORK.filter as select * from STAT_IMP.ZHVI where(StateName EQ 
		"MA");
quit;



data WORK.RECODE;
	length ISBOSTON $ 30;
	set WORK.FILTER;

	select (Metro);
		when ('Boston-Cambridge-Newton') ISBOSTON='Boston';
		otherwise ISBOSTON="NotBoston";
	end;
run;

/* Test for normality */
proc univariate data=WORK.RECODE normal mu0=0;
	ods select TestsForNormality;
	class ISBOSTON;
	var '2020-08-31'n;
run;

/* t test */
proc ttest data=WORK.RECODE sides=2 h0=0 plots(showh0);
	class ISBOSTON;
	var '2020-08-31'n;
run;

/* Nonparametric test */
proc npar1way data=WORK.RECODE wilcoxon plots=wilcoxonplot;
	class ISBOSTON;
	var '2020-08-31'n;
run;

