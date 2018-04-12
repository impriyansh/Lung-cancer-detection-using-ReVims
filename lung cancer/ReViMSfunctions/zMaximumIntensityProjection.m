function MaximumIntensityProjection = zMaximumIntensityProjection(InImageFolder, InImageBasename, InImageType)
% AUTHOR: Filippo Piccinini (E-mail: f.piccinini@unibo.it)
% DATE: 04 November 2016
% NAME: zMaximumIntensityProjection (version 1.0)
% 
% To compute the maximum intensity projection of a z-stack of images.
%
% PARAMETERS:
% 	InImageFolder   Absolute path of the folder containing the input
%                   images.
%   InImageBasename Basename of the images to be processed cannot contain 
%                   white spaces or special characters, and must be in the
%                   format: "BasenameImage_###.ImageFormat".
%   InImageType     Format of the input images. Typically ".tif", ".tiff",
%                   ".bmp", ".jpg".
%
% OUTPUT:
%   MaximumIntensityProjection   2D maximum intensity projection image.
%
% EXAMPLE OF USAGE: 
% MaximumIntensityProjection = zMaximumIntensityProjection('C:\FPICCININI\SampleA\', '.tif');
 
% CVG (Computer Vision Group) Toolbox
% Copyright © 2016 Filippo Piccinini, Alessandro Bevilacqua, 
% Advanced Research Center on Electronic Systems (ARCES), 
% University of Bologna, Italy. All rights reserved.
%
% This program is free software; you can redistribute it and/or modify it 
% under the terms of the GNU General Public License version 3 (or higher) 
% as published by the Free Software Foundation. This program is 
% distributed WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
% General Public License for more details.


%% INTERNAL PARAMETERS


%% CHECK PARAMETERS
Slash = filesep;
if ~strcmp(InImageFolder(end), Slash)
    InImageFolder = strcat(InImageFolder,Slash);
end


%% SET PARAMETERS

dirList = dir([InImageFolder InImageBasename '*' InImageType]);
NumberOfImages = length(dirList);
if NumberOfImages==0
    errordlg('ERROR: No images in the selected folder!')
end

ImInp = imread([InImageFolder char(dirList(ceil(NumberOfImages/2)).name)]);
[row, col, ch] = size(ImInp);
flag_rgb2gray = 0;
if ch>1
    flag_rgb2gray = 1;
end
MaximumIntensityProjection = zeros(row, col);
clear ImInp

% Wait message
ModValue = round(NumberOfImages/10);
try close(BarWaitWindows); catch ME; end;
pause(2*eps);
Message = {'MIP COMPUTATION', ...
    ' ', ...
    ['Please wait... Completed: ' '1' '%']};
BarWaitWindows = msgbox(Message, 'Message');
child = get(BarWaitWindows,'Children'); 
if isnumeric(child); delete(child(end)); else delete(child(1)); end   
pause(2*eps);

StartInd = 1;
CloseInd = NumberOfImages;
for ImNum = StartInd:CloseInd
    % Read the current image
    ImInp = imread([InImageFolder char(dirList(ImNum).name)]);
    ImInp = double(ImInp);
    if flag_rgb2gray == 1
        ImInp = rgb2gray(ImInp);
    end
    MIPi = max(MaximumIntensityProjection,ImInp);
    MaximumIntensityProjection = MIPi;
    clear MIPi ImInp
    
    % Wait message
    if mod(ImNum,ModValue)==0
        try close(BarWaitWindows); catch ME; end;
        pause(2*eps);
        Message = {'MIP COMPUTATION', ...
            ' ', ...
            ['Please wait... Completed: ' num2str(round(100*(ImNum/NumberOfImages))) '%']};
        BarWaitWindows = msgbox(Message, 'Message');
        child = get(BarWaitWindows,'Children'); 
        if isnumeric(child); delete(child(end)); else delete(child(1)); end   
        pause(2*eps);
    end
    
end
try close(BarWaitWindows); catch ME; end;

%figure, imshow(MaximumIntensityProjection, [], 'Border', 'Tight')