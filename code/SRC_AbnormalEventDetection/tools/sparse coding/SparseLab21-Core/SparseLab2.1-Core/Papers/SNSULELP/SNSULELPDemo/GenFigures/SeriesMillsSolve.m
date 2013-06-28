function t = SeriesMillsSolve(rho)
% t = SeriesMillsSolve(rho)
%
% Solves the equation M(s) = rho
global ztable millstable
% check that nu is in range.
if max(rho(:)) >= 1 | min( rho(:)) <= 0,
    disp(' Error in MillsSolve: rho outside (0,1) ')
end
if isempty(millstable) | isempty(ztable),
    z = linspace(.01,50,5000);
steps_large=2^15;
series_large=zeros(size(z))+steps_large;
for j=steps_large:-1:1
  series_large=z+j./series_large;
end
series_large=z./series_large;

steps_small=100;
series_small=zeros(size(z));
series_small_coef=zeros(steps_small,length(z));
series_small_coef(1,:)=z/1;
for j=1:steps_small-1
  series_small_coef(j+1,:)=series_small_coef(j,:).*z.^2/(2*j+1);
end
series_small=sqrt(pi/2)*exp(z.^2/2)-sum(series_small_coef);
series_small=z.*series_small;
%figure
%plot(z,series_large)
%hold on
%plot(z,series_small,'r')
series=zeros(size(z));
for j=1:length(z)
  if z(j)<1/2
    series(j)=series_small(j);
  else
    series(j)=series_large(j);
  end
end
	ztable = z;
    millstable = series;
else
    z = ztable;
    series = millstable;
end  
t = interp1(series,z,rho,'spline'); %using 'spline' helped
t = -t;

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
