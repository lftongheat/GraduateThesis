function [lambda,grid] = LambdaCurve(mu,tau,sigma,t)
% LambdaCurve: Radon-Nikodym Calculation
%   [lambda,grid] = LambdaCurve(mu,tau,sigma,t)
% Synopsis
%   mu      array(S,1)
%   tau     array(S,1)
%   sigma   array(S,1)
%   t       positive float
% Result
%   prob    probability
% 
% This function computes the curve
%      lambda(z) =  p_s[z|mu,tau,sigma / phi_s[z|mu,tau]
%      % Illustra
%      p_s[z] = dens[ Z_s |  |Z_i| < t sigma(i), i=1,...,S-1 ]
% Here
%      (Z_i: 1 <= i <= S) is a multivariate normal vector
%      mean Z_i = mu(i)
%      Cov(Z_i,Z_j) = tau^2(max(i,j))

S = length(sigma);
scale=max(sigma(:));
%grid = (-128*256):((256*128)-1); grid = grid ./256; dgrid = grid(2)-grid(1);
grid = (-128*256):((256*128)-1); grid = grid .* (7*scale)./(256*256); dgrid = grid(2)-grid(1);
f = 0*grid+1;
if S > 1,
    for s=1:S,
        if s < S,
        	g = MutilateDensity(grid,f,-t*sigma(s),t*sigma(s));
            kern = MakeTransKernel(grid,mu((s+1):-1:s),tau((s+1):-1:s));
            f = real(FunConv(g,reverse(kern)));
        end
        if (s == S),
            dens = NormalDens(grid,mu(s),tau(s)); dens = dens ./sum(dens);
            bot =  sum(f .* dens);
%             lambda = (f.*dens)./bot;
            lambda = (f)./bot;

        end
    end
end

%
% Copyright (c) 2006. David Donoho
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%
