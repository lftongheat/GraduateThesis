% GenDataFig02: Generates simulation data for Figure 02: Performance of 
% Homotopy in decoding a rate-1/5 partial Hadamard code.

rand('seed',11111);
randn('seed',22222);

nDist = 4;
n = 2^8;
R = 5;
len = R*n;
delta = (R-1)/R;
Q = hadamard(len);
sigma_z = 1;

rhoArr = linspace(0.05,0.5,20);
distArr = {'Gaussian','Signs','Cauchy','Rayleigh'};
iterArr = zeros(nDist,length(rhoArr));
BERArr = zeros(nDist,length(rhoArr));

for di = 1:nDist
    zDist = distArr{di};

    for ri = 1:length(rhoArr)
        rho = rhoArr(ri);
        k = floor(rho*delta*len);

        % Create digital signal to be encoded
        theta = SparseVector(n,n,'Signs');

        % Create encoding matrix
        p = randperm(len);
        E = Q(p(1:n),:)';
        D = Q(p((n+1):len),:);

        % Encoding stage
        tx = E*theta;

        % Transmission stage: Add sparse noise
        z = SparseVector(len,k,zDist,1) .* sigma_z;
        rx = tx+z;

        % Decoding stage: Solve with Homotopy (in k steps)
        y = D*rx;

        [xHom, iters] = SolveLasso(D, y, len);
        thetaHom = sign(E'*(rx-xHom));
        BER_Hom = sum(thetaHom ~= theta) ./ n;
        
        iterArr(di,ri) = iters;
        BERArr(di,ri) = BER_Hom;
        
        disp(['k = ' num2str(k), ', iters = ' num2str(iters)]);
    end
end

save DataFig02.mat iterArr BERArr nDist n R len delta rhoArr distArr