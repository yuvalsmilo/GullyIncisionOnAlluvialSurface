function [surffit,Xsurf,Ysurf,Zsurf] = FitSurfaceToCatchment(point_data,maximum_uninterapted_depth)

xvec = point_data(:,1);
yvec = point_data(:,2);
zvec = point_data(:,3);
z_to_exclude = max(zvec)-maximum_uninterapted_depth;
[surffit, gof] = createFit_SurfaceGenerate(xvec, yvec, zvec, z_to_exclude);

hplot=plot(surffit,[xvec,yvec],zvec);
Xsurf = get(hplot,'XData');
Xsurf =Xsurf{1};
Ysurf = get(hplot,'YData');
Ysurf =Ysurf{1};
Zsurf = get(hplot,'ZData');
Zsurf =Zsurf{1};

close all
%If you want that the interp surf will be above all the points uncomment
%this section:

% factor = 1.000;
% ystep = [1:2:size(Zsurf,1)];
% xstep = [1:2:size(Zsurf,2)];
% for i=1:length(ystep)-1
%     for j = 1:length(xstep)-1
%         Zsurf(ystep(i):ystep(i+1)-1,xstep(j):xstep(j+1)-1) = factor*(max(max( Zsurf(ystep(i):ystep(i+1)-1,xstep(j):xstep(j+1)-1))));
%     end
% end




end






