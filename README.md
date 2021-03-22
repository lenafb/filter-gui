# filter-gui
filter_gui allows users to tune parameters (radius, phase ramp and filter % rotation) in order to view various reconstructions utilizing Fourier transforms. filter_gui relies upon callbacks: each button press/slider movement has a callback that calculates the reconstruction using the set parameters in the callback (ie. slider3.handles contains the filter rotation value.) This GUI was made with MATLAB GUIDE.
%
MATLAB comments regarding GUIDE: 
%
% FILTER_GUI MATLAB code for filter_gui.fig
%      FILTER_GUI, by itself, creates a new FILTER_GUI or raises the existing
%      singleton*.
%
%      H = FILTER_GUI returns the handle to a new FILTER_GUI or the handle to
%      the existing singleton*.
%
%      FILTER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTER_GUI.M with the given input arguments.
%
%      FILTER_GUI('Property','Value',...) creates a new FILTER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before filter_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to filter_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help filter_gui

% Last Modified by GUIDE v2.5 09-Aug-2018 16:23:18
