#!/usr/bin/env octave -q
# octave script to calculate flow and pressure drop in pipelines
# units: headloss in m, flow in cubic meters per hour [cum/h]

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
	#for some reason looping instead of above return error - fink package?
# input block
SubLoop=input("Input Loop/Sub Loop ID as string: ", 's');
# input calculation range
UpperFlow=input("Input Higher Flow range [cum/h]: ");
UpperPressure=input("Input Higher Headloss range [m]: ");

# input paralel lines in Loop/Sub Loop
np=input("\nInput total number of parallel lines in Loop/Subloop (min 1, max 15): ");
for parallel= 1:np
	printf("\nParallel Pipe Line No %i: ", parallel);
	AP(parallel)=input("\nInput Pipe 'A' coeff of function 'A*x.**2+B': ");
	BP(parallel)=input("\nInput Pipe 'B' coeff of function 'A*x.**2+B': ");
	con(parallel)=1;
end 

# input serial lines in Loop/Sub Loop
ns=input("\nInput total number of serial lines in Loop/Subloop (min 1, max 15): ");
for serial=1:ns
	printf("\nSerial Pipe Line No %i: ", serial);
	AS(serial)=input("\nInput Pipe 'A' coeff of function 'A*x.**2+B': ");
	BS(serial)=input("\nInput Pipe 'B' coeff of function 'A*x.**2+B': ");
end
# end of input block

#input equivalent pump coeff
APump=input("Input equivalent Pump coef 'A'(must be negative) in function 'A*x.**2+B': ");
BPump=input("Input equivalent Pump coef 'B' in function 'A*x.**2+B: ");

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
	fprintf(fid, "\nHP(%i)=%f*Q.**2+%f", parallel, AP(parallel), BP(parallel));
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

#odavde je experiment:
global A1=APump
global B1=BPump
global A2=ARes
global B2=BRes

#functions for fsolve
#x(1) - flow
#x(2) - headloss
function y=f(x)
	y=zeros (0.001,0.001); 
	global A1;
	global B1;
	global A2;
	global B2;
	y(1)=A1*x(1).**2+B1-x(2);
	y(2)=A2*x(1).**2+B2 - x(2);
endfunction
[x]=fsolve ("f",[0.001;0.002]);

#working point:
Q=x(1);
H=x(2);
# total Headloss through composite parallel lines in sub-loop (HPC)
HPC= APar*x(1).**2+BPar;
#total Headloss through composite serial lines in sub-loop (HSC)
HSC=ASer*x(1).**2+BSer;
#writting above result in file
fid=fopen(fileResults, "a");
fprintf(fid, "\n\nSystem Working Point: %f cum/h, %f m", x(1), x(2));

#calculating and printing Q,H point for individual "parallel" pipelines
fprintf(fid, "\nParallel Pipes - Working Point:")
for parallel=1:np
	Q(parallel)=real(Flow(HPC,AP(parallel),BP(parallel),con(parallel)));
	fprintf(fid, "\nWorking Point - Parallel pipe %i: %f cum/h, %f m", parallel, Q(parallel), HPC);
end
fclose(fid);

#calculating and printing Q,H point for individual "serial" pipelines
fid=fopen(fileResults, "a");
fprintf(fid, "\nSerial Pipes - Working Point:");
for series=1:ns
	loss(series)=AS(series)*x(1).**2+BS(series);
	fprintf(fid, "\nWorking Point - Serial pipe %i: %f cum/h, %f m", series, x(1), loss(series));
end

fclose(fid); 