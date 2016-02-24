FileName='02-15-2016_21_04_37_top.fits';
EOS_Online( filename );

%The hope is to use this function as an easy way to do online fitting for
%EoS data
%FileName: the name of the file
%Pt:P/P0
%Kt:kappa/kappa_0
%ns:numberdensity
%Vs:potential
%Zs:The z position

%Defination of physical constant and experiment parameter
mli=9.988346*10^-27;  %kg
hbar=1.0545718*10^(-34); %SI
hh=2*pi*hbar;%SI Planck constant
omega=23.9*2*pi; %in rad/s
pixellength=1.44*10^-6; %in m
sigma0=0.215*10^-12/2; %in m^2
Nsat=630; %PI Camera
fudge=2.62;

% %Read the image
Img=fitsread(FileName);
Nimg=AtomNumber( Img,pixellength^2,sigma0, Nsat);
% %Get the ROI1
% questdlg('Now choose the ROI for get the n(z)')
% %msgbox('Now choose the ROI for get the n(z)');
% h=figure();
% imagesc(Nimg);
% caxis([0,15]);
% [~,Rect]=imcrop(h);
% close(h)
% ROI1=[round(Rect(1)),round(Rect(2)),round(Rect(1))+round(Rect(3)),round(Rect(2))+round(Rect(4))];
% %Get the ROI2 for outline fitting
% questdlg('Now choose the ROI for outline fitting')
% h=figure();
% imagesc(Nimg);
% caxis([0,15]);
% [~,Rect]=imcrop(h);
% close(h)
% ROI2=[round(Rect(1)),round(Rect(2)),round(Rect(1))+round(Rect(3)),round(Rect(2))+round(Rect(4))];
%ROI acquiring end
%Get the position of the tail, and tailor the tail to be a flat line
[n,z]=GenNvsZ( Nimg,ROI1,ROI2,pixellength,0,1 );
% h=figure();
% scatter(z,n);
% questdlg('Now give the range for tail fitting');
% [x,y]=getpts(h);
% close(h);
% zmin=min(x);
% zmax=max(x);
n=TailTailor(n,z,zmin,zmax);

%Get the n(z)

n=fudge*n;
Ptf=TFfit(n,z,60);         
z0=Ptf(2); %center of the TF profile
Ztf=Ptf(3)*pixellength; %TF radius
ntf=TFfun( Ptf,z );
Z=(z-z0)*pixellength;
V=0.5*mli*omega^2*Z.^2;
%sort Z,n with V
[Vsort,B]=sort(V);
nsort=n(B);
Zsort=Z(B);

Kt=GetKappavsV(nsort,Vsort);
[~,~,Pt]=GetPvsV( nsort,Vsort );

%select the data points to show in Kt vs Pt data
kmin=0.1;kmax=1.5;
Ktsel=Kt;Ptsel=Pt;Zsel=Zsort;

Ktsel(abs(Zsel)>kmax*Ztf)=[];
Ptsel(abs(Zsel)>kmax*Ztf)=[];
Zsel(abs(Zsel)>kmax*Ztf)=[];

Ktsel(abs(Zsel)<kmin*Ztf)=[];
Ptsel(abs(Zsel)<kmin*Ztf)=[];
Zsel(abs(Zsel)<kmin*Ztf)=[];

%Plot nvsz with TF fitting
h=figure()
subplot(3,2,1);
scatter(z,n);
hold on
plot(z,ntf);
hold off
xlabel('z (pixel)');
ylabel('n (m^{-3})');
title('n vs z')
%Plot n vs V
subplot(3,2,2);
scatter(Vsort/hh,nsort);
xlabel('V (Hz)');
ylabel('n (m^{-3})');
title('n vs V');
%Plot Pt vs V
subplot(3,2,3);
scatter(Vsort/hh,Pt);
ylim([0,5])
xlabel('V (Hz)');
ylabel('P/P_0 (m^{-3})');
title('P/P_0 vs V');
%Plot Kt vs V
subplot(3,2,4);
scatter(Vsort/hh,Kt);
ylim([0,5])
xlabel('V (Hz)');
ylabel('\kappa/\kappa_0');
title('\kappa/\kappa_0 vs V');
%Plot Kt vs Pt
subplot(3,2,5);
scatter(Ptsel,Ktsel);
ylim([0,4]);xlim([0,4]);
xlabel('P/O_0');
ylabel('\kappa/\kappa_0');
title('EoS')