Results_All=[];
N=128; 
NumExp=1000; 

% the dictionary - Hadamard +Identity
H0=1/sqrt(2)*[1 1 ; -1 1];
H=H0;
for k=1:1:log(N)/log(2)-1, 
    H=kron(H,H0);
end;
D=[H,eye(N)];
M=1/sqrt(N);

%=========================================================

NonZeros=1:1:floor((1+M)/4/M);
Results_All=zeros(length(NonZeros)*NumExp*10,8);
count=1;
h=waitbar(0,'Sweeping through experiments ...');

for Sparse=1:1:length(NonZeros),
    for VarS=0.1:0.1:1, % the variance of the noise
        countExp=1;
        while countExp<=NumExp, % number of experiments to perform
            waitbar(count/length(NonZeros)/NumExp/10);

            % create a sparse representation signal
            Flag=rand(2*N,1);
            SFlag=sort(Flag);
            Thr=(SFlag(2*N-NonZeros(Sparse)+1)+SFlag(2*N-NonZeros(Sparse)))/2;
            Flag=Flag>Thr;
            x=randn(2*N,1);
            x=x.*Flag;
            S=D*x;
            factor=1/sqrt(S'*S);
            S=S*factor;
            x=x*factor;

            % add the noise in growing strength
            Var=VarS^2;
            Noise=randn(N,1);
            Noise=sqrt(Var)*Noise/sqrt(sum(Noise.^2));
            Sn=S+Noise;

            % solve the l1 minimization in order to find the representation
            xest_BP=Basis_Pursuit_Denoising(Sn,D,Var,x,10,0.1,10);
            pos1=find(abs(xest_BP)>0.01);
            pos2=find(abs(xest_BP)<=0.01);
            xest_BP(pos1)=pinv(D(:,pos1))*(S-D(:,pos2)*xest_BP(pos2));

            % apply the OMP
            xest_OMP=Ortho_Matching_Pursuit(Sn,D,Var);

            % present the result
            if xest_BP~=-1,
                Denoised_BP=D*xest_BP-S;
                Denoised_OMP=D*xest_OMP-S;
                pos=find(x~=0);
                Results_All(count,:)=[NonZeros(Sparse),Var,...
                    sum((xest_BP-x).^2),sum((xest_OMP-x).^2),...
                    sum(Denoised_BP.^2),sum(Denoised_OMP.^2),...
                    sum(xest_BP(pos).^2)/sum(xest_BP.^2),...
                    sum(xest_OMP(pos).^2)/sum(xest_OMP.^2)];
                disp([count,Results_All(count,:)]);
                count=count+1;
                countExp=countExp+1;
            end;
        end;

    end;
end;
close(h);

save BPDN_vs_Stability_Results3_New Results_All
