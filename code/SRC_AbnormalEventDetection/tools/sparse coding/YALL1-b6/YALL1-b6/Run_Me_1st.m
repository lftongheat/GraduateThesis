path(path,genpath(pwd))
if exist('fastWHtrans','file') ~= 3
    cd Utilities;
    mex -O fastWHtrans.cpp
    cd ..;
end
disp('Welcome to YALL1')
