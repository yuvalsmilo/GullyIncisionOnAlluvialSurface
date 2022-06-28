%% Run gully incision from initial  topography 
clear
clc

%% Load gully data
load('gully_data.mat')
x = data.x';        % Distance along the gully profile [m]
z = data.z_init';   % Initial reconstructed topography of the alluvial surface [m]
A = data.A';        % Drainage area along the gully profile [m^2]
measured_z = data.z_end;
%% Defiend parameters for the simulation
m = 0.5;            % Area exponent [-]
n = 1.5;            % Slope exponent [-]
K = 5*10^-5;        % Erodibility coeff. [m^(1-2m) yr^-1]
D =0.0;             % Diffusion coeff [m^2/yr] 
dt = 1000;          % Model time step [yr], this may be modified internaly
plot_interval=inf;  % inf = no ploting.
tend = 70*10^3;     % Simulation duration [yr]
U  = data.dz/tend;  % Uplift rate [m/year]
bc = [0 1];         % Boundary conditions. A vector with 2 values of boundary cnditions (left,right):
                    % 0 fixed elevation, 1 is varying

%% Run the model
zend=runLEMadaptiveDtRK45(z, x, A, U, K, m, n, D, dt, tend, bc, plot_interval);
zend = zend-data.dz;

%% Ploting the results
figure;
p1 = plot(x,z,'k');hold on;
p2 = plot(x,zend,'b');
p3 = plot(x,measured_z,'r');
xlabel('Distance [m]')
ylabel('Elevation [m]')
legend([p1,p2,p3],{'Init topo','Simulated','Measured'})


