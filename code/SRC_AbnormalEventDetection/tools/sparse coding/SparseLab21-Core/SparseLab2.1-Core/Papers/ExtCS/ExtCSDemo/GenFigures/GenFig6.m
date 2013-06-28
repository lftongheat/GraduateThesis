% Figure 6: Plot of reconstruction error (empirical & theoretical) 
% when n,p are constant, m varies. 
% Uses data files: BoundData1.mat, CpVec.mat
% See also: GenBoundData2, GenTbl01

load CpVec.mat
load BoundData2.mat;
Cp = CpVec([5, 16]);
E = zeros(size(M));
R = zeros(size(M));

figNames = ['(a) ';'(b) '; '(c) '; '(d) '];
figNum = 0;
for pp = 1:length(P)
    for nn = 2:2
        for mm = 1:length(M)
            [E(mm), jj] = max(errArray(pp,mm,nn,:));
            R(mm) = Pnorm(pp,mm,nn,jj);
        end 
        figNum = figNum+1;
        subplot(1,2,figNum); 
        plot(M,E,'-k'); grid on;
        xlabel(['m']);
        ylabel('|| x_{1,n} - x_{0} ||_{2}');
        title([figNames(figNum,:) 'n = ' num2str(N(nn)) ', p = ' num2str(P(pp))]);
        axis([0 max(M) 0 1.2.*max(E)]);
        bound = Cp(pp) .* R .* (N(nn) ./ log2(M)) .^ (0.5 - 1/P(pp));
        hold on;
        plot(M,bound,'-.r');
        legend('Observed', 'Bound (3.2)');
        hold off;
    end
end

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
