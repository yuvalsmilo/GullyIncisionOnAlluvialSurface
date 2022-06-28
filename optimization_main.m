clear
clc

% Load gully data
load('gully_data.mat')

%% Constant parameters for this run
simdata.D = 0;                      % Diffusion coeff [m^2/yr] 
simdata.tend = 70*10^3;             % Simulation duration [yr]
simdata.dt = 1000;                  % Model time step [yr], this may be modified internaly
simdata.U = data.dz /simdata.tend ; % Uplift rate [m/year]

%% Defiend lower and upper bounds:
l(1,1) = 1*10^-5;                   % K lower bnd, Erodibility coeff. [m^(1-2m) yr^-1]
l(2,1) = 0.1;                       % m lower bnd, Area exponent [-]
l(3,1) = 1;                         % n lower bnd, slope exponent [-]

u(1,1) = 1*10^-3;                   % K upper bnd, Erodibility coeff. [m^(1-2m) yr^-1]
u(2,1) = 0.6;                       % m lower bnd, Area exponent [-]
u(3,1) = 2.5;                       % n lower bnd, slope exponent [-]

%% Randomly sample starting points for optimization
Kvals = randsample(linspace(l(1,1),u(1,1),10000),100);
mvals = randsample(linspace(l(2,1),u(2,1),1000),100);
nvals = randsample(linspace(l(3,1),u(3,1),1000),100);

%% Create structure for saving the results
optimization_struc = struct();

%% Optimization 
for i = 1:1000
    i
    input_parameters(1,1) = Kvals(i);
    input_parameters(2,1) = mvals(i);
    input_parameters(3,1) = nvals(i);
    
    %% 
    [x fval history] = optimize_params(input_parameters,l,u,data,simdata);
    

    optimization_struc(i).RMSD = fval;
    optimization_struc(i).Opt_K = x(1);
    optimization_struc(i).Opt_m = x(2);
    optimization_struc(i).Opt_n = x(3);
    optimization_struc(i).history = history;

end
