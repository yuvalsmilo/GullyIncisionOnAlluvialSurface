
%% Fit surface to gullies catchment and fill it accordingly
%
%   Input -
%       DEM  - ASCII file format (ASCII or TIFF) 
%   Output -
%       Filled DEM  - (GRIDobj of a DEM) 
%   Description
%       This script interpolate linear surface between pixels that assumed
%       to represented preserved patches on alluvial surfaces. 
%   


clear all
close all


%% Inputs
                    
ascii_path = 'DEM_example.asc';                                             % ASCII file of DEM
drainage_threshold = 1000;                                                  % cell_size^2
min_area = 0;                                                               % min area for extract the largest stream within the catchment. [cell_size^2]
max_drainage_area_for_preserved_surface = 10;                               % maximal drainage area for pixels that will be considerd as preserved [cell_size^2]    
maximum_uninterapted_depth = 100;                                           % height diffrence. pixels that their elevation difference relative to the heights point in the catchment is above this value will not affect the surface fitting [meters]
selected_catchment_ID = 30;                                                 % The catchment ID you want to work on (within DB1 grid element below)
portion_of_max_distance_for_outlet = 0.9;                                   % The minimal euclidean distance from the outlet of preserved pixels [portion of the maximal distance from the outlet within the catchment)]          

%% First - create stream network and catchments delineation
[DEM,FD,~,~]=MakeStreams(ascii_path ,drainage_threshold );
DEM1 = DEM;                                                                 % save the DEM for later
indexim_all=find(DEM.Z>=1);
[xall1,yall1]=ind2coord(DEM,indexim_all);
zall1=DEM.Z(indexim_all);
S   = STREAMobj(FD,'minarea',drainage_threshold );
DB1   = drainagebasins(FD,S); 
% Plot the catchments
figure;
imagesc(DB1)



% Start working:
close all
[MS,~,~] = GRIDobj2polygon(DB1);                                            % selected catchment boundaries to polygon
DEM.Z(DB1.Z~=selected_catchment_ID)=NaN;                                    % Clip out all pixels that are not within the selected catchment 



% Find the largest stream within the catchment
[S_large,S,~] = FindLargeStream(DEM,min_area);

% Plot the stream on map
figure()
[zmax,mask] = maplateral(S_large,DEM1,1,@max);
imageschs(DEM1,mask,'truecolor',[1 0 0],...
                   'colorbar',false,...
                   'ticklabels','nice') 
hold on
plot(MS(selected_catchment_ID).X,MS(selected_catchment_ID).Y,'k','LineWidth',2);
hold on
text(MS(selected_catchment_ID).X(50)-2,MS(selected_catchment_ID).Y(1),num2str(selected_catchment_ID),'FontSize',18);
MStream = STREAMobj2mapstruct(S);

  
%% Generate new DEM for this drainage only
[DEM,FD,~,S]=MakeStreams(DEM,min_area);
DEM = inpaintnans(DEM);
A = flowacc(FD).*(FD.cellsize^2);
Distance = flowdistance(FD);

%% Find the largest stream
[S_large,~,FD_out] = FindLargeStream(DEM,min_area);


%% Find preserved pixels
a=GRIDobj(A);
a.Z(:)=1;
GS = STREAMobj2GRIDobj(S_large);
outlet_inx=streampoi(S_large,'outlets','ix');

SEED = GRIDobj(DEM,'logical');
SEED.Z(outlet_inx) = true;

D    = GRIDobj(DEM);
D.Z  = bwdist(SEED.Z,'euclidean') * DEM.cellsize;


%% Conditions for 'presevered pixels'

a.Z(A.Z>max_drainage_area_for_preserved_surface | isnan(DEM.Z))=nan;
a.Z(D.Z<=portion_of_max_distance_for_outlet*max(max(D.Z)))=nan;


indexim=find(a.Z==1);                                                       % Indices of preserved pixels
[x,y]=ind2coord(DEM,indexim);                                               % Coordinates of the preserved pixels
z=DEM.Z(indexim);
indexim_all=find(DEM.Z>=1);                                                 % All pixels (including preserved pixels)
[xall,yall]=ind2coord(DEM,indexim_all);                                     % Coordinates of all pixels
zall=DEM.Z(indexim_all);


[x_outlet,y_outlet]=ind2coord(DEM,outlet_inx);                               % OUTLET indices
z_outlet=DEM.Z(outlet_inx);

% Save preserved pixels  x,y,z data for fitting the surface
point_data=[];
point_data(:,1)=x;
point_data(:,2)=y;
point_data(:,3)=z;


% Cretate polygon for the surface and get its boundaries
catchment_polygon = polyshape({MS(selected_catchment_ID).X},{MS(selected_catchment_ID).Y});
[xlim,ylim] = boundingbox(catchment_polygon);
zlim = ones(size(xlim))*max(z)-(maximum_uninterapted_depth+10);
point_data(end+1:end+2,:)=[xlim',ylim',zlim' ];                                                                            % Stupid elevation - making sure the point that bounds the watershed are not affect the surfaces fitting
point_data(end+1,:)=[x_outlet,y_outlet,z_outlet];                           % Make sure the outlet is in the point data set (altough its not affect the surface fitting)



%% Create filled surface
[surffit,Xsurf,Ysurf,Zsurf] = FitSurfaceToCatchment(point_data,maximum_uninterapted_depth); 
clear  divides

%% Plot the fitted surface
figure(1291); subplot(1,2,1);
imageschs(DEM,[],'colormap',[.9 .9 .9],'colorbar',false);
hold on;plot(S_large);hold on;imagesc(a);colormap(bone)
figure(1291); subplot(1,2,2);plot(surffit,[x,y],z);


%% Fill the DEM according to the fitted surface
[IncisionMap,filledDEM]=FillDEM(DEM,Xsurf,Ysurf,Zsurf);


%% Plot the result
figure;subplot(1,2,1);imagesc(DEM);colorbar();title('DEM (data)'),hold on;subplot(1,2,2);imagesc(filledDEM);colorbar();hold on
plot(MS(selected_catchment_ID).X,MS(selected_catchment_ID).Y,'k','LineWidth',2);title('Filled DEM')

