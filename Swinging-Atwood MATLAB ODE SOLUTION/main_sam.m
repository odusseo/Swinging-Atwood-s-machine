%% CONDIZIONI INIZIALI
close all
clear all

tspan = [0 35]; %secondi
g = 9.806;
m = 1;
M =2.185;

% Condizioni iniziali configurazione 1
r_1 = 1; %distanza dal perno
r_v1 = 0; %velocità radiale
d_1 = pi/2; %angolo rispetto alla verticale
d_v1 = 0; %velocità angolare

y1 = [d_1 r_1 d_v1 r_v1 M];
E_kin = 1./2.*M.*r_v1.*r_v1 +1./2.*m.*(r_v1.*r_v1+r_1.*r_1.*d_v1.*d_v1);
E_pot = M.*g.*(r_1)-m.*g.*r_1.*cos(d_1);
E_tot_i1 = E_kin+E_pot;

% Condizioni iniziali configurazione 2
r_2 = 1+1e-8;
r_v2 = +1e-8;
d_2 = pi/2+1e-8;
d_v2 = +1e-8;

y2 = [d_2 r_2 d_v2 r_v2 M];
E_kin = 1./2.*M.*r_v2.*r_v2 +1./2.*m.*(r_v2.*r_v2+r_2.*r_2.*d_v2.*d_v2);
E_pot = M.*g.*(r_2)-m.*g.*r_2.*cos(d_2);
E_tot_i2 = E_kin+E_pot;

%% RISULTATI
options = odeset('RelTol',1e-12,'AbsTol',1e-12); % Richiediamo errori di appross relativo e assoluto <10^(-12) 
[T1,Y1] = ode45(@sam_L,tspan,y1, options); % Config 1
[T2,Y2] = ode45(@sam_L,T1,y2, options); % Config 2 con tspan = T1 per avere sincronizzazione dati

fig1 = figure();
plot(Y1(:,2).*sin(Y1(:,1)),-Y1(:,2).*cos(Y1(:,1)),'k');
title('\mu=3 - conf 1')
%xlim([-10 10]);
%ylim([-10 6]);
axis equal
hold on
% 
% e =-1/M;
% l = E_tot_i1/(m*g*M);
% theta=0:0.001:2*pi;
% rho = (l./(1+e.*cos(theta+pi/2)));
% [x,y] = pol2cart(theta,rho);
% plot(x,y);


fig2 = figure();
plot(Y2(:,2).*sin(Y2(:,1)),-Y2(:,2).*cos(Y2(:,1)), 'k');
title('\mu=3 - conf 2')
axis equal


% Energia finale 1
r_0 = Y1(:,2);
r_v0 = Y1(:,4);
d_0 = Y1(:,1);
d_v0 = Y1(:,3);
E_kin = 1./2.*M.*r_v0.*r_v0 +  1./2.*m.*(r_v0.*r_v0+r_0.*r_0.*d_v0.*d_v0);
E_pot = M.*g.*(r_0)-m.*g.*r_0.*cos(d_0);
E_tot_f1 = E_kin(1,1)+E_pot(1,1);

% Energia finale 2
r_f2 = Y2(:,2);
r_vf2 = Y2(:,4);
d_f2 = Y2(:,1);
d_vf2 = Y2(:,3);
E_kin = 1./2.*M.*r_vf2.*r_vf2 + 1./2.*m.*(r_vf2.*r_vf2+r_f2.*r_f2.*d_vf2.*d_vf2);
E_pot = M.*g.*(r_f2)-m.*g.*r_f2.*cos(d_f2);
E_tot_f2 = E_kin(1,1)+E_pot(1,1);

% Variazione energia
Delta_E_1 = E_tot_f1-E_tot_i1;
Delta_E_2 = E_tot_f2-E_tot_i2;

%% Calcolo esp lyapunov con grafico separati
dZ_t1 = abs(Y2(:,1)-Y1(:,1));
dZ_t2 = abs(Y2(:,2)-Y1(:,2));
dZ_t3 = abs(Y2(:,3)-Y1(:,3));
dZ_t4 = abs(Y2(:,4)-Y1(:,4));
dZ_i = abs(y1-y2);

fig3 = figure();
color = ['r' 'b' 'k' 'y'];
for i=1:4
    if dZ_i(i)==0
        lambda{i} = 0;
    else
        lambda{i} = log(dZ_t1./dZ_i(i))./T1;
    end
    plot(T1,lambda{i}, 'Color', color(i));
    ylim([-15 15])
    hold on
end

title('Lyapunov in spazio delle fasi');
legend('lyap theta', 'lyap r','lyap dtheta', 'lyap dr');
grid on
hold off

%% Calcolo esp lyapunov totale con grafico
delta_0 =  norm(y1-y2);
for i = 1:size(T1)
    delta_t(i) = norm([dZ_t1(i) dZ_t2(i) dZ_t3(i) dZ_t4(i)]);
end

% % Metodo 1
% x=T1(2:end)';
% y=log(delta_t(2:end));
% w = 1;
% Delta = ((sum(w))*(sum(w.*(x.^2))))-((sum(w.*x)).^2);
% A = (((sum(w.*(x.^2)))*(sum(w.*y)))-((sum(w.*x))*(sum(w.*(x.*y)))))/(Delta);
% B = (((sum(w))*(sum(w.*(x.*y))))-((sum(w.*y))*(sum(w.*x))))/(Delta);
% 
% T1=T1';
% lyap = B;
% 
% fig9=figure();
% hAy4=axes;
% hAy4.YScale='log';
% hold all
% scatter(T1,delta_t, 0.5);
% plot(T1,exp(A)*exp(B*T1),'m','LineWidth', 1, 'Color', 'k');     
% grid on
% hold off

% % Metodo 2
% x=T1(2:end);
% y=log(delta_t(2:end)'./delta_0);
% w = 1;
% Delta = ((sum(w))*(sum(w.*(x.^2))))-((sum(w.*x)).^2);
% A = (((sum(w.*(x.^2)))*(sum(w.*y)))-((sum(w.*x))*(sum(w.*(x.*y)))))/(Delta);
% B = (((sum(w))*(sum(w.*(x.*y))))-((sum(w.*y))*(sum(w.*x))))/(Delta);
% 
% lyap_t = log(delta_t./delta_0)'./T1;
% lyap = mean(lyap_t(2:end));
% 
% fig9=figure();
% hAy4=axes;
% hAy4.YScale='log';
% hold all
% scatter(T1,delta_t, 0.5);
% plot(T1,delta_0*exp(B*T1),'m','LineWidth', 1, 'Color', 'k');     
% grid on
% hold off

% Metodo 3
fine=size(T1);
x=T1(2:end);
y=log(delta_t(2:end)'./delta_0);
B3 = (log(delta_t(fine(1)))-log(delta_0))./(T1(fine(1)));

fig9=figure();
hAy4=axes;
hAy4.YScale='log';
hold all
scatter(T1,delta_t, 0.5, 'k');
plot(T1,delta_0.*exp(B3*T1),'m','LineWidth', 1.5, 'Color', 'r');
title('\delta(t) per \mu=3 (\delta(0)=2e-8)','FontSize',13, 'FontName', 'David Libre');
yl = ylabel('\delta(t)');
set(yl, 'FontSize', 16);
xl = xlabel('t [s]');
set(xl, 'FontSize', 16);
grid on
hold off

%%EXPORT figure
hfig1=fig1;
set(hfig1, 'PaperType', 'A4');
set(hfig1, 'PaperUnits', 'centimeters');
set(hfig1, 'PaperPositionMode', 'manual');
set(hfig1, 'PaperPosition', [0 0 29 21]);
print(hfig1, '-dpng', 'conf1_3.png')

hfig1=fig2;
set(hfig1, 'PaperType', 'A4');
set(hfig1, 'PaperUnits', 'centimeters');
set(hfig1, 'PaperPositionMode', 'manual');
set(hfig1, 'PaperPosition', [0 0 29 21]);
print(hfig1, '-dpng', 'conf2_3.png')

hfig1=fig9;
set(hfig1, 'PaperType', 'A4');
set(hfig1, 'PaperUnits', 'centimeters');
set(hfig1, 'PaperPositionMode', 'manual');
set(hfig1, 'PaperPosition', [0 0 29 21]);
print(hfig1, '-dpng', 'lyap_27-13.png')

function dydt = sam_L(t,y)
    g = 9.806;
    m = 1;
    
    y1=y(1);
    y2=y(2);
    y3=y(3);
    y4=y(4);
    M=y(5);
    dydt = zeros(5,1);
    dydt(1) = y3;
    dydt(2) = y4;
    dydt(3) = -(2*y3*y4+g*sin(y1))/y2;
    dydt(4) = (y3*y3*y2-g*(M/m-cos(y1)))/(1+M/m);
    dydt(5) = 0;
end








