#!/usr/bin/env octave -q
# calculates pump Q-H curve given points
#Qup=input("Upper flow limit [cum/h]: ");
n=input ("Input Number of points (integer, min 3): ");
for inc=1:n
	printf("\nPoint %i", inc);
	Q(inc)=input("\nInput flow [cum/h]: ");
	H(inc)=input("\nInput headloss [m]: ");
# http://www.gnu.org/software/octave/doc/interpreter/Index-Expressions.html
	Q(end+1)=Q(inc);
	H(end+1)=H(inc);
end
Q(end)=[];
H(end)=[];
p=polyfit(Q,H,2);
printf('H=%f*x.**2+%f*x.^1+%f',p);
printf("\n")
H=polyval(p,Q);

# plot control graph
plot(Q,H);
title('Pump Q-HCurve');
legend ('Pump Curve');
#setting axis labels
xlabel("Flow - Q[cum/h]");
ylabel("Headloss - H[m]");
print ('PumpCurve', '-dpng');
#sum (x, dim)
#Built-in Function: sum (..., 'native')
#Sum of elements along dimension dim. If dim is omitted, it defaults to 1 (column-wise sum).
#As a special case, if x is a vector and dim is omitted, return the sum of the elements.

#If the optional argument 'native' is given, then the sum is performed in the same type as the original argument, rather than in the default double type. For example