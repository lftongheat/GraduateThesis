% Creation of Figure 3
M=1e-2;
R=[1e1 3e1 1e2 3e2 1e4];
figure(1); clf;
plot(0,0); hold on;
for k=1:1:5,
    count=1;
    for J=2:0.1:15,
        % Regular Bound
        B1(count)=(1+M)/(2*M+1/R(k));
        % Union of ortho Bound
        a1=J-1+sqrt(2*M^2*R(k)^2+2*M*R(k)+1)/(2*M*R(k)+1);
        a2=J-1+(M*R(k)+1)/sqrt(2*M^2*R(k)^2+2*M*R(k)+1);
        a3=J-1+1/(2*M*R(k)+1);
        B2(count)=1/M*(a1*a2/a3-J);
        count=count+1;
    end;
    plot(2:0.1:15,B1);
    plot(2:0.1:15,B2,'r');
end;
axis([2 15 0 100]);
xlabel('J');
ylabel('Bounds on ||\alpha_0||_0');
gtext('R=10');
gtext('R=30');
gtext('R=100');
gtext('R=300');
gtext('R=10000');
