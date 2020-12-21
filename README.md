# BIDS-Transformation

### preparation

1. prepare the folder structure

2. fill in the sourcedata with the .mff files

3. fill in the corresponding .set .fdt files

4. open the example.json in your cloned repo and change the values to correspond to your default. 

   see here the documentation of the BIDS .json file: https://bids-specification.readthedocs.io/en/stable/04-modality-specific-files/03-electroencephalography.html



## run the script

1. open Matlab (I have used 2018b but it should work for others too)

2. make sure EEGLAB is installed

3. open eeglab by typing `eeglab`

4. close it again (this is to make sure the paths are set correctly and the functions are accessible) 

5. select the script depending on: 

   - when you have different session use the session one:

     `BIDS_SET_To_EDF_session.m`

   - when you only have different tasks, but just one session per participant use `BIDS_SET_To_EDF.m` (this means that every "eeg" folder contains the data directly and no "ses" folder

6. run the script
7. select the folder
8. verify everything run properly

## what is the code doing? 

+ go through all subfolders
+ open the .set files it finds
+ save these files as .edf
+ modify the following values in the .json: 
  + TaskName 
  + SamplingFrequency 
  + EEGChannelCount 
  + RecordingDuration 
  + EEGReference

