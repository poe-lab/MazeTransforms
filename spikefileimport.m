function [data] = spikefileimport(spike_file_directory)

sep = filesep;
extension = '*.txt';
filepath = [spike_file_directory sep extension];
filenames = dir(filepath);
filepath_array = {length(filenames),1};
data = cell(length(filenames),2);

k = 0;
while k < length(filenames)
    k = k + 1;
    filepath_array{k} = [spike_file_directory sep filenames(k).name];
    [path{k},name{k}] = fileparts(filepath_array{k});
    data{k,2} = importdata(filepath_array{k}); 
end

for k = 1:length(name)
    data{k,1} = name{k};
end

end

