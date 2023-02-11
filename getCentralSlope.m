function s=getCentralSlope(z,dx);
%Computes topographic gradient (central diff)
%Inputs:
%x-vector of distances
%z-vector of elevaion values in each node [L], x-vector of distance from boundary for each node [L],


%Output:
%s-vector of slope values

%Author: Eitan Shelef 2020



%get slope central diff
sm=(z(3:end)-z(1:end-2))./(2*dx);
sl=(z(2)-z(1))./dx;
sr=(z(end)-z(end-1))./dx;
s=[sl, sm, sr];


