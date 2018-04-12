function varargout = ReViMS_GUI(varargin)
% REVIMS_GUI MATLAB code for ReViMS_GUI.fig
%      REVIMS_GUI, by itself, creates a new REVIMS_GUI or raises the existing
%      singleton*.
%
%      H = REVIMS_GUI returns the handle to a new REVIMS_GUI or the handle to
%      the existing singleton*.
%
%      REVIMS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REVIMS_GUI.M with the given input arguments.
%
%      REVIMS_GUI('Property','Value',...) creates a new REVIMS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ReViMS_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ReViMS_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ReViMS_GUI

% Last Modified by GUIDE v2.5 25-Nov-2016 11:01:48

% Added by Filippo
addpath(['.' filesep 'ReViMSfunctions'])

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ReViMS_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ReViMS_GUI_OutputFcn, ...
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


% --- Executes just before ReViMS_GUI is made visible.
function ReViMS_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ReViMS_GUI (see VARARGIN)

% Choose default command line output for ReViMS_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ReViMS_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

clc
clearvars -global revims_handles
global revims_handles
revims_handles.h_GUIhelpA = [];
revims_handles.h_GUIhelpB = [];
revims_handles.PathInputFolderOriginal = [];
revims_handles.PathInputFolderCurrent = [];
revims_handles.PathOutputFolder = [];
revims_handles.BasenameImages = [];
revims_handles.ImageFormat = [];
revims_handles.NumOriginalImages = 0;
revims_handles.OriginalImagesRow = 0;
revims_handles.OriginalImagesCol = 0;
revims_handles.ROI = [];

revims_handles.h_GUIsetB = [];
revims_handles.visPercent = 0;
revims_handles.visOriMinInt = 0;
revims_handles.visOriMaxInt = 255;
revims_handles.visCurMinInt = 0;
revims_handles.visCurMaxInt = 255;
revims_handles.flag_ShowMask = 1;

revims_handles.firstImgToBeSegmented = [];
revims_handles.lastImgToBeSegmented = [];
revims_handles.flag_DoNotUseROI = 0;

revims_handles.h_GUIsetC = [];
revims_handles.flagGUIclosedWithX = 0;
revims_handles.autoSegmMode = 1;
revims_handles.firstOperDilEro = 1;
revims_handles.maskDilation = 0;
revims_handles.maskErosion = 0;

revims_handles.PathMaskFolder = [];
revims_handles.BasenameMasks = [];
revims_handles.MaskFormat = [];
revims_handles.pixelXmicrometers = 1; 
revims_handles.pixelYmicrometers = 1;
revims_handles.gapZmicrometers = 1;
revims_handles.interpolationMode = 2; % 2 = Linear interpolation; 1 = No interpolation;
revims_handles.Volume3D = [];
revims_handles.flagShowMesh = 1;


% --- Outputs from this function are returned to the command line.
function varargout = ReViMS_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in About.
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

Message = {'SOFTWARE VERSION', ...
    'ReViMS v1.0', ...
    'February 19, 2017', ...
    ' ', ...
    'REQUIREMENTS', ...
    'MATLAB 2015a and Image Processing Toolbox 9.2 or later versions.', ...
    ' ', ...
    'CONTACTS', ...
    'Eng. Filippo Piccinini and Prof. Alessandro Bevilacqua', ...
    'Advanced Research Center on Electronic Systems (ARCES)', ...
    'University of Bologna, Italy', ...
    'f.piccinini@unibo.it and alessandro.bevilacqua@unibo.it', ...
    ' ', ...
    'LICENSE', ...
    'Copyright (c) 2017, Filippo Piccinini and Alessandro Bevilacqua.', ... 
    'All rights reserved.', ... 
    'This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.', ...
    'This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.', ...
    'You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.', ...
    ' ', ...
    ' ', ...
    ' ', ...
    ' '};

if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
revims_handles.h_GUIhelpA = msgbox(Message,'About us'); 
%To delete the button OK in the lower part of the window
child = get(revims_handles.h_GUIhelpA,'Children'); 
if isnumeric(child); delete(child(end)); else delete(child(1)); end   
pause(2*eps);


% --- Executes during object creation, after setting all properties.
function text_pathInputOriginal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_pathInputOriginal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in help_1.
function help_1_Callback(hObject, eventdata, handles)
% hObject    handle to help_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

helpString = ['IMAGE FOLDER PATH \n' '\n' 'The image folder must contain the images only, without any other file.'];

if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
revims_handles.h_GUIhelpA = helpdlg(sprintf(helpString));
%To delete the button OK in the lower part of the window
child = get(revims_handles.h_GUIhelpA,'Children'); 
if isnumeric(child); delete(child(end)); else delete(child(1)); end   
pause(2*eps);


% --- Executes on button press in help_2.
function help_2_Callback(hObject, eventdata, handles)
% hObject    handle to help_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

helpString = ['BASENAME AND FORMAT OF THE INPUT IMAGES \n' '\n' 'The basename of the images to be processed cannot contain white spaces or any special character, and must be in the format: "BasenameImage_###.ImageFormat". The possible ImageFormat types are: tif, tiff, bmp, png, jpg. The original images must be 8-bit gray-level.'];

if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
revims_handles.h_GUIhelpA = helpdlg(sprintf(helpString));
%To delete the button OK in the lower part of the window
child = get(revims_handles.h_GUIhelpA,'Children'); 
if isnumeric(child); delete(child(end)); else delete(child(1)); end   
pause(2*eps);


% --- Executes on button press in help_3.
function help_3_Callback(hObject, eventdata, handles)
% hObject    handle to help_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

helpString = ['OUTPUT FOLDER PATH \n' '\n' 'Select the folder where saving the output files.'];

if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
revims_handles.h_GUIhelpA = helpdlg(sprintf(helpString));
%To delete the button OK in the lower part of the window
child = get(revims_handles.h_GUIhelpA,'Children'); 
if isnumeric(child); delete(child(end)); else delete(child(1)); end   
pause(2*eps);


% --- Executes on button press in help_4.
function help_4_Callback(hObject, eventdata, handles)
% hObject    handle to help_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

helpString = ['MANUAL SEGMENTATION (multiple images) \n' '\n' 'To manually segment one or more images in the input folder. The output binary masks (i.e. black and white) will be saved into the MASK folder (automatically created if not previously present), inside the output folder. The area of segmentation can be either limited to the region of interest (ROI) originally defined (default), or freehand (selecting the checkbox). To improve the segmentation, use the button "Visualization options" to stretch the intensity of the images to be segmented.'];

if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
revims_handles.h_GUIhelpA = helpdlg(sprintf(helpString));
%To delete the button OK in the lower part of the window
child = get(revims_handles.h_GUIhelpA,'Children'); 
if isnumeric(child); delete(child(end)); else delete(child(1)); end   
pause(2*eps);


% --- Executes on button press in help_5.
function help_5_Callback(hObject, eventdata, handles)
% hObject    handle to help_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

helpString = ['MANUAL SEGMENTATION (single image) \n' '\n' 'To manually segment a single image selected throught a pop-up image selector. The output binary mask (i.e. black and white) will be saved into the MASK folder (automatically created if not previously present), inside the output folder. To improve the segmentation, use the button "Visualization options" to stretch the intensity of the image to be segmented.'];

if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
revims_handles.h_GUIhelpA = helpdlg(sprintf(helpString));
%To delete the button OK in the lower part of the window
child = get(revims_handles.h_GUIhelpA,'Children'); 
if isnumeric(child); delete(child(end)); else delete(child(1)); end   
pause(2*eps);


% --- Executes on button press in help_6.
function help_6_Callback(hObject, eventdata, handles)
% hObject    handle to help_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

helpString = ['AUTOMATIC SEGMENTATION (all images) \n' '\n' 'To automatically segment the images in the input folder. The output binary masks (i.e. black and white) will be saved into the MASK folder inside the output folder (previous MASK folder will be overwritten). The area of segmentation is limited to the region of interest (ROI) originally defined. If "show masks" is checked, to improve the visualization of the obtained results use the button "Visualization options" to stretch the intensity of the segmented images.'];

if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
revims_handles.h_GUIhelpA = helpdlg(sprintf(helpString));
%To delete the button OK in the lower part of the window
child = get(revims_handles.h_GUIhelpA,'Children'); 
if isnumeric(child); delete(child(end)); else delete(child(1)); end   
pause(2*eps);


% --- Executes on button press in help_b1.
function help_b1_Callback(hObject, eventdata, handles)
% hObject    handle to help_b1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

helpString = ['BINARY MASK FOLDER PATH \n' '\n' 'Select the folder containing the binary (i.e. black and white) masks to be processed.'];

if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
revims_handles.h_GUIhelpA = helpdlg(sprintf(helpString));
%To delete the button OK in the lower part of the window
child = get(revims_handles.h_GUIhelpA,'Children'); 
if isnumeric(child); delete(child(end)); else delete(child(1)); end   
pause(2*eps);


% --- Executes on button press in help_b2.
function help_b2_Callback(hObject, eventdata, handles)
% hObject    handle to help_b2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

helpString = ['BASENAME AND FORMAT OF THE BINARY MASKS \n' '\n' 'The basename of the masks to be processed cannot contain white spaces or any special character, and must be in the format: "BasenameMasks_###.ImageFormat". The possible MaskFormat types are: tif, tiff, bmp, png, jpg.'];

if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
revims_handles.h_GUIhelpA = helpdlg(sprintf(helpString));
%To delete the button OK in the lower part of the window
child = get(revims_handles.h_GUIhelpA,'Children'); 
if isnumeric(child); delete(child(end)); else delete(child(1)); end   
pause(2*eps);


% --- Executes on button press in help_b3.
function help_b3_Callback(hObject, eventdata, handles)
% hObject    handle to help_b3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

helpString = ['RECONSTRUCTION METHOD \n' '\n' 'Defining the method to join consecutive sections. If "Linear interpolation" is selected, the 3D border of the consecutive sections is smoothed.'];

if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
revims_handles.h_GUIhelpA = helpdlg(sprintf(helpString));
%To delete the button OK in the lower part of the window
child = get(revims_handles.h_GUIhelpA,'Children'); 
if isnumeric(child); delete(child(end)); else delete(child(1)); end   
pause(2*eps);


% --- Executes on button press in button_browseInput.
function button_browseInput_Callback(hObject, eventdata, handles)
% hObject    handle to button_browseInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

[ImageName, PathInputFolder] = uigetfile({'*.tif;*.tiff;*.bmp;*.png;*.jpg;'}, 'Select in the input folder one of the images to be processed', 'MultiSelect', 'off', revims_handles.PathInputFolderCurrent);
if ~isempty(PathInputFolder) && all(PathInputFolder~=0)
    try
        % Read Path, name, Format
        PositionsPointImage = strfind(ImageName, '.');
        PositionsUnderscore = strfind(ImageName, '_');
        BasenameImages = ImageName(1:PositionsUnderscore(end)-1);
        ImageFormat = ImageName(PositionsPointImage(end):end);
        
        % Wait message
        try close(BarWaitWindows); catch ME; end;
        pause(2*eps);
        Message = {'PARAMETER COMPUTATION', ...
            ' ', ...
            ['Please wait... Completed: ' '1' '%']};
        BarWaitWindows = msgbox(Message, 'Message');
        child = get(BarWaitWindows,'Children'); 
        if isnumeric(child); delete(child(end)); else delete(child(1)); end   
        pause(2*eps);
        
        % Check if the input images are gray-level 8-bit images
        dirList = dir([PathInputFolder BasenameImages '*' ImageFormat]);
        NumImages = length(dirList(:));
        referenceFrame = imread([PathInputFolder char(dirList(ceil(NumImages/2)).name)]);
        [row, col, ch] = size(referenceFrame);
        flag_error1 = 0;
        if isa(referenceFrame, 'uint16');
            flag_error1 = 1;
            referenceFrame  = 255.*double(referenceFrame)./(2^16-1); 
        elseif isa(referenceFrame, 'uint32');
            flag_error1 = 1;
            referenceFrame  = 255.*double(referenceFrame)./(2^32-1); 
        elseif isa(referenceFrame, 'uint64');
            flag_error1 = 1;
            referenceFrame  = 255.*double(referenceFrame)./(2^64-1); 
        end
        if size(referenceFrame, 3)~=1
            flag_error1 = 1;
            referenceFrame = rgb2gray(referenceFrame);
        end
        if flag_error1==1
            try close(BarWaitWindows); catch ME; end;
            errorString = ['The input images must be gray-level 8-bit images.'];
            if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
            revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
            return
        end
        clear flag_error1 referenceFrame
        
        % Check if the input folder contains at least two images
        if NumImages<2
            try close(BarWaitWindows); catch ME; end;
            errorString = ['The input image folder must contain at least two images.'];
            if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
            revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
            return
        end

        % Compute MinValue and MaxValue
        MinValue = 255;
        MaxValue = 0;
        valuesUnique = [];
        ModValue = round(NumImages/10);

        for i=1:NumImages
            
            referenceFrame = imread([PathInputFolder char(dirList(i).name)]);            
            valuesUnique = unique([valuesUnique; referenceFrame(:)]);
            MinValuei = min(referenceFrame(:));
            MaxValuei = max(referenceFrame(:));
            if MinValuei<MinValue; MinValue=MinValuei; end
            if MaxValuei>MaxValue; MaxValue=MaxValuei; end
            if MinValue==0 && MaxValue==255; break; end 

            clear MaxValuei MinValuei referenceFrame

            if mod(i,ModValue)==0
                try close(BarWaitWindows); catch ME; end;
                pause(2*eps);
                Message = {'PARAMETERS COMPUTATION', ...
                    ' ', ...
                    ['Please wait... Completed: ' num2str(round(100*(i/NumImages))) '%']};
                BarWaitWindows = msgbox(Message, 'Message');
                child = get(BarWaitWindows,'Children'); 
                if isnumeric(child); delete(child(end)); else delete(child(1)); end   
                pause(2*eps);
            end 
        end
        try close(BarWaitWindows); catch ME; end;
        if length(valuesUnique) <= 2
            errorString = ['The input images cannot be binary images.'];
            if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
            revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
            return
        end
        clear valuesUnique

        % Update MinValue and MaxValue into the GUI
        if MaxValue <= MinValue
            errorString = ['The minimum and the maximum values of the input images are coincident.'];
            if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
            revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
            return
        end
        revims_handles.visOriMinInt = MinValue;
        revims_handles.visOriMaxInt = MaxValue;
        revims_handles.visCurMinInt = MinValue;
        revims_handles.visCurMaxInt = MaxValue;
        
        % Define ROI (binary image with white for the ROI.
        revims_handles.ROI = uint8(true( [row, col] ));
             
        % Maximum Intensity Projection
        MIP = zMaximumIntensityProjection(PathInputFolder, BasenameImages, ImageFormat);

        % Maximum Intensity Projection segmentation
        a = double(0);
        b = double(255);
        c = double(revims_handles.visCurMinInt);
        d = double(revims_handles.visCurMaxInt);
        ROIsp = MIP;
        ROIsp(ROIsp>revims_handles.visCurMaxInt) = revims_handles.visCurMaxInt;
        ROIsp(ROIsp<revims_handles.visCurMinInt) = revims_handles.visCurMinInt;
        ROIsp = ((ROIsp-c).*((b-a)/(d-c)))+a;
        try 
            % New version: multiple-selection
            % New version from: http://stackoverflow.com/questions/23463516/draw-multiple-regions-on-an-image-imfreehand
            figure('Name',['DEFINE THE REGION OF INTEREST (ROI). Freehand manual segmentation. Double-click within the selection to fix it. Repeat the operation for multiple selections. One more double-click closes the figure.'],'NumberTitle','off'), imshow(uint8(ROIsp), 'Border', 'Tight');
            hFigFree = gcf;

            % Check monitor screen size to set the initial figure
            set(0,'units','pixels')  %characters
            Pix_SS = get(0,'screensize');
            Perc = 0.1;
            gapyrow = Pix_SS(4)*Perc;
            gapxcol = Pix_SS(3)*Perc;
            set(hFigFree,'Position',[gapxcol, gapyrow, floor(Pix_SS(3)-(2*gapxcol)), floor(Pix_SS(4)-(2*gapyrow))])

            [rowsz, colsz, chsz] = size(ROIsp);
            clear BWout1
            BWout1 = false( [rowsz, colsz] ); % accumulate all single object masks to this one
            hFigFree2 = imfreehand( gca ); setColor(hFigFree2,'red');
            Del03 = wait( hFigFree2 );
            clear PartialMask
            if hFigFree2.isvalid == 1; PartialMask = createMask( hFigFree2 ); else PartialMask=0; end;
            while sum(PartialMask(:)) > 25 || hFigFree2.isvalid == 0 % less than 25 pixels is considered empty mask
                  BWout1 = BWout1 | PartialMask; % add mask to global mask
                  % ask user for another mask
                  hFigFree2 = imfreehand( gca ); setColor(hFigFree2,'red');
                  Del03 = wait( hFigFree2 );
                  if hFigFree2.isvalid == 1; PartialMask = createMask( hFigFree2 ); else PartialMask=0; end;

                  if ~ishandle(hFigFree);
                      break
                  end;
            end
            if ishandle(hFigFree); close(hFigFree); end;
        catch ME
            if max(BWout1)==0 
                BWout1 = true( [rowsz, colsz] );
            end
            if ~ishandle(hFigFree);
            else
                if exist('hFigFree')==1; if ishandle(hFigFree); close(hFigFree); end; end; 
                errorString = ['Wrong segmentation.'];
                if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
                revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
                return
            end
            if exist('hFigFree')==1; if ishandle(hFigFree); close(hFigFree); end; end; 
        end
        BW_MIPmaskDilated = BWout1;
        SeDisk07 = strel('disk', 7);
        BW_MIPmaskDilated = imdilate(BW_MIPmaskDilated,SeDisk07);
        BW_MIPmaskDilated = imfill(BW_MIPmaskDilated,'holes');
        BW_MIPmaskDilated = uint8(BW_MIPmaskDilated);
        revims_handles.ROI = BW_MIPmaskDilated;
        
        % GUI update
        revims_handles.OriginalImagesRow = row; % Original images row
        revims_handles.OriginalImagesCol = col; % Original images col
        revims_handles.NumOriginalImages = NumImages; % Number of original images
        revims_handles.firstImgToBeSegmented = 1; % First image to be manually segmented
        revims_handles.lastImgToBeSegmented = NumImages; % Last image to be manually segmented
        set(handles.text_pathInputOriginal,'String', PathInputFolder);
        revims_handles.PathInputFolderOriginal = PathInputFolder;
        revims_handles.PathInputFolderCurrent = PathInputFolder;
        set(handles.text_basenameImages,'String', BasenameImages);
        revims_handles.BasenameImages = BasenameImages;
        set(handles.text_imageFormat,'String', ImageFormat);
        revims_handles.ImageFormat = ImageFormat;
        
        % Save ROI manually segmented
        if ~isempty(revims_handles.PathOutputFolder)
            BW_MIPmaskDilated = revims_handles.ROI;
            ROI_0_255 = zeros(size(BW_MIPmaskDilated));
            ROI_0_255(BW_MIPmaskDilated>0) = 255;
            imwrite(ROI_0_255, [revims_handles.PathOutputFolder 'ROI_ManuallySegmented.tif']);
            clear MIP_0_255 BW_MIPmaskDilated
        end
        
    catch err
        try close(BarWaitWindows); catch ME; end;
        errorString = ['Please, select an image. \n' '\n' 'The input folder must contain only images and no other files. \n' '\n' 'The basename of the images cannot contain spaces and special characters, and must be in the format: "BasenameImage_###.ImageFormat".'];
        if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
        revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    end
end


% --- Executes on button press in button_browseOutput.
function button_browseOutput_Callback(hObject, eventdata, handles)
% hObject    handle to button_browseOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

if isempty(revims_handles.PathInputFolderCurrent)
    errorString = ['First you must define the input image folder.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end

PathOutputFolder = uigetdir(revims_handles.PathOutputFolder, 'Select the folder where saving the output files.');
if ~isempty(PathOutputFolder) && all(PathOutputFolder~=0)
    Slash = filesep;
    if ~strcmp(PathOutputFolder(end), Slash)
        PathOutputFolder = strcat(PathOutputFolder,Slash);
    end
    if strcmp(revims_handles.PathInputFolderOriginal,PathOutputFolder) || strcmp(revims_handles.PathInputFolderCurrent,PathOutputFolder)
        errorString = ['The input folder and the output folder cannot be the same. \n' '\n' 'Change the output folder.'];
        if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
        revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    else
        set(handles.text_pathOutput,'String', PathOutputFolder);
        revims_handles.PathOutputFolder = PathOutputFolder;
    end
end

% Save ROI manually segmented
BW_MIPmaskDilated = revims_handles.ROI;
ROI_0_255 = zeros(size(BW_MIPmaskDilated));
ROI_0_255(BW_MIPmaskDilated>0) = 255;
imwrite(ROI_0_255, [revims_handles.PathOutputFolder 'ROI_ManuallySegmented.tif']);
clear MIP_0_255 BW_MIPmaskDilated


% --- Executes on button press in checkbox_showMask.
function checkbox_showMask_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_showMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_showMask
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

value1 = get(hObject,'Value');
revims_handles.flag_ShowMask = value1;


% --- Executes during object creation, after setting all properties.
function edit_pixelXmicrometers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pixelXmicrometers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_pixelXmicrometers_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pixelXmicrometers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pixelXmicrometers as text
%        str2double(get(hObject,'String')) returns contents of edit_pixelXmicrometers as a double
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

value1 = str2double(get(hObject,'String'));
if ~isempty(value1) && ~isnan(value1) && value1>=0 && isnumeric(value1)
    revims_handles.pixelXmicrometers = value1;
else
    set(handles.edit_pixelXmicrometers, 'String', '1.000');
    revims_handles.pixelXmicrometers = 1; 
    errorString = ['The pixelXmicrometers value must must be a positive value.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = msgbox(sprintf(errorString));
end


% --- Executes during object creation, after setting all properties.
function edit_pixelYmicrometers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_pixelYmicrometers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_pixelYmicrometers_Callback(hObject, eventdata, handles)
% hObject    handle to edit_pixelYmicrometers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_pixelYmicrometers as text
%        str2double(get(hObject,'String')) returns contents of edit_pixelYmicrometers as a double
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

value1 = str2double(get(hObject,'String'));
if ~isempty(value1) && ~isnan(value1) && value1>=0 && isnumeric(value1)
    revims_handles.pixelYmicrometers = value1;
else
    set(handles.edit_pixelYmicrometers, 'String', '1.000');
    revims_handles.pixelYmicrometers = 1; 
    errorString = ['The pixelYmicrometers value must must be a positive value.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = msgbox(sprintf(errorString));
end


% --- Executes during object creation, after setting all properties.
function edit_gapZmicrometers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_gapZmicrometers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_gapZmicrometers_Callback(hObject, eventdata, handles)
% hObject    handle to edit_gapZmicrometers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_gapZmicrometers as text
%        str2double(get(hObject,'String')) returns contents of edit_gapZmicrometers as a double
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

value1 = str2double(get(hObject,'String'));
if ~isempty(value1) && ~isnan(value1) && value1>=0 && isnumeric(value1)
    revims_handles.gapZmicrometers = value1;
else
    set(handles.edit_gapZmicrometers, 'String', '1.000');
    revims_handles.gapZmicrometers = 1; 
    errorString = ['The value must must be a positive value.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = msgbox(sprintf(errorString));
end


% --- Executes on selection change in popupmenu_interpolationMode.
function popupmenu_interpolationMode_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_interpolationMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_interpolationMode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_interpolationMode
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

Popupmenu1Pos  = get(handles.popupmenu_interpolationMode,'Value');
if Popupmenu1Pos == 1
    % Linear interpolation
    revims_handles.interpolationMode = 2;
elseif Popupmenu1Pos == 2
    % No interpolation
    revims_handles.interpolationMode = 1;
end


% --- Executes during object creation, after setting all properties.
function popupmenu_interpolationMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_interpolationMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_manSegmAll.
function button_manSegmAll_Callback(hObject, eventdata, handles)
% hObject    handle to button_manSegmAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

if isempty(revims_handles.PathInputFolderCurrent) || isempty(revims_handles.PathOutputFolder)
    errorString = ['The input image and the output folders must be defined first.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end

% Check NumImages
if ~isempty(revims_handles.NumOriginalImages) && ~isnan(revims_handles.NumOriginalImages) && revims_handles.NumOriginalImages>=2
    NumImages = revims_handles.NumOriginalImages;
else
    errorString = ['The input image folder must contain at least two images.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end
dirList = dir([revims_handles.PathInputFolderCurrent revims_handles.BasenameImages '*' revims_handles.ImageFormat]);
NumImages2 = length(dirList(:));
if revims_handles.NumOriginalImages~=NumImages2
    errorString = ['The input image and the output folders must be defined first.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end
clear NumImages2

% Check image size
if revims_handles.OriginalImagesRow>0 && revims_handles.OriginalImagesCol>0
    row = revims_handles.OriginalImagesRow;
    col = revims_handles.OriginalImagesCol;
else
    errorString = ['The original images must contain at least a pixel.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end

% Call the settings window
try 
    revims_handles.h_GUIsetC = GUI_ManAllSegmSettings;
    uiwait(revims_handles.h_GUIsetC);
    if revims_handles.flagGUIclosedWithX==1
        revims_handles.flagGUIclosedWithX = 0;
        return
    end
catch err
    if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
    if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;
    errorString = ['Wrong parameter set.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end

% To refresh the handles contained in revims_handles.
RefreshHandles(handles)

% Delete and recreate MASK into the output folder
%if isequal(exist([revims_handles.PathOutputFolder 'MASK'], 'dir'),7); rmdir([revims_handles.PathOutputFolder 'MASK'],'s'); mkdir([revims_handles.PathOutputFolder 'MASK']); else mkdir([revims_handles.PathOutputFolder 'MASK']); end;
% Do not delete MASK into the output folder
if isequal(exist([revims_handles.PathOutputFolder 'MASK'], 'dir'),7); 
else mkdir([revims_handles.PathOutputFolder 'MASK']); 
end;

% Define ROI
if revims_handles.flag_DoNotUseROI == 0;
    BW_MIPmaskDilated = revims_handles.ROI;
else
    BW_MIPmaskDilated = uint8(true( [row, col] ));
end
[xrow, ycol] = find(BW_MIPmaskDilated>0);
%cornersROI = [1,1; col,row];
cornersROI = [min(ycol),min(xrow); max(ycol),max(xrow)];
clear xrow ycol

% Manual segmentation with freehand selection
a = double(0);
b = double(255);
c = double(revims_handles.visCurMinInt);
d = double(revims_handles.visCurMaxInt);
startInd = revims_handles.firstImgToBeSegmented;
stopInd = revims_handles.lastImgToBeSegmented;
for i=startInd:stopInd
    ImIn = imread([revims_handles.PathInputFolderCurrent char(dirList(i).name)]);
    ImIn(ImIn>revims_handles.visCurMaxInt) = revims_handles.visCurMaxInt;
    ImIn(ImIn<revims_handles.visCurMinInt) = revims_handles.visCurMinInt;
    ImIn_0_255 = ((ImIn-c).*((b-a)/(d-c)))+a;
    ImIn_0_255 = uint8(ImIn_0_255).*BW_MIPmaskDilated;
    ROIsp = ImIn_0_255(cornersROI(1,2):cornersROI(2,2),cornersROI(1,1):cornersROI(2,1));

    try 
        % New version: multiple-selection
        % New version from: http://stackoverflow.com/questions/23463516/draw-multiple-regions-on-an-image-imfreehand
        figure('Name',['Image: ' num2str(i) '/' num2str(NumImages) '. ' 'Freehand manual segmentation. Double-click within the selection to fix it. Repeat the operation for multiple selections. One more double-click closes the figure.'],'NumberTitle','off'), imshow(uint8(ROIsp), 'Border', 'Tight');
        hFigFree = gcf;

        % Check monitor screen size to set the initial figure
        set(0,'units','pixels')  %characters
        Pix_SS = get(0,'screensize');
        Perc = 0.1;
        gapyrow = Pix_SS(4)*Perc;
        gapxcol = Pix_SS(3)*Perc;
        set(hFigFree,'Position',[gapxcol, gapyrow, floor(Pix_SS(3)-(2*gapxcol)), floor(Pix_SS(4)-(2*gapyrow))])

        [rowsz, colsz, chsz] = size(ROIsp);
        clear BWout1
        BWout1 = false( [rowsz, colsz] ); % accumulate all single object masks to this one
        hFigFree2 = imfreehand( gca ); setColor(hFigFree2,'red');
        Del03 = wait( hFigFree2 );
        clear PartialMask
        if hFigFree2.isvalid == 1; PartialMask = createMask( hFigFree2 ); else PartialMask=0; end;
        while sum(PartialMask(:)) > 25 || hFigFree2.isvalid == 0 % less than 25 pixels is considered empty mask
              BWout1 = BWout1 | PartialMask; % add mask to global mask
              % ask user for another mask
              hFigFree2 = imfreehand( gca ); setColor(hFigFree2,'red');
              Del03 = wait( hFigFree2 );
              if hFigFree2.isvalid == 1; PartialMask = createMask( hFigFree2 ); else PartialMask=0; end;

              if ~ishandle(hFigFree);
                  break
              end;
        end
        if ishandle(hFigFree); close(hFigFree); end;
    catch ME
        if ~ishandle(hFigFree);
            return
        else
            if exist('hFigFree')==1; if ishandle(hFigFree); close(hFigFree); end; end; 
            errorString = ['Wrong segmentation.'];
            if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
            revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
            return
        end
    end
    
    % Restore ROI coordinates
    ImOut = zeros(row, col);
    ImOut(cornersROI(1,2):cornersROI(2,2), cornersROI(1,1):cornersROI(2,1)) = BWout1; 
    
    % Save output mask
    ImOut = uint8(ImOut).*BW_MIPmaskDilated;
    ImOut(ImOut>0) = 255;
    imwrite(ImOut, [revims_handles.PathOutputFolder 'MASK' filesep char(dirList(i).name)]);

    % Visualize the output mask
    if revims_handles.flag_ShowMask == 1        
        try          
            Bar = 255.*uint8([ones(row, 5) zeros(row, 5) ones(row, 5)]);
            figure('Name',[dirList(i).name ' -Image: ' num2str(i) '/' num2str(NumImages) '- (press ENTER to continue).'],'NumberTitle','off'), imshow(uint8([ImIn_0_255 Bar ImOut]), 'Border', 'Tight');
            hFinalFigure = gcf;
            Del04 = waitforbuttonpress;
            if ishandle(hFinalFigure); close(hFinalFigure); end;
        catch err
        end
    end

end


% --- Executes on button press in button_manSegSingle.
function button_manSegSingle_Callback(hObject, eventdata, handles)
% hObject    handle to button_manSegSingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

if isempty(revims_handles.PathOutputFolder)
    errorString = ['First you must define the output folder.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end

% Check image size
if revims_handles.OriginalImagesRow>0 && revims_handles.OriginalImagesCol>0
    row = revims_handles.OriginalImagesRow;
    col = revims_handles.OriginalImagesCol;
else
    errorString = ['The original images must contain at least a pixel.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end

% To refresh the handles contained in revims_handles.
RefreshHandles(handles)

% Do not delete MASK into the output folder
if isequal(exist([revims_handles.PathOutputFolder 'MASK'], 'dir'),7); 
else mkdir([revims_handles.PathOutputFolder 'MASK']); 
end;

% Load an image
[filename, pathname, filterindex] = uigetfile({'*.tif;*.tiff;*.bmp;*.png;*.jpg;'}, 'Select the image to be segmented', 'MultiSelect', 'off', revims_handles.PathInputFolderCurrent);
if isequal(filename,0) || isequal(pathname,0) || isequal(filterindex,0)
    errorString = ['A wrong input file has been selected.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end   

cornersROI = [1,1; col,row];
BW_MIPmaskDilated = uint8(ones(row, col));

% Manual segmentation with freehand selection
ImIn = imread([pathname filename]);
a = double(0);
b = double(255);
c = double(revims_handles.visCurMinInt);
d = double(revims_handles.visCurMaxInt);
ImIn_0_255 = ImIn;
ImIn_0_255(ImIn_0_255>revims_handles.visCurMaxInt) = revims_handles.visCurMaxInt;
ImIn_0_255(ImIn_0_255<revims_handles.visCurMinInt) = revims_handles.visCurMinInt;
ImIn_0_255 = ((ImIn_0_255-c).*((b-a)/(d-c)))+a;
ImIn_0_255 = uint8(ImIn_0_255).*BW_MIPmaskDilated;
ROIsp = ImIn_0_255(cornersROI(1,2):cornersROI(2,2),cornersROI(1,1):cornersROI(2,1));

try 
    % New version: multiple-selection
    % New version from: http://stackoverflow.com/questions/23463516/draw-multiple-regions-on-an-image-imfreehand
    figure('Name',['Image: ' filename '. ' 'Freehand manual segmentation. Double-click within the selection to fix it. Repeat the operation for multiple selections. One more double-click closes the figure.'],'NumberTitle','off'), imshow(uint8(ROIsp), 'Border', 'Tight');
    hFigFree = gcf;

    % Check monitor screen size to set the initial figure
    set(0,'units','pixels')  %characters
    Pix_SS = get(0,'screensize');
    Perc = 0.1;
    gapyrow = Pix_SS(4)*Perc;
    gapxcol = Pix_SS(3)*Perc;
    set(hFigFree,'Position',[gapxcol, gapyrow, floor(Pix_SS(3)-(2*gapxcol)), floor(Pix_SS(4)-(2*gapyrow))])

    [rowsz, colsz, chsz] = size(ROIsp);
    clear BWout1
    BWout1 = false( [rowsz, colsz] ); % accumulate all single object masks to this one
    hFigFree2 = imfreehand( gca ); setColor(hFigFree2,'red');
    Del03 = wait( hFigFree2 );
    clear PartialMask
    if hFigFree2.isvalid == 1; PartialMask = createMask( hFigFree2 ); else PartialMask=0; end;
    while sum(PartialMask(:)) > 25 || hFigFree2.isvalid == 0 % less than 25 pixels is considered empty mask
          BWout1 = BWout1 | PartialMask; % add mask to global mask
          % ask user for another mask
          hFigFree2 = imfreehand( gca ); setColor(hFigFree2,'red');
          Del03 = wait( hFigFree2 );
          if hFigFree2.isvalid == 1; PartialMask = createMask( hFigFree2 ); else PartialMask=0; end;

          if ~ishandle(hFigFree);
              break
          end;
    end
    if ishandle(hFigFree); close(hFigFree); end;
catch ME
    if ~ishandle(hFigFree);
        return
    else
        errorString = ['Wrong segmentation.'];
        if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
        revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
        return
    end
end

% Restore ROI coordinates
ImOut = zeros(row, col);
ImOut(cornersROI(1,2):cornersROI(2,2), cornersROI(1,1):cornersROI(2,1)) = BWout1; 

% Save output mask
ImOut = uint8(ImOut).*BW_MIPmaskDilated;
ImOut(ImOut>0) = 255;
imwrite(ImOut, [revims_handles.PathOutputFolder 'MASK' filesep filename]);

% Visualize the output mask
if revims_handles.flag_ShowMask == 1        
    try 
        Bar = 255.*uint8([ones(row, 5) zeros(row, 5) ones(row, 5)]);
        figure('Name',[filename ' (press ENTER to continue).'],'NumberTitle','off'), imshow(uint8([ImIn_0_255 Bar ImOut]), 'Border', 'Tight');
        hFinalFigure = gcf;
        Del04 = waitforbuttonpress;
        if ishandle(hFinalFigure); close(hFinalFigure); end;
    catch err
    end
end


% --- Executes on button press in button_autoSeg1.
function button_autoSeg1_Callback(hObject, eventdata, handles)
% hObject    handle to button_autoSeg1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

if ishandle(revims_handles.h_GUIhelpB); close(revims_handles.h_GUIhelpB); end;

if isempty(revims_handles.PathInputFolderCurrent) || isempty(revims_handles.PathOutputFolder)
    errorString = ['The input image and the output folders must be defined first.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end

% Check NumImages
if ~isempty(revims_handles.NumOriginalImages) && ~isnan(revims_handles.NumOriginalImages) && revims_handles.NumOriginalImages>=2
    NumImages = revims_handles.NumOriginalImages;
else
    errorString = ['The input image folder must contain at least two images.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end
dirList = dir([revims_handles.PathInputFolderCurrent revims_handles.BasenameImages '*' revims_handles.ImageFormat]);
NumImages2 = length(dirList(:));
if revims_handles.NumOriginalImages~=NumImages2
    errorString = ['The input image and the output folders must be defined first.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end
clear NumImages2

% Check image size
if revims_handles.OriginalImagesRow>0 && revims_handles.OriginalImagesCol>0
    row = revims_handles.OriginalImagesRow;
    col = revims_handles.OriginalImagesCol;
else
    errorString = ['The original images must contain at least a pixel.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end

% Call the settings window
try 
    revims_handles.h_GUIsetC = GUI_AutoSegmSettings;
    uiwait(revims_handles.h_GUIsetC);
    if revims_handles.flagGUIclosedWithX==1
        revims_handles.flagGUIclosedWithX = 0;
        return
    end
catch err
    if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
    if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;
    errorString = ['Wrong parameter set.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end

% To refresh the handles contained in revims_handles.
RefreshHandles(handles)

% Delete and recreate MASK into the output folder
if isequal(exist([revims_handles.PathOutputFolder 'MASK'], 'dir'),7); rmdir([revims_handles.PathOutputFolder 'MASK'],'s'); mkdir([revims_handles.PathOutputFolder 'MASK']); else mkdir([revims_handles.PathOutputFolder 'MASK']); end;


% Define ROI
BW_MIPmaskDilated = revims_handles.ROI;
[xrow, ycol] = find(BW_MIPmaskDilated>0);
%cornersROI = [1,1; col,row];
cornersROI = [min(ycol),min(xrow); max(ycol),max(xrow)];
clear xrow ycol

% Automatic segmentation

% Wait message
ModValue = round(NumImages/10);
try close(BarWaitWindows); catch ME; end;
pause(2*eps);
Message = {'THRESHOLD COMPUTATION', ...
    ' ', ...
    ['Please wait... Completed: ' '1' '%']};
BarWaitWindows = msgbox(Message, 'Message');
child = get(BarWaitWindows,'Children'); 
if isnumeric(child); delete(child(end)); else delete(child(1)); end   
pause(2*eps);

%countsComulative = zeros(256,1);
imageComulative = [];
for i=1:NumImages 
    ImIn = imread([revims_handles.PathInputFolderCurrent char(dirList(i).name)]);
    ROIsp = uint8(ImIn(cornersROI(1,2):cornersROI(2,2),cornersROI(1,1):cornersROI(2,1)));
    
    imageComulative = [imageComulative; ROIsp(:)];
    %[counts, binLocations] = imhist(ROIsp, 256);
    %countsComulative = countsComulative + counts;
    clear ROIsp ImIn_0_255 ImIn
    
    if mod(i,ModValue)==0
        try close(BarWaitWindows); catch ME; end;
        pause(2*eps);
        Message = {'THRESHOLD COMPUTATION', ...
            ' ', ...
            ['Please wait... Completed: ' num2str(round(100*(i/NumImages))) '%']};
        BarWaitWindows = msgbox(Message, 'Message');
        child = get(BarWaitWindows,'Children'); 
        if isnumeric(child); delete(child(end)); else delete(child(1)); end   
        pause(2*eps);
    end
    
end
try close(BarWaitWindows); catch ME; end;

% Automatic threshold
try
    if revims_handles.autoSegmMode == 2
        % Otsu
        [BWthreshold, EffectivenessMetric] = graythresh(imageComulative);
        %[BWthreshold, EffectivenessMetric] = otsuthresh(countsComulative);
        if EffectivenessMetric < 0.50
            errorString = ['For this dataset was not possible to obtain a good automatic segmentation using the Otsu segmentation. \nSuggestion: segment manually the images.'];
            if ishandle(revims_handles.h_GUIhelpB); close(revims_handles.h_GUIhelpB); end;
            revims_handles.h_GUIhelpB = msgbox(sprintf(errorString));
        end
    elseif revims_handles.autoSegmMode == 3
        % Triangle
        [counts, binLocations] = imhist(imageComulative);
        HistoCountVector = counts;
        PeakRightOrLeft = 'Left';
        TailRightOrLeft = 'Right';
        version = 0;
        BinThresh = HistoTriangleThreshold(HistoCountVector, PeakRightOrLeft, TailRightOrLeft, version);
        BWthreshold = binLocations(BinThresh)/length(binLocations);
    elseif revims_handles.autoSegmMode == 1
        % Average between Otsu and Triangle
        [BWthresholdOtsu, EffectivenessMetric] = graythresh(imageComulative);
        if EffectivenessMetric < 0.50
            errorString = ['For this dataset was not possible to obtain a good automatic segmentation using the Otsu segmentation. \nSuggestion: segment manually the images.'];
            if ishandle(revims_handles.h_GUIhelpB); close(revims_handles.h_GUIhelpB); end;
            revims_handles.h_GUIhelpB = msgbox(sprintf(errorString));
        end
        [counts, binLocations] = imhist(imageComulative);
        HistoCountVector = counts;
        PeakRightOrLeft = 'Left';
        TailRightOrLeft = 'Right';
        version = 0;
        BinThresh = HistoTriangleThreshold(HistoCountVector, PeakRightOrLeft, TailRightOrLeft, version);
        BWthresholdTriangle = binLocations(BinThresh)/length(binLocations);
        BWthreshold = (BWthresholdOtsu+BWthresholdTriangle)/2;
    else
        try close(BarWaitWindows); catch ME; end;
        errorString = ['Please, select a different segmentation modality.'];
        if ishandle(revims_handles.h_GUIhelpB); close(revims_handles.h_GUIhelpB); end;
        revims_handles.h_GUIhelpB = msgbox(sprintf(errorString));
        return
    end
catch ME
    try close(BarWaitWindows); catch ME; end;
    errorString = ['It was not possible to find a right threshold value for the selected segmentation modality.'];
    if ishandle(revims_handles.h_GUIhelpB); close(revims_handles.h_GUIhelpB); end;
    revims_handles.h_GUIhelpB = msgbox(sprintf(errorString));
    return
end

% Automatic segmentation
if revims_handles.flag_ShowMask == 1        
else
    % Wait message
    ModValue = round(NumImages/10);
    try close(BarWaitWindows); catch ME; end;
    pause(2*eps);
    Message = {'SEGMENTATION', ...
        ' ', ...
        ['Please wait... Completed: ' '1' '%']};
    BarWaitWindows = msgbox(Message, 'Message');
    child = get(BarWaitWindows,'Children'); 
    if isnumeric(child); delete(child(end)); else delete(child(1)); end   
    pause(2*eps);
end
a = double(0);
b = double(255);
c = double(revims_handles.visCurMinInt);
d = double(revims_handles.visCurMaxInt);
for i=1:NumImages
    ImIn = imread([revims_handles.PathInputFolderCurrent char(dirList(i).name)]);
    ROIsp = uint8(ImIn(cornersROI(1,2):cornersROI(2,2),cornersROI(1,1):cornersROI(2,1)));
    BW_0_1 = im2bw(ROIsp,BWthreshold);
    
    %For visualization purposes
    ImIn(ImIn>revims_handles.visCurMaxInt) = revims_handles.visCurMaxInt;
    ImIn(ImIn<revims_handles.visCurMinInt) = revims_handles.visCurMinInt;
    ImIn_0_255 = ((ImIn-c).*((b-a)/(d-c)))+a;
    ImIn_0_255 = uint8(ImIn_0_255);
    
    %Smoothing and hole filling.
    SeDisk05 = strel('disk', 5);
    BWout1 = imdilate(BW_0_1,SeDisk05);
    BWout1 = imfill(BWout1,'holes');
    BWout1 = imerode(BWout1,SeDisk05);
    if revims_handles.firstOperDilEro == 1
        if ~isempty(revims_handles.maskDilation) && ~isnan(revims_handles.maskDilation) && revims_handles.maskDilation>0
            SeDiskDil = strel('disk', round(revims_handles.maskDilation));
            BWout1 = imdilate(BWout1,SeDiskDil);
        end
        if ~isempty(revims_handles.maskErosion) && ~isnan(revims_handles.maskErosion) && revims_handles.maskErosion>0
            SeDiskDil = strel('disk', round(revims_handles.maskErosion));
            BWout1 = imerode(BWout1,SeDiskDil);
        end
    elseif revims_handles.firstOperDilEro == 2
        if ~isempty(revims_handles.maskErosion) && ~isnan(revims_handles.maskErosion) && revims_handles.maskErosion>0
            SeDiskDil = strel('disk', round(revims_handles.maskErosion));
            BWout1 = imerode(BWout1,SeDiskDil);
        end
        if ~isempty(revims_handles.maskDilation) && ~isnan(revims_handles.maskDilation) && revims_handles.maskDilation>0
            SeDiskDil = strel('disk', round(revims_handles.maskDilation));
            BWout1 = imdilate(BWout1,SeDiskDil);
        end
    end
    BWout1 = uint8(BWout1);
    
    % Restore ROI coordinates
    ImOut = zeros(row, col);
    ImOut(cornersROI(1,2):cornersROI(2,2), cornersROI(1,1):cornersROI(2,1)) = BWout1;
    
    % Save output mask
    ImOut = uint8(ImOut).*BW_MIPmaskDilated;
    ImOut(ImOut>0) = 255;
    imwrite(ImOut, [revims_handles.PathOutputFolder 'MASK' filesep char(dirList(i).name)]);

    % Visualize the output mask
    if revims_handles.flag_ShowMask == 1        
        try 
            if i==1
                Bar = 255.*uint8([ones(row, 5) zeros(row, 5) ones(row, 5)]);
                figure('Name',[dirList(i).name ' -Image: ' num2str(i) '/' num2str(NumImages) '- (press ENTER to continue).'],'NumberTitle','off'), imshow(uint8([ImIn_0_255 Bar ImOut]), 'Border', 'Tight');
                hFinalFigure = gcf;
                Del04 = waitforbuttonpress;
            else
                if hFinalFigure.isvalid == 0
                    revims_handles.flag_ShowMask = 0;
                    try close(BarWaitWindows); catch ME; end;
                    pause(2*eps);
                    Message = {'SEGMENTATION', ...
                        ' ', ...
                        ['Please wait... Completed: ' num2str(round(100*(i/NumImages))) '%']};
                    BarWaitWindows = msgbox(Message, 'Message');
                    child = get(BarWaitWindows,'Children'); 
                    if isnumeric(child); delete(child(end)); else delete(child(1)); end   
                    pause(2*eps);
                else
                    if ishandle(hFinalFigure); close(hFinalFigure); end; 
                	Bar = 255.*uint8([ones(row, 5) zeros(row, 5) ones(row, 5)]);
                    figure('Name',[dirList(i).name ' -Image: ' num2str(i) '/' num2str(NumImages) '- (press ENTER to continue).'],'NumberTitle','off'), imshow(uint8([ImIn_0_255 Bar ImOut]), 'Border', 'Tight');
                    hFinalFigure = gcf;
                    Del04 = waitforbuttonpress;
                end
            end
        catch err
        end
    else
        if mod(i,ModValue)==0
            try close(BarWaitWindows); catch ME; end;
            pause(2*eps);
            Message = {'SEGMENTATION', ...
                ' ', ...
                ['Please wait... Completed: ' num2str(round(100*(i/NumImages))) '%']};
            BarWaitWindows = msgbox(Message, 'Message');
            child = get(BarWaitWindows,'Children'); 
            if isnumeric(child); delete(child(end)); else delete(child(1)); end   
            pause(2*eps);
        end
    end
    
end
if exist('hFinalFigure')==1; if ishandle(hFinalFigure); close(hFinalFigure); end; end; 

save([revims_handles.PathOutputFolder 'revims_handles.mat'], 'revims_handles');

try close(BarWaitWindows); catch ME; end;
messageString = ['SEGMENTATION CONCLUDED'];
if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
revims_handles.h_GUIhelpA = msgbox(sprintf(messageString));


% --- Executes on button press in button_browseMasks.
function button_browseMasks_Callback(hObject, eventdata, handles)
% hObject    handle to button_browseMasks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

[MaskName, PathMaskFolder] = uigetfile({'*.tif;*.tiff;*.bmp;*.png;*.jpg;'}, 'Select inside the mask folder one of the masks to be processed', 'MultiSelect', 'off', revims_handles.PathOutputFolder);
if ~isempty(PathMaskFolder) && all(PathMaskFolder~=0)
    try
        PositionsPointMask = strfind(MaskName, '.');
        PositionsUnderscore = strfind(MaskName, '_');
        BasenameMasks = MaskName(1:PositionsUnderscore(end)-1);
        MaskFormat = MaskName(PositionsPointMask(end):end);
        
        set(handles.text_pathMaskInput,'String', PathMaskFolder);
        revims_handles.PathMaskFolder = PathMaskFolder;
        set(handles.text_basenameMasks,'String', BasenameMasks);
        revims_handles.BasenameMasks = BasenameMasks;
        set(handles.text_maskFormat,'String', MaskFormat);
        revims_handles.MaskFormat = MaskFormat;
        
    catch err
        errorString = ['Please, select a correct mask. \n' '\n' 'The mask folder must contain only masks and no other files. \n' '\n' 'The basename of the masks cannot contain spaces and special characters, and must be in the format: "BasenameMask_###.ImageFormat".'];
        if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
        revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    end
end


% --- Executes on button press in button_3Drendering.
function button_3Drendering_Callback(hObject, eventdata, handles)
% hObject    handle to button_3Drendering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
revims_handles.Volume3D = [];
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

if isempty(revims_handles.PathMaskFolder) || isempty(revims_handles.BasenameMasks)
    errorString = ['First you must define the folder of the masks to be processed.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end

% To refresh the handles contained in revims_handles.
RefreshHandles(handles)

% Check if the z-gap is higher than the x-pixel and y-pixel dimensions
if revims_handles.gapZmicrometers<revims_handles.pixelXmicrometers || revims_handles.gapZmicrometers<revims_handles.pixelYmicrometers
    errorString = ['The z-gap must be higher than the x-pixel and y-pixel size.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end

% Check if the input images are gray-level 8-bit images
dirList = dir([revims_handles.PathMaskFolder revims_handles.BasenameMasks '*' revims_handles.MaskFormat]);
NumImages = length(dirList(:));
if isempty(NumImages) || isnan(NumImages) || NumImages<=1
    errorString = ['The folder must contains at least two masks to be processed.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end
referenceFrame = imread([revims_handles.PathMaskFolder char(dirList(ceil(NumImages/2)).name)]);
flag_error1 = 0;
if isa(referenceFrame, 'uint16');
    flag_error1 = 1;
elseif isa(referenceFrame, 'uint32');
    flag_error1 = 1;
elseif isa(referenceFrame, 'uint64');
    flag_error1 = 1;
end
if size(referenceFrame, 3)~=1
    flag_error1 = 1;
end
if flag_error1==1
    errorString = ['The input masks must gray-level 8-bit images.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end
clear flag_error1 referenceFrame

% create tmp folder
if isequal(exist('OUTPUT', 'dir'),7); rmdir('OUTPUT','s'); mkdir('OUTPUT'); else mkdir('OUTPUT'); end;
if isequal(exist('tmpfold', 'dir'),7); rmdir('tmpfold','s'); mkdir('tmpfold'); else mkdir('tmpfold'); end;

% Compute the volume
Volume = VolumeZstackFull(revims_handles.PathMaskFolder, revims_handles.BasenameMasks, revims_handles.MaskFormat, revims_handles.flagShowMesh, revims_handles.pixelXmicrometers, revims_handles.pixelYmicrometers, revims_handles.gapZmicrometers, revims_handles.interpolationMode);

if isequal(exist('tmpfold', 'dir'),7); rmdir('tmpfold','s'); end;

% Visualize the results
if ~isempty(Volume) && Volume>0
    revims_handles.Volume3D = Volume;
    Message = {'Spheroid:', ...
        strcat(revims_handles.PathMaskFolder, revims_handles.BasenameMasks), ...
        ' ', ...
        'Volume [cubic micrometers]:', ...
        num2str(Volume), ...
    ' '};
    msgbox(Message,'VOLUME [cubic micrometers]')
    save(['OUTPUT' filesep 'VolumeCubicMicrometers.mat'], 'Volume')
end
save(['OUTPUT' filesep 'revims_handles.mat'], 'revims_handles')


% --- Executes on button press in button_VisualOptions.
function button_VisualOptions_Callback(hObject, eventdata, handles)
% hObject    handle to button_VisualOptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global revims_handles
if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;

if isempty(revims_handles.PathInputFolderCurrent) || isempty(revims_handles.PathOutputFolder)
    errorString = ['The input image and the output folders must be defined first.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end

% Check NumImages
if ~isempty(revims_handles.NumOriginalImages) && ~isnan(revims_handles.NumOriginalImages) && revims_handles.NumOriginalImages>=2
    NumImages = revims_handles.NumOriginalImages;
else
    errorString = ['The input image folder must contain at least two images.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end
dirList = dir([revims_handles.PathInputFolderCurrent revims_handles.BasenameImages '*' revims_handles.ImageFormat]);
NumImages2 = length(dirList(:));
if revims_handles.NumOriginalImages~=NumImages2
    errorString = ['The input image and the output folders must be defined first.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end
clear NumImages2

% Check image size
if revims_handles.OriginalImagesRow>0 && revims_handles.OriginalImagesCol>0
    row = revims_handles.OriginalImagesRow;
    col = revims_handles.OriginalImagesCol;
else
    errorString = ['The original images must contain at least a pixel.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end

% Call the settings window
try 
    revims_handles.h_GUIsetB = GUI_VisualOptSettings;
    uiwait(revims_handles.h_GUIsetB);
    if revims_handles.flagGUIclosedWithX==1
        revims_handles.flagGUIclosedWithX = 0;
        return
    end
catch err
    if ishandle(revims_handles.h_GUIsetB); close(revims_handles.h_GUIsetB); end;
    if ishandle(revims_handles.h_GUIsetC); close(revims_handles.h_GUIsetC); end;
    errorString = ['Wrong parameter set.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = errordlg(sprintf(errorString));
    return
end
