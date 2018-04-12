function VolumeCubicMicrometers = VolumeZstackFull(InImageFolder1, ImageBaseName, InImageType, flagShowMesh, pixelXmicrometers, pixelYmicrometers, gapZmicrometersOriginal, interpolationMode)
% AUTHOR: Filippo Piccinini (E-mail: f.piccinini@unibo.it)
% DATE: November 13, 2016
% NAME: VolumeZstackFull (version 2.0)
% 
% To reconstruct the spheroids starting from a z-stack of binary masks.
%
% PARAMETERS:
% 	InImageFolder1  Absolute path of the folder containing the input
%                   masks.
%   ImageBaseName   Basename of the mask to be processed cannot contain 
%                   white spaces or special characters, and must be in the
%                   format: "BasenameMask_###.ImageFormat".
%   InImageType     Format of the input masks. Typically ".tif", ".tiff",
%                   ".bmp", ".jpg".
%   flagShowMesh    1 to visualize the output 3D mesh.
%
%   pixelXmicrometers Size of the x side of the pixels in micrometers.
%
%   pixelYmicrometers Size of the y side of the pixels in micrometers.
%
%   gapZmicrometersOriginal z-distance in micrometers between two 
%                   adjacent acquired images.
%   interpolationMode 1 means no interpolation, 2 means linear
%                   interpolation.
%
% OUTPUT:
%   VolumeCubicMicrometers Volume in cubic-micrometers of the obtained 3D
%                   mesh.
%
% EXAMPLE OF USAGE:
%  VolumeCubicMicrometers = VolumeZstackFull('C:\FPICCININI\Masks\','Masks_', '.tif', 1, 0.5, 0.5, 2, 2);
 
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

%% READ INPUT
VolumeCubicMicrometers = NaN; % To have the output also if there is a return


%% DATA EXTRACTION: ORIGINAL SECTIONS

dirList = dir([InImageFolder1 ImageBaseName '*' InImageType]);
NumberOfImages = length(dirList);
if isempty(NumberOfImages)
    errordlg(['In the input folder "' InImageFolder1 '" there are not images of type "' InImageType '".'])
    return
end
if NumberOfImages == 0
    errordlg(['In the input folder "' InImageFolder1 '" there are not images of type "' InImageType '".'])
    return
end

% Wait message
ModValue1 = round(NumberOfImages/10);
try close(BarWaitWindows); catch ME; end;
pause(2*eps);
Message = {'ANALYSIS OF ORIGINAL SECTIONS', ...
    ' ', ...
    ['Please wait... Completed: ' '1' '%']};
BarWaitWindows = msgbox(Message, 'Message');
child = get(BarWaitWindows,'Children'); 
if isnumeric(child); delete(child(end)); else delete(child(1)); end   
pause(2*eps);

StartInd = 1;
CloseInd = NumberOfImages;
BackgroundValue = 0;
for ImNum = StartInd:CloseInd

    % Read the current mask
    ImInp = imread([InImageFolder1 char(dirList(ImNum).name)]);
    NonNaNIndex = find(isnan(ImInp(:,:,1))==0);
    YesNaNIndex = find(isnan(ImInp(:,:,1))==1);
    [row, col, ch] = size(ImInp);
    
    %Background value: the mask can be black for bg and white for fg, or black for fg and white for bg.
    if ImNum==StartInd
        ValuesBorder = [];
        ValuesBorder = [ValuesBorder, ImInp(1,:)];
        ValuesBorder = [ValuesBorder, ImInp(end,:)];
        ValuesBorder = [ValuesBorder, ImInp(:,1)'];
        ValuesBorder = [ValuesBorder, ImInp(:,end)'];
        BackgroundValue = mode(double(ValuesBorder));
    end
    
    % Check mask
    if ch~=1
        errordlg(['The mask: "' dirList(ImNum).name '" in the folder "' InImageFolder1 '" is not a binary mask.'])
        return
    end
    Values = ImInp(NonNaNIndex);
    ValuesUnique = unique(Values);
    if length(ValuesUnique)>2
        errordlg(['The mask: "' dirList(ImNum).name '" in the folder "' InImageFolder1 '" is not a binary mask.'])
        return
    end
    if length(ValuesUnique)<1
        errordlg(['The mask: "' dirList(ImNum).name '" in the folder "' InImageFolder1 '" is not a binary mask.'])
        return
    end
    
    % Data extraction
    Servizio = zeros(row, col);
    Servizio(ImInp~=BackgroundValue) = 1;
    Servizio(YesNaNIndex) = 0;
    AreaValue = sum(sum(Servizio));

    DataMaskOri.ImageNames{ImNum,1} = char(dirList(ImNum).name);
    DataMaskOri.AreaPixels{ImNum,1} = AreaValue;
    
    % Help message wait
    if mod(ImNum,ModValue1)==0
        try close(BarWaitWindows); catch ME; end;
        pause(2*eps);
        Message = {'ANALYSIS OF ORIGINAL SECTIONS', ...
            ' ', ...
            ['Please wait... Completed: ' num2str(round(100*(ImNum/CloseInd))) '%']};
        BarWaitWindows = msgbox(Message, 'Message');
        child = get(BarWaitWindows,'Children'); 
        if isnumeric(child); delete(child(end)); else delete(child(1)); end   
        pause(2*eps);
    end 
    
end
try close(BarWaitWindows); catch ME; end;
clear ImInp NonNaNIndex YesNaNIndex Values Servizio

% Save tables
save(['OUTPUT' filesep 'DataMaskOri.mat'], 'DataMaskOri')


%% IMAGE INTERPOLATION
pixelZmicrometers = max([pixelXmicrometers, pixelYmicrometers]);
NumImageInterpolated = floor(gapZmicrometersOriginal/pixelZmicrometers); %Between two existing ORIGINAL SECTIONS.
pixelZmicrometersInt = gapZmicrometersOriginal/NumImageInterpolated;
if NumImageInterpolated>=1 % If z-gap < x-pixelSize is a problem!
    
    %% NO INTERPOLATION
    if interpolationMode == 1
        
        % Wait message
        try close(BarWaitWindows); catch ME; end;
        pause(2*eps);
        Message = {'ANALYSIS OF RECONSTRUCTED SECTIONS', ...
            ' ', ...
            ['Please wait... Completed: ' '1' '%']};
        BarWaitWindows = msgbox(Message, 'Message');
        child = get(BarWaitWindows,'Children'); 
        if isnumeric(child); delete(child(end)); else delete(child(1)); end   
        pause(2*eps);

        CounterA = 0;
        StartInd = 1;
        CloseInd = NumberOfImages;
        for ImNum = StartInd:CloseInd
            
            % Read the current mask
            ImInp = imread([InImageFolder1 char(dirList(ImNum).name)]);
            NonNaNIndex = find(isnan(ImInp(:,:,1))==0);
            YesNaNIndex = find(isnan(ImInp(:,:,1))==1);
            [row, col, ch] = size(ImInp);
            
            if ImNum==CloseInd
                EndInd = 1; %The last image can not be interpolated
            else
                EndInd = NumImageInterpolated;
            end
            for ImInt = 1:EndInd
                Servizio = zeros(row, col);
                Servizio(ImInp~=BackgroundValue) = 255;
                Servizio(YesNaNIndex) = 0;
                CounterA = CounterA+1;
                strnum = sprintf('%.7d',CounterA);
                ImIntName = ['tmpfold' filesep 'ImInt_' strnum '.tif'];
                imwrite(uint8(Servizio), ImIntName);
                %figure(1), imshow(uint8(Servizio), [], 'Border', 'Tight');
            end
            clear EndInd
            
            % Help message wait
            if mod(ImNum,ModValue1)==0
                try close(BarWaitWindows); catch ME; end;
                pause(2*eps);
                Message = {'ANALYSIS OF RECONSTRUCTED SECTIONS', ...
                    ' ', ...
                    ['Please wait... Completed: ' num2str(round(100*(ImNum/CloseInd))) '%']};
                BarWaitWindows = msgbox(Message, 'Message');
                child = get(BarWaitWindows,'Children'); 
                if isnumeric(child); delete(child(end)); else delete(child(1)); end   
                pause(2*eps);
            end 

        end
        clear CounterA ImInp NonNaNIndex YesNaNIndex Values Servizio
        try close(BarWaitWindows); catch ME; end;
        
        
    %% LINEAR INTERPOLATION
    elseif interpolationMode == 2
        zLinearInterpolation(InImageFolder1, ImageBaseName, InImageType, BackgroundValue, pixelXmicrometers, pixelYmicrometers, gapZmicrometersOriginal);       
    end
end


%% DATA EXTRACTION: INTERPOLATED IMAGES
dirListInt = dir(['tmpfold' filesep 'ImInt_*.tif']);
NumberOfImagesInt = length(dirListInt);
if ~isempty(NumberOfImagesInt) && ~isnan(NumberOfImagesInt) && NumberOfImagesInt>=1
    
    ModValue2 = round(NumberOfImagesInt/10);
    % Wait message
    try close(BarWaitWindows); catch ME; end;
    pause(2*eps);
    Message = {'DATA EXTRACTION', ...
        ' ', ...
        ['Please wait... Completed: ' '1' '%']};
    BarWaitWindows = msgbox(Message, 'Message');
    child = get(BarWaitWindows,'Children'); 
    if isnumeric(child); delete(child(end)); else delete(child(1)); end   
    pause(2*eps);
    
    StartIndInt = 1;
    CloseIndInt = NumberOfImagesInt;
    for ImNum = StartIndInt:CloseIndInt

        % Read the current mask
        ImInp = imread(['tmpfold' filesep char(dirListInt(ImNum).name)]);
        YesNaNIndex = find(isnan(ImInp(:,:,1))==1);
        [row, col, ch] = size(ImInp);

        % Data extraction
        Servizio = zeros(row, col);
        Servizio(ImInp~=BackgroundValue) = 1;
        Servizio(YesNaNIndex) = 0;
        AreaValue = sum(sum(Servizio));

        DataMaskInt.ImageNames{ImNum,1} = char(dirListInt(ImNum).name);
        DataMaskInt.AreaPixels{ImNum,1} = AreaValue;

        % Help message wait
        if mod(ImNum,ModValue2)==0
            try close(BarWaitWindows); catch ME; end;
            pause(2*eps);
            Message = {'DATA EXTRACTION', ...
                ' ', ...
                ['Please wait... Completed: ' num2str(round(100*(ImNum/CloseIndInt))) '%']};
            BarWaitWindows = msgbox(Message, 'Message');
            child = get(BarWaitWindows,'Children'); 
            if isnumeric(child); delete(child(end)); else delete(child(1)); end   
            pause(2*eps);
        end

    end
    try close(BarWaitWindows); catch ME; end;
    clear ImInp NonNaNIndex YesNaNIndex Values Servizio

    % Save tables
    save(['OUTPUT' filesep 'DataMaskInt.mat'], 'DataMaskInt')
end


%% VOLUME

% Volume mask interpolated
if isempty(NumberOfImagesInt) || isnan(NumberOfImagesInt) || NumberOfImagesInt<1
    VolumeIntMicrometers = 0;
elseif NumberOfImages == 0
    VolumeIntMicrometers = 0;
else
    clear DataMaskInt
    load(['OUTPUT' filesep 'DataMaskInt.mat'])
    try AreaInt = sum(cell2mat(DataMaskInt.AreaPixels(2:end-1,1))); catch ME; AreaInt = 0; end;
    AreaOriFirstImage = sum(cell2mat(DataMaskOri.AreaPixels(1:1,1)));
    AreaOriLastImage = sum(cell2mat(DataMaskOri.AreaPixels(end:end,1)));
    %VolumeIntMicrometers = AreaInt*pixelXmicrometers*pixelYmicrometers*pixelZmicrometersInt + AreaOriFirstImage*pixelXmicrometers*pixelYmicrometers*pixelZmicrometersInt/2 + AreaOriLastImage*pixelXmicrometers*pixelYmicrometers*pixelZmicrometersInt/2;
    VolumeIntMicrometers = AreaInt*pixelXmicrometers*pixelYmicrometers*pixelZmicrometersInt + AreaOriFirstImage*pixelXmicrometers*pixelYmicrometers*pixelZmicrometersInt + AreaOriLastImage*pixelXmicrometers*pixelYmicrometers*pixelZmicrometersInt;
end

% Volume final
VolumeCubicMicrometers = VolumeIntMicrometers;
AreaOri = sum(cell2mat(DataMaskOri.AreaPixels(1:end-1,1))); %The last must be not used
VolumeMicrometersGroundTruthNoInterpolation = AreaOri*pixelXmicrometers*pixelYmicrometers*gapZmicrometersOriginal; %DELETE


%% 3D RENDERING
GapPixels = 3; %3 by default % To speed up the 3D rendering: it keeps 1 pixels every X.
FullEveryNFrames = ceil(0.05*NumberOfImagesInt/GapPixels); % To improve the 3D rendering: it shows in full 1 frame every N.
if flagShowMesh == 1
    dirListInt = dir(['tmpfold' filesep 'ImInt_*.tif']);
    NumberOfImagesInt = length(dirListInt);
    
    ModValue3 = round(NumberOfImagesInt/10);
    
    % Help message wait
    try close(BarWaitWindows); catch ME; end;
    pause(2*eps);
    Message = {'3D RENDERING', ...
        ' ', ...
        ['Please wait... Completed: ' '1' '%']};
    BarWaitWindows = msgbox(Message, 'Message');
    child = get(BarWaitWindows,'Children'); 
    if isnumeric(child); delete(child(end)); else delete(child(1)); end   
    pause(2*eps);

    StartIndInt = 1;
    CloseIndInt = NumberOfImagesInt;
    
    xrow = [];
    ycol = [];
    z = [];
    fi = linspace(0.70,0.00,NumberOfImagesInt); %Colours
    f = [];
    counterA = 1;
    counterB = 1;
    counterC = 1;
    counterD = 0;
    for ImNum = StartIndInt:CloseIndInt
        %Point 3D computation
        
        counterD = counterD + 1; %total number of cycles done.
        
        % Read the current mask
        ImInp = imread(['tmpfold' filesep char(dirListInt(counterA).name)]);
        YesNaNIndex = find(isnan(ImInp(:,:,1))==1);
        [row, col, ch] = size(ImInp);

        % Image BW
        Servizio = zeros(row, col);
        Servizio(ImInp~=BackgroundValue) = 1;
        Servizio(YesNaNIndex) = 0;
        if ~isempty(GapPixels)
            if GapPixels>1
                Servizio2 = Servizio(1:GapPixels:end,1:GapPixels:end,1);
                clear Servizio
                Servizio = Servizio2;
            end
        end
        
        % FP2017/02/04: For a better visualization
        if counterA~=StartIndInt && counterA~=CloseIndInt
            if mod(counterD, FullEveryNFrames)~=0
                Servizio = bwperim(Servizio,8);
            end
        end
        %if counterA~=StartIndInt && counterA~=CloseIndInt
        %    Servizio = bwperim(Servizio,8);
        %end

        % Coordinates
        [xrowi,ycoli,chi] = find(Servizio==1);
        numPoints = length(xrowi);
        if numPoints>0
            zi = counterB.*(pixelZmicrometersInt/pixelZmicrometers).*ones(numPoints,1);
            xrow = [xrow; xrowi];
            ycol = [ycol; ycoli];
            z = [z; zi];
            f = [f; repmat(fi(counterA),[numPoints, 1])];
        end
        clear zi ycoli xrowi numPoints
        
        if ~isempty(GapPixels) && GapPixels>1
            counterA = counterA+round(GapPixels*pixelZmicrometers/pixelZmicrometersInt);
        else
            counterA = counterA+1;
        end
        counterB = counterB+1;
        
        if counterA==CloseIndInt
            counterC = counterC + 1;
        end
        if counterA>CloseIndInt
            if counterC==1
                counterC = counterC + 1;
                counterA = CloseIndInt;
            else
                break
            end
        end
        
        % Help message wait
        if mod(ImNum,ModValue3)==0
            try close(BarWaitWindows); catch ME; end;
            pause(2*eps);
            Message = {'3D RENDERING', ...
                ' ', ...
                ['Please wait... Completed: ' num2str(round(100*(counterA/CloseIndInt))) '%']};
            BarWaitWindows = msgbox(Message, 'Message');
            child = get(BarWaitWindows,'Children'); 
            if isnumeric(child); delete(child(end)); else delete(child(1)); end   
            pause(2*eps);
        end
    
    end
    try close(BarWaitWindows); catch ME; end;
    
    % Help message wait
    try close(BarWaitWindows); catch ME; end;
    pause(2*eps); 
    BarWaitWindows = msgbox('3D MESH IS COMING. Please, wait.', 'Message');
    child = get(BarWaitWindows,'Children'); 
    if isnumeric(child); delete(child(end)); else delete(child(1)); end   
    pause(2*eps);

    % 3D MESH SHOW
    figure,
    scatter3(xrow,ycol,z,1,[f, f, f]);
    daspect([1 1 1])
    set(gca, 'XTickLabel', []); set(gca, 'YTickLabel', []); set(gca, 'ZTickLabel', []); set(gcf,'Color','white')
    
    try close(BarWaitWindows); catch ME; end;
end
clear ImInp NonNaNIndex YesNaNIndex Servizio