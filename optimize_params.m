
function [x fval history] = optimize_parmas(input_parameters,l,u,data,simdata)
    history = [];
    options = optimset('OutputFcn', @myoutput,'MaxFunEvals',2000);
    [x fval] = fminsearchbnd(@run_gully,input_parameters,l,u,options,data,simdata);
    function stop = myoutput(x,optimvalues,state)
        stop = false;
        if isequal(state,'iter')
          history = [history; x' optimvalues.fval];
        end
    end
end
