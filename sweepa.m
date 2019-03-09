function [f]=sweepa(a,b)
% program: sweepa.m
% date:  6/20/96
% passes (sweeps) a col vector Across a matrix
% a is a matrix of dim n x k, b is a col vect of dim n x 1
% the entries of f are a(i,j) * b(i)


  f = zeros(rows(a),cols(a));
  iter = cols(a);
  for i=1:iter
    f(:,i) =  a(:,i) .* b;
  end





