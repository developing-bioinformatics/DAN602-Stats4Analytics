filename testurl url "https://raw.githubusercontent.com/developing-bioinformatics/DAN602-Stats4Analytics/main/module_docs/m4/IBM_attrition_data.csv";


proc import file=testurl 
	out=WORK.ATTRITION
	dbms=csv
	replace;
run;

proc surveyselect data=WORK.ATTRITION out=WORK.ATTRITION method=srs 
		sampsize=500;
run;