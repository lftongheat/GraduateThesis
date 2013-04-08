function [pc,W,data_mean,xr,evals,percentVar]=ppca(data,k)
% PCA applicable to 
%   - extreme high-dimensional data (e.g., gene expression data) and
%   - incomplete data (missing data)
%
% probabilistic PCA (PPCA) [Verbeek 2002]
% based on sensible principal components analysis [S. Roweis 1997]
%  code slightly adapted by M.Scholz
%
% pc = ppca(data)
% [pc,W,data_mean,xr,evals,percentVar]=ppca(data,k)
%
%  data - inclomplete data set, d x n - matrix
%          rows:    d variables (genes or metabolites)
%          columns: n samples
%
%  k  - number of principal components (default k=2)
%  pc - principal component scores  (feature space)
%       plot(pc(1,:),pc(2,:),'.')
%  W  - loadings (weights)
%  xr - reconstructed complete data matrix (for k components)
%  evals - eigenvalues
%  percentVar - Variance of each PC in percent
%
%    pc=W*data
%    data_recon = (pinv(W)*pc)+repmat(data_mean,1,size(data,2))
%
% Example:
%    [pc,W,data_mean,xr,evals,percentVar]=ppca(data,2)
%    plot(pc(1,:),pc(2,:),'.'); 
%    xlabel(['PC 1 (',num2str(round(percentVar(1)*10)/10),'%)',]);
%    ylabel(['PC 2 (',num2str(round(percentVar(2)*10)/10),'%)',]);
%
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin==1
  k=2
end
 

  [C,ss,M,X,Ye]=ppca_mv(data',k,0,1);
  xr=Ye';
  W=C';
  data_mean=M';
  pc=X';
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate variance of PCs
 
  for i=1:size(data,1)  % total variance, by using all available values
   v(i)=var(data(i,~isnan(data(i,:)))); 
  end
  total_variance=sum(v(~isnan(v)));
  
  evals=nan(1,k);
  for i=1:k 
    data_recon = (pinv(W(i,:))*pc(i,:)); % without mean correction (does not change the variance)
    evals(i)=sum(var(data_recon'));
  end
  
  percentVar=evals./total_variance*100;
  
%    cumsumVarPC=nan(1,k);  
%   for i=1:k 
%     data_recon = (pinv(W(1:i,:))*pc(1:i,:)) + repmat(data_mean,1,size(data,2));
%     cumsumVarPC(i)=sum(var(data_recon')); 
%   end
%   cumsumVarPC
  


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% original code by Jakob Verbeek

function [C, ss, M, X,Ye] = ppca_mv(Ye,d,dia,plo);
%
% implements probabilistic PCA for data with missing values, 
% using a factorizing distrib. over hidden states and hidden observations.
%
%  - The entries in Ye that equal NaN are assumed to be missing. - 
%
% [C, ss, M, X, Ye ] = ppca_mv(Y,d,dia,plo);
%
% Y   (N by D)  N data vectors
% d   (scalar)  dimension of latent space
% dia (binary)  if 1: printf objective each step
% plo (binary)  if 1: plot first PCA direction each step. 
%               if 2: plot eigenimages
%
% ss  (scalar)  isotropic variance outside subspace
% C   (D by d)  C*C' +I*ss is covariance model, C has scaled principal directions as cols.
% M   (D by 1)  data mean
% X   (N by d)  expected states
% Ye  (N by D)  expected complete observations (interesting if some data is missing)
%
% J.J. Verbeek, 2002. http://www.science.uva.nl/~jverbeek
%

%threshold = 1e-3;     % minimal relative change in objective funciton to continue
threshold = 1e-5;  

if plo; set(gcf,'Double','on'); end

[N,D] = size(Ye);
    
Obs   = ~isnan(Ye);
hidden = find(~Obs);
missing = length(hidden);

% compute data mean and center data
if missing
  for i=1:D;  M(i) = mean(Ye(find(Obs(:,i)),i)); end;
else
    M = mean(Ye);
end
Ye = Ye - repmat(M,N,1);

if missing;   Ye(hidden)=0;end

r     = randperm(N); 
C     = Ye(r(1:d),:)';     % =======     Initialization    ======
C     = randn(size(C));
CtC   = C'*C;
X     = Ye * C * inv(CtC);
recon = X*C'; recon(hidden) = 0;
ss    = sum(sum((recon-Ye).^2)) / ( (N*D)-missing);

count = 1; 
old   = Inf;


while count          %  ============ EM iterations  ==========
    
    if plo; plot_it(Ye,C,ss,plo);    end
   
    Sx = inv( eye(d) + CtC/ss );    % ====== E-step, (co)variances   =====
    ss_old = ss;
    if missing; proj = X*C'; Ye(hidden) = proj(hidden); end  
    X = Ye*C*Sx/ss;          % ==== E step: expected values  ==== 
    
    SumXtX = X'*X;                              % ======= M-step =====
    C      = (Ye'*X)  / (SumXtX + N*Sx );    
    CtC    = C'*C;
    ss     = ( sum(sum( (C*X'-Ye').^2 )) + N*sum(sum(CtC.*Sx)) + missing*ss_old ) /(N*D); 
    
    objective = N*(D*log(ss) +trace(Sx)-log(det(Sx)) ) +trace(SumXtX) -missing*log(ss_old);           
    rel_ch    = abs( 1 - objective / old );
    old       = objective;
    
    count = count + 1;
    if ( rel_ch < threshold) & (count > 5); count = 0;end
    if dia; fprintf('Objective: M %s    relative change: %s \n',objective, rel_ch ); end
    
end             %  ============ EM iterations  ==========


C = orth(C);
[vecs,vals] = eig(cov(Ye*C));
[vals,ord] = sort(diag(vals));
ord = flipud(ord);
vecs = vecs(:,ord);

C = C*vecs;
X = Ye*C;
 
% add data mean to expected complete data
Ye = Ye + repmat(M,N,1);


% ====  END === 




function plot_it(Y,C,ss,plo); 
clf;
    if plo==1
        plot(Y(:,1),Y(:,2),'.');
        hold on; 
        h=plot(C(1,1)*[-1 1]*(1+sqrt(ss)), (1+sqrt(ss))*C(2,1)*[-1 1],'r');
        h2=plot(0,0,'ro');
        set(h,'LineWi',4);
        set(h2,'MarkerS',10);set(h2,'MarkerF',[1,0,0]);
        axis equal;
    elseif plo==2
        len = 28;nc=1;
        colormap([0:255]'*ones(1,3)/255);
        d = size(C,2);
        m = ceil(sqrt(d)); n = ceil(d/m);
        for i=1:d; 
            subplot(m,n,i); 
            im = reshape(C(:,i),len,size(Y,2)/len,nc);
            im = (im - min(C(:,i)))/(max(C(:,i))-min(C(:,i))); 
            imagesc(im);axis off;
        end; 
    end
    drawnow;
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
    