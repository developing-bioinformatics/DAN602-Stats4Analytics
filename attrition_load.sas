filename testurl url "https://raw.githubusercontent.com/developing-bioinformatics/DAN602-Stats4Analytics/main/module_docs/m4/IBM_attrition_data.csv";


proc import file=testurl 
	out=WORK.VACANCIES 
	dbms=csv
	replace;
run;
