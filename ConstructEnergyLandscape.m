function [BasinGraph, LocalMinIndex] = ConstructEnergyLandscape(roop)
 
 if (nargin > 0) && ~isempty(roop)
    InputFileName   = roop.InputFile;          % Input file name
    DataType        = roop.DataType;           % Input file data type  
    threshold       = roop.Threshold;          % Threshold
    OutputFolder    = roop.OutputFolder;       % Output folder 
    fRoi            = roop.fRoi;               % Flag of using ROI name file or not
    RoiNameFile     = roop.RoiFile;            % ROI name file
    fSaveBasinList  = roop.fSaveBasinList;   
else
%     %% Orig
InputFileName =  'S1172.dat';
%type 
    %disorganizedtype.dat
    %paranoidtype.dat
    %schizoaffective.dat
    %undifferentiated.dat
    %sz.dat
    %schizopheniform.dat
    %unspecified.dat
%       %% All files
% files =  dir('/Users/janerraallen/Documents/schizophrenia/BrainnetomeAtlas/AUD/orig/patient_results/ROI/*.dat');  % Get all of the files properties with a .dat extension
% load(files(1).name);
% % Sweep the rest of the files.
% for j=2:length(files)
%     load(files(j).name); % Load the files.
%     %InputFileName(j) = files(j).name  
% end 
  
% % %      %% sliding window
%       sliceNumber = 1;
%       load 'SlidingWin_fmri_S1350_slice1.mat';
%       InputFileName = slicedData(:,:,sliceNumber);
% %       InputFileName = slicedData(:,:);
% %       %InputFileName = slicedData;
    %% 
    DataType = 1;
    % Binarization threshold
    threshold = 0;
    % Output folder
    OutputFolder = [pwd '/output2/'];
    % Flag of using ROI name file or not
    fRoi = false;
    % ROI name filed
    RoiNameFile = [];
    % flag of save basin list or not
    fSaveBasinList = true;
end
 
BasinGraph = [];
LocalMinIndex = [];
 
% Connect Input Files if needed.
if iscell(InputFileName)
    nFiles = length(InputFileName);
else
    nFiles = 1;
    InputFileName = {InputFileName};
end
 
binarizedData = [];
for i=1:nFiles
    switch DataType
        case 1
            try
                %Statics
                originalData= importdata(InputFileName{i});
                
                %Dynamics
                %originalData= InputFileName{i};
            catch ME
                errordlg('Invalid Input File.');
                return;
            end
            %binarize
            tmpB = pfunc_01_Binarizer(originalData,threshold);
            binarizedData = [binarizedData, tmpB];
        case 2
            % Binarized data
            try
                tmpB =importdata(InputFileName{i});
            catch ME
                errordlg('Invalid Input File.');
                return;
            end
            binarizedData = [binarizedData, tmpB];
        otherwise
            errordlg('Invalid Data Type');
            return;
    end
end
 
%% Main part
[h,J] = pfunc_02_Inferrer_ML(binarizedData)
%%[h,J] = pfunc_02_Inferrer_PL(binarizedData);
[probN, prob1, prob2, rD, r] = pfunc_03_Accuracy(h, J, binarizedData);
% Calculate Energy
E = mfunc_Energy(h, J);
peaks(E);
 
%% Calculate Local Minima
nodeNumber = length(h);
[LocalMinIndex, BasinGraph, AdjacentList] = mfunc_LocalMin(nodeNumber, E);
 
%% Calculate Energy path by Dijkstra
[Cost, Path] = mfunc_DisconnectivityGraph(E, LocalMinIndex, AdjacentList);
 
%% Show activity pattern
if fRoi
    Name = importdata(RoiNameFile);
else
    Name = [];
end
    
vectorList = mfunc_VectorList(nodeNumber);
mfunc_ActivityMap(vectorList, LocalMinIndex, Name);
 
disp('ended')
 end