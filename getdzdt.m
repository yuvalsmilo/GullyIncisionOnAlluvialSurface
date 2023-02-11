function [dzdt, dzdth]=getdzdt(z, A, U, K, m, n, D, dx, bc)

%Computes the rate of elevation change using linear diffusion and stream power equations (e.g., Tucker and Hancock, 2010) to produce model results shown in Shelef and Goren 2021.

%Inputs:
%z-vector of elevaion values in each node [L], x-vector of distance from boundary for each node [L],
%a-vector drainage area for each node, U-uplift rate [L/t], K-erodibility
%coefficient [L^1-2m)t^-1], m,n - exponents, D - diffusion coefficient [L^2/t],
%bc - vector with 2 values of boundary cnditions (left,right) - 0 fixed elevation, 1 is varying
%elevation

%Output:
%dzdt-vector of rate of change in elevatio for each node [L/t]

%Author: Eitan Shelef 2020

%--detachment limited fluvial
%s=getCentralSlope(z,dx);
s=getForwardSlope(z,dx,bc);

dzdtf=K.*A.^m.*s.^n;

%%ES - if needed - set 0 erosion in 1st order depressions , help eliminate lows next to boundary issues as well
% f= find (z(2:end-1)<z(1:end-2) & z(2:end-1)<z(3:end));
% dzdtf(f+1)=0;


%---diffusion 
dzdth=D/dx^2 * (z(3:end)-2*z(2:end-1)+z(1:end-2));
%set at boundaries
j=1;
dzdth_l=D/dx^2*(z(j+1)-z(j))-0;%assuming 0 flux at bc
j=length(z)-1;
dzdth_r=0-D/dx^2*(z(j+1)-z(j));%assuming 0 flux at bc
dzdth=[dzdth_l,dzdth,dzdth_r];

%--total dzdt
dzdt=U-(dzdtf-dzdth);

%set bc
if bc(1)==0 
    dzdt(1)=0;
end

if bc(2)==0 
    dzdt(end)=0;
end

