function tk = TransitionK(x,k)
    tk = 0;
    if x <= k && x>= 0
        tk = 0.5*x/k;
    end
    if x <= 1 && x>= k
        tk = 1 - 0.5*log(x)/log(k);
    end
end