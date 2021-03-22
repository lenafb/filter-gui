%%% note on line 15: if you look at errchkfxn, ErrChk1 = x_center-radius &&
%%% ErrChk2 = y_center-radius. Therefore, in order to plot the circle at
%%% the center of the crop, we use ErrChk2 + radius and ErrChk1 + radius as
%%% the x and y centers. Also, as mentioned in reconstrxnfxn, "x is y, y is
%%% x".
function plotfxn_wrap(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius)
    phsdisp = phs - phs_bkgd; %background subtraction
    
    subplot(2, 2, 1);
    imagesc(hologram); %interferogram
    axis equal
    axis off

    subplot(2, 2, 2);
    centers = [ErrChk2 + radius, ErrChk1 + radius];
    imagesc(fftdisp); %fft
    hold on
    viscircles(centers,radius,'Color','w');
    axis equal
    axis off

    subplot(2, 2, 3);
    imagesc(cropdisp); %filter + crop
    axis equal
    axis off

    subplot(2, 2, 4);
    colormap(gray) 
    imagesc(phsdisp(100:end-100,100:end-100)); 
    %crop eliminates an image artifact that changes the scale of imagesc
    axis equal
    axis off