
% Example, select 'EXAMLPE_images to modify'
waitfor(msgbox('Select the BIDS data folder.'));
tochangefolder=uigetdir(path)

%%%%%%%%%%%%%%%%%%%%%%       START         %%%%%%%%%%%%%%%%%%%%
%cd(tochangefolder)
files = dir(tochangefolder);

dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);

% Print folder names to command window.
for k = 1 : length(subFolders)
    if contains(subFolders(k).name,'sub')
        % go into subject folder
        fprintf('Sub folder #%d = %s\n', k, subFolders(k).name);
        sesFolders = dir(strcat(tochangefolder,"/",subFolders(k).name));
        for s = 1 : length(sesFolders)
            if contains(sesFolders(s).name,'ses')
                % go into the session folder
                subfiles = dir(strcat(tochangefolder,"/",subFolders(k).name,"/",sesFolders(s).name,"/eeg"));
                for f = 1 : length(subfiles)
                    if contains(subfiles(f).name,'.set')
                        fprintf('Open Data = %s\n', subfiles(f).name);
                        %define the output dir
                        output_path = strcat(tochangefolder,'/',subFolders(k).name,'/',sesFolders(s).name,'/eeg/',subfiles(f).name(1:end-4),'.edf')

                        EEG = pop_loadset(subfiles(f).name,strcat(tochangefolder,'/',subFolders(k).name,'/',sesFolders(s).name,'/eeg') ); 
                        data = EEG.data;
                        srate = EEG.srate;
                        event = EEG.event;
                        label = {EEG.chanlocs.labels};
                        
                        %read the example json
                        tmp = split(subfiles(f).name,'_'); 
                        val = jsondecode(fileread('example.json'));

                        %fill in the new values
                        val.TaskName = tmp{length(tmp)-2};
                        val.SamplingFrequency = EEG.srate;
                        val.EEGChannelCount = EEG.nbchan;
                        val.RecordingDuration = EEG.pnts/EEG.srate;
                        val.EEGReference = EEG.ref;

                        jsontxt = jsonencode(val);
                        fid = fopen(strcat(tochangefolder,'/',subFolders(k).name,'/',sesFolders(s).name,'/eeg/',subfiles(f).name(1:end-4),'.json'),'w');
                        fprintf(fid,'%s',jsontxt);
                        fclose(fid);

                        writeeeg(output_path, data, srate, 'Label', label, 'EVENT', event, 'TYPE', 'EDF');

                        writeeeg(output_path, data, srate, 'Label', label, 'EVENT', event, 'TYPE', 'EDF');
                    end 
                end
            end
        end
    end
end


