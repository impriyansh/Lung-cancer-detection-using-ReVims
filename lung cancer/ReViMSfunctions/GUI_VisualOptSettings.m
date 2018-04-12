function varargout = GUI_VisualOptSettings(varargin)
% GUI_VISUALOPTSETTINGS MATLAB code for GUI_VisualOptSettings.fig
%      GUI_VISUALOPTSETTINGS, by itself, creates a new GUI_VISUALOPTSETTINGS or raises the existing
%      singleton*.
%
%      H = GUI_VISUALOPTSETTINGS returns the handle to a new GUI_VISUALOPTSETTINGS or the handle to
%      the existing singleton*.
%
%      GUI_VISUALOPTSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_VISUALOPTSETTINGS.M with the given input arguments.
%
%      GUI_VISUALOPTSETTINGS('Property','Value',...) creates a new GUI_VISUALOPTSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_VisualOptSettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_VisualOptSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_VisualOptSettings

% Last Modified by GUIDE v2.5 28-Nov-2016 14:08:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_VisualOptSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_VisualOptSettings_OutputFcn, ...
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


% --- Executes just before GUI_VisualOptSettings is made visible.
function GUI_VisualOptSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_VisualOptSettings (see VARARGIN)


global revims_handles
revims_handles.flagGUIclosedWithX = 1;

% Choose default command line output for GUI_AutoSegmSettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_AutoSegmSettings wait for user response (see UIRESUME)
% uiwait(handles.fig_AutoSegmSettings);

% set parameters to be showed
try
    
    flag_error = 0;
    
    % Check parameters
    if revims_handles.visOriMinInt<0 || revims_handles.visOriMinInt>=revims_handles.visOriMaxInt
        flag_error = 1;
    end
    if revims_handles.visOriMaxInt>255 || revims_handles.visOriMinInt>=revims_handles.visOriMaxInt
        flag_error = 1;
    end
    if revims_handles.visCurMinInt<revims_handles.visOriMinInt || revims_handles.visCurMaxInt>revims_handles.visOriMaxInt
        flag_error = 1;
    end
    if revims_handles.visCurMinInt<0 || revims_handles.visCurMinInt>=revims_handles.visCurMaxInt
        flag_error = 1;
    end
    if revims_handles.visCurMaxInt>255 || revims_handles.visCurMinInt>=revims_handles.visCurMaxInt
        flag_error = 1;
    end
    if revims_handles.visPercent<0 || revims_handles.visPercent>100
        flag_error = 1;
    end
    
    if flag_error == 1
        error('Wrong parameter set.')
        return
    end
    
    % Set parameters
    set(handles.edit_B_Percent, 'String', num2str(revims_handles.visPercent));
    set(handles.edit_B_OriMinInt, 'String', num2str(revims_handles.visOriMinInt));
    set(handles.edit_B_OriMaxInt, 'String', num2str(revims_handles.visOriMaxInt));
    set(handles.edit_B_CurMinInt, 'String', num2str(revims_handles.visCurMinInt));
    set(handles.edit_B_CurMaxInt, 'String', num2str(revims_handles.visCurMaxInt));

catch ME1
    Message = {'Wrong parameter set.', ...
        ' '};
    msgbox(Message,'Message')
end


% --- Outputs from this function are returned to the command line.
function varargout = GUI_VisualOptSettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_B_OriMinInt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_B_OriMinInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_B_OriMinInt as text
%        str2double(get(hObject,'String')) returns contents of edit_B_OriMinInt as a double


% --- Executes during object creation, after setting all properties.
function edit_B_OriMinInt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_B_OriMinInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_B_OriMaxInt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_B_OriMaxInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_B_OriMaxInt as text
%        str2double(get(hObject,'String')) returns contents of edit_B_OriMaxInt as a double


% --- Executes during object creation, after setting all properties.
function edit_B_OriMaxInt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_B_OriMaxInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_B_CurMinInt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_B_CurMinInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_B_CurMinInt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_B_CurMinInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_B_CurMinInt as text
%        str2double(get(hObject,'String')) returns contents of edit_B_CurMinInt as a double
global revims_handles

value1 = str2double(get(hObject,'String'));
if ~isempty(value1) && ~isnan(value1) && value1>=0 && value1<revims_handles.visCurMaxInt && isnumeric(value1) && value1>=revims_handles.visOriMinInt
    value1 = round(value1);
    set(handles.edit_B_CurMinInt, 'String', num2str(value1));
    revims_handles.visCurMinInt = value1;
    set(handles.edit_B_Percent, 'String', '0');
    revims_handles.visPercent = 0;
else
    set(handles.edit_B_CurMinInt, 'String', num2str(revims_handles.visOriMinInt));
    revims_handles.visCurMinInt = revims_handles.visOriMinInt; 
    errorString = ['Min value must must be an integer between original min value and max value.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = msgbox(sprintf(errorString));
end


% --- Executes during object creation, after setting all properties.
function edit_B_CurMaxInt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_B_CurMaxInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_B_CurMaxInt_Callback(hObject, eventdata, handles)
% hObject    handle to edit_B_CurMaxInt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_B_CurMaxInt as text
%        str2double(get(hObject,'String')) returns contents of edit_B_CurMaxInt as a double
global revims_handles

value1 = str2double(get(hObject,'String'));
if ~isempty(value1) && ~isnan(value1) && value1<=255 && value1>revims_handles.visCurMinInt && isnumeric(value1) && value1<=revims_handles.visOriMaxInt
    value1 = round(value1);
    set(handles.edit_B_CurMaxInt, 'String', num2str(value1));
    revims_handles.visCurMaxInt = value1;
    set(handles.edit_B_Percent, 'String', '0');
    revims_handles.visPercent = 0;
else
    set(handles.edit_B_CurMaxInt, 'String', num2str(revims_handles.visOriMaxInt));
    revims_handles.visCurMaxInt = revims_handles.visOriMaxInt; 
    errorString = ['Max value must must be an integer between min value and original max value.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = msgbox(sprintf(errorString));
end


% --- Executes during object creation, after setting all properties.
function edit_B_Percent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_B_Percent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_B_Percent_Callback(hObject, eventdata, handles)
% hObject    handle to edit_B_Percent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_B_Percent as text
%        str2double(get(hObject,'String')) returns contents of edit_B_Percent as a double
global revims_handles

value1 = str2double(get(hObject,'String'));
if ~isempty(value1) && ~isnan(value1) && value1>=0 && value1<100 && isnumeric(value1)
    % Update windows
    value1 = round(value1);
    set(handles.edit_B_Percent, 'String', num2str(value1));
    revims_handles.visPercent = value1;
    value2 = revims_handles.visOriMaxInt;
    value1 = double(value1);
    value2 = double(value2);
    
    %Update min and max
    threshold = round(value2*value1/100);
    NewCurMinInt = revims_handles.visOriMinInt + threshold;
    NewCurMaxInt = revims_handles.visOriMaxInt - threshold;
    if NewCurMinInt<NewCurMaxInt
        set(handles.edit_B_CurMinInt, 'String', num2str(NewCurMinInt));
        set(handles.edit_B_CurMaxInt, 'String', num2str(NewCurMaxInt));
        revims_handles.visCurMinInt = NewCurMinInt;
        revims_handles.visCurMaxInt = NewCurMaxInt;
    else
        set(handles.edit_B_Percent, 'String', '0');
        revims_handles.visPercent = 0; 
        errorString = ['The percentage value must be lower than 49%%.'];
        if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
        revims_handles.h_GUIhelpA = msgbox(sprintf(errorString));
    end
else
    set(handles.edit_B_Percent, 'String', '0');
    revims_handles.visPercent = 0; 
    errorString = ['The percentage value must be lower than 49%%.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = msgbox(sprintf(errorString));
end


% --- Executes when user attempts to close fig_VisualOptSettings.
function fig_VisualOptSettings_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to fig_VisualOptSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global revims_handles
revims_handles.flagGUIclosedWithX = 1;
delete(hObject);


% --- Executes on button press in button_Save.
function button_Save_Callback(hObject, eventdata, handles)
% hObject    handle to button_Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
delete(handles.fig_VisualOptSettings);
