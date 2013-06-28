% Figure 7: Plot of reconstruction error for signals with controlled 
% number of nonzeros versus the quasibound (3.2) in the paper.
% Uses data files: DataL0_50.mat, DataL0_100.mat, CpVec.mat
% See also: GenDataL0, GenTbl01
load CpVec.mat

load DataL0_50.mat;
R = zeros(size(P));
for pp = 1:length(P)
    R(pp) = K .^ (1./P(pp));
end 

subplot(2,1,1);
plot(N,E,'-.k','LineWidth',2); grid on;
xlabel(['n']);
ylabel('|| x_{1,n} - x_{0} ||_{2}');
title(['(a) k = ' num2str(K)]);
lineType = ['-ro'; '-rs'; '-rd'; '-r^'];
Pind = [4, 8, 12, 16];
for lineNum = 1:4
    bound = CpVec(Pind(lineNum)) .* R(Pind(lineNum)) .* (N ./ log2(M)) .^ (0.5 - 1/P(Pind(lineNum)));
    hold on;
    plot(N,bound,lineType(lineNum,:), 'MarkerSize', 4);
    hold off;
end
legend('Observed', ['p = ' num2str(P(Pind(1)))], ['p = ' num2str(P(Pind(2)))], ...
    ['p = ' num2str(P(Pind(3)))], ['p = ' num2str(P(Pind(4)))]);
axis([0 max(N) 0 8]);


load DataL0_100.mat;
R = zeros(size(P));
for pp = 1:length(P)
    R(pp) = K .^ (1./P(pp));
end 

subplot(2,1,2);
plot(N,E,'-.k','LineWidth',2); grid on;
xlabel(['n']);
ylabel('|| x_{1,n} - x_{0} ||_{2}');
title(['(b) k = ' num2str(K)]);
lineType = ['-ro'; '-rs'; '-rd'; '-r^'];
Pind = [4, 8, 12, 16];
for lineNum = 1:4
    bound = CpVec(Pind(lineNum)) .* R(Pind(lineNum)) .* (N ./ log2(M)) .^ (0.5 - 1/P(Pind(lineNum)));
    hold on;
    plot(N,bound,lineType(lineNum,:), 'MarkerSize', 4);
    hold off;
end
legend('Observed', ['p = ' num2str(P(Pind(1)))], ['p = ' num2str(P(Pind(2)))], ...
    ['p = ' num2str(P(Pind(3)))], ['p = ' num2str(P(Pind(4)))]);
axis([0 max(N) 0 8]);

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
