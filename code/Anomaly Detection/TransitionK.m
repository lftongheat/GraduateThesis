function tk = TransitionK(x)
%%
    k = 0.8;
    if x <= k && x>= 0
        tk = 0.5*x/k;
    elesif x <= 1 && x>= k
        tk = 1 - 0.5*log(x)/log(k);
    end
end