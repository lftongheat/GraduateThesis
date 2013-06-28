% This script generates Figure 2 in the paper

%h=figure(1); clf; set(h,'Position',[213 57 1037 838]);

% L1 option
lambda=1; 
a=0:0.001:3; 
p=1;
zout=a*0;
z=0:0.001:3;
h=waitbar(0,'sweeping through values of a');
for k=1:1:length(a);
    waitbar(k/length(a))
        Er=0.5*(z-a(k)).^2+lambda*(z.^p);
    pos=find(Er==min(Er));
    zout(k)=z(pos(1));
end;
close(h);

subplot(2,2,1); 
h=plot(a,zout);
set(h,'LineWidth',2);
hold on;
h=plot(-a,-zout);
set(h,'LineWidth',2);
grid on
h=plot([-3 3 ],[-3 3],'--');
set(h,'LineWidth',2);
axis image
h=title('\rho(z) = |z|');
set(h,'FontSize',16);
h=xlabel('a');
set(h,'FontSize',16);
h=ylabel('\psi(a)');
set(h,'FontSize',16);
set(gca,'FontSize',16)

% L0 option
lambda=1; 
a=0:0.001:3; 
p=0.001;
zout=a*0;
z=0:0.001:3;
h=waitbar(0,'sweeping through values of a');
for k=1:1:length(a);
    waitbar(k/length(a))
        Er=0.5*(z-a(k)).^2+lambda*(z.^p);
    pos=find(Er==min(Er));
    zout(k)=z(pos(1));
end;
close(h);

subplot(2,2,2); 
h=plot(a,zout);
set(h,'LineWidth',2);
hold on;
h=plot(-a,-zout);
set(h,'LineWidth',2);
grid on
h=plot([-3 3 ],[-3 3],'--');
set(h,'LineWidth',2);
axis image
h=title('\rho(z) = |z|^0');
set(h,'FontSize',16);
h=xlabel('a');
set(h,'FontSize',16);
h=ylabel('\psi(a)');
set(h,'FontSize',16);
set(gca,'FontSize',16);

% Cauchy function
lambda=1; 
a=0:0.001:3; 
zout=a*0;
z=0:0.001:3;
h=waitbar(0,'sweeping through values of a');
for k=1:1:length(a);
    waitbar(k/length(a))
        Er=0.5*(z-a(k)).^2+lambda*(z.^2)./(z.^2+0.5);
    pos=find(Er==min(Er));
    zout(k)=z(pos(1));
end;
close(h);

subplot(2,2,3); 
h=plot(a,zout);
set(h,'LineWidth',2);
hold on;
h=plot(-a,-zout);
set(h,'LineWidth',2);
grid on
h=plot([-3 3 ],[-3 3],'--');
set(h,'LineWidth',2);
axis image
h=title('\rho(z) = z^2/(z^2+0.5)');
set(h,'FontSize',16);
h=xlabel('a');
set(h,'FontSize',16);
h=ylabel('\psi(a)');
set(h,'FontSize',16);
set(gca,'FontSize',16);

% Hubber-Markov function
lambda=1; 
a=0:0.001:3; 
zout=a*0;
z=0:0.001:3;
h=waitbar(0,'sweeping through values of a');
for k=1:1:length(a);
    waitbar(k/length(a))
        Er=0.5*(z-a(k)).^2+lambda*((z>=0.5).*(z-0.25)+(z<0.5).*(z.^2));
    pos=find(Er==min(Er));
    zout(k)=z(pos(1));
end;
close(h);

subplot(2,2,4); 
h=plot(a,zout);
set(h,'LineWidth',2);
hold on;
h=plot(-a,-zout);
set(h,'LineWidth',2);
grid on
h=plot([-3 3 ],[-3 3],'--');
set(h,'LineWidth',2);
axis image
h=title('\rho(z) = z^2 [for |z|<0.5] & z-0.5 [otherwise]');
set(h,'FontSize',16);
h=xlabel('a');
set(h,'FontSize',16);
h=ylabel('\psi(a)');
set(h,'FontSize',16);
set(gca,'FontSize',16);