
function [simulation_struc] = solvefortime(input_parameters,dts,data)
    
    
    m = input_parameters.m;
    n = input_parameters.n; %slope exponent - note - not used and assumed 1 in model
    K = input_parameters.K; % R erodibility coeff [m^(1-2m) yr^-1]
    dt = input_parameters.dt ;%yr, this may be modified internaly
    plot_interval=10^10;%yr
    D = input_parameters.D;
    
    x = data.x';        % Distance along the gully profile [m]
    z = data.z_init';   % Initial reconstructed topography of the alluvial surface [m]
    A = data.A';        % Drainage area along the gully profile [m^2]
    measured_z = data.z_end';
    dz = data.dz;
    
    counter = 1;
    simulation_struc = struct();
    for dt_temp = dts
        tend = dt_temp;
        profile_out = [];
        profile_out(:,1) = x';

        U = dz/tend;

        %set model parameters
            
          
        bc = [0 1];         % Boundary conditions. A vector with 2 values of boundary cnditions (left,right):
        zend=runLEMadaptiveDtRK45(z, x, A, U, K, m, n, D, dt, tend, bc, plot_interval);
        zend = zend-dz;
        profile_out(:,2) = zend';

        rmsd = rms(zend-measured_z );
        
        simulation_struc(counter).ProfileData =  profile_out;
        simulation_struc(counter).K =  K;
        simulation_struc(counter).m =  m;
        simulation_struc(counter).n =  n;
        simulation_struc(counter).total_time =  tend;
        simulation_struc(counter).rmsd =  rmsd;

        counter = counter+1;
    end
end




            
            

