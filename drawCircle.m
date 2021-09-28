function varargout = drawCircle(varargin)
% DRAWCIRCLE MATLAB code for drawCircle.fig
%      DRAWCIRCLE, by itself, creates a new DRAWCIRCLE or raises the existing
%      singleton*.
%
%      H = DRAWCIRCLE returns the handle to a new DRAWCIRCLE or the handle to
%      the existing singleton*.
%
%      DRAWCIRCLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRAWCIRCLE.M with the given input arguments.
%
%      DRAWCIRCLE('Property','Value',...) creates a new DRAWCIRCLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before drawCircle_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to drawCircle_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help drawCircle

% Last Modified by GUIDE v2.5 25-Feb-2020 09:11:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @drawCircle_OpeningFcn, ...
    'gui_OutputFcn',  @drawCircle_OutputFcn, ...
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


% --- Executes just before drawCircle is made visible.
function drawCircle_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to drawCircle (see VARARGIN)

% Choose default command line output for drawCircle
handles.output = hObject;

%Draw circles on axis;
% global radius_outer %KL made this a global variable
% radius_outer = 4.75; %KL added this parameter
% global radius_inner %KL made this a global variable
% radius_inner = 4.25; %KL added this parameter
radius_outer = 4.75;
radius_inner = 4.25;
[x_outer, y_outer] = plotCircle(radius_outer); %KL changed from 4.75 to radius_outer
[x_inner, y_inner] = plotCircle(radius_inner); %KL changed from 4.25 to radius_inner
hold on; axis off;

s1 = scatter(handles.axes1, 0, 0, 67000, 'w', 'filled'); %This produces a single giant white scatter point 
%KL can the size be defined in terms of the radius parameters? %(pi*945.6*(radius_outer)^2) works for the annulus size I want, but not for others. 
%Decided to leave it to be tuned manually. For tuning, temporarily change to another colour like yellow, 
%so you can check that it accurately fills the annulus boundaries plotted in white below.
%s1.MarkerEdgeColor = [0, 0, 0]; %KL this was commented out to remove the black line around the white scatter point (outer annulus edge).
s2 = scatter(handles.axes1, 0, 0, 53998, [0.85 0.85 0.85], 'filled'); %This produces a single giant grey scatter point (smaller than the white one).
%s2.MarkerEdgeColor = [0, 0, 0]; %KL commented this out to remove black line around the grey scatter point (inner annulus edge).

%plot inner and outer annulus boudaries
plot(handles.axes1, x_outer, y_outer, 'w'); %KL changed form 'k' to 'w' to change outer annulus line from black to white. Moved this plot to after the scatters rather than before, so that it will always be overlaid.
plot(handles.axes1, x_inner, y_inner, 'w'); %KL changed form 'k' to 'w' to change inner annulus line from black to white. Moved this plot to after the scatters rather than before, so that it will always be overlaid.
%define region of the x- and y-axes to be viewed
set(handles.axes1, 'XLim', [-(radius_outer+0.75) (radius_outer+0.75)]); %KL changed from 5.5 to (radius_outer+0.75)
set(handles.axes1, 'Ylim', [-(radius_outer+0.75) (radius_outer+0.75)]); %KL changed from 5.5 to (radius_outer+0.75)

%Set button press detector to zero
handles.buttonPress = 0;

%Save radii to handles
handles.radius_outer = radius_outer;
handles.radius_inner = radius_inner;

%Initialize important vectors
handles.timeStamp = [];
handles.coordPoints = [];
handles.error_TF = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes drawCircle wait for user response (see UIRESUME)
%uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = drawCircle_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

%svarargout{1} = temp;



% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


C = get(gca, 'CurrentPoint');
coordPoint = C(1,1:2);

if handles.buttonPress > 0
    
    %Extract stuff from handles
    t0= handles.t0;
    coordPoints = handles.coordPoints;
    error_TF = handles.error_TF;
    timeStamp = handles.timeStamp;
    tnow = clock;
    elapsedTime = etime(tnow, t0);
    radius_outer = handles.radius_outer;
    radius_inner = handles.radius_inner;
    
    if elapsedTime < 45
        %scatter(handles.axes1, coordPoint(1), coordPoint(2), 36,'bo', 'filled');
        timeStamp = vertcat(timeStamp, elapsedTime); %Store timestamp of each point into nx1 vector
        coordPoints = vertcat(coordPoints, coordPoint); %Store xy position of each coordinate in matrix
        
        len = size(coordPoints,1);
        
        if len > 1
            xpts = coordPoints(end-1:end,1);
            ypts = coordPoints(end-1:end, 2);
            plot(handles.axes1, xpts, ypts, 'b')
        end
        
        
        %Determine whether point is inside or outside of ring
%         global radius_outer %KL I added this in as this variable is needed for errorDetection
%         global radius_inner %KL I added this in as this variable is needed for errorDetection
%         TF = errorDetection(coordPoint);
        TF = errorDetection(coordPoint, radius_outer, radius_inner);
        error_TF = vertcat(error_TF, TF);
        
        handles.timeStamp = timeStamp;
        handles.coordPoints = coordPoints;
        handles.error_TF = error_TF;
        
    elseif elapsedTime >= 45 & elapsedTime <= 45.3 %KL added this to use a sound downloaded from https://soundbible.com/1251-Beep.html
        set(handles.text_instruction, 'string', 'Stop');
        [y,Fs] = audioread('Beep-SoundBible.com-923660219.wav'); sound(y,Fs);
    
    elseif elapsedTime > 45.3 %KL changed this from >=45 to >45.3 
        set(handles.text_instruction, 'string', 'Stop');
    end
    
end



% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton_start.
function pushbutton_start_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text_instruction, 'string', 'Get ready...'); %KL changed 'Pause' to 'Get ready'
pause(2); 
[y,Fs] = audioread('Beep-SoundBible.com-923660219.wav'); sound(y,Fs); %KL changed this from 'beep' to use a sound downloaded from https://soundbible.com/1251-Beep.html
set(handles.pushbutton_start, 'visible', 'off');
t0= clock;
handles.buttonPress = handles.buttonPress + 1;
handles.t0 = t0;
set(handles.text_instruction, 'string', 'Start drawing');
    
% Update handles structure
guidata(hObject, handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
     
selection = questdlg('Have you exported data if necessary before closing?', ...
'Warning', ...
'Yes','No','Yes');
switch selection
     case 'Yes'
       delete(gcf)
    case 'No'
       return
end

% The GUI is no longer waiting, just close it
delete(hObject);


% --- Executes on button press in pushbutton_export.
function pushbutton_export_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selpath = uigetdir;
id = get(handles.edit_ID, 'String');
trialNum = get(handles.edit_trial, 'String');
if isempty(id)
    id = 'unknownID';
end

if isempty(trialNum)
    trialNum = 'unknown';
end

filename = fullfile(selpath, [id, '_trial', trialNum, '.xlsx']);

%extract values from handles
coordPoints = handles.coordPoints;
timeStamp = handles.timeStamp;
error_TF = handles.error_TF;

%Calculate performance metrics
[errorNum, errorDuration, cumulative_errorDuration] = errorCount(timeStamp, error_TF);
[rotationNumber, cycleLengths, partialLength] = timePerCycle(coordPoints, timeStamp);

m = max([length(errorDuration), length(cycleLengths)]);

%Format into cell for excel
header_template = cell(1, m);
header1= header_template; header1{1} = 'Error Number';
header2 = header_template; header2{1} = 'Error Duration';
header3 = header_template; header3{1} = 'Cumulative Error Duration';
header4 = header_template; header4{1} = 'Number of Rotations';
header5 = header_template; header5{1} = 'Time per full cycle (s)';
header6 = header_template; header6{1} = 'Time for partial cycle (s)';


data1 = header_template;
data2 = header_template;
data3 = header_template;
data4 = header_template;
data5 = header_template;
data6 = header_template;

data1(1) = num2cell(errorNum);
data2(1:length(errorDuration)) = num2cell(errorDuration);
data3(1) = num2cell(cumulative_errorDuration);
data4(1) = num2cell(rotationNumber);
data5(1:length(cycleLengths)) = num2cell(cycleLengths);
data6(1) = num2cell(partialLength);
output1 = vertcat(header1, data1, header2, data2, header3, data3, header4, data4, header5, data5, header6, data6);

%Concatenate into matrix
header = {'x coord', 'y coord', 'Elapsed Time', 'In ring?'};
datamatrix = num2cell(horzcat(coordPoints, timeStamp, error_TF));
outputfile = vertcat(header, datamatrix);

xlswrite(filename, output1);
xlswrite(filename, outputfile, 'raw');

%handles.saveButton = 1;

% Update handles structure
guidata(hObject, handles);



function edit_ID_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ID as text
%        str2double(get(hObject,'String')) returns contents of edit_ID as a double


% --- Executes during object creation, after setting all properties.
function edit_ID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_trial_Callback(hObject, eventdata, handles)
% hObject    handle to edit_trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_trial as text
%        str2double(get(hObject,'String')) returns contents of edit_trial as a double


% --- Executes during object creation, after setting all properties.
function edit_trial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_trial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
