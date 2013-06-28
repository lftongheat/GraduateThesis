% Creation of Figure 5 

load BPDN_vs_Stability_Results3_New % created by 'Generate_Results.m'
h=figure(5); clf; 
set(h,'Position',[10 10 1400 500]);
x=0:0.01:1;

for Sparse=1:1:R3(end,1);
    subplot(1,R3(end,1),Sparse);
    plot(x,x,'r:'); hold on; 
    set(gca,'FontSize',20,'FontName','Times');
    for k=1:1:10,
        pos=find(R3(:,1)==Sparse & abs(sqrt(R3(:,2))-k/10)<1e-5);
        V=sqrt(R3(pos,6));
        V=sort(V);
        plot(sqrt(R3(pos(1),2)),V(1),'x');
        for jj=1:1:10,
            plot(sqrt(R3(pos(1),2)),V(round(jj*length(V)/10)),'x');
            % errorbar(sqrt(R3(pos(1),2)),median(V),min(V),max(V));
        end;
        plot([sqrt(R3(pos(1),2)),sqrt(R3(pos(1),2))],[V(1),V(end)],'b');
    end;
    axis([0 1.02 0 1]);
    if Sparse==2, 
        h=xlabel('Noise Power [\epsilon]');
        set(h,'FontSize',20,'FontName','Times');
    end;
    if Sparse==1, 
        h=ylabel('Signal Error [Sqrt-MSE]');
        set(h,'FontSize',20,'FontName','Times');
    end;
    h=title(['N=',num2str(Sparse)]);
    set(h,'FontSize',20,'FontName','Times');
end;

