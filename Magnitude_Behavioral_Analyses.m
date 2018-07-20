clear
addpath functions

%% Select experiment

[expe] = listdlg('PromptString','Select an experiment',...
    'SelectionMode','single',...
    'ListString',{'Experiment 1 (N=20)','Experiment 2 (N=40)','Both (N=60)'}) ;

% cond 1 Gain 1E  tv1= comp tv0= part
% cond 2 Gain 10c tv1= part tv0= comp
% cond 3 Loss 1E  tv1= comp tv0= part
% cond 4 Loss 10c tv1= part tv0= comp

%% Data extraction

% cho  : subjects choices during learning test (correct/incorrect)
% con  : conditions for both sessions (1 to 8)
% con2 : conditions per session (1 to 4)
% con3 : whether this is a complete feedback state (0=complete/1=partial)
% out  : factual outcome (experienced)
% cou  : counterfactual outcome (experienced)
% out2 : factual ouctome (in a relative scale)
% cou2 : counterfactual ouctome (in a relative scale)
% ss   : presented symbols during transfer test (left/right)
% aa   : subjects choices during transfer test (left/right)

if expe == 1
    load('Data_expe1.mat');
elseif expe == 2
    load('Data_expe2.mat');
elseif expe == 3    
    expe1 = load('Data_expe1.mat');    
    expe2 = load('Data_expe2.mat');
    subjects = [expe1.subjects expe2.subjects];
    cho = [expe1.cho expe2.cho];
    con2 = [expe1.con2 expe2.con2];
    aa = [expe1.aa expe2.aa];
    ss = [expe1.ss expe2.ss];
end
    
nsub = 0;

for sub = subjects
    
    nsub = nsub + 1;
    
    % learning test
    
    perf1E(nsub)  = mean(cho{nsub}(con2{nsub}==1 | con2{nsub}==3)-1);
    perf10c(nsub) = mean(cho{nsub}(con2{nsub}==2 | con2{nsub}==4)-1);
    
    % transfer test
    
    Post{1,nsub}=[aa{nsub}(ss{nsub}(:,2)==1,:)-1;(aa{nsub}(ss{nsub}(:,1)==1,:)-2)*-1];
    Post{2,nsub}=[aa{nsub}(ss{nsub}(:,2)==2,:)-1;(aa{nsub}(ss{nsub}(:,1)==2,:)-2)*-1];
    Post{3,nsub}=[aa{nsub}(ss{nsub}(:,2)==3,:)-1;(aa{nsub}(ss{nsub}(:,1)==3,:)-2)*-1];
    Post{4,nsub}=[aa{nsub}(ss{nsub}(:,2)==4,:)-1;(aa{nsub}(ss{nsub}(:,1)==4,:)-2)*-1];
    Post{7,nsub}=[aa{nsub}(ss{nsub}(:,2)==5,:)-1;(aa{nsub}(ss{nsub}(:,1)==5,:)-2)*-1];
    Post{8,nsub}=[aa{nsub}(ss{nsub}(:,2)==6,:)-1;(aa{nsub}(ss{nsub}(:,1)==6,:)-2)*-1];
    Post{5,nsub}=[aa{nsub}(ss{nsub}(:,2)==7,:)-1;(aa{nsub}(ss{nsub}(:,1)==7,:)-2)*-1];
    Post{6,nsub}=[aa{nsub}(ss{nsub}(:,2)==8,:)-1;(aa{nsub}(ss{nsub}(:,1)==8,:)-2)*-1];
    
    for m=1:8
        transfer(m,nsub) = nanmean(Post{m,nsub});
    end
       
end

performance = [perf1E; perf10c] ;
performance_dif = perf1E-perf10c ;

%% Plot the analyses

Colors(1,:) = [0.64 0.4 0.64];
Colors(2,:) = [0.64 0.4 0.64];
Colors(3,:) = [0.64 0.4 0.64];
Colors(4,:) = [0.64 0.4 0.64];
Colors(5,:) = [0.64 0.4 0.64];
Colors(6,:) = [0.64 0.4 0.64];
Colors(7,:) = [0.64 0.4 0.64];
Colors(8,:) = [0.64 0.4 0.64];

figure;
subplot(1,2,1)
BarsAndErrorPlot_Total(performance,Colors,0.5,1,12,'','','Correct choice');
subplot(1,2,2)
BarsAndErrorPlot_Total(performance_dif,Colors,-0.1,0.2,12,'','','');

figure;
BarsAndErrorPlot_Total(transfer,Colors,0,1,12,'','','Transfer test choice rate');



