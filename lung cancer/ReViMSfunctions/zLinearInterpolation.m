function zLinearInterpolation(InImageFolder1, ImageBaseName, InImageType, BackgroundValue, pixelXmicrometers, pixelYmicrometers, gapZmicrometersOriginal)
% AUTHOR: Filippo Piccinini (E-mail: f.piccinini@unibo.it)
% DATE: March 1, 2016
% NAME: zLinearInterpolation (version 1.0)
% 
% To linearly interpolate adjacent z-slices. This function has not an
% output because the images computed are automatically saved in a folder
% named "tmpfold".
%
% PARAMETERS:
% 	InImageFolder1  Absolute path of the folder containing the input
%                   masks.
%   ImageBaseName   Basename of the mask to be processed cannot contain 
%                   white spaces or special characters, and must be in the
%                   format: "BasenameMask_###.ImageFormat".
%   InImageType     Format of the input masks. Typically ".tif", ".tiff",
%                   ".bmp", ".jpg".
%   BackgroundValue Values of the background pixels in the binary mask.
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
% EXAMPLE OF USAGE:
%  zLinearInterpolation('C:\FPICCININI\Masks\','Masks_', '.tif', 0, 0.5, 0.5, 2, 2);
 
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


%% INTERNAL PARAMETER
flag_convexhull = 1;    %Una volta stimati i punti dati dalla interpolazione lineare in z, occorre unire i punti per creare un oggetto chiuso. flag_convexhull = 1 permette di velocizzare la computazione perdendo accuratezza perchè si perdono le insenature che vengono fittate dal convex hull.
coef_convexhull = 0.20; %Se flag_convexhull = 1, coef_convexhull ci da il grado di severità del convex hull. 0 indica un vero convex hull. 1 indica un fitting dei puntini (sconsigliato).


%% DATA EXTRACTION: ORIGINAL IMAGES
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


%% IMAGE INTERPOLATION
pixelZmicrometers = max([pixelXmicrometers, pixelYmicrometers]);
NumImageInterpolated = floor(gapZmicrometersOriginal/pixelZmicrometers); %Between two existing original images.

%if NumImageInterpolated>=1 % If z-gap < x-pixelSize is a problem!
CounterA = 0;
StartInd = 1;
CloseInd = NumberOfImages;
ModValue1 = round(CloseInd/10);

% Help message wait
try close(BarWaitWindows); catch ME; end;
pause(2*eps);
Message = {'ANALYSIS OF RECONSTRUCTED SECTIONS', ...
    ' ', ...
    ['Please wait... Completed: ' '1' '%']};
BarWaitWindows = msgbox(Message, 'Message');
child = get(BarWaitWindows,'Children'); 
if isnumeric(child); delete(child(end)); else delete(child(1)); end   
pause(2*eps);

for ImNum = StartInd:CloseInd-1

    if CounterA~=((ImNum-1)*NumImageInterpolated)
        error(['ERROR at image:' num2str(ImNum-1)])
    end

    % Read the current mask
    ImA = imread([InImageFolder1 char(dirList(ImNum).name)]);
    ImB = imread([InImageFolder1 char(dirList(ImNum+1).name)]);
    YesNaNIndexA = find(isnan(ImA(:,:,1))==1);
    YesNaNIndexB = find(isnan(ImB(:,:,1))==1);
    [row, col, ch] = size(ImA);

    ImABW = zeros(row, col);
    ImABW(ImA~=BackgroundValue) = 1;
    ImABW(YesNaNIndexA) = 0;
    PerimetroA = bwperim(ImABW,8);
    LabImA = bwlabel(ImABW);
    NumObjImA = max(LabImA(:));

    ImBBW = zeros(row, col);
    ImBBW(ImB~=BackgroundValue) = 1;
    ImBBW(YesNaNIndexB) = 0;
    LabImB = bwlabel(ImBBW);
    NumObjImB = max(LabImB(:));

    ImABBW = zeros(row, col);
    ImABBW(ImABW==1) = 1;
    ImABBW(ImBBW==1) = 1;

    CounterA = CounterA+1;
    strnum = sprintf('%.7d',CounterA);
    ImIntName = ['tmpfold' filesep 'ImInt_' strnum '.tif'];
    imwrite(uint8(ImABW.*255), ImIntName); %ATTENZIONE! Sostituire "ImABW" con "PerimetroA" per avere un controllo sul bordo delle immagini interpolate!
    clear ImIntName strnum

    if NumObjImA>=1 && NumObjImB>=1 && NumImageInterpolated>1

        ServizioT = zeros(row, col, NumImageInterpolated-1); % Sum of every object in ImageA

        % I set a cycle for to manage the different objects present in the mask
        for l=1:NumObjImA

            indLabLImA = find(LabImA==l);

            % If there are more objects also in ImageB I imposed the fitting to the one touching but with the largest area
            LabImBsovrapposte = LabImB(indLabLImA);
            LabImBsovrapposte = unique(LabImBsovrapposte);
            if ~isempty(LabImBsovrapposte)
                if LabImBsovrapposte(1) == 0
                    if length(LabImBsovrapposte)>=2
                        LabImBsovrapposte = LabImBsovrapposte(2:end);
                    else
                        LabImBsovrapposte = [];
                    end
                end
            end
            numLabImBsovrapposte = length(LabImBsovrapposte);
            if isempty(LabImBsovrapposte)
                % If the object in ImageA and the object in ImageB are not touching

                % ATTENZIONE: Sarebbe carino guardare dove è il
                % baricentro dell'oggetto in ImageB e spostare
                % ImageA linearmente verso il baricentro. Si può
                % anche peensare ad una dilatazione ed erosione per
                % ottenere le forme intermedie. Tra i vari oggetti 
                % di ImageB occorre guardare quello che ha il 
                % baricentro più vicino. NON FARLO! Altrimenti
                % quando si ha la ricostruzione top-to-bottom e
                % bottom-to-top diverse.

                c=1;
                %for c=1:NumImageInterpolated-1
                    BW = zeros(row, col);
                    %BW(indLabLImA) = 1; %Non ho ragionato se questa riga va commentata o meno
                    ServizioT(:,:,c) = ServizioT(:,:,c) + BW;
                    clear BW
                %end           

            else
                % If there is at least one object in ImageA that is touching with an object in ImageB

                PerimetroAObjL = zeros(row, col);
                PerimetroAObjL(indLabLImA) = 1;
                PerimetroAObjL = bwperim(PerimetroAObjL,8);
                [yrowPA, xcolPA] = find(PerimetroAObjL~=BackgroundValue);
                NumPointPA = length(yrowPA);

                for s=1:numLabImBsovrapposte
                    % Cycle for every touching object

                    ServizioL = zeros(row, col, NumImageInterpolated-1); % For every object in ImageA, sum of every object in ImageB

                    indLabLImB = find(LabImB==LabImBsovrapposte(s));

                    PerimetroBObjL = zeros(row, col);
                    PerimetroBObjL(indLabLImB) = 1;
                    PerimetroBObjL = bwperim(PerimetroBObjL,8);
                    [yrowPB, xcolPB] = find(PerimetroBObjL~=BackgroundValue);
                    NumPointPB = length(yrowPB);

                    for i=1:NumPointPA
                        yrowPAi = yrowPA(i);
                        xcolPAi = xcolPA(i);
                        yrowPBdif = abs(yrowPB-yrowPAi);
                        xcolPBdif = abs(xcolPB-xcolPAi);
                        distEuc = sqrt((xcolPBdif.^2)+(yrowPBdif.^2));
                        [minDistEucV, minDistEucI] = min(distEuc);
                        yrowPBi = yrowPB(minDistEucI);
                        xcolPBi = xcolPB(minDistEucI);
                        yrowPvector = round(linspace(yrowPAi,yrowPBi,NumImageInterpolated+1));
                        xcolPvector = round(linspace(xcolPAi,xcolPBi,NumImageInterpolated+1));
                        for j=1:NumImageInterpolated-1
                            ServizioL(yrowPvector(j+1), xcolPvector(j+1), j) = 1;
                        end
                        clear yrowPAi xcolPAi yrowPBdif xcolPBdif distEuc minDistEucV minDistEucI yrowPBi xcolPBi yrowPvector xcolPvector
                    end
                    for i=1:NumPointPB
                        yrowPBi = yrowPB(i);
                        xcolPBi = xcolPB(i);
                        yrowPAdif = abs(yrowPA-yrowPBi);
                        xcolPAdif = abs(xcolPA-xcolPBi);
                        distEuc = sqrt((xcolPAdif.^2)+(yrowPAdif.^2));
                        [minDistEucV, minDistEucI] = min(distEuc);
                        yrowPAi = yrowPA(minDistEucI);
                        xcolPAi = xcolPA(minDistEucI);
                        yrowPvector = round(linspace(yrowPAi,yrowPBi,NumImageInterpolated+1));
                        xcolPvector = round(linspace(xcolPAi,xcolPBi,NumImageInterpolated+1));
                        for j=1:NumImageInterpolated-1
                            ServizioL(yrowPvector(j+1), xcolPvector(j+1), j) = 1;
                        end
                        clear yrowPAi xcolPAi yrowPBdif xcolPBdif distEuc minDistEucV minDistEucI yrowPBi xcolPBi yrowPvector xcolPvector
                    end

                    % Una volta stimati i punti dati dalla interpolazione lineare in z, occorre unire i punti per creare un oggetto chiuso.
                    for c=1:NumImageInterpolated-1
                        if flag_convexhull == 0
                            %ATTENZIONE: Codice non finito!
                            % Computazione lentissima ma vengono rispettate tutte le insenature
                            ServizioC = ServizioL(:,:,c);
                            ServizioCPer = bwmorph(ServizioC,'remove');
                            counts = conv2(double(ServizioCPer), ones(3), 'same') >= 4;
                            EndPoints = bwmorph(ServizioCPer,'endpoints');
                            EndPoints(counts==1) = 0;
                            LabSerC = bwlabel(ServizioC);
                            NumSegmenti = 0;
                            NumSegmenti = max(LabSerC(:));
                            while NumSegmenti>1
                                for s=1:NumSegmenti
                                    areaSegmenti(s) = length(find(LabSerC==s));
                                end
                                [indMaxSegmentoVal, indMaxSegmentoInd] = max(areaSegmenti);
                                MaskSegmento1 = zeros(row, col);
                                MaskSegmento1(EndPoints==1) = 1;
                                MaskSegmento1(LabSerC~=indMaxSegmentoInd) = 0;
                                MaskOther = zeros(row, col);
                                MaskOther(EndPoints==1) = 1;
                                MaskOther(LabSerC==indMaxSegmentoInd) = 0;
                                [yrowEPi, xcolEPi] = find(MaskSegmento1==1);
                                yrowEPi = yrowEPi(1);
                                xcolEPi = xcolEPi(1);
                                [yrowEPt, xcolEPt] = find(MaskOther==1);
                                yrowEPdif = abs(yrowEPt-yrowEPi);
                                xcolEPdif = abs(xcolEPt-xcolEPi);
                                distEuc = sqrt((xcolEPdif.^2)+(yrowEPdif.^2));
                                [minDistEucV, minDistEucI] = min(distEuc);
                                yrowEPti = yrowEPt(minDistEucI);
                                xcolEPti = xcolEPt(minDistEucI);
                                ServizioC = linept(ServizioC, yrowEPi, xcolEPi, yrowEPti, xcolEPti);
                                %figure, imshow(ServizioC, [], 'Border', 'Tight');
                                clear EndPoints LabSerC xcolEPti yrowEPti minDistEucV minDistEucI xcolEPdif yrowEPdif yrowEPt xcolEPt yrowEPi xcolEPi
                                NumSegmenti = 0;
                                ServizioCPer = bwmorph(ServizioC,'remove');
                                counts = conv2(double(ServizioCPer), ones(3), 'same') >= 4;
                                clear EndPoints
                                EndPoints = bwmorph(ServizioCPer,'endpoints');
                                EndPoints(counts==1) = 0;
                                LabSerC = bwlabel(ServizioC);
                                NumSegmenti = max(LabSerC(:));
                            end
                            while sum(sum(EndPoints))>=2
                                %Close the last endpoints
                                [yrowEPt, xcolEPt] = find(EndPoints==1);
                                yrowEPi = yrowEPt(1);
                                xcolEPi = xcolEPt(1);
                                yrowEPt = yrowEPt(2:end);
                                xcolEPt = xcolEPt(2:end);
                                yrowEPdif = abs(yrowEPt-yrowEPi);
                                xcolEPdif = abs(xcolEPt-xcolEPi);
                                distEuc = sqrt((xcolEPdif.^2)+(yrowEPdif.^2));
                                [minDistEucV, minDistEucI] = min(distEuc);
                                yrowEPti = yrowEPt(minDistEucI);
                                xcolEPti = xcolEPt(minDistEucI);
                                ServizioC = linept(ServizioC, yrowEPi, xcolEPi, yrowEPti, xcolEPti);
                                %figure, imshow(ServizioC, [], 'Border', 'Tight');
                                ServizioCPer = bwmorph(ServizioC,'remove');
                                counts = conv2(double(ServizioCPer), ones(3), 'same') >= 4;
                                clear EndPoints
                                EndPoints = bwmorph(ServizioCPer,'endpoints');
                                EndPoints(counts==1) = 0;
                            end
                            ServizioC = imfill(ServizioC);
                            indServizioC = find(ServizioC~=BackgroundValue);
                            ServizioCT = zeros(row, col);
                            ServizioCT(indServizioC) = 1;
                            ServizioT(:,:,c) = ServizioT(:,:,c) + ServizioCT;
                            clear BWper BW indExt yrowSi indServizioC ServizioCT ServizioC
                        else
                            % Computazione veloce ma si perdono insenature a causa del convex hull
                            ServizioC = ServizioL(:,:,c);
                            [yrowSi, xcolSi] = find(ServizioC>0);
                            indExt = boundary(xcolSi,yrowSi,coef_convexhull);
                            BW = roipoly(ServizioC,xcolSi(indExt),yrowSi(indExt));
                            BW(ImABBW==0) = 0;
                            ServizioT(:,:,c) = ServizioT(:,:,c) + BW;
                            clear BW indExt yrowSi xcolSi ServizioC
                        end
                    end
                    clear ServizioL
                end
            end
        end
        for c=1:NumImageInterpolated-1
            CounterA = CounterA+1;
            strnum = sprintf('%.7d',CounterA);
            ImIntName = ['tmpfold' filesep 'ImInt_' strnum '.tif'];
            ServizioC = zeros(row, col);
            ServizioC(ServizioT(:,:,c)>0)=255;
            %figure, imshow(ServizioC, [], 'Border', 'Tight')
            imwrite(uint8(ServizioC), ImIntName);
            clear ImIntName strnum ServizioC
        end
        clear Servizio NumPointPB yrowPB xcolPB NumPointPA yrowPA xcolPA PerimetroB PerimetroA rowA colA chA YesNaNIndexB YesNaNIndexA ImB ImA
    else
        % If ImgA or ImgB are empty!
        for c=1:NumImageInterpolated-1
            CounterA = CounterA+1;
            strnum = sprintf('%.7d',CounterA);
            ImIntName = ['tmpfold' filesep 'ImInt_' strnum '.tif'];
            ServizioC = zeros(row, col);
            imwrite(uint8(ServizioC), ImIntName); %ATTENZIONE! Sostituire "ImABW" con "PerimetroA" per avere un controllo sul bordo delle immagini interpolate!
            clear ImIntName strnum ServizioC
        end
    end
    
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

try close(BarWaitWindows); catch ME; end;
%end

%First image
ImFirst = imread([InImageFolder1 char(dirList(1).name)]);
YesNaNIndex = find(isnan(ImFirst(:,:,1))==1);
ImFirstBW = zeros(row, col);
ImFirstBW(ImFirst~=BackgroundValue) = 255;
ImFirstBW(YesNaNIndex) = 0;
strnum = sprintf('%.7d',1); %Non ho ragionato se qui andrebbe messo ('%.7d',1) o ('%.7d',0)
ImIntName = ['tmpfold' filesep 'ImInt_' strnum '.tif'];
imwrite(uint8(ImFirstBW), ImIntName);
clear ImFirst YesNaNIndex ImFirstBW strnum ImIntName

%Last image
ImLast = imread([InImageFolder1 char(dirList(NumberOfImages).name)]);
YesNaNIndex = find(isnan(ImLast(:,:,1))==1);
ImLastBW = zeros(row, col);
ImLastBW(ImLast~=BackgroundValue) = 255;
ImLastBW(YesNaNIndex) = 0;
CounterA = CounterA+1;
strnum = sprintf('%.7d',CounterA);
ImIntName = ['tmpfold' filesep 'ImInt_' strnum '.tif'];
imwrite(uint8(ImLastBW), ImIntName);
clear ImLast YesNaNIndex ImLastBW strnum ImIntName