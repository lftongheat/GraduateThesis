function y = ifastWHtrans(x)
% ivfastWHtrans computes fast inverse discrete Walsh-Hadamard transform 
% with sequency order.
%
% Since the forward and inverse transforms are exactly identical
% operations, fastWHtrans.mexw32 is used to perform inverse transform.
%
% Right now, this code only accept the real vector (row or column) as the 
% input argument.
%
% written by: Chengbo Li
% Computational and Applied Mathematics Department, Rice University.


y = fastWHtrans(x);
% Perform scaling
[m,n] = size(y);
if m == 1 % column vector
    m = n;
end
y = y .* m;
