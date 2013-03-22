function largeIm = Expand(im);
%EXPAND Compute large layer of Gaussian pyramid

% Sohaib Khan, Feb 16, 2000

%Algo
%Gaussian mask = [0.05 0.25 0.4 0.25 0.05] 
% Insert zeros in every alternate row position and conv with mask
% insert zeros in every alternate clmn position in result and conv with mask'

mask = 2*[0.05 0.25 0.4 0.25 0.05]; %factor of 2 is there because each pixel gets contribution 
												% either from 0.05, 0.4, 0.05  or from 0.25, 0.25

% insert zeros in every alternate position in each row
rowZeros = [im; zeros(size(im))];
rowZeros = reshape(rowZeros, size(im,1), 2*size(im,2));

%conv with horiz mask
newIm = conv2(rowZeros, mask);
newIm = newIm(:,3:size(newIm,2)-2);

% insert zeros in every alternate position in each col
colZeros = newIm';
colZeros = [colZeros; zeros(size(colZeros))];
colZeros = reshape(colZeros, size(colZeros,1)/2, 2*size(colZeros,2));
colZeros = colZeros';

largeIm=conv2(colZeros, mask');
largeIm=largeIm(3:size(largeIm,1)-2,:);