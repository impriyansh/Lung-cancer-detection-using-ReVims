function varargout = GUI_AutoSegmSettings(varargin)
% GUI_AUTOSEGMSETTINGS MATLAB code for GUI_AutoSegmSettings.fig
%      GUI_AUTOSEGMSETTINGS, by itself, creates a new GUI_AUTOSEGMSETTINGS or raises the existing
%      singleton*.
%
%      H = GUI_AUTOSEGMSETTINGS returns the handle to a new GUI_AUTOSEGMSETTINGS or the handle to
%      the existing singleton*.
%
%      GUI_AUTOSEGMSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_AUTOSEGMSETTINGS.M with the given input arguments.
%
%      GUI_AUTOSEGMSETTINGS('Property','Value',...) creates a new GUI_AUTOSEGMSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_AutoSegmSettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_AutoSegmSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_AutoSegmSettings

% Last Modified by GUIDE v2.5 28-Nov-2016 14:06:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_AutoSegmSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_AutoSegmSettings_OutputFcn, ...
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


% --- Executes just before GUI_AutoSegmSettings is made visible.
function GUI_AutoSegmSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_AutoSegmSettings (see VARARGIN)

global revims_handles
revims_handles.flagGUIclosedWithX = 0;

% Choose default command line output for GUI_VisualOptSettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_VisualOptSettings wait for user response (see UIRESUME)
% uiwait(handles.fig_VisualOptSettings);

% set parameters to be showed
try
    
    flag_error = 0;
    
    % Check parameters
    if isempty(revims_handles.maskDilation) || isnan(revims_handles.maskDilation) || revims_handles.maskDilation<0 || ~isnumeric(revims_handles.maskDilation)
        flag_error = 1;
    end
    if isempty(revims_handles.maskErosion) || isnan(revims_handles.maskErosion) || revims_handles.maskErosion<0 || ~isnumeric(revims_handles.maskErosion)
        flag_error = 1;
    end
    
    if flag_error == 1
        error('Wrong parameter set.')
        return
    end
    
    % Set parameters
    set(handles.edit_C_maskDilation, 'String', num2str(revims_handles.maskDilation));
    set(handles.edit_C_maskErosion, 'String', num2str(revims_handles.maskErosion));
    Value1 = double(revims_handles.autoSegmMode);
    set(handles.popup_C_SegmMod,'Value',Value1);
    Value2 = double(revims_handles.firstOperDilEro);
    set(handles.popup_C_DilEro,'Value',Value2);

catch ME1
    Message = {'Wrong parameter set.', ...
        ' '};
    msgbox(Message,'Message')
end


% --- Outputs from this function are returned to the command line.
function varargout = GUI_AutoSegmSettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function popup_C_SegmMod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_C_SegmMod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_C_SegmMod.
function popup_C_SegmMod_Callback(hObject, eventdata, handles)
% hObject    handle to popup_C_SegmMod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_C_SegmMod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_C_SegmMod
global revims_handles

allItems = get(hObject,'string');
selectedIndex = get(hObject,'Value');
revims_handles.autoSegmMode = selectedIndex;


% --- Executes during object creation, after setting all properties.
function popup_C_DilEro_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_C_DilEro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_C_DilEro.
function popup_C_DilEro_Callback(hObject, eventdata, handles)
% hObject    handle to popup_C_DilEro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_C_DilEro contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_C_DilEro
global revims_handles

allItems = get(hObject,'string');
selectedIndex = get(hObject,'Value');
revims_handles.firstOperDilEro = selectedIndex;


% --- Executes during object creation, after setting all properties.
function edit_C_maskDilation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_C_maskDilation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_C_maskDilation_Callback(hObject, eventdata, handles)
% hObject    handle to edit_C_maskDilation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_C_maskDilation as text
%        str2double(get(hObject,'String')) returns contents of edit_C_maskDilation as a double
global revims_handles

value1 = str2double(get(hObject,'String'));
if ~isempty(value1) && ~isnan(value1) && value1>=0 && isnumeric(value1)
    value1 = round(value1);
    set(handles.edit_C_maskDilation, 'String', num2str(value1));
    revims_handles.maskDilation = value1;
else
    set(handles.edit_C_maskDilation, 'String', '0');
    revims_handles.maskDilation = 0; 
    errorString = ['The value must must be a positive integer.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = msgbox(sprintf(errorString));
end


% --- Executes during object creation, after setting all properties.
function edit_C_maskErosion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_C_maskErosion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_C_maskErosion_Callback(hObject, eventdata, handles)
% hObject    handle to edit_C_maskErosion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_C_maskErosion as text
%        str2double(get(hObject,'String')) returns contents of edit_C_maskErosion as a double
global revims_handles

value1 = str2double(get(hObject,'String'));
if ~isempty(value1) && ~isnan(value1) && value1>=0 && isnumeric(value1)
    value1 = round(value1);
    set(handles.edit_C_maskErosion, 'String', num2str(value1));
    revims_handles.maskErosion = value1;
else
    set(handles.edit_C_maskErosion, 'String', '0');
    revims_handles.maskErosion = 0; 
    errorString = ['The value must must be a positive integer.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = msgbox(sprintf(errorString));
end


% --- Executes when user attempts to close fig_AutoSegmSettings.
function fig_AutoSegmSettings_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to fig_AutoSegmSettings (see GCBO)
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
delete(handles.fig_AutoSegmSettings);
