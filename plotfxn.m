%%% This function plots all 4 areas of filter_gui upon opening. The initial
%%% reconstruction is phase wrapped. There are no circles  in this plot
%%% because the user hasn't tuned the filter yet. Also the initial
%%% reconstruction is tuned to parameters that do not generate an error, 
%%% meaning errchkfxn does not run in this callback.
function plotfxn (phs,phs_bkgd,hologram,fftdisp,cropdisp) 
    phsdisp = phs - phs_bkgd;  %background subtraction  

    subplot(2, 2, 1);
    imagesc(hologram); %interferogram
    axis equal
    axis off

    subplot(2, 2, 2);
    imagesc(fftdisp); %fft
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