%%% Author: Lena Blackmon, 2018
%%% reconstrxnfxn calculates the Fourier Transform (fftdisp) of a hologram
%%% (hologram)then filters and crops one of the complex components of the Fourier
%%% Transform according to a radius (radius), the distance between the
%%% complex and real valued peaks of the Fourier Transform (arbdist), and
%%% the angle at which this distance is found (mask_theta).
function [hologram,fftdisp,cropdisp,phs] = reconstrxnfxn(hologram,radius,arbdist,mask_theta)
%% image,axes,FFT
m = hologram; % placeholder
hologram = hologram(2:end,2:end);
x = -size(hologram,2)/2:size(hologram,2)/2; % x is y, y is x
y = -size(hologram,1)/2:size(hologram,1)/2;
[xx,yy] = meshgrid(x,y);
hologram = m;
Y = fft2_DC(hologram);
fftdisp = log(1+(abs(Y)));
%% crop
[~,Q] = max(Y(:)); % finds center of real-valued DC term (not conjugates)
[P,B] = ind2sub(size(Y),Q); % now the center has coordinates
mask = zeros(size(Y));
x_shift = round(arbdist.*sin(mask_theta)); % x is y, y is x
y_shift = round(arbdist.*cos(mask_theta));
mask((xx + y_shift).^2+(yy + x_shift).^2 <= (radius).^2) = 1; %circular
crop = mask.*(Y);
x_center = P - x_shift; % center of circular crop
y_center = B - y_shift;
quad2 = crop(round(x_center-radius):round(x_center+radius),round(y_center-radius):round(y_center+radius));
cropdisp = log(1+abs(quad2)); 
%% reconstruction
less_pix = padarray(quad2,2*size(quad2)); %gives the image the appearance of being less pixelated
X = less_pix;
reconstruction = ifft2_DC(X); 
phs = angle(reconstruction); 
