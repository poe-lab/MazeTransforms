function [] = RectangleMazeTransform(...
    bin_length,...
    maze_length,...
    VTdatafilepath,...
    TTdirectory,...
    output_filepath)
%==========================================================================
% rectangleMT.m
%==========================================================================

%===================================
% INPUTS
%===================================
% directory   --> spike file directory
% output      --> output filepath
% VTdata      --> TS, maze position
% bin length  --> in cm (default = 3cm)
% maze length --> should be constant, find a measure of it (239.2cm)
%===================================
% PROCEDURE
%===================================
% same as MT, but no center-finding, etc.
% interpolation should still be there
%==========================================================================

VTdata = xlsread(VTdatafilepath);
% v(:,2) = velocity(VTdata);
% v(:,1) = VTdata(:,1);

%=====================================
% SPIKE FILE IMPORT
%=====================================
[TT_cell] = spikefileimport(TTdirectory);

% Scans VT timestamps paired with maze position for gaps greater than 1 cm then fills them
[interp_VT_data] = mazeinterpolation(VTdata);

%=====================================
% BIN MARKING/SORTING
%=====================================
% Determining total number of distance intervals
ui = maze_length/bin_length;
vi = int32(ui);

% Cleaning up rounding errors, making sure z is a whole number
if ui > vi
    number_of_bins = vi + 3;
else
    number_of_bins = vi + 2;
end

% Shifting z from int32 to double so it can enter for-loop
number_of_bins = double(number_of_bins);

% Initializing distance interval arclength_array
interval = 0:bin_length:(number_of_bins*bin_length);

% Assigning distance bins to timestamps from the VT file
for bi = 1:length(interval) 
    for ci = 1:length(interp_VT_data(:,1))
        if bi ~= length(interval)
            if interp_VT_data(ci,2) > interval(bi) && interp_VT_data(ci,2) <= interval(bi + 1)
                interp_VT_data(ci,3) = interval(bi);
                
            end
        else
            if interp_VT_data(ci,2) > interval(bi)
                interp_VT_data(ci,3) = interval(bi);
                
            end
        end
    end
end

% Initializing di for below

li = length(interp_VT_data(:,1));


di = 0; 
for ci = 1:li 
    if (ci ~= 1) && (ci ~= li)
        if interp_VT_data(ci,3) ~= interp_VT_data(ci-1,3)
            di = di + 1;                    
        end
    elseif ci == 1
        di = di + 1;        
    elseif ci == li
        di = di + 1;
    end
end

interval_array = zeros(di,2);

% Finding distance interval VT_TS brackets
di = 0;
for ci = 1:li 
    if (ci ~= 1) && (ci ~= li)
        if interp_VT_data(ci,3) ~= interp_VT_data(ci-1,3)
            di = di + 1;        
            interval_array(di,1) = interp_VT_data(ci,3);
            interval_array(di,2) = interp_VT_data(ci,1);
        end
    elseif ci == 1
        di = di + 1;        
        interval_array(di,1) = interp_VT_data(ci,3);
        interval_array(di,2) = interp_VT_data(ci,1);
    elseif ci == li
        di = di + 1;        
        interval_array(di,1) = interp_VT_data(ci,3);
        interval_array(di,2) = interp_VT_data(ci,1);
    end
end

%=====================================
% CELL MANIPULATION
%=====================================
% Spike count per VT_TS/interval bracket
lii = length(interval_array(:,1));
spike_count_cell = cell(length(TT_cell(:,2)),1);
for k = 1:length(TT_cell(:,2))
    spike_count_array = zeros(lii,1);
    TT_TS = TT_cell{k,2};  
    for l = 1:length(interval_array(:,1))-1
        for m = 1:length(TT_TS)
            if (TT_TS(m) >= interval_array(l,2)) && (TT_TS(m) < interval_array(l+1,2))
                spike_count_array(l,1) = spike_count_array(l,1) + 1;
            end
        end
    end
    spike_count_cell{k,1} = spike_count_array;
end
            
% Frequency, total time
avg_freq_cell = cell(length(TT_cell(:,2)),1);
total_time_cell = cell(length(TT_cell(:,2)),1);
for k = 1:length(TT_cell(:,2))
    spike_count(:,1) = spike_count_cell{k,1};
    avg_freq_array = zeros(lii,1);
    total_time_array = zeros(lii,1);
    for l = 1:lii-1
        avg_freq_array(l) = spike_count(l)/((interval_array(l+1,2)-interval_array(l,2))/10^6);
        total_time_array(l) = ((interval_array(l+1,2)-interval_array(l,2))/10^6);
    end
    avg_freq_cell{k,1} = avg_freq_array;
    total_time_cell{k,1} = total_time_array;
end

% Sorting data by interval
sorted_cell = cell(length(TT_cell(:,2)),1);
for k = 1:length(TT_cell(:,2))
    array = zeros(lii,5);
    array(:,1) = interval_array(:,1);
    array(:,2) = interval_array(:,2);
    array(:,3) = total_time_cell{k,1};
    array(:,4) = spike_count_cell{k,1};
    array(:,5) = avg_freq_cell{k,1};
    array = sortrows(array,1);
    sorted_cell{k,1} = array;
end

% interval_array:
% 1 = bin
% 2 = TS
% 3 = SpikeCount
% 4 = avgfreq
% 5 = total time

% finalizing output
bin_cell = cell(length(TT_cell(:,2)),1);
for k = 1:length(TT_cell(:,2))
    sorted_array = sorted_cell{k,1};
    bin_array = zeros(length(interval),4);
    bin_array(:,1) = interval;
    for l = 1:length(interval);
        for m = 1:length(sorted_array);
            if sorted_array(m,1) == interval(l);
                bin_array(l,2) = bin_array(l,2) + sorted_array(m,3);
                bin_array(l,3) = bin_array(l,3) + sorted_array(m,4);
            end
        end
        bin_array(l,4) = bin_array(l,3)/bin_array(l,2);
    end
    bin_cell{k,1} = bin_array;
end
        

%=====================================
% DATA OUTPUT
%=====================================
% Writing excel Output
warning off MATLAB:xlswrite:AddSheet;
%xlswrite(output_filepath,interp_VT_data,'VT timestamps & bins');
xlswrite(output_filepath,[interp_VT_data(:,1) interp_VT_data(:,2)],'Bin & Occupancy Time');
%xlswrite(output_filepath,f_array,'Final Output');
for k = 1:length(TT_cell(:,2))
    excel_array_f = zeros(length(interval)-2,4);
    excel_array_i = bin_cell{k,1};
    excel_array_f(:,1) = excel_array_i(1:length(excel_array_i(:,1))-2,1);
    excel_array_f(:,2) = excel_array_i(1:length(excel_array_i(:,1))-2,2);
    excel_array_f(:,3) = excel_array_i(1:length(excel_array_i(:,1))-2,3);
    excel_array_f(:,4) = excel_array_i(1:length(excel_array_i(:,1))-2,4);
    xlswrite(output_filepath,excel_array_f,TT_cell{k,1}(end-29:end));
end
% deleting standard excel worksheets
delete_std_xls_ws(output_filepath);


%=====================================
% PLOT OUTPUT
%=====================================
plot_array = bin_cell{1,1};
figure1 = figure;
axes1 = axes('Parent',figure1);
box(axes1,'on');
hold(axes1,'all');
plot(plot_array(:,1),plot_array(:,2));
xlabel('Track Position (cm)');
ylabel('Occupancy (s)');
title('Position vs. Occupancy');

for k = 1:length(TT_cell(:,2))
    eval(['figure' num2str(k) ' = figure;']);
    eval(['axes' num2str(k) ' = axes(''Parent'',figure' num2str(k) ');']);
    eval(['box(axes' num2str(k) ',''on'');']);
    eval(['hold(axes' num2str(k) ',''all'');']);
    eval(['plot_array' num2str(k) ' = bin_cell{k,1};']);
    eval(['fp' num2str(k) ' = plot(plot_array' num2str(k) '(:,1),plot_array' num2str(k) '(:,4));']);
    plottitle = regexprep(TT_cell{k},'_','-');
    title(plottitle);
end     

end

