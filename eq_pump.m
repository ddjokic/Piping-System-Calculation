#!/usr/bin/env octave -q
# octave script calculates equivalent pump - difference of pump characteristic and 
# suction line headloss
# units: headloss in m, flow in cubic meters per hour [cum/h]
# assumption: only one suction pipe

# input block
# input pump
AP=input("Input Pump coef 'A'(must be negative) in function 'A*x.**2+B': ");
BP=input("Input Pump coef 'B' in function 'A*x.**2+B: ");

# input suction line
AC=input("\nInput Pipe 'A' coeff of function 'A*x.**2+B': ");
BC=input("\nInput Pipe 'B' coeff of function 'A*x.**2+B': ");

# input flow range
QU=input("\nInput upper bound of flow range [cum/h]: ");
# calculation block
Q=0:QU;
HP=AP*Q.**2+BP;
HC=-(AC*Q.**2+BC);
H=HP+HC;

# control plot
plot(Q,H, Q,HP, Q,HC) 
legend("EQ-Pump", "Pump", "Pipe")

# fitting equivalent pump curve
p=polyfit(Q,H,2);
printf('H=%f*x.**2+%f*x.^1+%f',p);
printf("\n")