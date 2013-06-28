% Table 1: Empirically-derived constant C_p in the CS error bound.
% Uses data file: BoundData1.mat
% See also: GenBoundData1


close all;

load BoundData1.mat;

Cp = zeros(length(P),length(M),length(Nfrac));
E = zeros(size(Nfrac));

for pp = 1:length(P)
    for mm = 1:length(M)
        N = floor(Nfrac .* M(mm));
        for nn = 1:length(Nfrac)
            [E(nn), jj] = max(errArray(pp,mm,nn,:));
            R = Pnorm(pp,mm,nn,jj);
            Cp(pp,mm,nn) = E(nn) ./ (R .* (N(nn) ./ log2(M(mm))) .^ (0.5 - 1/P(pp)));
        end 
    end
end

CpVec = zeros(size(P));
for pp = 1:length(P)
    CpVec(pp) = max(max(Cp(pp,:,:)));
end

figure; plot(P,CpVec,'-k'); grid on;
xlabel(['p']);
axis([0.25 1 0 0.3]);
title('Behavior of C_{p}');

% Generate table
fprintf('\n');
for jj = 1:length(CpVec)
    fprintf([num2str(P(jj)) ' & ' num2str(CpVec(jj)) ' \\\\ \\hline \n']);
end

save CpVec.mat CpVec P
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
