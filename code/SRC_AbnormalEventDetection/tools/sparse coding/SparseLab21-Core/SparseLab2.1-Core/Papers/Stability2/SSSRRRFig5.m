% Creation of Figure 5

M=1e-2;
JM=10;
J=2:0.1:JM; B1=0.5+1./(4*J-6); B2=sqrt(2)-1+1./(2*J-2);
figure(1); clf; plot(J,B1/M); hold on;
plot(J,B2/M,'r');
plot([2.701 2.701],[0.4 1]/M,'g:');
B3=0.5*(1+1/M)*(J>0);
plot(J,B3,'c');
xlabel('J');
ylabel('Bounds on ||\alpha_0||_0');