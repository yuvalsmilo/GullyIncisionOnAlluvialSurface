
function [simulation_struc] = solvefortime(input_parameters,dts,data)
    
    m = input_parameters.m;     % Area exponent [-]
    n = input_parameters.n;     % Slope exponent [-]
    K = input_parameters.K;     % Erodibility coeff. [m^(1-2m) yr^-1]
    dt = input_parameters.dt ;  % Model time step [yr], this may be modified internaly
    plot_interval=inf;          % inf = not ploting
    D = input_parameters.D;
    
    x = data.x';                % Distance along the gully profile [m]
    z = data.z_init';           % Initial reconstructed topography of the alluvial surface [m]
    A = data.A';                % Drainage area along the gully profile [m^2]
    measured_z = data.z_end';   % Measured topography to match
    dz = data.dz;
    bc = [0 1];                 % Boundary conditions. 
                                % A vector with 2 values of boundary cnditions (left,right):

    counter = 1;
    simulation_struc = struct();
    for dt_temp = dts
        tend = dt_temp;
        profile_out = [];
        profile_out(:,1) = x';

        % Change the uplift according to the current model run time
        U = dz/tend;

            
        % Run the model
        zend=runLEMadaptiveDtRK45(z, x, A, U, K, m, n, D, dt, tend, bc, plot_interval);
        zend = zend-dz;
        profile_out(:,2) = zend';

        % Compare to measured profile
        rmsd = rms(zend-measured_z );
        
        % Save iteration data
        simulation_struc(counter).ProfileData =  profile_out;
        simulation_struc(counter).K =  K;
        simulation_struc(counter).m =  m;
        simulation_struc(counter).n =  n;
        simulation_struc(counter).total_time =  tend;
        simulation_struc(counter).rmsd =  rmsd;
        counter = counter+1;
    end
end




            
            

