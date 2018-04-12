function RefreshHandles(handles)
% AUTHOR: Filippo Piccinini (E-mail: f.piccinini@unibo.it)
% DATE: November 13, 2016
% NAME: RefreshHandles (version 1.0)
% 
% To refresh the handles contained in revims_handles.
%
% PARAMETERS:
% 	handles  handles of the main GUI objects.

% CVG (Computer Vision Group) Toolbox
% Copyright © 2015 Filippo Piccinini, Alessandro Bevilacqua, 
% Advanced Research Center on Electronic Systems (ARCES), 
% University of Bologna, Italy. All rights reserved.
%
% This program is free software; you can redistribute it and/or modify it 
% under the terms of the GNU General Public License version 2 (or higher) 
% as published by the Free Software Foundation. This program is 
% distributed WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
% General Public License for more details.

global revims_handles


% revims_handles.flag_ShowMask
value1 = get(handles.checkbox_showMask,'Value');
revims_handles.flag_ShowMask = value1;
clear value1


%revims_handles.pixelXmicrometers
value1 = str2double(get(handles.edit_pixelXmicrometers,'String'));
if ~isempty(value1) && ~isnan(value1) && value1>=0 && isnumeric(value1)
    revims_handles.pixelXmicrometers = value1;
else
    set(handles.edit_pixelXmicrometers, 'String', '1.000');
    revims_handles.pixelXmicrometers = 1; 
    errorString = ['The pixelXmicrometers value must must be a positive value.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = msgbox(sprintf(errorString));
end
clear value1

%revims_handles.pixelYmicrometers
value1 = str2double(get(handles.edit_pixelYmicrometers,'String'));
if ~isempty(value1) && ~isnan(value1) && value1>=0 && isnumeric(value1)
    revims_handles.pixelYmicrometers = value1;
else
    set(handles.edit_pixelYmicrometers, 'String', '1.000');
    revims_handles.pixelYmicrometers = 1; 
    errorString = ['The pixelYmicrometers value must must be a positive value.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = msgbox(sprintf(errorString));
end
clear value1

%revims_handles.gapZmicrometers
value1 = str2double(get(handles.edit_gapZmicrometers,'String'));
if ~isempty(value1) && ~isnan(value1) && value1>=0 && isnumeric(value1)
    revims_handles.gapZmicrometers = value1;
else
    set(handles.edit_gapZmicrometers, 'String', '1.000');
    revims_handles.gapZmicrometers = 1; 
    errorString = ['The value must must be a positive value.'];
    if ishandle(revims_handles.h_GUIhelpA); close(revims_handles.h_GUIhelpA); end;
    revims_handles.h_GUIhelpA = msgbox(sprintf(errorString));
end
clear value1

%revims_handles.interpolationMode
Popupmenu1Pos  = get(handles.popupmenu_interpolationMode,'Value');
if Popupmenu1Pos == 1
    % Linear interpolation
    revims_handles.interpolationMode = 2;
elseif Popupmenu1Pos == 2
    % No interpolation
    revims_handles.interpolationMode = 1;
end
clear Popupmenu1Pos