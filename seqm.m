function vout = seqm(b,f,T)
% Mimics seqm() from Gauss.
% Requires 3 arguments, a begining value, a factor, and
% the total number of elements in the output vector.
% As in Gauss, the output is a column vector.

vout = zeros(T,1)-9.99;
i=1;
multiplier = 1;
while i <= T;
  vout(i,1) = b * multiplier;
  multiplier = multiplier * f;
i=i+1;
end;
