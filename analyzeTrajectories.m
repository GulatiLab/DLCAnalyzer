%% Read .mat files containing trajectory correlations
%  Author - Aamir Abbasi
%% --------------------------------------
clc;clear;close all;
start = tic;
disp('running...');
rootpath = 'Z:\Aamir\BMI\';
cd(rootpath);

bmiBlocks =  { 'I076\Data\I076-201201-120931'...
              ,'I076\Data\I076-201202-112106'...
              ,'I076\Data\I076-201203-113433'...
              ,'I076\Data\I076-201205-112030'...
              ,'I086\Data\I086-210507-104527'...
              ,'I086\Data\I086-210511-120330'...
              ,'I086\Data\I086-210512-134507'...
              ,'I086\Data\I086-210513-121746'...
              ,'I086\Data\I086-210514-104903'...
              ,'I096\Data\I096-211102-112930'...
              ,'I096\Data\I096-211103-122447'...
              ,'I107\Data\I107-211208-151652'...
              ,'I107\Data\I107-211209-145631'...
              ,'I107\Data\I107-211210-121406'};
          
tstart = [ 14,  6, 1, 1, 33, 56,  1,  1, 10, 25, 13, 11,  1,12];
tstop  = [139,141,49,92,267,124,150,177,207,101,102,130,110,70];

for j=1:length(bmiBlocks)
  
  % display current block
  disp(bmiBlocks{j});
  
  % Load cross-correlation data
  load([rootpath,bmiBlocks{j},'\CC_ForepawPipe_DLC.mat']);
  
  % Get valid trials
  mean_C = mean_C(tstart(j):tstop(j));
  mean_C = mean_C./sum(mean_C);  
  corrcoeff_R = corrcoeff_R(tstart(j):tstop(j));
  mean_sumC = mean_sumC(tstart(j):tstop(j));  
  
  % Split it into early and late trials and take mean
  eT(j) = mean(squeeze(mean_C(1:floor(size(mean_C,2)/3))));
  lT(j) = mean(squeeze(mean_C(end-floor(size(mean_C,2)/3)+1:end)));
 
end

% Plot mean across sessions
bar([mean(eT),mean(lT)]); hold on;
errorbar([1,2],[mean(eT),mean(lT)],[std(eT)/sqrt(length(eT)-1),std(lT)/sqrt(length(lT)-1)]);
plot([1,2],[eT',lT']);

% Stats 
[h,p] = ttest(eT,lT);
tbl = [[eT,lT]',[zeros(14,1);ones(14,1)],repmat([1 1 1 1 2 2 2 2 2 3 3 4 4 4]',2,1)];
tbl = array2table(tbl,'VariableNames',{'CC','EL','RatID'});
formula = 'CC ~ 1 + EL + (1 | RatID)';
lme = fitlme(tbl,formula);
disp(lme);

runTime = toc(start);
disp(['done! time elapsed (minutes) - ', num2str(runTime/60)]);

%% --------------------------------------
% Plot an example correlation trace
clc;clear;close all;
start = tic;
disp('running...');
rootpath = 'Z:\Aamir\BMI\';
cd(rootpath);
% bmiBlocks = {'I076\Data\I076-201201-120931\'...
%             ,'I076\Data\I076-201201-141645\'...
%             ,'I076\Data\I076-201202-112106\'...
%             ,'I076\Data\I076-201202-142652\'...
%             ,'I076\Data\I076-201203-113433\'...
%             ,'I076\Data\I076-201203-131642\'...
%             ,'I076\Data\I076-201204-121406\'...
%             ,'I076\Data\I076-201204-141944\'...
%             ,'I076\Data\I076-201205-112030\'...
%             ,'I076\Data\I076-201205-125511\'};
        
bmiBlocks =  { 'I076\Data\I076-201201-120931'...
              ,'I076\Data\I076-201202-112106'...
              ,'I076\Data\I076-201203-113433'...
              ,'I076\Data\I076-201205-112030'...
              ,'I086\Data\I086-210507-104527'...
              ,'I086\Data\I086-210511-120330'...
              ,'I086\Data\I086-210512-134507'...
              ,'I086\Data\I086-210513-121746'...
              ,'I086\Data\I086-210514-104903'...
              ,'I096\Data\I096-211102-112930'...
              ,'I096\Data\I096-211103-122447'...
              ,'I107\Data\I107-211208-151652'...
              ,'I107\Data\I107-211209-145631'...
              ,'I107\Data\I107-211210-121406'};
          
tstart = [ 14,  6, 1, 1, 33, 56,  1,  1, 10, 25, 13, 11,  1,12];
tstop  = [139,141,49,92,267,124,150,177,207,101,102,130,110,70];        

for j=1:length(bmiBlocks)
  
  % display current block
  disp(bmiBlocks{j});
  
  % Load cross-correlation data
  load([rootpath,bmiBlocks{j},'\CC_ForepawPipe_DLC.mat']);
  
  % Get valid trials
  mean_C = mean_C(tstart(j):tstop(j));
  mean_C = mean_C./sum(mean_C);
  corrcoeff_R = corrcoeff_R(tstart(j):tstop(j));  
  mean_sumC = mean_sumC(tstart(j):tstop(j));    
  
  % Split it into early and late trials and take mean
  plot(mean_C);
  pause;
 
end

runTime = toc(start);
disp(['done! time elapsed (minutes) - ', num2str(runTime/60)]);