function [fitresult, gof] = createFitLine(xl, yl)
%CREATEFIT(XL,YL)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : xl
%      Y Output: yl
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 16-Feb-2016 14:51:43


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( xl, yl );

% Set up fittype and options.
ft = fittype( 'poly1' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% % % Plot fit with data.
% % figure( 'Name', 'untitled fit 1' );
% % h = plot( fitresult, xData, yData );
% % legend( h, 'yl vs. xl', 'untitled fit 1', 'Location', 'NorthEast' );
% % % Label axes
% % xlabel xl
% % ylabel yl
% % grid on


