%Figure 4.3

psinu=[];
psiC=[];
psiI=[];

count=1;
for nu = linspace(.55,.95,10)
   psinu(count) = PsiExt(nu);
   psiC(count) = PsiCom(nu,.095,.5555);
   psiI(count) = PsiInt(nu,.095,.5555);
   count=count+1;
end;

hold on;
plot(1:count-1,psinu);
plot(1:count-1,psiC,'r');
plot(1:count-1,psiI,'g');
xlabel('\nu');
title('\Psi_{com}(red) \Psi_{int}(green) \Psi_{ext}(blue)')
set(gca,'XTick',[1:count-1])
set(gca,'XTickLabel',{'.55','0.6','0.65','0.7','0.75','0.8','0.85','0.9','0.95','1'})
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
