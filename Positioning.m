function [ ENU ] = Positioning( rho, sat, clk, ref, sys,sig, angles )

%%%%%%%%%%%%%%%%%%%%%%%%%%  작성부분 1 %%%%%%%%%%%%%%%%%%%%%%%%%%
num_sys = max(sys);
%%%%%%%%%%%%%%%%%%%%%%%%%%  작성부분 1  %%%%%%%%%%%%%%%%%%%%%%%%%%

unknown = [0; 0; 0; zeros(num_sys,1)]; % 초기 선형화 지점
dx = [1; 1; 1; ones(num_sys,1)];
ENU = zeros(1,3);
count = 1;

R = rho + clk;
c1=38.62;
lamd1=-0.161;
c2=9.947;
lamd2=-0.01569;
PRC_the=c1*exp(lamd1*angles)+c2*exp(lamd2*angles);
%%%%%%%%%%%%%%%%%%%%%%%%%%  작성부분 2 %%%%%%%%%%%%%%%%%%%%%%%%%%
len_PRN = size(rho,1);
H_bias = zeros(len_PRN,num_sys);
Wpr = diag(1./(sig));
% Wpr = diag((1./(sig).*(50./(50+PRC_the))));
for i = 1:len_PRN
    H_bias(i,sys(i)) = 1;
end

while(norm(dx) > 0.001)
    R_d = sqrt((sat(:,1)-unknown(1)).^2+(sat(:,2)-unknown(2)).^2+(sat(:,3)-unknown(3)).^2);
    R_0 = R_d + unknown(3+sys);
    H_ros = [(unknown(1)-sat(:,1))./R_d (unknown(2)-sat(:,2))./R_d (unknown(3)-sat(:,3))./R_d];
    H = [H_ros H_bias];
%%%%%%%%%%%%%%%%%%%%%%%%%%  작성부분 2 %%%%%%%%%%%%%%%%%%%%%%%%%%
    Y = R - R_0;
    dx = ((H'*H)\H')*Y;
%     dx = ((H'*Wpr*H)\(H'*Wpr))*Y;
    unknown = unknown+dx;
    
    if count > 100
        fprintf('Standalone 반복문 횟수 초과\n');
        ENU(1,:) = NaN;
        break
    end
    count = count + 1;
end

ENU(1,:) = xyz2enu(unknown(1:3,1), ref);