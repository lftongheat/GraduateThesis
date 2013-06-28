% Creation of Figure 4

M=1e-2;
R(1)=1e4;
k=1;
count=1;
for J=2:0.1:15,
    % Regular Bound
    B1(count)=(1+M)/(2*M+1/R(k));
    % Union of ortho Bound
    a1=J-1+sqrt(2*M^2*R(k)^2+2*M*R(k)+1)/(2*M*R(k)+1);
    a2=J-1+(M*R(k)+1)/sqrt(2*M^2*R(k)^2+2*M*R(k)+1);
    a3=J-1+1/(2*M*R(k)+1);
    B2(count)=1/M*(a1*a2/a3-J);
    % positivity condition for y1
    z1=sqrt(2*M*R(1)*(1+M*R(1))+1)/(2*M*R(1)+1);
    C(count)=(J-1+z1)/z1-J;
    count=count+1;
end;
figure(1); clf
plot(2:0.1:15,B1); hold on;
plot(2:0.1:15,B2,'r');
plot(2:0.1:15,C/M,'g')
axis([2 15 0 100]);
xlabel('J');
ylabel('Bounds on ||\alpha_0||_0');