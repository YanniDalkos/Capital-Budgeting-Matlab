function [f] = mvnormal(mu,sigma,N)
% program: mvnormal.m 
% author: LRG
% date:  7/1//96
% produces N draws from a prespecified K-dimensional multivariate normal distb
% Must supply the Kx1 mean vector mu, and the KxK VCV matx sigma
% N is the number of vectors to return, say 10,000 for simulations
% output is a KxN matx - each col is a different draw from the dist
%  See my file 'technical tricks' specifcally Bjorn's HW#1 from
%   Duffie's PhD class at Stanford for the solution technique.


% First generate a Kx1 vector Z that is distb iid N(0,I)
% Then decompose sigma into sigma^(0.5) * sigma^(0.5) via cholskey decomp
% The entries of sigma^(0.5) give the coef's to mult by the Z's to get
%   the values of the X's

%***************
%path(path,'/home/finance/phd/gorman/matlab/larrylib'); % LRG custom .m files

dim = rows(mu);
f = zeros(dim,N);
rootsig = chol(sigma); % has zeros in lower diag - Cholesky decomposition

for n=1:N

  Z = randn(dim,1);
  f(:,n) = (sum(sweepa(rootsig,Z)))' + mu;
    % above line mults the chol matx by the iid rv's Z and adds mu
    % thus for a 2 dim problem (K=2) we have
    % x1 = mu1 + A*z1 and x2 = mu2 + B*z1 + C*z2
    % the chol matx will equal [A B, 0 C] thus the above works.
    % sweepa is a custom LRG command for sweeping a col across a matx

end
