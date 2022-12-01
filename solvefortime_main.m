

%% Load gully data
load('gully_data.mat')

%% Defiend parameters for the simulation
input_parameters.m = 0.5;            % Area exponent [-]
input_parameters.n = 1.5;            % Slope exponent [-]
input_parameters.K = 5*10^-5;        % Erodibility coeff. [m^(1-2m) yr^-1]
input_parameters.D =10^-10;             % Diffusion coeff [m^2/yr] 
input_parameters.dt = 1000;          % Model time step [yr], this may be modified internaly
dts = [10000:5000:100000];           % Model elapsed times to run [year]
[simulation_struc] = solvefortime(input_parameters,dts,data);