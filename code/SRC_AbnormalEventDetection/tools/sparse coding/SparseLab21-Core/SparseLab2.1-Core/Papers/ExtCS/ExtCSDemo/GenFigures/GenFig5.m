% Figure 5: Plot of reconstruction error (empirical & theoretical) 
% when m,p are constant, n varies. 
% Uses data files: BoundData1.mat, CpVec.mat
% See also: GenBoundData1, GenTbl01

load BoundData1.mat;
load CpVec.mat;

E = zeros(size(Nfrac));
R = zeros(size(Nfrac));

figNames = ['(a) ';'(b) '; '(c) '; '(d) '];
figNum = 0;
for pp = [4, 8, 12, 16]
    for mm = 2:2
        N = floor(Nfrac .* M(mm));
        for nn = 1:length(Nfrac)
            [E(nn), jj] = max(errArray(pp,mm,nn,:));
            R(nn) = Pnorm(pp,mm,nn,jj);
        end 
        figNum = figNum+1;
        subplot(2,2,figNum); 
        plot(N,E,'-k'); grid on;
        xlabel(['n']);
        ylabel('|| x_{1,n} - x_{0} ||_{2}');
        title([figNames(figNum,:) 'm = ' num2str(M(mm)) ', p = ' num2str(P(pp))]);
        axis([0 max(N) 0 1.25.*max(E)]);
        bound = CpVec(pp) .* R .* (N ./ log2(M(mm))) .^ (0.5 - 1/P(pp));
        hold on;
        plot(N,bound,'-.r');
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
