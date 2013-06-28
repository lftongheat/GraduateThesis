% Figure4.1b

psinu = [];
ind=1;
for nu = linspace(.01,.99,50)
    psinu(ind)=PsiExt(nu);
    ind=ind+1;
end

plot(1:50,psinu)
xlabel('\nu')
title('\Psi_{ext}(\nu)')
set(gca,'XTickLabel',{'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1'})
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
