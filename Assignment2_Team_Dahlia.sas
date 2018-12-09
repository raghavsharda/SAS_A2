/************************************************
* Assignment No. 2
* Team Member #1: 	Sushil Kharel 		
* Team Member #2: 	Raghav Sharda 		
* Team Member #3: 	Jing Zhang		
* Team Member #4: 	Haoran Ma		
* Team Member #5: 	Stephen LaPierre	
*
* Mark				__________/__________
*************************************************/

LIBNAME Assign2 'C:\445\Course_data';
run;

/***************************************************
*Textbook Question 12.6 by Hoaran Ma
****************************************************/

*using cat functions;
data new_study;
set Assign2.study;
length GroupDose $ 6;
GroupDose = catx('-',Group,Dose);
run;
title qusestion 6 using cat functions;
proc print data=new_study;
run;

*without using cat functions;
data new_study_2;
set Assign2.study;
length GroupDose $ 6;
GroupDose = trim(Group) || '-' || Dose;
run;
title qusestion 6 without using cat functions;
proc print data=new_study_2;
run;

/***************************************************
*Textbook Question 12.10 by Hoaran Ma
****************************************************/

title question 12;
proc print data=Assign2.errors;
where findc(PartNumber,'XD','i');
var Subj PartNumber;
run;

/***************************************************
*Textbook Question 13.4 by Hoaran Ma
****************************************************/

data survey_any5;
set Assign2.survey2;
array Ques{5} Q1-Q5;
Any5 = 'No ';
do i = 1 to 5;
if Ques{i} = 5 then do;
Any5 = 'Yes';
leave;
end;
end;
drop i;
run;
title ch13 question 4;
proc print data=survey_any5;
run;

/***************************************************
*Textbook Question 14.2 by Raghav Sharda
****************************************************/

proc sort data= Assign2.sales_2010 out= A2S2010;
by Region ;
run;

title1 "Question 14.2 ";
title2 "Sales Figures from the Sales Data Set";

proc print data = A2S2010 noobs ;
by Region;
id Region;
var TotalSales Quantity ;
sum TotalSales Quantity ; 
label EmpID = "Employee ID"
	  TotalSales = "Total Sales"
      Quantity = "Number Sold";
format TotalSales dollar10.2 Quantity comma7.;
run;

/***************************************************
*Textbook Question 16.6 by Raghav Sharda
****************************************************/

/*Using the SAS data set College, report the mean and median GPA and ClassRank*/
/*broken down by school size (SchoolSize). Do this twice, once using a BY statement,*/
/*and once using a CLASS statemen*/

data q16by ;
set Assign2.college;
run;


proc sort data=q16by  out=q16sorted;
by SchoolSize;
run;

proc means data=q16sorted mean median;
by SchoolSize;
var GPA ClassRank;
run;

/******************************************/
data q16class ;
set Assign2.college;
run;

proc sort data=q16class  out=q16classsorted;
by SchoolSize;
run;

proc means data=q16classsorted mean median;
class SchoolSize;
var GPA ClassRank;
run;


/**********************************************
*Textbook Question 18.4 by Jing Zhang
***********************************************/

proc format;
value $yesno 'Y','1' = 'Yes'
'N','0' = 'No'
' ' = 'Not Given';
value $size 'S' = 'Small'
'M' = 'Medium'
'L' = 'Large'
' ' = 'Missing';
value $gender 'F' = 'Female'
'M' = 'Male'
' ' = 'Not Given';
value ClassRank low-70="Low to 70"
				71-high="71 and higher";
run;

title "quesion 18.4";
proc tabulate data=Assign2.College missing;
class  ClassRank Gender Scholarship;
table (Scholarship ALL),  ClassRank*(Gender All)*n="";
keylabel ALL='Total';
format ClassRank  ClassRank.;
format Gender $gender.;
run;

/**********************************************
*Textbook Question 23.2 by Jing Zhang
***********************************************/

proc sort data=Assign2.Narrow;
	by Subj Time;
run;
data Assign2.Narrow1;
	set Assign2.Narrow;
	by subj time;
	array S{5};
	retain S1-S5;
	if first.subj then call  missing(of S1-S5);
	S{Time}=Score;
	if last.subj then output;
	keep subj S1-S5;
run;

proc print data=Assign2.Narrow1;
run;

/***********************************************************
* Text Book Question 24.2 by Stephen LaPierre
************************************************************/

/* create temporary data set from permanent data set Dailyprices*/
data tempprices;
	set Assign2.dailyprices;

/* Manipulate tempprices to produce a table showing each stock symbol, its average price, 
	how many transactions it had and its minimum and maxoimum prices */

proc means data=tempprices noprint nway;
class Symbol;
var Price;
output out=values(drop = _freq_ _type_)
mean= n= min= max= /autoname;
run;

title "Listing of Summary";
proc print data=values noobs;
run;

/***************************************************
*Textbook Question 24.6 by Stephen LaPierre
****************************************************/

/* Create a table displaying each stock symbol's price and the difference between first day trrad and last day trade.
	All stcoks with only 1 trade are removed from the table. */

proc sort data=Assign2.dailyprices out=dailyprices;
by Symbol Date;
run;
data diff_in_price;
set dailyprices;
by Symbol;
if first.Symbol and last.Symbol then delete;
if first.Symbol or last.Symbol then Difference = dif(Price);
if last.Symbol then output;
keep Symbol Price Difference;
run;

title "Listing of differences";
proc print data=diff_in_price noobs;
run;

/***************************************************
*Textbook Question 25.2 by Sushil Kharel
****************************************************/

%let a = 2;
%let z = 7;
data sqrt_table;
do n = &a to &z;
square = sqrt(n);
output;
end;
run;
title "Square Root table";
proc print data=sqrt_table noobs;
run;


/***************************************************
*Textbook Question 25.4 by Sushil Kharel
****************************************************/

%macro stats(dsn,class,vars );
title "Stats from &dsn";
proc means data=&dsn n mean min max maxdec=1;
class &class;
var &vars;
run;
%mend stats;

%stats(Assign2.bicycles, Country, Units TotalSales)

/************************************************
* Assignment 2, Question 6 by Sushil Kharel
*************************************************/

/*	a)	Write a MACRO PRINT_obs to print first k observations from the dataset DSN with title containing 
	information about how many observations are printed from which dataset. Run your macro %print_obs(mydata.discount, 5)*/


%macro print_obs(dsn, k);
   title "Listing of the first &k obs from Data set &dsn";
   proc print data=&dsn(obs=&k) noobs;
   run;
%mend print_obs;

%print_obs(Assign2.discount, 5)



/***************************************************************************************/
/***************************************************************************************/
/***************************************************************************************/

/************************************************
* Assignment 2, Question 2 by Hoaran Ma
*************************************************/

*A they do actually effect the average chance of survial. the highest class should have more chance to survey. male are 
more than female;

PROC IMPORT OUT=data 
            DATAFILE= "C:\445\course_data\train.csv" 
            DBMS=CSV REPLACE;
     		GETNAMES=YES;
     		DATAROW=2; 
RUN;
proc freq data =data;
table Survived pclass Sex;
run;

/* B - No answer */

*C
NLEVELS option is going to determine the variables level.
MISSPRINT shows the freq for missing value table.
MISSING put missing values as nonmissing level for all TABLES variables.;

Proc freq data=data nlevels;
table Survived Pclass Sex;
run; 
Proc freq data=data ;
table Survived Pclass Sex / missprint;
run; 
Proc freq data=data ;
table Survived Pclass Sex / missing;
run; 

*D;
title 'Histogram of Age for Survived';
proc univariate data=data;
var Age Survived;
histogram Age / normal;
run;


*E
The outliers are the Extreme Observations, too high or too low.
missing values are the values not shown on the data set. there are 263 total observations.
the lowest value observed are 0.17, 0.33, 0.42, 0.67, 0.75 and the highest value observed are 71. 74, 76, 80.
The min value is 0.17 and the max value is 80.;

/************************************************
* Assignment 2, Question 3 by Jing Zhang
*************************************************/

data Assign2.Names_And_More;
input Name $16. Phone $16.  Height $10. Mixed $8.;
cards;
Roger Cody       (908)782-1234  5ft. 10in. 50 1/8
Thomas Jefferson (315) 848-8484 6ft. 1in. 23 1/2
Marco Polo       (800)123-4567  5Ft. 6in.  40
Brian Watson     (518)355-1766  5ft. 10in 89 3/4
Michael DeMarco  (445)232-2233  6ft.      76 1/3
;
run;

data Names_And_More_a;
	set Assign2.Names_And_More;
	Name=strip(Name);
run;
proc print data=Names_And_More_a;
var Name;
run;

data  Names_And_More_b;
	set Assign2.Names_And_More;
	Phone=compress(Phone,,'kd');
run;
proc print data=Names_And_More_b;
var Phone;
run;

data  Names_And_More_c;
	set Assign2.Names_And_More;
	Mixed_num=round(SUM(scan(Mixed,1,""),(scan(scan(Mixed,2,""),1,"/")/scan(scan(Mixed,2,""),2,"/"))),0.001);
run;
proc print data=Names_And_More_c;
var Mixed_num;
run;


data  Names_And_More_d;
	set Assign2.Names_And_More;
	AreaCode=substr(phone,2,3);
	phone=strip(scan(phone,2,")"));
run;
proc print data=Names_And_More_d;
var AreaCode phone;
run;


/************************************************
* Assignment 2, Question 4 by Raghav Sharda
*************************************************/

DATA Assign2.dept_store;
   LENGTH client_id shopping_instance DATE_shopping purchase 8;
   format purchase dollar8.2 DATE_shopping DATE9.;
   RETAIN DATE_shopping purchase;
/**/
   DO client_id = 1 TO 1000000;
   	   X1 = RANUNI(today());
	   X2 = RANUNI(678333);
	   X3 = RANUNI(122739);
/**/
/**/
       IF X3 LT .65 THEN do;
/**/
			GENDER = 'Male';
/**/
/**/
/**/
				DO shopping_instance = 1 TO ceil(X1*X3*10);
/**/
					if X2 LT .5 THEN Payment = 'Cash         ';
       				 ELSE IF X2 LT .80 THEN Payment = 'Credit card';
       				 ELSE Payment = 'Debit';
/**/
         			IF shopping_instance = 1 THEN DO;
            			 DATE_shopping = 15929-INT(X2*600);
            			 purchase = X2*15 + X1*30;
						 Item_cat_code=int(X1*10);
        			END;
/**/
        			ELSE DO;
        			    DATE_shopping = DATE_shopping + shopping_instance*(10 + INT(X1*50));
       				    purchase = purchase + INT(X2*10);
						Item_cat_code=int(X2*10);
         			END;
/**/
					 IF X2 LT .35 THEN Store = 'Montreal ';
	 				   else IF X2 LT .8 THEN Store = 'Toronto';
				       ELSE Store = 'Vancouver'; 
/**/
         			OUTPUT;
/**/
			  end;
/**/
 	  end;
/**/
      ELSE do;
/**/
			 GENDER = 'Female';			
/**/
				DO shopping_instance = 1 TO ceil(X1*X3*5);
/**/
					if X2 LT .7 THEN Payment = 'Cash         ';
       				 ELSE IF X2 LT .80 THEN Payment = 'Credit card';
       				 ELSE Payment = 'Debit';
/**/
         			IF shopping_instance = 1 THEN DO;
            			 DATE_shopping = 13929-INT(X1*X2*300);
            			 purchase = X2*15 + X1*30;
						 Item_cat_code=int(X1*10);
        			END;
/**/
        			ELSE DO;
        			    DATE_shopping = DATE_shopping + shopping_instance*(300 + INT(X2*50));
       				    purchase = purchase + INT(X2*10);
						Item_cat_code=int(X2*10);
         			END;
/**/
					 IF X2 LT .35 THEN Store = 'Montreal ';
	 				   else IF X2 LT .8 THEN Store = 'Toronto';
				       ELSE Store = 'Vancouver'; 
/**/
         			OUTPUT;
/**/
				 end;
			   end;
IF X1 LT .2 THEN LEAVE;
/**/
END;
DROP X1 X2 X3;
/**/
RUN;

/*PART A */
data parta;
set Assign2.dept_store;
run;

proc freq data= parta (obs=1000);
tables client_id;
run;

PROC SGPLOT
 DATA = parta; 
   HISTOGRAM client_id; 
  title "Histogram of Clien_Id";
RUN;

/*Part B*/

data gender;
set Assign2.dept_store;
run;

proc sort data=gender out=gendersort;
by Gender Payment;
run;

proc print data = gendersort (obs = 100);
run;


/*No ,payment method does depend on Gender because after running the below code
the lines are straight
*/

title "Scatter Plot of Gender by Payment";
symbol value=dot interpol=join width=2;
proc gplot data=gendersort;
plot Gender * Payment;
run;

/*Part C*/

/* Calculate the total value of all purchases for each client */

data foreacht;
set Assign2.dept_store;

proc sort data= foreacht out =foreachsort;
by client_id;
run;

data tpurchase;
set foreachsort;
by client_id;
if FIRST.client_id then TotalPurchase = 0;
TotalPurchase + purchase;
if LAST.client_id; 
run;

proc print data=tpurchase;
run;


/*Print 5 highest spenders*/
title 'Helloboss'; 
data higestsal ;
set tpurchase;
run;

proc sort data = higestsal;
by DESCENDING  TotalPurchase;
/*drop = TotalPurchase;*/
run;

proc print data = higestsal (obs = 5);
run;

/*Part D*/

data dayselapsed;
set Assign2.dept_store;
run;

proc sort data = dayselapsed out= elapsedsort;
by client_id DATE_shopping;
run;

data limitinstances;
set elapsedsort;
where shopping_instance>=5;
run;

proc print data = limitinstances (obs = 20);
run;

data fresult;
set limitinstances;
by client_id;
if first.client_id then datevariable=0;
datevariable = last.DATE_shopping - first.DATE_shopping;
run;

proc print data = fresult;
var client_id datevariable;
run;


/*PART E*/

/*Answer comes out to be Dining Department from Vancouver */

data dept;
set Assign2.dept_store;
run;
proc sort data = dept out = deptsort;
by Item_cat_code Store;
run;

proc sql;
select Item_cat_code,Store , SUM(purchase) as TotalSales from deptsort
GROUP BY Item_cat_code , Store
order by TotalSales DESC;
quit;



/************************************************
* Assignment 2, Question 5 by Jing Zhang
*************************************************/

/*a*/
proc sort data=Assign2.Purchase_sort;by model;run;
proc  sort data=Assign2.Inventory;by model;run;
data Not_purchase_a;
	merge Assign2.Inventory(in=ina) Assign2.Purchase_sort(in=inb);
	by model;
	if ina and not inb;
run;
proc print data=Not_purchase_a;
var Model Price;
run;

/*b*/
proc sql;
	select Model,Price into:Model,:Price from Assign2.Inventory
	where model not in (select model from Assign2.Purchase_sort);
quit;

/*C*/
/*Macros are particularly useful if you want to make your SAS programs more flexible and */
/*allow them to be used in different situations without having to rewrite entire programs. */
/*Macro variables also provide a useful method for passing information from one DATA step */
/*to another. You can even select which procedures within a large program to run, depending */
/*on the day of the week or the values in your data.*/


/*D*/
%macro bike_sale(DSN1,DSN2,Sold );

proc sort data=Assign2.&DSN1.;by model;run;
proc sort data=Assign2.&DSN2.;by model;run;

data Not_purchase_d;
	merge Assign2.&DSN1.(in=ina) Assign2.&DSN2.(in=inb);
	by model;
	if ina and &Sold. inb;
run;

proc print data=Not_purchase_d;
var Model Price;
run;
%mend;
%bike_sale(inventory,purchase_sort,not);






