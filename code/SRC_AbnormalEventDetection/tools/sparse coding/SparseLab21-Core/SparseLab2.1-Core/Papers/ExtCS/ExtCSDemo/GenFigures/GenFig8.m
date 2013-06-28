% Figure 8: Plot of reconstruction error (empirical & theoretical) 
% when m,p are constant, n varies, for different matrix ensembles. 
% Uses data files: BoundDataUniform.mat, BoundDataSigns.mat,
%    BoundDataFourier.mat, BoundDataHadamard.mat, CpVec.mat
% See also: GenBoundDataUniform, GenBoundDataSigns, 
%    GenBoundDataFourier, GenBoundDataHadamard, GenTbl01

load CpVec.mat;
Cp = CpVec(find(P == 0.75));
pp = 2; mm = 2;

load BoundDataUniform.mat;
N = floor(Nfrac .* M(mm));
E = zeros(size(N));
R = zeros(size(N));
for nn = 1:length(Nfrac)
    [E(nn), jj] = max(errArray(pp,mm,nn,:));
    R(nn) = Pnorm(pp,mm,nn,jj);
end 
subplot(2,2,1); 
plot(N,E,'-k'); grid on;
xlabel(['n']); ylabel('|| x_{1,n} - x_{0} ||_{2}');
axis([0 max(N) 0 0.25]);
title(['(a) Uniform Spherical Ensemble']);
bound = Cp .* R .* (N ./ log2(M(mm))) .^ (0.5 - 1/P(pp));
hold on; plot(N,bound,'-.r');
legend('Observed', 'Bound (3.2)');
hold off;

load BoundDataSigns.mat;
N = floor(Nfrac .* M(mm));
E = zeros(size(N));
R = zeros(size(N));
for nn = 1:length(Nfrac)
    [E(nn), jj] = max(errArray(pp,mm,nn,:));
    R(nn) = Pnorm(pp,mm,nn,jj);
end 
subplot(2,2,2); 
plot(N,E,'-k'); grid on;
xlabel(['n']); ylabel('|| x_{1,n} - x_{0} ||_{2}');
axis([0 max(N) 0 0.25]);
title(['(b) Random Signs Ensemble']);
bound = Cp .* R .* (N ./ log2(M(mm))) .^ (0.5 - 1/P(pp));
hold on; plot(N,bound,'-.r');
legend('Observed', 'Bound (3.2)');
hold off;

load BoundDataHadamard.mat;
N = floor(Nfrac .* M(mm));
E = zeros(size(N));
R = zeros(size(N));
for nn = 1:length(Nfrac)
    [E(nn), jj] = max(errArray(pp,mm,nn,:));
    R(nn) = Pnorm(pp,mm,nn,jj);
end 
subplot(2,2,3); 
plot(N,E,'-k'); grid on;
xlabel(['n']); ylabel('|| x_{1,n} - x_{0} ||_{2}');
axis([0 max(N) 0 0.25]);
title(['(c) Partial Hadamard Ensemble']);
bound = Cp .* R .* (N ./ log2(M(mm))) .^ (0.5 - 1/P(pp));
hold on; plot(N,bound,'-.r');
legend('Observed', 'Bound (3.2)');
hold off;

load BoundDataFourier.mat;
N = floor(Nfrac .* M(mm));
E = zeros(size(N));
R = zeros(size(N));
for nn = 1:length(Nfrac)
    [E(nn), jj] = max(errArray(pp,mm,nn,:));
    R(nn) = Pnorm(pp,mm,nn,jj);
end 
subplot(2,2,4); 
plot(N,E,'-k'); grid on;
xlabel(['n']); ylabel('|| x_{1,n} - x_{0} ||_{2}');
axis([0 max(N) 0 0.25]);
title(['(d) Partial Fourier Ensemble']);
bound = Cp .* R .* (N ./ log2(M(mm))) .^ (0.5 - 1/P(pp));
hold on; plot(N,bound,'-.r');
legend('Observed', 'Bound (3.2)');
hold off;

%
% Copyright (c) 2006. Yaakov Tsaig
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%
