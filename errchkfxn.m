%%% Author: Lena Blackmon (2018)
%%% This function checks to see that the indexes of the crop performed in
%%% reconstrxnfxn are positive. Otherwise, reconstrxnfxn produces a MATLAB
%%% error
function [ErrChk1,ErrChk2] = errchkfxn(radius,phsrmp,mask_theta_calc)
x_shift = round(phsrmp.*sin(mask_theta_calc)); % x is y, y is x
y_shift = round(phsrmp.*cos(mask_theta_calc));
x_center = 513 - x_shift; % 513 is the value of 'P' in reconstrxnfxn
y_center = 641 - y_shift; % 641 is the value of 'B' in reconstrxnfxn
ErrChk1 = x_center-radius;
ErrChk2 = y_center-radius;