
filename testurl url "https://raw.githubusercontent.com/alex/nyt-2020-election-scraper/master/all-state-changes.csv";


proc import file=testurl 
	out=WORK.IMPORT 
	dbms=csv
	replace;
run;

data WORK.IMPORT;
	set WORK.IMPORT;
	percent_reporting = precincts_reporting / precincts_total;
	
	if (leading_candidate_name EQ "Biden") then vote_differential = -1 * vote_differential;
	else vote_differential = vote_differential;
	
run;


proc sql noprint;
	create table WORK.filter as select * from WORK.IMPORT where(state LIKE 
		"Pennsylvania%");
quit;

proc sgplot data=WORK.FILTER;
	scatter x=timestamp y=vote_differential /
	markerattrs=(symbol=CircleFilled size=9);
run;

proc corr data=WORK.FILTER pearson nosimple noprob plots=none;
	var vote_differential;
	with new_votes;
run;

proc reg data=WORK.FILTER alpha=0.05 plots(only)=(diagnostics residuals fitplot 
		observedbypredicted);
	where votes_remaining >=1000000;
	model vote_differential=votes_remaining /;
	run;
quit;
