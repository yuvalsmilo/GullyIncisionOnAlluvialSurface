function [IncisionMap,filledDEM]=fillDEM(DEM,Xsurf,Ysurf,Zsurf)
DEM = inpaintnans(DEM);

cellsize = DEM.cellsize;
xll = DEM.refmat(3);
yll = DEM.refmat(6)-((cellsize)*DEM.size(1));

rStep = zeros(DEM.size);
xInterp = repmat(xll+cellsize/2:cellsize:((xll+size(rStep,2)*cellsize)),size(rStep,1),1);
yInterp = flipud(repmat((yll+cellsize/2:cellsize:((yll+size(rStep,1)*cellsize)))',1,size(rStep,2)));

%% Create the fill map - topographic before incision
FillMap = interp2(Xsurf,Ysurf,Zsurf,xInterp,yInterp); %Surfaec to grid
IncisionMap = FillMap - DEM.Z; % Incision map
IncisionMap(IncisionMap<0)=0;
filledDEM = DEM; % Filled Map with the drainage boundaries
filledDEM.Z = FillMap ; % Filled Map with the drainage boundaries

% Optional : where the data is above take the dem data
% indxim_above_surface = find(IncisionMap<0); %Indx that are above the interpolated surface
% filledDEM.Z(indxim_above_surface) = FillMap(indxim_above_surface); 


%% Scratching the exsiting stream network to the fill map
diffrence_max_elev = max(max(filledDEM.Z)) - max(max(DEM.Z));
% filledDEM.Z = filledDEM.Z+diffrence_max_elev; % Optional - Make the divide be in the same height.


               


end