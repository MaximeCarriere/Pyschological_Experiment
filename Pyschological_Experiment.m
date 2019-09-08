function [output_f] = coursework(id)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                         %   Psychological_Experiment  %
                         %          N-Back Task       %

                    
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% INPUTS
% id = id number (use two digits, eg '01')

%% SCREEN
Screen('Preference', 'SkipSyncTests', 1); 
screens=Screen('Screens');
screenNumber=max(screens);
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
[w, wRect]=Screen('OpenWindow',screenNumber, white);
[width, height]=Screen('WindowSize', w, []);
 

%% COLOUR PARAMETERS 
colourrgb=000;

%% ISI DURATION
isi_dur =2.0;

%% STIM DURATIONS
std_interval =.5; 

%% CROSS FIXATION
[xCenter, yCenter] = RectCenter(wRect);
fixCrossDimPix = 40;
xCoords = [-fixCrossDimPix fixCrossDimPix 0 0];
yCoords = [0 0 -fixCrossDimPix fixCrossDimPix];
allCoords = [xCoords; yCoords];
lineWidthPix = 4;

%% NUMBER OF TRIALS & BLOCKS
% Unfortunatly the number of blocks cannot be changed 
blocknum= 2;    % number of blocks 
trialnum= 10 ;     % number of trials 
%% RESPONSE OPTIONS
resp_options = 'E (YES)     O(NO)';

%% TIME & DATE STAMP (for output file)
timeday_stamp=datestr(clock);
time_stamp=str2num([timeday_stamp(end-7:end-6) timeday_stamp(end-4:end-3) timeday_stamp(end-1:end)]);
day_stamp=datenum(date);


%% STIMULUS MATRIX
% first column for different stimulis : 0-1-2-3-4-5-6-7-8-9
% second column : even = 1; odd =2
stim_mat=[0 2; 1 1; 2 2 ;3 1; 4 2; 5 1; 6 2; 7 1;8 2; 9 1 ];

 % repeat matrix based on number of trials for block 1
stim_mat=repmat(stim_mat,trialnum/size(stim_mat,1),1);


 %% PERMUTATION OF MATRIX & SETTING UP BLOCKS
 for bn=1:blocknum
    blocks_mat((trialnum *bn-(trialnum-1)):trialnum*bn,:)=stim_mat(randperm(size(stim_mat,1)),:);
 end

%% KEYBOARD CHECK & WINDOW PRIORITY
KbCheck;
WaitSecs(0.01);
Priority(MaxPriority(w));

%% TASK VERSIONS & INSTRUCTIONS
% main instructions
task_instruction_1='You have to judge whether the stimulus parity (even/odd) is the same as the parity of the stimulus presented 2 trials before \n\n Press strongly O for NO, E for YES.\n \nPress any key to begin to begin.';
% between-block instructions
task_instruction_2='You have to judge whether the stimulus parity (even/odd) is the same as the parity of the stimulus presented 3 trials before \n\n Press strongly O for NO, E for YES. \n \nPress any key to begin to begin.';

%% PREPARE OUTPUT
%%%%%%%%%% CHANGE THE NEXT LINE (less specific) %%%%%%%%%%%%%%%%%%%%%
output = zeros(trialnum,4)
resp_1 = zeros(trialnum,1)'
kbNameResult = zeros(1,1)
        



%% EXPERIMENTAL TRIALS
% specify starting points for blocks
blocktrialstarts=1:trialnum:size(blocks_mat,1);

% For loop for block
for blocks = 1:blocknum
    % specifying block of trials
    blockstim = blocks_mat(blocktrialstarts(blocks):blocktrialstarts(blocks)+(trialnum-1),:);
    
    
%% PRESENT INSTRUCTIONS


Screen('TextSize', w, 22);
Screen('TextFont', w, 'Arial');

if  mod(blocks,2)~=0   %block odd ==> 2n-back
block.instruction = task_instruction_1

else mod(blocks,2)==0  % block even ==> 3n-back
    block.instruction = task_instruction_2

end

time2flip=0;
Screen('TextSize', w, 22);
Screen('TextFont', w, 'Arial');
DrawFormattedText(w, block.instruction,'center', 'center', BlackIndex(w));  
% flip instructions screen
tata=Screen('Flip',w,time2flip);
        
% % wait for response
t_ini = GetSecs();
while (GetSecs() - t_ini <100)
    keyIsDown = KbCheck; 

    if keyIsDown == 1
        break
    end 
end
   
    % for-loop for trials
    for trials = 1:trialnum
        

        %% STIMULIS
        if blockstim(trials,1)==1
            stimword='1';
        else if blockstim(trials,1)==2
            stimword='2';
        else if blockstim(trials,1)==3
            stimword='3';
        else if blockstim(trials,1)==4
            stimword='4';
        else if blockstim(trials,1)==5
            stimword='5';   
        else if blockstim(trials,1)==6
            stimword='6';
        else if blockstim(trials,1)==7
            stimword='7';
        else if blockstim(trials,1)==8
            stimword='8';  
        else if blockstim(trials,1)==9
            stimword='9';    
        else if blockstim(trials,1)==0
                    stimword='0';
                    
            end
            end
            end
            end
            end
            end
            end
            end
            end
            end
       
        Screen('Flip', w);
        % increase font size
        Screen('TextSize', w, 40);
        
        %% STIMULUS COLOUR
        
        stimcolour=colourrgb;
                
       %% TRIAL START
       
        Screen('DrawLines', w, allCoords,lineWidthPix, black, [xCenter yCenter]);
        time2flip=0; trialstart.VBLTimestamp=Screen('Flip',w,time2flip);
        
         %% STIMULUS
         
         DrawFormattedText(w, stimword,'center', 'center', stimcolour);
        time2flip = trialstart.VBLTimestamp + std_interval; 
        stim.VBLTimestamp=Screen('Flip',w,time2flip);
         %% ISI (blank screen)
         
         DrawFormattedText(w, '','center', 'center', WhiteIndex(w));
         time2flip= stim.VBLTimestamp + 0.5;
         isi.VBLTimestamp = Screen('Flip',w,time2flip);
         
         % check timing
         stimduration=isi.VBLTimestamp-stim.VBLTimestamp;
    
        
       %% RESPONSE OUTPUT (resp = key & rt)
        t_ini = GetSecs();
       [keyIsDown, secs,keyCode, deltaSecs,] = KbCheck;
 
        while (GetSecs() - t_ini <2) 
             kbNameResult = KbName(keyCode)
            
               if keyIsDown == 1 && kbNameResult == 'e'
                         key = 1;
                         resp = [str2num(kbNameResult(1)) secs-t_ini];
                         
                         
                 elseif keyIsDown == 1 && kbNameResult == 'o'
                         key = 0;
                         resp = [str2num(kbNameResult(1)) secs-t_ini];
                 
                         
                 elseif keyIsDown ==0
                         key = 2;
                         resp = 0;
                         
                
               end
                   
            % Extraction of the answer 
            key_1(trials) = key ;
            
            % Extraction of the block 
            block_n(trials) = blocks;
            
            % Extraction of the time to answer
            resp_1 (trials) = resp;
            
            %Extraction of the objective time of stimulation
            stim_dur (trials) = stimduration;
            
        
        end
           
    end
    

    %% OUTPUT FOR EACH BLOCK
    
    if mod(blocks,2)~=0  %block odd ==> 2n-back
        
     % First output
     % First column = number of block
     % Second column = presented stimulus
     % Third column = matching of presented stimulus (1 = odd, 2 = even)
     % Fourth column = pressed key
     % Fifth column = response time
     % Sixth column = stimulus duration 
        output_2(1:trialnum, 1:6)= [block_n' blockstim(:,1) blockstim(:,2) key_1' (resp_1'*1000) stim_dur'];
        
        % Accurancy calcul
        back2 = output_2(1:trialnum-2,3)==output_2(3:trialnum,3); 
        accurancy_2 = back2==output_2(3:trialnum,4);
        
        % Final output :
        output_f2 = [output_2(3:end,1) output_2(3:end,2) accurancy_2 output_2(3:end,5) output_2(3:end,6)]
        
    elseif mod(blocks,2) == 0 % block even ==> 3n-back
        
     % First output
     % First column = number of block
     % Second column = presented stimulus
     % Third column = matching of presented stimulus (1 = odd, 2 = even)
     % Fourth column = pressed key
     % Fifth column = response time
     % Sixth column = stimulus duration 
        output_3(1:trialnum, 1:6)= [block_n' blockstim(:,1) blockstim(:,2) key_1' (resp_1'*1000) stim_dur'];
        
         % Accurancy calcul
        back3 = output_3(1:trialnum-3,3)==output_3(4:trialnum,3);
        accurancy_3 = back3==output_3(4:trialnum,4);
       
        % Final output 
        output_f3= [output_3(4:end,1) output_3(4:end,2) accurancy_3 output_3(4:end,5) output_2(4:end,6)];
        
    end 
    
   
  
    
end

 %% FINAL OUTPUT
    
     % First column = number of block
     % Second column = presented stimulus
     % Third column = accurancy (correct = 1 // incorrect = 0)
     % Fourth column = response time
     % Fifth column = objective stimulus duration 
     % Number of row = trialnum - 5 (2 for n-2-back and 3 for n-3-back)
     output_f = vertcat(output_f2, output_f3)
     
     % Save the output as a file.mat and the name inclundes ID number, time and date
     % stamps
     save([num2str(id) '_' num2str(day_stamp) '_' num2str(time_stamp) '.mat'],'output_f');
    

%% END EXPERIMENT
Screen('CloseAll');
clear Screen
ShowCursor;
fclose('all');
Priority(0);