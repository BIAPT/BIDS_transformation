
% Example, select 'EXAMLPE_images to modify'
waitfor(msgbox('Select the BIDS data folder.'));
tochangefolder=uigetdir(path)

%need to run this to avoid error
x = fileparts( which('sopen') );
rmpath(x);
addpath(x,'-begin');

%%%%%%%%%%%%%%%%%%%%%%   START         %%%%%%%%%%%%%%%%%%%%
%cd(tochangefolder)
files = dir(tochangefolder);

dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);

% Print folder names to command window.
for k = 1 : length(subFolders)
    if contains(subFolders(k).name,'sub')
        fprintf('Sub folder #%d = %s\n', k, subFolders(k).name);
        subfiles = dir(strcat(tochangefolder,"/",subFolders(k).name,"/eeg"));
    
        for s = 1 : length(subfiles)
            if contains(subfiles(s).name,'.set')
                fprintf('Open Data = %\n', subfiles(s).name);
                output_path = strcat(tochangefolder,'/',subFolders(k).name,'/eeg/',subfiles(s).name(1:end-4),'.edf')
                
                EEG = pop_loadset(subfiles(s).name,strcat(tochangefolder,'/',subFolders(k).name,'/eeg') ); 
                data = EEG.data;
                srate = EEG.srate;
                event = EEG.event;
                label = {EEG.chanlocs.labels};
                
                %read the example json
                tmp = split(subfiles(s).name,'_');
                val = jsondecode(fileread('example.json'));
                
                %fill in the new values
                val.TaskName = tmp{length(tmp)-1};
                val.SamplingFrequency = EEG.srate;
                val.EEGChannelCount = EEG.nbchan;
                val.RecordingDuration = EEG.pnts/EEG.srate;
                val.EEGReference = EEG.ref;
                
                jsontxt = jsonencode(val);
                fid = fopen(strcat(tochangefolder,'/',subFolders(k).name,'/eeg/',subfiles(s).name(1:end-4),'.json'),'w');
                fprintf(fid,'%s',jsontxt);
                fclose(fid);
                
                writeeeg(output_path, data, srate, 'Label', label, 'EVENT', event, 'TYPE', 'EDF');
            end 
        end
    end
end


