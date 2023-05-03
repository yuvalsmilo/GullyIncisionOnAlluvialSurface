function [S_large,S,FD] = FindLargeStream(DEM,min_area)
    FD  = FLOWobj(DEM,'preprocess','carve');
    S = STREAMobj(FD,'minarea',min_area); % All streams
    ix = streampoi(S,'outlets','ix'); %get the outlet index
    [xout,yout] = ind2coord(DEM,ix);
    %Find the logest stream
    D_stream  = flowdistance(FD,ix); %calculate flow distances
    DB   = drainagebasins(FD,S);
    maxd = max(max(D_stream.Z)); %calculate the maximal distance
    LOCS = D_stream==maxd & DB>0 ; %find indxim of longest channel
    IX   = find(LOCS.Z);
    [x,y] = ind2coord(DEM,IX);

    A = flowacc(FD).*(DEM.cellsize^2);    
    I = influencemap(FD,IX);
    I.Z(A.Z<min_area)=0;
    S1 = STREAMobj(FD,I);
    S_large=klargestconncomps(S1);
    
end


