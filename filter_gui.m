function varargout = filter_gui(varargin)
% Author: Lena Blackmon, 2018
% filter_gui allows users to tune parameters (radius, phase ramp and filter
% rotation) in order to view various reconstructions utilizing Fourier
% transforms. filter_gui relies upon callbacks: each button press/slider 
% movement has a callback that calculates the reconstruction using the set 
% parameters in the callback (ie. slider3.handles contains the filter 
% rotation value.) This GUI was made with MATLAB GUIDE.
%
% MATLAB comments regarding GUIDE: 
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

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @filter_gui_OpeningFcn, ...
    'gui_OutputFcn',  @filter_gui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before filter_gui is made visible.
function filter_gui_OpeningFcn(hObject, ~, handles, varargin)
% sets up slider/edit box initial positions
set(handles.slider1, 'Value', str2double(get(handles.edit1, 'String')));
radius = get(handles.slider1, 'Value');
set(handles.slider3, 'Value', str2double(get(handles.edit2, 'String')));
phsrmp = get(handles.slider3, 'Value');
set(handles.slider4, 'Value', str2double(get(handles.edit3, 'String')));
mask_theta = get(handles.slider4, 'Value');
mask_theta_calc = deg2rad(mask_theta);

global hologram bkgd;
if isa(hologram,'uint8') == true && isa(bkgd,'uint8') == true
    [hologram,fftdisp,cropdisp,phs] = reconstrxnfxn(hologram,radius,phsrmp,mask_theta_calc);
    [~,~,~,phs_bkgd] = reconstrxnfxn(bkgd,radius,phsrmp,mask_theta_calc);
    plotfxn(phs,phs_bkgd,hologram,fftdisp,cropdisp);
else
    f = errordlg('Please load data and/or background files','404: File(s) Not Found!');
end


% Choose default command line output for filter_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = filter_gui_OutputFcn(hObject, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement.
function slider1_Callback(hObject, ~, handles)
global hologram bkgd;
radius = round(get(hObject,'Value'));
set(handles.slider1,'UserData',radius);
set(handles.edit1,'String',radius);
phsrmp = get(handles.slider3, 'Value');
mask_theta = get(handles.slider4, 'Value');
mask_theta_calc = deg2rad(mask_theta);

[ErrChk1,ErrChk2] = errchkfxn(radius,phsrmp,mask_theta_calc);

if ErrChk1 <=0 || ErrChk2 <= 0
    f = errordlg('Radius extends beyond image dimensions','Radius Too Large');
else
    
    [hologram,fftdisp,cropdisp,phs] = reconstrxnfxn(hologram,radius,phsrmp,mask_theta_calc);
    [~,~,~,phs_bkgd] = reconstrxnfxn(bkgd,radius,phsrmp,mask_theta_calc);
    nobkgd = zeros(size(phs_bkgd));
    button_state = get(handles.togglebutton1,'Value');
    unwrap_state = get(handles.togglebutton2,'Value');
    if button_state == get(handles.togglebutton1,'Max')
        if unwrap_state == get(handles.togglebutton1,'Max')
            plotfxn_circles(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        else
            plotfxn_wrap(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        end
    elseif button_state == get(hObject,'Min')
        if unwrap_state == get(handles.togglebutton1,'Max')
            plotfxn_circles(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        else
            plotfxn_wrap(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        end
    end
end
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, ~, ~)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider3_Callback(hObject, ~, handles)
global hologram bkgd;
phsrmp = round(get(hObject,'Value'));
set(handles.slider3,'UserData',phsrmp);
set(handles.edit2,'String',phsrmp);
radius = get(handles.slider1, 'Value');
mask_theta = get(handles.slider4, 'Value');
mask_theta_calc = deg2rad(mask_theta);

[ErrChk1,ErrChk2] = errchkfxn(radius,phsrmp,mask_theta_calc);

if ErrChk1 <=0 || ErrChk2 <= 0
    f = errordlg('Phase ramp extends the crop beyond image dimensions','Phase Ramp Too Large');
else
    
    [hologram,fftdisp,cropdisp,phs] = reconstrxnfxn(hologram,radius,phsrmp,mask_theta_calc);
    [~,~,~,phs_bkgd] = reconstrxnfxn(bkgd,radius,phsrmp,mask_theta_calc);
    nobkgd = zeros(size(phs_bkgd));
    button_state = get(handles.togglebutton1,'Value');
    unwrap_state = get(handles.togglebutton2,'Value');
    if button_state == get(handles.togglebutton1,'Max')
        if unwrap_state == get(handles.togglebutton1,'Max')
            plotfxn_circles(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        else
            plotfxn_wrap(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        end
    elseif button_state == get(hObject,'Min')
        if unwrap_state == get(handles.togglebutton1,'Max')
            plotfxn_circles(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        else
            plotfxn_wrap(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        end
    end
end

function slider3_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider4_Callback(hObject, ~, handles)
global hologram bkgd;
mask_theta = get(hObject, 'Value');
set(hObject,'UserData',mask_theta);
set(handles.edit3,'String',mask_theta);
mask_theta_calc = deg2rad(mask_theta);
radius = get(handles.slider1, 'Value');
phsrmp = get(handles.slider3, 'Value');

[ErrChk1,ErrChk2] = errchkfxn(radius,phsrmp,mask_theta_calc);

if ErrChk1 <=0 || ErrChk2 <= 0
    f = errordlg('Filter Rotation extends the crop beyond image dimensions','Filter Rotation Too Large');
else
    
    [hologram,fftdisp,cropdisp,phs] = reconstrxnfxn(hologram,radius,phsrmp,mask_theta_calc);
    [~,~,~,phs_bkgd] = reconstrxnfxn(bkgd,radius,phsrmp,mask_theta_calc);
    nobkgd = zeros(size(phs_bkgd));
    button_state = get(handles.togglebutton1,'Value');
    unwrap_state = get(handles.togglebutton2,'Value');
    if button_state == get(handles.togglebutton1,'Max')
        if unwrap_state == get(handles.togglebutton1,'Max')
            plotfxn_circles(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        else
            plotfxn_wrap(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        end
    elseif button_state == get(hObject,'Min')
        if unwrap_state == get(handles.togglebutton1,'Max')
            plotfxn_circles(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        else
            plotfxn_wrap(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        end
    end
end

function slider4_CreateFcn(hObject, ~, ~)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes when the user presses "Enter" after typing the desired value
function edit1_Callback(hObject, ~, handles)
global hologram bkgd;
set(handles.slider1, 'Value', str2double(get(hObject, 'String')));
radius = round(get(handles.slider1, 'Value'));
phsrmp = get(handles.slider3, 'Value');
mask_theta = get(handles.slider4, 'Value');
mask_theta_calc = deg2rad(mask_theta);

[ErrChk1,ErrChk2] = errchkfxn(radius,phsrmp,mask_theta_calc);

if ErrChk1 <=0 || ErrChk2 <= 0
    f = errordlg('Radius extends beyond image dimensions','Radius Too Large');
else
    
    [hologram,fftdisp,cropdisp,phs] = reconstrxnfxn(hologram,radius,phsrmp,mask_theta_calc);
    [~,~,~,phs_bkgd] = reconstrxnfxn(bkgd,radius,phsrmp,mask_theta_calc);
    nobkgd = zeros(size(phs_bkgd));
    button_state = get(handles.togglebutton1,'Value');
    unwrap_state = get(handles.togglebutton2,'Value');
    if button_state == get(handles.togglebutton1,'Max')
        if unwrap_state == get(handles.togglebutton1,'Max')
            plotfxn_circles(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        else
            plotfxn_wrap(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        end
    elseif button_state == get(hObject,'Min')
        if unwrap_state == get(handles.togglebutton1,'Max')
            plotfxn_circles(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        else
            plotfxn_wrap(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        end
    end
end
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, ~, handles)
global hologram bkgd;
set(handles.slider3, 'Value', str2double(get(hObject, 'String')));
radius = round(get(handles.slider1, 'Value'));
phsrmp = get(handles.slider3, 'Value');
mask_theta = get(handles.slider4, 'Value');
mask_theta_calc = deg2rad(mask_theta);

[ErrChk1,ErrChk2] = errchkfxn(radius,phsrmp,mask_theta_calc);

if ErrChk1 <=0 || ErrChk2 <= 0
    f = errordlg('Phase ramp value extends the crop beyond image dimensions','Phase Ramp Too Large');
else

    [hologram,fftdisp,cropdisp,phs] = reconstrxnfxn(hologram,radius,phsrmp,mask_theta_calc);
    [~,~,~,phs_bkgd] = reconstrxnfxn(bkgd,radius,phsrmp,mask_theta_calc);
    nobkgd = zeros(size(phs_bkgd));
    button_state = get(handles.togglebutton1,'Value');
    unwrap_state = get(handles.togglebutton2,'Value');
    if button_state == get(handles.togglebutton1,'Max')
        if unwrap_state == get(handles.togglebutton1,'Max')
            plotfxn_circles(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        else
            plotfxn_wrap(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        end
    elseif button_state == get(hObject,'Min')
        if unwrap_state == get(handles.togglebutton1,'Max')
            plotfxn_circles(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        else
            plotfxn_wrap(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        end
    end
end

function edit2_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, ~, handles)
global hologram bkgd;
set(handles.slider4, 'Value', str2double(get(hObject, 'String')));
radius = round(get(handles.slider1, 'Value'));
phsrmp = get(handles.slider3, 'Value');
mask_theta = get(handles.slider4, 'Value');
mask_theta_calc = deg2rad(mask_theta);

[ErrChk1,ErrChk2] = errchkfxn(radius,phsrmp,mask_theta_calc);

if ErrChk1 <=0 || ErrChk2 <= 0
    f = errordlg('Filter Rotation value extends the crop beyond image dimensions','Filter Rotation Too Large');
else
    
    [hologram,fftdisp,cropdisp,phs] = reconstrxnfxn(hologram,radius,phsrmp,mask_theta_calc);
    [~,~,~,phs_bkgd] = reconstrxnfxn(bkgd,radius,phsrmp,mask_theta_calc);
    nobkgd = zeros(size(phs_bkgd));
    button_state = get(handles.togglebutton1,'Value');
    unwrap_state = get(handles.togglebutton2,'Value');
    if button_state == get(handles.togglebutton1,'Max')
        if unwrap_state == get(handles.togglebutton1,'Max')
            plotfxn_circles(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        else
            plotfxn_wrap(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        end
    elseif button_state == get(hObject,'Min')
        if unwrap_state == get(handles.togglebutton1,'Max')
            plotfxn_circles(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        else
            plotfxn_wrap(phs,phs_bkgd,hologram,fftdisp,cropdisp,ErrChk1,ErrChk2,radius);
        end
    end
end

function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bkgd
if isa(bkgd,'uint8') ~= true
    f = errordlg('Upload Background','Upload Background Image');
else
end


% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hologram;
[filename,filepath1]=uigetfile({'*.*','All Files'},...
    'Select Data File 1');
hologram=imread([filepath1,filename]);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global bkgd;
[filename,filepath1]=uigetfile({'*.*','All Files'},...
    'Select Data File 1');
bkgd=imread([filepath1,filename]);


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2
