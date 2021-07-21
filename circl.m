r=0:0.1:1;
r2=[r;r;r;r;r;r;r;r;r;r;r;r;r;r;r;r;r;r;r;r;r;r;r;r;r];
the=0:15:360;
the3=linspace(0,90,25)
the2=[the; the; the; the; the; the; the; the; the; the; the];
figure(11)
hold on
for i=1:size(r,2)
    for j=1:size(the,2)
    chance(i,j)=1/cosd(r(i)*cosd(the(j)));
    plot3(r(i)*sind(the(j)),r(i)*cosd(the(j)),chance(i,j),'*');
    end
end
figure(20)
hold on
for i=1:size(r,2)
    for j=1:size(the,2)
        N=[abs(r2.*sind(the2)'-r(i)*sind(the(j))) abs(r2.*cosd(the2)'-r(i)*cosd(the(j)))];
    dis(i,j)=norm(mean(N));
    plot3(r(i)*sind(the(j)),r(i)*cosd(the(j)),dis(i,j),'*');
    end
end

