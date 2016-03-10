%%
addpath('../Library');
warning('off','all');
%%
filename='/Users/Zhenjie/Data/2016-03-02/03-03-2016_01_52_16_top.fits';
[Pt,Kt,nsort,Vsort,Zsort,Ptsel,Ktsel,EF]=EOS_Online( filename ,'ROI1',[215,25,312,430],...
    'ROI2',[209,187,335,243],'ShowOutline',1,'KappaMode',2,'PolyOrder',10,'VrangeFactor',5,'IfHalf',1,'kmax',0.9,'kmin',0.15,...
    'Fudge',2.2,'BGSubtraction',BGimg);

d=figure();
scatter(Ptsel,Ktsel);
hold on
xlim([0,6])
[ KappaTildeP, PTildeP, ~, ~ ] = IdealFermiEOS( 1.1, 2, 100 );
ylim([0,4])
plot(PTildeP,KappaTildeP);
hold off

%'TailRange',[65,360],