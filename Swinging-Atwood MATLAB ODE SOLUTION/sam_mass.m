%% CONDIZIONI INIZIALI
close all
clear all

tspan = [0 15]; %secondi
g = 9.806;
m = 1;

for M=1:1:100
    %M = M/10;
    % Condizioni iniziali configurazione 1
    r_1 = 1; %distanza dal perno 
    r_v1 = 0; %velocità radiale
    d_1 = pi/2; %angolo rispetto alla verticale
    d_v1 = 0; %velocità angolare

    y1 = [d_1 r_1 d_v1 r_v1 M];
    
    % Condizioni iniziali configurazione 2
    r_2 = 1+1e-8;
    r_v2 = +1e-8;
    d_2 = pi/2+1e-8;
    d_v2 = 0+1e-8;

    y2 = [d_2 r_2 d_v2 r_v2 M];
    %M=M*10;
    %% RISULTATI
    options = odeset('RelTol',1e-12,'AbsTol',1e-12); % Richiediamo errori di appross relativo e assoluto <10^(-12) 
    [T1,Y1] = ode45(@sam_L,tspan,y1, options); % Config 1
    [T2,Y2] = ode45(@sam_L,T1,y2, options); % Config 2 con tspan = T1 per avere sincronizzazione dati



    % Calcolo esp lyapunov 2 con grafico
    
    dZ_t1 = abs(Y2(:,1)-Y1(:,1));
    dZ_t2 = abs(Y2(:,2)-Y1(:,2));
    dZ_t3 = abs(Y2(:,3)-Y1(:,3));
    dZ_t4 = abs(Y2(:,4)-Y1(:,4));
    dZ_i = abs(y1-y2);
    delta_0 =  norm(y1-y2);
    for i = 1:size(T1)
        delta_t(i) = norm([dZ_t1(i) dZ_t2(i) dZ_t3(i) dZ_t4(i)]);
    end

    % CASO 3
    fine=size(T1);
    x=T1(2:end);
    y=log(delta_t(2:end)'./delta_0);
    lyap_m(M)  = (log(delta_t(fine(1)))-log(delta_0))./(T1(fine(1)));

end    

M = [1:1:100];
fig1=figure();
scatter(M,lyap_m, 1.5);   
title('Esponente di Lyapunov in funzione di \mu (\delta(0) =1e-8)','FontSize',13, 'FontName', 'David Libre');
yl = ylabel('\lambda');
set(yl, 'FontSize', 14);
xl = xlabel('\mu = m/M');
set(xl, 'FontSize', 14);
grid on
hold off


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


