function g = FunConv(f1,f2)
% FunConv -- convolve two functions
%  g = FunConv(f1,f2)
fh1 = fft(fftshift(f1));
fh2 = fft(fftshift(f2));
g = real(fftshift(ifft(fh1.*fh2)));
% should normalize to make this accurate! 


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
