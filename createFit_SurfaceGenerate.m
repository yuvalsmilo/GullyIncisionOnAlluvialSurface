function [surffit, gof] = createFit_SurfaceGenerate(xvec, yvec, zvec,z_to_exclude)

%CREATEFIT(XSURF,YSURF,ZSURF)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : Xsurf
%      Y Input : Ysurf
%      Z Output: Zsurf
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 24-Sep-2019 12:35:42


% % %% Fit: 'untitled fit 1'.
% [xData, yData, zData] = prepareSurfaceData( xvec, yvec, zvec );
% % 
% % Set up fittype and options.
% ft = fittype( 'poly55' );
% opts = fitoptions( 'Method', 'LinearLeastSquares' );
% opts.Normalize = 'on';
% opts.Robust = 'LAR';
% 
% % Fit model to data.
% [surffit, gof] = fit( [xData, yData], zData, ft, opts );
% 
% % Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( surffit, [xData, yData], zData );
% legend( h, 'untitled fit 1', 'Zsurf vs. Xsurf, Ysurf', 'Location', 'NorthEast' );
% % Label axes
% xlabel Xsurf
% ylabel Ysurf
% zlabel Zsurf
% grid on




%% Fit: 'untitled fit 1'.
[xData, yData, zData] = prepareSurfaceData( xvec, yvec, zvec );

% Set up fittype and options.

ft='poly11';
% Fit model to data.
[surffit, gof] = fit( [xData, yData], zData, ft, 'Normalize', 'on','Exclude',zData<z_to_exclude);

index_to_plot=find(zData>z_to_exclude);
% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( surffit, [xData(index_to_plot), yData(index_to_plot)], zData(index_to_plot) );
legend( h, 'Fill surface', 'zvec vs. xvec, yvec', 'Location', 'NorthEast' );
% Label axes
xlabel xvec
ylabel yvec
zlabel zvec


