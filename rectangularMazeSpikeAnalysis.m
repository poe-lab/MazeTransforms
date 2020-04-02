function rectangularMazeSpikeAnalysis
mazeLength = 239.2; % Rectangular maze is 239.2 cm
binLength = 7.9733; % Bin length is set to default value of 3 cm.

% Call the linearized coordinate VT file name:
working_dir=pwd;
current_dir='C:\SleepData';
cd(current_dir);
[filename, pathname] = uigetfile('*.xls', 'Pick linearized VT file');
if isequal(filename,0) || isequal(pathname,0)
    uiwait(errordlg('You need to select a file. Please press the button again',...
        'ERROR','modal'));
    cd(working_dir);
else
    cd(working_dir);
    linearizedVTfile= fullfile(pathname, filename);
end
% Load the linear coordinate VT data = [Timestamp LinearizedCoordinate]
try
    vtData= xlsread(linearizedVTfile);
catch %#ok<*CTCH>
    uiwait(errordlg('Check if the file is saved in Microsoft Excel format.',...
        'ERROR','modal'));
end
vtData(:,1) = vtData(:,1)/1000000;
lengthVtData = size(vtData,1);

for i = 1:lengthVtData
    if isequal(vtData(i,2),0)
        vtData(i,2) = vtData(i-1,2);
    end
end
% [vtData] = mazeinterpolation(tempVtData)
% clear tempVtData

% Determining total number of distance intervals
ui = mazeLength/binLength;
vi = int32(ui);


% Cleaning up rounding errors, making sure z is a whole number
if ui > vi
    numberOfBins = vi + 3;
else
    numberOfBins = vi + 2;
end

% Shifting z from int32 to double so it can enter for-loop
numberOfBins = double(numberOfBins);

% Initializing distance interval arclength_array
interval = 0:binLength:(numberOfBins * binLength);
numberOfIntervals = length(interval);


% Assigning distance bins to timestamps from the VT file
for i = 1:numberOfIntervals
    for j = 1:lengthVtData
        if isequal(i, numberOfIntervals)
            if vtData(j,2) > interval(i)
                vtData(j,3) = interval(i); 
            end
        else
            if vtData(j,2) > interval(i) && vtData(j,2) <= interval(i + 1)
                vtData(j,3) = interval(i);         
            end
        end
    end
end

% Finding time intervals for each bin
binTimeIntervals = zeros(1,2);
binTimeIntervals(1,1) = vtData(1,3);
binTimeIntervals(1,2) = vtData(1,1);

nextInterval = zeros(1,2);
for i = 2:lengthVtData
    if (i < lengthVtData)
        if vtData(i,3) ~= vtData(i-1,3)
            nextInterval(1,1) = vtData(i,3);
            nextInterval(1,2) = vtData(i,1);
            binTimeIntervals = [binTimeIntervals; nextInterval]; %#ok<*AGROW>
        end
    elseif i == lengthVtData       
        nextInterval(1,1) = vtData(i,3);
        nextInterval(1,2) = vtData(i,1);
        binTimeIntervals = [binTimeIntervals; nextInterval];
    end
end
startVtTime = vtData(1,1);
endVtTime = vtData(end,1);

% Call the spike file name:
current_dir='C:\SleepData';
cd(current_dir);
[spikeFile, spikePath] = uigetfile({'*.ntt',...
        'Sorted Neuralynx Tetrode File (*.NTT)'},'Select a Spike Sorted Data File');
if isequal(spikeFile,0) || isequal(spikePath,0)
    uiwait(errordlg('You need to select a file. Please press the button again',...
        'ERROR','modal'));
    cd(working_dir);
else
    cd(working_dir);
    spikeFileName = fullfile(spikePath, spikeFile);
end

% Import Spike Data
[spikeTimestamps, spikeCellNumbers] = Nlx2MatSpike(spikeFileName, [1 0 1 0 0], 0, 1, [] );
nonZerosIndex = find(spikeCellNumbers);
spikeCellNumbers = spikeCellNumbers(nonZerosIndex);
spikeTimestamps = spikeTimestamps(nonZerosIndex);
clear nonZerosIndex
spikeTimestamps = spikeTimestamps/1000000;
AllSpikeIndices = find(spikeTimestamps > startVtTime & spikeTimestamps < endVtTime);
%This extracts the time stamps of spikes that are in the EEG file for the
%purpose of analyzing split files.
spikeTimestamps = spikeTimestamps(AllSpikeIndices);
spikeCellNumbers = spikeCellNumbers(AllSpikeIndices);
numberofUnits = max(spikeCellNumbers);
allSpikesDataArray = [spikeCellNumbers' spikeTimestamps'];
clear spikeCellNumbers spikeTimestamps

% binTimeIntervals = [x-coordinate binStartTime]
numBinTimeIntervals = size(binTimeIntervals, 1);
spikeCountPerBin = zeros(numBinTimeIntervals-1, numberofUnits);
firingRatePerBin = spikeCountPerBin;
timeInBin = diff(binTimeIntervals(:,2));

for i = 1:numBinTimeIntervals - 1
    indexSpikesInBin = find((allSpikesDataArray(:,2) >= binTimeIntervals(i,2)) & (allSpikesDataArray(:,2) < binTimeIntervals(i+1,2)));
    targetBinSpikes = allSpikesDataArray(indexSpikesInBin,1); %#ok<*FNDSB>
    for j = 1:numberofUnits
        spikeCountPerBin(i,j) = length(find(targetBinSpikes==j)); % # of spikes for a given unit/neuron that fired during time bin
        firingRatePerBin(i,j) = spikeCountPerBin(i,j)/timeInBin(i); % Firing rate of a given unit/neuron for each time bin
    end   
end


% Write all Results to an Excel file:

%Request user input to name the file:
prompt = {'File name for results:'};
def = {'Rat_TT_MazeType_Laps'};
dlgTitle = 'Save Results';
lineNo = 1;
answer = inputdlg(prompt,dlgTitle,lineNo,def);
filenameUserInput = char(answer(1,:));
dateString = date;
timeSaved = clock;
timeSavedString = [num2str(timeSaved(4)) '-' num2str(timeSaved(5))];
resultsFilename = strcat('C:\SleepData\', filenameUserInput, '_', dateString, '_', timeSavedString, '.xls');
clear timeSaved timeSavedString filenameUserInput
%Request user input to name the file:
prompt = {'Enter user name:'};
def = {'Your name'};
dlgTitle = 'User Name';
lineNo = 1;
answer = inputdlg(prompt,dlgTitle,lineNo,def);
username = char(answer(1,:));
warning off MATLAB:xlswrite:AddSheet

%Write all file names used for analyses to the 'headerInfo' sheet:
headerArray = {'Date_of_Analysis', dateString; 'User_Name', username;...
    'Tetrode_File', spikeFileName; 'Cleaned_VT_File', linearizedVTfile; 'Bin_Size', binLength};
sheetName = 'HeaderInfo';
xlswrite(resultsFilename,headerArray, sheetName);
clear headerArray username prompt def lineNo answer spikeFileName linearizedVTfile dateString

%Write column headers for results to the 'binStartTS' sheet:
sheetName = 'binStartTS';
columnHeaders = {'BinCoordinate', 'BinStartTS'};
xlswrite(resultsFilename,columnHeaders, sheetName, 'A1');
clear columnHeaders

%Write results to the 'binStartTS' sheet:
xlswrite(resultsFilename,binTimeIntervals, sheetName, 'A2');

%Write column headers for results to the 'spikeCounts' sheet:
sheetName = 'spikeCounts';
columnHeaders = {'BinCoordinate', 'TimeinBin'};
xlswrite(resultsFilename,columnHeaders, sheetName, 'A1');
clear columnHeaders
unitHeaders = 1:1:numberofUnits;
%Write results to the 'spikeCounts' sheet:
xlswrite(resultsFilename,unitHeaders, sheetName, 'C1');
%Write results to the 'spikeCounts' sheet:
xlswrite(resultsFilename,[binTimeIntervals(1:end-1,1) timeInBin spikeCountPerBin], sheetName, 'A2');

%Write column headers for results to the 'spikeFrequencies' sheet:
sheetName = 'spikeFrequencies';
columnHeaders = {'BinCoordinate'};
xlswrite(resultsFilename,columnHeaders, sheetName, 'A1');
clear columnHeaders
%Write results to the 'spikeFrequencies' sheet:
xlswrite(resultsFilename,unitHeaders, sheetName, 'B1');
%Write results to the 'spikeFrequencies' sheet:
xlswrite(resultsFilename,[binTimeIntervals(1:end-1,1) firingRatePerBin], sheetName, 'A2');



