%%%% Author - Aamir Abbasi
%%%% This script is used for splitting the video recorded using RV2 in to trials based on the WAVE channel 
%% Read video file and wave channels and then save every trial as a separate video file
clc; clear; close;
start = tic;
disp('running...');
root = 'Z:\Aamir\BMI\';
savepath = 'Z:\Aamir\BMI\';
cd(root);
bmiBlocks =  { 'I076\Data\I076-201201-120931\'...
              ,'I076\Data\I076-201202-112106\'...
              ,'I076\Data\I076-201203-113433\'...
              ,'I076\Data\I076-201205-112030\'...
              ,'I086\Data\I086-210507-104527\'...
              ,'I086\Data\I086-210511-120330\'...
              ,'I086\Data\I086-210512-134507\'...
              ,'I086\Data\I086-210513-121746\'...
              ,'I086\Data\I086-210514-104903\'...
              ,'I096\Data\I096-211102-112930\'...
              ,'I096\Data\I096-211103-122447\'...
              ,'I107\Data\I107-211208-151652\'...
              ,'I107\Data\I107-211209-145631\'...
              ,'I107\Data\I107-211210-121406\'}; 
          
for j=1:length(bmiBlocks)
  
  % display current block
  disp(bmiBlocks{j});
  
  % Read Wave channel
  W = dir([bmiBlocks{j},'WAV*.mat']);
  load([root, bmiBlocks{j},W.name]);
  if exist('wav','var') 
    WAVE = wav;
    clear wav
  end
  if exist('fs','var') 
    Fs = fs;
    clear fs
  end 
  
  % Get trials start markers
  [~,trial_start, rtrials_start,~] = fn_getPerformanceTimestamps(WAVE,Fs,0,0);
  trial_start = trial_start./Fs;
  rtrials_start = rtrials_start/Fs;

  % Make save path
  savedir = [savepath,bmiBlocks{j},'Videos\'];
  if ~exist(savedir, 'dir')
    mkdir(savedir);
  end
  
  % Read trials from the video files and save them into separate .avi files
  VID = dir([bmiBlocks{j},'*.avi']);
  vidpath = [root,bmiBlocks{j},VID.name];
  vR = VideoReader(vidpath);
  for t=1:length(trial_start)
    frames = read(vR,[round((trial_start(t)-2)*vR.FrameRate),round((trial_start(t)+20)*vR.FrameRate)]);
    if t<10
        vW = VideoWriter([savedir,'Trial_00',num2str(t),'.avi'],'Motion JPEG AVI');
    elseif t>=10 && t<100
        vW = VideoWriter([savedir,'Trial_0',num2str(t),'.avi'],'Motion JPEG AVI');        
    elseif t>=100
        vW = VideoWriter([savedir,'Trial_',num2str(t),'.avi'],'Motion JPEG AVI');        
    end
    vW.FrameRate = vR.FrameRate;
    open(vW);
    writeVideo(vW,frames);
    close(vW);
  end
  
end
runTime = toc(start);
disp(['done! time elapsed (minutes) - ', num2str(runTime/60)]);

%%