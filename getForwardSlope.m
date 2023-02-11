function s=getForwardSlope(z,dx,bc);
%Computes topographic gradient (central diff)
%Inputs:
%x-vector of distances
%z-vector of elevaion values in each node [L], x-vector of distance from boundary for each node [L],


%Output:
%s-vector of slope values

%Author: Eitan Shelef 2021

% %get slope forward diff
s= abs(diff(z)/dx);
s=[s(1), s];%arbitrarily set left slope same as one to the right, this is OK for yuval's needs



