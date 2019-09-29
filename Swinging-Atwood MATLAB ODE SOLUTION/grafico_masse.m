fig1=figure();
scatter(M,lyap_m, 100, '.', 'k');   
title('Esponente di Lyapunov in funzione di \mu (\delta(0)=2e-8)','FontSize',13, 'FontName', 'David Libre');
yl = ylabel('\lambda');
set(yl, 'FontSize', 16);
xl = xlabel('\mu = M/m');
set(xl, 'FontSize', 16);
grid on
hold off

%%EXPORT figure
hfig1=fig1;
set(hfig1, 'PaperType', 'A4');
set(hfig1, 'PaperUnits', 'centimeters');
set(hfig1, 'PaperPositionMode', 'manual');
set(hfig1, 'PaperPosition', [0 0 29 21]);
print(hfig1, '-dpng', 'masse_1e-8e-8-15sec.png')
