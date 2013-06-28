function Kern = MakeTransKernel(grid,mu,sigma)
% MakeTransKernel -- make standard normal transition kernel
%  Kern = MakeTransKernel(grid,mu,sigma)
dmu = mu(2) - mu(1);
dsig2 = sigma(2)^2 - sigma(1)^2;
Kern = exp( -(grid - dmu).^2/(2*dsig2) )/sqrt(2*pi*dsig2);
Kern = Kern ./sum(Kern);
