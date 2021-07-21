% load Data_72h
% tot_size=size(size(Rov(1,:).GPSsec),2);
% GPSsec=zeros(1,tot_size);
% GPSdat=zeros(32,11,tot_size);
% for i=1: tot_size
% GPSsec(i)=Rov(1,i).GPSsec;
% GPSdat(:,:,i)=Rov(1,i).GPS;
% end
Rov_30=Rov(1:30:end);