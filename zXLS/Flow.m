function fl=Flow(H, A, B, con)
% function calculates flow as a function of H[m]

fl=(((real(H-B))/A).**0.5)*con; #moze i "abs"!!
