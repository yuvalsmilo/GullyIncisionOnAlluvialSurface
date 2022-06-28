function [rmsd] = run_gully(input_parameters,data,simdata)
    

    K = input_parameters(1);        % Erodibility coeff. [m^(1-2m) yr^-1]
    m = input_parameters(2);        % Area exponent [-]
    n = input_parameters(3);        % Slope exponent [-]
    D = simdata.D;                  % Diffusion coeff [m^2/yr] 
    tend = simdata.tend;            % Simulation duration [yr]
    U = simdata.U;                  % Uplift rate [m/year]
    dt = simdata.dt;                % Model time step [yr], this may be modified internaly
    bc = [0 1];                     % Boundary conditions. A vector with 2 values of boundary cnditions (left,right):
                                    % 0 fixed elevation, 1 is varying
    plot_interval=inf ;             % inf = no ploting
    

    x = data.x';                    % Distance along the gully profile [m] 
    z = data.z_init';               % Initial reconstructed topography of the alluvial surface [m]
    A = data.A';                    % Drainage area along the gully profile [m^2]
    z_to_match = data.z_end';       % Present gully topography to match

    %% Run the model 
    zend=runLEMadaptiveDtRK45(z, x, A, U, K, m, n, D, dt, tend, bc, plot_interval);
    zend = zend-data.dz;
    
    %% Calculate RMSD criteria
    diff_vec = zend- z_to_match ;
    rmsd = rms(diff_vec);
end
