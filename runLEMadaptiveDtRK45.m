function z=runLEMadaptiveDtRK45(z, x, A, U, K, m, n, D, dt0, tend, bc, t_plot)

%Simulate landscape evolution to steady state using linear diffusion
%and stream power equations (e.g., Tucker and Hancock, 2010). 
%Inputs:
%x-distance vector
%z-vector of initial elevation  [L], x-vector of distance from boundary [L],
%a - drainage area vector
%K - bedrock erodibility [L^1-2m)t^-1], 
%m- exponents, note n assumed 1 for linearity,
%n- slope mexponent
%D - diffusion coefficient [L^2/t],
%dt0 - suggested time step [t]
%bc - vector with 2 values of boundary cnditions (left,right) - 0 fixed elevation, 1 is varying
%elevation

%Outputs:
%zend-vector of output elevations

%Author: Eitan Shelef 2020

dx=x(2)-x(1);

t_interval=0;
t=0;

while t<=tend 
    
    dt=dt0;
    
    %%-----set time step   
    dtD=dx^2/D;
    
   %s=getCentralSlope(z,dx);
    s=getForwardSlope(z,dx,bc);
    
    vkp=K.*A.^m.*s.^(n-1);    
    dtF=dx/max(vkp);%this is for n=1
       
    dtmin=min([dtF, dtD]);
    
    denom=4;
    if dt>dtmin/denom
        dt=dtmin/denom;
    end
    
    
    
    %----solve for z(t) using RK45
    dzdt=getdzdt(z,A,U,K,m,n,D,dx,bc);
    
    %step 1:
    ztemp=z + dzdt*(dt/3);
    k2=getdzdt(ztemp,A,U,K,m,n,D,dx,bc);
    
    %step 2:
    ztemp=z + (dzdt+k2)*dt/6;
    k3=getdzdt(ztemp,A,U,K,m,n,D,dx,bc);
    
    
    %step 3:
    ztemp=z + (dzdt+k3*3.0)*dt/8;
    k4=getdzdt(ztemp,A,U,K,m,n,D,dx,bc);
    
    %step 4:
    ztemp=z + ( dzdt-k3*3.0+k4*4.0)*dt/2;
    k5=getdzdt(ztemp,A,U,K,m,n,D,dx,bc);
    
    %compute z new
    z_new=z + (dzdt+k4*4.0+k5)*dt/6;
    
    t = t+dt;
    z = z_new;
    
    
    %---plot output
    t_interval=t_interval+dt;
    if t_interval>t_plot
        figure(1)       
        plot(x,z);shg;
        xlabel('distance');
        ylabel('elevation');
        title(['t=', num2str(t)])
        hold on
        t_interval=0;
    end
    
       
end

% disp('done');
end
    
    



