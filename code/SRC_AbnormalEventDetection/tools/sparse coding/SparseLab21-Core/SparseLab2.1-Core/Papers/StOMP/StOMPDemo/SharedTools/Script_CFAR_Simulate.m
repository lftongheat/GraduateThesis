% Simulate one combination of [k,n,p], 1000 times

Nexp = 1000;
SMax = 10;

	delta = n/p;
	rho = k/n;
	
	% Stats to keep track of:
	Stat_rnorm        = zeros(SMax,Nexp);
	Stat_qnorm        = zeros(SMax,Nexp);
	Stat_NULL_Remain  = zeros(SMax,Nexp);  % 
	Stat_NONZ_Remain  = zeros(SMax,Nexp);  %
	Stat_Dims_Remain  = zeros(SMax,Nexp); 
	Stat_Num_S        = zeros(Nexp,1);

    for exper=1:Nexp,

			%  Generate USE Matrix
			X = randn(n, p);
			for i=1:p,
                X(:,i) = X(:,i) ./ norm(X(:,i),'fro');
			end
			
			% Generate Unit Coeffs
			beta = zeros(p,1);
			beta(1:k) = ones(1,k);
			
            % Generate Projector  P0 = Q0 Q0^T
            [Q0,R] = qr(X(:,1:k),0);
                
			% Desired iterations
			S          = SMax;
			alpha      = (n-k)/((p-n)*S);
			constz     =  erfinv(1-alpha) * sqrt(2);
			
			% Set up Iteration
			Y = X*beta;
			r = Y;
			I = [];
			s= 0;
			normr0 = norm(r,'fro');
		
			while((s <= S) & (norm(r,'fro') > (1.e-4 .* normr0)))
                s = s+1;
                c = X'*r;
                normr = norm(r,'fro');
                c = c./normr;
                goodc = abs(c') > 1.e-5;
                nullp = (1:p) > k;
                nonz  = (1:p) < (k+1);
                tt = constz ./ sqrt(n);
                J = abs(c') >= tt;
		
                Stat_NULL_Remain(s,exper) = sum(nullp & goodc);
                Stat_NONZ_Remain(s,exper) = sum(nonz  & goodc);
                Stat_Dims_Remain(s,exper) = n - length(I);
                Stat_rnorm(s,exper)       = normr;
                Stat_qnorm(s,exper)       = norm(Q0 * (Q0' *r),'fro');
         
                if any(J),
                    Pickr = 1:p;
                    I = [ I Pickr(J)];
                    XI = X(:,I);
                    r = Y - XI * (XI\Y);
                 else
                    break
                end
			end %s loop
            if s < SMax,
                nullleft = (1:p) > k;
                nonzleft = (1:p) < (k+1);
                if ~isempty(I),
                    nullleft(I) = 0;
                    nonzleft(I) = 0;
                end               
                for t=s+1:SMax,              
                    Stat_NULL_Remain(t,exper) = sum(nullleft);
                    Stat_NONZ_Remain(t,exper) = sum(nonzleft);
                    Stat_Dims_Remain(t,exper) = n - length(I);
                    Stat_rnorm(t,exper)       = norm(r,'fro');
                    Stat_qnorm(t,exper)       = norm(Q0 * (Q0' *r),'fro');
                end
            end
            Stat_Num_S(exper) = min(s,S);
		end %exper loop
		
		Ave_rnorm        = zeros(1,SMax); 
		Ave_qnorm        = zeros(1,SMax); 
		Ave_NULL_Remain  = zeros(1,SMax);  % 
		Ave_NONZ_Remain  = zeros(1,SMax);  %
		Ave_Dims_Remain  = zeros(1,SMax); 
		Ave_Iter_Cnt     = zeros(1,SMax);
        
		for s=1:SMax,
                Ave_rnorm(s )      =  sqrt(mean(Stat_rnorm(s,:).^2));
                Ave_qnorm(s )      =  sqrt(mean(Stat_qnorm(s,:).^2));
                Ave_NULL_Remain(s) =  (mean(Stat_NULL_Remain(s,:) ));
                Ave_NONZ_Remain(s) =  (mean(Stat_NONZ_Remain(s,:) ));
                Ave_Dims_Remain(s) =  (mean(Stat_Dims_Remain(s,:) ));
                Ave_Iter_Cnt(s)    =  mean(Stat_Num_S(:) >= s);
		end
		fprintf('\n(  k,  n,   N):   s | Null True Dims |  rnorm     qnorm \n')
		for s=1:SMax,
                fprintf('(%3i,%3i,%4i): %3i | %4i %4i %4i | %f %f | %i \n', ...
                [ k n p s round(Ave_NULL_Remain(s)) round(Ave_NONZ_Remain(s))  ...
                          round(Ave_Dims_Remain(s)) Ave_rnorm(s) Ave_qnorm(s) Ave_Iter_Cnt(s) ])
		end

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
