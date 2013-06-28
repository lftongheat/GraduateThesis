% Creation of Figure1

SNRv=[100000 250000 400000 600000 1e6 2e6 5e6 1e10];
figure(1); clf; plot(0,0); hold on;
for k=1:1:8;
    SNR=SNRv(k);
    M=1/500; N=1/M^2;
    Res=zeros(1001,2);
    s1=0; Go=1;
    while Go,
        s2=0:0.01:1000;
        Func=(s1+s2+2*M*s1*s2)-(1-M*max(s2,s1)-2*M^2*s1*s2)*SNR/2/sqrt(N);
        Pos=find(Func<0);
        if isempty(Pos),
            Go=0;
        else,
            Pos=Pos(end);
            Res(s1+1,:)=[s1,s2(Pos)];
            s1=s1+1;
        end;
    end;
    Res=Res(1:s1-1,:);
    plot(Res(:,1),Res(:,2)); 
end;
axis image;
xlabel('|S_1|');
ylabel('|S_2|');
hold on;
plot([0 1/M],[1/M 0],'r');
plot((sqrt(2)-0.5)*[0 1/M],(sqrt(2)-0.5)*[1/M 0],'r:');
plot([0 (1+M)/M/2],[(1+M)/M/2 0],'r--');
axis([0 500 0 500]);
