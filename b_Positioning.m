clc
clearvars
% close all
hold on
load Data_72h_30
load angles
load w_theta_fin

xyz_ref = [-3052875.40716982,4039793.96050724,3865296.72217509]; % 실험데이터 실제 위치 (Data)

%%
len = length(Rov_30);
ENU = NaN(len,3);
ENU_elev = NaN(len,3);
ENU_codop = NaN(len,3);
ENU_dop = NaN(len,3);
ECEF = NaN(len,3);
PrGPS=zeros(32,len)+NaN;
sat_pos=zeros(32,3,len)+NaN;
rec=zeros(15,len)+NaN;

for i = 1:len
    sat_on=[];
    n_vs = 32;
    GNSS = Rov_30(i).GPS;
    vs = zeros(n_vs,1);
    for p = 1:n_vs
        if GNSS(p,1) ~= 0 && GNSS(p,2) ~= 0
            vs(p) = 1;
            sat_on=[sat_on p];
        end
    end
    GPS = GNSS(vs==1,:);
    
    n_vs = 24;
    GNSS = Rov_30(i).GLO;
    vs = zeros(n_vs,1);
    for p = 1:n_vs
        if GNSS(p,1) ~= 0 && GNSS(p,2) ~= 0
            vs(p) = 1;
        end
    end
    GLO = GNSS(vs==1,:);
    
    n_vs = 36;
    GNSS = Rov_30(i).GAL;
    vs = zeros(n_vs,1);
    for p = 1:n_vs
        if GNSS(p,1) ~= 0 && GNSS(p,2) ~= 0
            vs(p) = 1;
        end
    end
    GAL = GNSS(vs==1,:);
    
    n_vs = 30;
    GNSS = Rov_30(i).BEI;
    vs = zeros(n_vs,1);
    for p = 1:n_vs
        if GNSS(p,1) ~= 0 && GNSS(p,2) ~= 0
            vs(p) = 1;
        end
    end
    BEI = GNSS(vs==1,:);
    
    GNSS = [GPS; GLO; GAL; BEI];
       
    sys = [ones(size(GPS,1),1)];
%     ; 2*ones(size(GLO,1),1); 3*ones(size(GAL,1),1); 4*ones(size(BEI,1),1)];
    
    temp = length(sys);
    rho = GNSS(1:temp,1);
    sig=GNSS(1:temp,2);
    PrGPS(sat_on(1:temp),i)=rho;
    rec(1:temp,i)=sat_on(1:temp);
    clk = GNSS(1:temp,8);
    sat = GNSS(1:temp,9:11);
    sat_pos(sat_on(1:temp),:,i)=sat;
    angles_in=angles(sat_on(1:temp),i,:);
    w_theta_in=180/pi*w_theta(sat_on(1:temp),i);

    ENU(i,:)  = Positioning( rho, sat, clk, xyz_ref, sys,sig, angles_in );
    ENU_elev(i,:)  = Positioning_elev( rho, sat, clk, xyz_ref, sys,sig, angles_in );
    ENU_codop(i,:)  = Positioning_codop( rho, sat, clk, xyz_ref, sys,sig,angles_in, w_theta_in );
end
%%

ENU_filter = ENU(abs(ENU(:,2))<500,:);
ENU_WDOP_filter = ENU_elev(abs(ENU_elev(:,2))<500,:);
ENU_MDOP_filter = ENU_codop(abs(ENU_codop(:,2))<500,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%  작성부분 4 %%%%%%%%%%%%%%%%%%%%%%%%%%
figure(12)
grid on; hold on;
% plot(ENU_filter(:,1),ENU_filter(:,2),'*g'); 
plot(ENU_WDOP_filter(:,1),ENU_WDOP_filter(:,2),'.r');
plot(ENU_MDOP_filter(:,1),ENU_MDOP_filter(:,2),'.b');

legend('WDOP','WDOP+PPDOP')
axis equal
title("Weight Variation")
xlabel("East (m)")
ylabel("North (m)")

%%%%%%%%%%%%%%%%%%%%%%%%%%  작성부분 4 %%%%%%%%%%%%%%%%%%%%%%%%%%