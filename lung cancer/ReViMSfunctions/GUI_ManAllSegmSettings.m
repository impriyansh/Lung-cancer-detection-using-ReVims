function varargout = GUI_ManAllSegmSettings(varargin)
% GUI_MANALLSEGMSETTINGS MATLAB code for GUI_ManAllSegmSettings.fig
%      GUI_MANALLSEGMSETTINGS, by itself, creates a new GUI_MANALLSEGMSETTINGS or raises the existing
%      singleton*.
%
%      H = GUI_MANALLSEGMSETTINGS returns the handle to a new GUI_MANALLSEGMSETTINGS or the handle to
%      the existing singleton*.
%
%      GUI_MANALLSEGMSETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_MANALLSEGMSETTINGS.M with the given input arguments.
%
%      GUI_MANALLSEGMSETTINGS('Property','Value',...) creates a new GUI_MANALLSEGMSETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_ManAllSegmSettings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_ManAllSegmSettings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_ManAllSegmSettings

% Last Modified by GUIDE v2.5 05-Jan-2017 11:41:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_ManAllSegmSettings_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_ManAllSegmSettings_OutputFcn, ...
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


% --- Executes just before GUI_ManAllSegmSettings is made visible.
function GUI_ManAllSegmSettings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_ManAllSegmSettings (see VARARGIN)

global revims_handles
revims_handles.flagGUIclosedWithX = 0;

% Choose default command line output for GUI_ManAllSegmSettings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_ManAllSegmSettings wait for user response (see UIRESUME)
% uiwait(handles.fig_ManAllSegmSettings);

% set parameters to be showed
try
    
    flag_error = 0;
    
    % Check parameters
    if isempty(revims_handles.NumOriginalImages) || isnan(revims_handles.NumOriginalImages) || revims_handles.NumOriginalImages<2 || ~isnumeric(revims_handles.NumOriginalImages)
        flag_error = 1;
    end
    if isempty(revims_handles.firstImgToBeSegmented) || isnan(revims_handles.firstImgToBeSegmented) || revims_handles.firstImgToBeSegmented<1 || ~isnumeric(revims_handles.firstImgToBeSegmented)
        flag_error = 1;
    end
    if isempty(revims_handles.lastImgToBeSegmented) || isnan(revims_handles.lastImgToBeSegmented) || revims_handles.lastImgToBeSegmented>revims_handles.NumOriginalImages || ~isnumeric(revims_handles.lastImgToBeSegmented)
        flag_error = 1;
    end
    
    if flag_error == 1
        error('Wrong parameter set.')
        return
    end
    
    % Set parameters
    set(handles.edit_D_numImg, 'String', num2str(revims_handles.NumOriginalImages));
    set(handles.edit_D_firstImg, 'String', num2str(revims_handles.firstImgToBeSegmented));
    set(handles.edit_D_lastImg, 'String', num2str(revims_handles.lastImgToBeSegmented));
    set(handles.checkbox_D_ROI, 'Value', revims_handles.flag_DoNotUseROI);

catch ME1
    Message = {'Wrong parameter set.', ...
        ' '};
    msgbox(Message,'Message')
end


% --- Outputs from this function are returned to the command line.
function varargout = GUI_ManAllSegmSettings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when user attempts to close fig_ManAllSegmSettings.
function fig_ManAllSegmSettings_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to fig_ManAllSegmSettings (see GCBO)
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
delete(handles.fig_ManAllSegmSettings);



function text_D_Title_Callback(hObject, eventdata, handles)
% hObject    handle to text_D_Title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of text_D_Title as text
%        str2double(get(hObject,'String')) returns contents of text_D_Title as a double


% --- Executes during object creation, after setting all properties.
function text_D_Title_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_D_Title (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit_D_numImg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_D_numImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_D_numImg_Callback(hObject, eventdata, handles)
% hObject    handle to edit_D_numImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_D_numImg as text
%        str2double(get(hObject,'String')) returns contents of edit_D_numImg as a double


% --- Executes during object creation, after setting all properties.
function edit_D_firstImg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_D_firstImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_D_firstImg_Callback(hObject, eventdata, handles)
% hObject    handle to edit_D_firstImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_D_firstImg as text
%        str2double(get(hObject,'String')) returns contents of edit_D_firstImg as a double
global revims_handles

value1 = str2double(get(hObject,'String'));
if ~isempty(value1) && ~isnan(value1) && value1>=1 && value1<=revims_handles.lastImgToBeSegmented && value1<=revims_handles.NumOriginalImages && isnumeric(value1)
    value1 = round(value1);
    set(handles.edit_D_firstImg, 'String', num2str(value1));
    revims_handles.firstImgToBeSegmented = value1;
elseif ~isempty(value1) && ~isnan(value1) && value1>=1 && value1>revims_handles.lastImgToBeSegmented && value1<=revims_handles.NumOriginalImages && isnumeric(value1)
    value1 = round(value1);
    set(handles.edit_D_firstImg, 'String', num2str(value1));
    revims_handles.firstImgToBeSegmented = value1;
    set(handles.edit_D_lastImg, 'String', num2str(value1));
    revims_handles.lastImgToBeSegmented = value1;
else
    set(handles.edit_D_firstImg, 'String', '1');
    revims_handles.firstImgToBeSegmented = 1; 
    errorString = ['Wrong parameter set.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = msgbox(sprintf(errorString));
end


% --- Executes during object creation, after setting all properties.
function edit_D_lastImg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_D_lastImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_D_lastImg_Callback(hObject, eventdata, handles)
% hObject    handle to edit_D_lastImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_D_lastImg as text
%        str2double(get(hObject,'String')) returns contents of edit_D_lastImg as a double
global revims_handles

value1 = str2double(get(hObject,'String'));
if ~isempty(value1) && ~isnan(value1) && value1<=revims_handles.NumOriginalImages && value1>=revims_handles.firstImgToBeSegmented && isnumeric(value1)
    value1 = round(value1);
    set(handles.edit_D_lastImg, 'String', num2str(value1));
    revims_handles.lastImgToBeSegmented = value1;
else
    set(handles.edit_D_lastImg, 'String', num2str(revims_handles.NumOriginalImages));
    revims_handles.lastImgToBeSegmented = revims_handles.NumOriginalImages; 
    errorString = ['Wrong parameter set.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = msgbox(sprintf(errorString));
end


% --- Executes on button press in checkbox_D_ROI.
function checkbox_D_ROI_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_D_ROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_D_ROI
global revims_handles

value1 = get(hObject,'Value');
revims_handles.flag_DoNotUseROI = value1;
