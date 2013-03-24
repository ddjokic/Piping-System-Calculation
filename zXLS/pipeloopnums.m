#!/usr/bin/env octave -q

# improved version, which get read of input 
# input is handled by separate xls/ods/csv file

# units: headloss in m, flow in cubic meters per hour [cum/h]
# D. Djokic, March 2013

# initialisation block
	# initialisation of parallel lines
	AP(1)=AP(2)=AP(3)=AP(4)=AP(5)=AP(6)=AP(7)=AP(8)=AP(9)=AP(10)=AP(11)=AP(12)=AP(13)=AP(14)=AP(15)=0.01;
	BP(1)=BP(2)=BP(3)=BP(4)=BP(5)=BP(6)=BP(7)=BP(8)=BP(9)=BP(10)=BP(11)=BP(12)=BP(13)=BP(14)=BP(15)=0.01;
	 #eliminating "div by zero" warning
	con(1)=con(2)=con(3)=con(4)=con(5)=con(6)=con(7)=con(8)=con(9)=con(10)=con(11)=con(12)=con(13)=con(14)=con(15)=0;
	# end of initialization parallel
	#init serial
	AS(1)=AS(2)=AS(3)=AS(4)=AS(5)=AS(6)=AS(7)=AS(8)=AS(9)=AS(10)=AS(11)=AS(12)=AS(13)=AS(14)=AS(15)=0;
	BS(1)=BS(2)=BS(3)=BS(4)=BS(5)=BS(6)=BS(7)=BS(8)=BS(9)=BS(10)=BS(11)=BS(12)=BS(13)=BS(14)=BS(15)=0;
	UpperPressure=100;
	UpperFlow=700;

# start input
SubLoop=input("Input Loop/Sub Loop ID as string: ", 's');

filepar=input ("Enter input filename with PARALLEL pipes: ", "s");
fileser=input ("Enter input filename with SERIAL pipes: ", "s");
filepum=input("Enter input filename with EQUIVALENT PUMP: ", "s");

npf=dlmread(filepar, ',', 'B1:C1');
nsf=dlmread(fileser, ",", "B1:C1");
np=npf(1);
ns=nsf(1);

APf=dlmread(filepar, ',', "B3:B17");
BPf=dlmread(filepar, ',', "C3:C17");

ASf=dlmread(fileser, ',', "B3:B17");
BSf=dlmread(fileser, ',', "C3:C17");

APumpeq=dlmread(filepum, ',', "A2:A3");
BPumpeq=dlmread(filepum, ',', "B2:B3");

APump=APumpeq(1);
BPump=BPumpeq(1);

for parallel=1:np
	con(parallel)=1;
	AP(parallel)=APf(parallel);
	BP(parallel)=BPf(parallel);

end 	# for parallel loop

for serial=1:ns
	AS(serial)=ASf(serial);
	BS(serial)=BSf(serial);
end     # for serial loop
# end of input block

# calculation block
# parallel lines, HPar, QPar
HPar=[0:0.1:UpperPressure];	
QPar=real(Flow(HPar,AP(1),BP(1),con(1))+Flow(HPar,AP(2),BP(2),con(2))+Flow(HPar,AP(3),BP(3),con(3))+Flow(HPar,AP(4),BP(4),con(4))+Flow(HPar,AP(5),BP(5),con(5))+Flow(HPar,AP(6),BP(6),con(6))+Flow(HPar,AP(7),BP(7),con(7))+Flow(HPar,AP(8),BP(8),con(8))+Flow(HPar,AP(9),BP(9),con(9))+Flow(HPar,AP(10),BP(11),con(12))+Flow(HPar,AP(13),BP(13),con(13))+Flow(HPar,AP(14),BP(14),con(14))+Flow(HPar,AP(15),BP(15),con(15)));
# for some reason looping instead of above line return error - fink package?

# serial pipes, HSer, QPar
# looping does not work, again:
HS1=AS(1)*QPar.**2+BS(1);
HS2=AS(2)*QPar.**2+BS(2);
HS3=AS(3)*QPar.**2+BS(3);
HS4=AS(4)*QPar.**2+BS(4);
HS5=AS(5)*QPar.**2+BS(5);
HS6=AS(6)*QPar.**2+BS(6);
HS7=AS(7)*QPar.**2+BS(7);
HS8=AS(8)*QPar.**2+BS(8);
HS9=AS(9)*QPar.**2+BS(9);
HS10=AS(10)*QPar.**2+BS(10);
HS11=AS(11)*QPar.**2+BS(11);
HS12=AS(12)*QPar.**2+BS(12);
HS13=AS(13)*QPar.**2+BS(13);
HS14=AS(14)*QPar.**2+BS(14);
HS15=AS(15)*QPar.**2+BS(15);
HS=HS1+HS2+HS3+HS4+HS5+HS6+HS7+HS8+HS9+HS10+HS11+HS12+HS13+HS14+HS15;

#pump curve, HPump, QPar
HPump=APump*QPar.**2+BPump;

#total result, HRes
HRes=HPar+HS;
#fitting curves
#serial curve
cs=polyfit(QPar,HS, 2); 
#paralel curve	
cp=polyfit(QPar,HPar,2); 
#result curve
cres=polyfit(QPar,HRes,2);
#assigning
ASer=cs(1);
BSer=cs(3);
APar=cp(1);
BPar=cp(3);
ARes=cres(1); #ovde bila greshka?
BRes=cres(3); #ovde bila greshka?
#end of fitting block

titleH=strcat("Loop: ",SubLoop, " Headloss as f(Q)");
titleH=strcat("Loop: ",SubLoop, " Headloss as f(Q)");
plot(QPar, HPar, QPar, HRes, QPar, HS, QPar, HPump);
title(titleH);
legend ('HPar - Parallel', 'HRes -Total Loop', 'HS - Serial', 'HPump - Pump Curve');
#setting axis labels
xlabel("Flow - Q[cum/h]");
ylabel("Headloss - H[m]");

#printing to file(s) - png and dxf
fileName=strcat("Loop-",SubLoop);
dxf=strcat(fileName, ".dxf");
png=strcat(fileName, ".png");
print (dxf, '-ddxf');
print (png, '-dpng');

#writting txt file with input and results
fileResults=strcat(SubLoop, "-Results", ".txt");
fid=fopen(fileResults, "w");
fprintf(fid, "Loop ID: %s", SubLoop);
fclose(fid);

#writting input
fid=fopen(fileResults, "a");
fprintf(fid, "\nParallel pipes");
for parallel= 1:np
	fprintf(fid, "\nHP(%i)=%f*Q.**2+%f", parallel, AP(parallel), BP(parallel));  ##ovde?
end
fclose(fid);
fid=fopen(fileResults, "a");

fprintf(fid, "\nSerial pipes");
for serial=1:ns 
	fprintf(fid, "\nHS(%i)=%f*Q.**2+%f", serial, AS(serial), BS(serial));
end
fclose(fid);

fid=fopen(fileResults, "a");
fprintf(fid, "\nEq. Pump:  H=%f*Q.**2+%f", APump, BPump);
#end of writting input block

#writting resulting curves
fprintf(fid, "\nResulting Curves");
fprintf(fid, "\nRes. Serial curve:  HS=%f*Q.**2+%f", ASer, BSer);
fprintf(fid, "\nRes. Parallel curve:  HS=%f*Q.**2+%f",APar, BPar);
fprintf(fid, "\nSystem Curve:  H=HS=%f*Q.**2+%f",ARes, BRes);
fclose(fid);