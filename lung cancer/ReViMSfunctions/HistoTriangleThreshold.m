function BinThresh = HistoTriangleThreshold(HistoCountVector, PeakRightOrLeft, TailRightOrLeft, version)
% AUTHOR: Filippo Piccinini (f.piccinini@unibo.it)
% DATE: 03 December 2013
% NAME: HistoTriangleThreshold (version 1.0)
% 
% A line is constructed between the Peak (called point P1) of the first
% distribution detected (scanning the histogram "HistoCountVector" from
% right or left according to the flag "PeakRightOrLeft") and the most
% esternal point (called P2) of the "HistoCountVector" in the right or left
% tail (according to the flag "TailRightOrLeft"). The distance L normal to
% the line and between the line and the histogram "HistoCountVector" is
% computed for all values from P1 to P2. The level where the distance
% between the histogram and the line is maximal is the threshold value
% suggested ("BinThresh") to cut of the Peak of the distribution. This is
% an implementation of the Triangle Method proposed by Zack GW, Rogers WE, 
% Latt SA (1977), "Automatic measurement of sister chromatid exchange 
% frequency", J. Histochem. Cytochem. 25 (7): 741–53.
%
% PARAMETERS:
%  HistoCountVector Vector [1, n]. Histogram of the gray level image. In x
%                   the bins, in y the counts.
%  PeakRightOrLeft  Flag used to estimate the point P1. It can be 'Right'
%                   or 'Left'. If "PeakRightOrLeft" == 'Right' the first 
%                   Peak starting scanning from the right of the vector 
%                   is detected. 
%  TailRightOrLeft  Flag used to estimate the point P2. It can be 'Right'
%                   or 'Left'. If "TailRightOrLeft" == 'Right' the first 
%                   non zero value starting scanning from the right of the 
%                   vector is detected.
%  version          00 = the most esternal point of the histogram is set 
%                   to 0 and the threshold is estimated not considering 
%                   other peaks near the one detected.
%                   01 = the most esternal point of the histogram is kept 
%                   as it is and the threshold is estimated not considering 
%                   other peaks near the one detected.
%                   10 = the most esternal point of the histogram is set 
%                   to 0 and the threshold is estimated considering also
%                   the other peaks near the one detected. 
%                   11 = the most esternal point of the histogram is kept 
%                   as it is and the threshold is estimated considering 
%                   also the other peaks near the one detected. 
%
% OUTPUT:
%  BinThresh        Bin of the histogram suggested as threshold value.
%
% USAGE:
%  BinThresh = FP_HistoTriangleThresh(HistoCountVector, 'Right', 'Left', 0);
%
% See also graythresh

% CVG (Computer Vision Group) Toolbox
% Copyright © 2012 Filippo Piccinini, Alessandro Bevilacqua, 
% Advanced Research Center on Electronic Systems (ARCES), 
% University of Bologna, Italy. All rights reserved.
%
% This program is free software; you can redistribute it and/or modify it 
% under the terms of the GNU General Public License version 2 (or higher) 
% as published by the Free Software Foundation. This program is 
% distributed WITHOUT ANY WARRANTY; without even the implied warranty of 
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
% General Public License for more details.

% Check input parameters
if strcmp(PeakRightOrLeft,'Right')
    PeakROrL = 1;
else
    PeakROrL = 2;
end

if strcmp(TailRightOrLeft,'Right')
    TailROrL = 1;
else
    TailROrL = 2;
end

version = uint8(version);

% Find the local maximums.
[row, col, ch] = size(HistoCountVector);
if row ~= 1 && col == 1
    HistoCountVector = HistoCountVector';
    [row, col, ch] = size(HistoCountVector);
end

DerivativesForvard = HistoCountVector(2:col) - HistoCountVector(1:col-1);
DerivativesForvard = [0, DerivativesForvard];
LocalMaximums = zeros(1,col);
for i = 1:col-1
    if DerivativesForvard(i)>=0 && DerivativesForvard(i+1)<0
        LocalMaximums(i) = HistoCountVector(i);
    end
end

% Clean LocalMaximums
LocalMaximums(LocalMaximums<(max(LocalMaximums)/10)) = 0;

% Find the Peak of the different distributions
Arm = 5; % size of the search window
for i = 1:col-Arm
    if LocalMaximums(i)~=0
        for j = 1:Arm
            if LocalMaximums(i)<LocalMaximums(i+j)
                LocalMaximums(i) = 0;
            end
        end
    end
end
    
% Find the bin of the intresting peak (P1)
[Peaks, PosPeaks] = find(LocalMaximums>0);
if isempty(PosPeaks)
    BinThresh = 0;
    return
end
if PeakROrL == 1
    P1 = PosPeaks(end);
else
    P1 = PosPeaks(1);
end
ValueP1 = HistoCountVector(P1);

% Find the bin of the tail (P2)
HistoCountVector(HistoCountVector<(ValueP1/1000)) = 0;
[HistValues, PosNonZero] = find(HistoCountVector>0);
if TailROrL == 1
    P2 = PosNonZero(end);
else
    P2 = PosNonZero(1);
end
if P1==P2
    BinThresh = P1;
    return
end
if version == 0 || version == 10
    ValueP2 = 0;
else
    ValueP2 = HistoCountVector(P2);
end
    
% Find for each pixel between [P1, P2] the length of the distance L normal 
% to the line [P1, P2]
minLengthAltezza = 3; %pixels
nonCleanWindow = 10; %pixels 
Altezze = zeros(1,col);
Ipotenusa = sqrt(abs(ValueP1 - ValueP2).^2 + abs(P2-P1)^2);
if P1<P2
    ValueIpotenusa = [zeros(1, P1) linspace(ValueP1, ValueP2, abs(P2-P1))];
    for i = P1:P2-1
        %if version == 0 || version == 1
            if ValueIpotenusa(i) < HistoCountVector(i)
                Altezze(i) = 0;
            else
                Cateto1 = sqrt(abs(i-P1).^2 + abs(ValueP1 - HistoCountVector(i)).^2);
                Cateto2 = sqrt(abs(P2-i).^2 + abs(HistoCountVector(i) - ValueP2).^2);
                SemiPerimetro = (Ipotenusa + Cateto1 + Cateto2)/2;
                Area = sqrt(SemiPerimetro*(SemiPerimetro-Ipotenusa)*(SemiPerimetro-Cateto1)*(SemiPerimetro-Cateto2));
                Altezza = (Area*2)/Ipotenusa;
                Altezze(i) = Altezza;
            end
        %end
    end
    if version == 10 || version == 11
        % Clean values related to other peaks maybe present
        [cleanVal cleanPos] = find(Altezze(P1+nonCleanWindow:P2)<minLengthAltezza);
        if ~isempty(cleanPos)
            cleanPo = cleanPos(1);
        else
            cleanPo = 0;
        end
        Altezze(P1+nonCleanWindow+cleanPo:P2) = 0;
    end
else
    ValueIpotenusa = [zeros(1, P2) linspace(ValueP2, ValueP1, abs(P2-P1))];
    for i = P2:P1-1
        %if version == 0 || version == 1
            if ValueIpotenusa(i) < HistoCountVector(i)
                Altezze(i) = 0;
            else
                Cateto1 = sqrt(abs(i-P1).^2 + abs(ValueP1 - HistoCountVector(i)).^2);
                Cateto2 = sqrt(abs(P2-i).^2 + abs(HistoCountVector(i) - ValueP2).^2);
                SemiPerimetro = (Ipotenusa + Cateto1 + Cateto2)/2;
                Area = sqrt(SemiPerimetro*(SemiPerimetro-Ipotenusa)*(SemiPerimetro-Cateto1)*(SemiPerimetro-Cateto2));
                Altezza = (Area*2)/Ipotenusa;
                Altezze(i) = Altezza;
            end
        %end
    end
    if version == 10 || version == 11
        % Clean values related to other peaks maybe present
        [cleanVal cleanPos] = find(Altezze(P2:P1-nonCleanWindow)<minLengthAltezza);
        if ~isempty(cleanPos)
            cleanPo = cleanPos(end);
        else
            cleanPo = 0;
        end
        Altezze(P2:P2+cleanPo) = 0;
    end
end
if max(Altezze)==0
    BinThresh = P1;
    return
end
[Val, BinThresh] = find(max(Altezze)==Altezze); 

    
   