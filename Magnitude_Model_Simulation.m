clear
addpath functions

%% SET UP

% cond 1 Gain 1E  tv1= comp tv0= part
% cond 2 Gain 10c tv1= part tv0= comp
% cond 3 Loss 1E  tv1= comp tv0= part
% cond 4 Loss 10c tv1= part tv0= comp

% which experiment ?

[expe] = listdlg('PromptString','Select an experiment',...
    'SelectionMode','single',...
    'ListString',{'Experiment 1 (N=20)','Experiment 2 (N=40)'}) ;

% which model ?

[model] = listdlg('PromptString','Select a model',...
    'SelectionMode','single',...
    'ListString',{'ABSOLUTE','RELATIVE','HYBRID'}) ;

% load parameters

load(strcat('Magnitude_Optimization_LearningTest_expe',num2str(expe)),'parameters','subjects','con','con2','con3','cho','out','out2','cou','cou2');
parametersTest = parameters(:,:,model);
load(strcat('Magnitude_Optimization_TransferTest_expe',num2str(expe)),'parameters','aa','ss');
parametersPostTest = parameters(:,:,model);

% matrix initialization

ntrial = 20;
sessions = 1:2;

choice1=zeros(ntrial,numel(subjects));
choice2=zeros(ntrial,numel(subjects));
choice3=zeros(ntrial,numel(subjects));
choice4=zeros(ntrial,numel(subjects));

bmodel1=zeros(ntrial,numel(subjects));
bmodel2=zeros(ntrial,numel(subjects));
bmodel3=zeros(ntrial,numel(subjects));
bmodel4=zeros(ntrial,numel(subjects));

%% MODEL PREDICTIONS

repet=100;

for n = 1:repet

    for sub = 1:numel(subjects)
        
        if expe == 1
            [Proba_2{sub}] = Model_Simulation_Magnitude1(parametersTest(sub,:), con{sub}, con2{sub}, cho{sub}, out{sub}, out2{sub}, ss{sub}, model, 1);
        elseif expe == 2
            [Proba_2{sub}] = Model_Simulation_Magnitude2(parametersTest(sub,:), con{sub}, con2{sub}, con3{sub}, cho{sub}, out{sub}, out2{sub}, cou{sub}, cou2{sub}, ss{sub}, model, 1);
        end
        if expe == 1
            [~, Proba_post{sub}] = Model_Simulation_Magnitude1(parametersPostTest(sub,:), con{sub}, con2{sub}, cho{sub}, out{sub}, out2{sub}, ss{sub}, model, 2);
        elseif expe == 2
            [~, Proba_post{sub}] = Model_Simulation_Magnitude2(parametersPostTest(sub,:), con{sub}, con2{sub}, con3{sub}, cho{sub}, out{sub}, out2{sub}, cou{sub}, cou2{sub}, ss{sub}, model, 2);
        end
        
        % matrices for the post-test
        
        Proba_post{sub} = Proba_post{sub}';
        
        Post_Test{1,sub}=[Proba_post{sub}(ss{sub}(:,2)==1,:)-1;(Proba_post{sub}(ss{sub}(:,1)==1,:)-2)*-1];
        Post_Test{2,sub}=[Proba_post{sub}(ss{sub}(:,2)==2,:)-1;(Proba_post{sub}(ss{sub}(:,1)==2,:)-2)*-1];
        Post_Test{3,sub}=[Proba_post{sub}(ss{sub}(:,2)==3,:)-1;(Proba_post{sub}(ss{sub}(:,1)==3,:)-2)*-1];
        Post_Test{4,sub}=[Proba_post{sub}(ss{sub}(:,2)==4,:)-1;(Proba_post{sub}(ss{sub}(:,1)==4,:)-2)*-1];
        Post_Test{7,sub}=[Proba_post{sub}(ss{sub}(:,2)==5,:)-1;(Proba_post{sub}(ss{sub}(:,1)==5,:)-2)*-1];
        Post_Test{8,sub}=[Proba_post{sub}(ss{sub}(:,2)==6,:)-1;(Proba_post{sub}(ss{sub}(:,1)==6,:)-2)*-1];
        Post_Test{5,sub}=[Proba_post{sub}(ss{sub}(:,2)==7,:)-1;(Proba_post{sub}(ss{sub}(:,1)==7,:)-2)*-1];
        Post_Test{6,sub}=[Proba_post{sub}(ss{sub}(:,2)==8,:)-1;(Proba_post{sub}(ss{sub}(:,1)==8,:)-2)*-1];
        
        ratingSub{1,sub}=[aa{sub}(ss{sub}(:,2)==1,:)-1;(aa{sub}(ss{sub}(:,1)==1,:)-2)*-1];
        ratingSub{2,sub}=[aa{sub}(ss{sub}(:,2)==2,:)-1;(aa{sub}(ss{sub}(:,1)==2,:)-2)*-1];
        ratingSub{3,sub}=[aa{sub}(ss{sub}(:,2)==3,:)-1;(aa{sub}(ss{sub}(:,1)==3,:)-2)*-1];
        ratingSub{4,sub}=[aa{sub}(ss{sub}(:,2)==4,:)-1;(aa{sub}(ss{sub}(:,1)==4,:)-2)*-1];
        ratingSub{7,sub}=[aa{sub}(ss{sub}(:,2)==5,:)-1;(aa{sub}(ss{sub}(:,1)==5,:)-2)*-1];
        ratingSub{8,sub}=[aa{sub}(ss{sub}(:,2)==6,:)-1;(aa{sub}(ss{sub}(:,1)==6,:)-2)*-1];
        ratingSub{5,sub}=[aa{sub}(ss{sub}(:,2)==7,:)-1;(aa{sub}(ss{sub}(:,1)==7,:)-2)*-1];
        ratingSub{6,sub}=[aa{sub}(ss{sub}(:,2)==8,:)-1;(aa{sub}(ss{sub}(:,1)==8,:)-2)*-1];
        
        % final matrix for the post test
        for m=1:8
            mrating(m,sub)=nanmean(Post_Test{m,sub});
            rating(m,sub) =nanmean(ratingSub{m,sub});
        end
    end
    
    % matrices for the learning test
    
    hyperCho =vector_to_structure_matrix(cho,numel(sessions),80);
    hyperCon =vector_to_structure_matrix(con2,numel(sessions),80);
    hyperCond =vector_to_structure_matrix(con,numel(sessions),80);
    
    Proba = vector_to_structure_matrix(Proba_2,numel(sessions),80);
    
    bmodel1 = bmodel1 + (structure_matrix_to_plotmatrix(Proba,1,hyperCon,numel(subjects),numel(sessions),20,0))/repet;  % p(best choice) for gainpart
    bmodel2 = bmodel2 + (structure_matrix_to_plotmatrix(Proba,2,hyperCon,numel(subjects),numel(sessions),20,0))/repet;  % p(best choice) for gaincomp
    bmodel3 = bmodel3 + (structure_matrix_to_plotmatrix(Proba,3,hyperCon,numel(subjects),numel(sessions),20,0))/repet;  % p(best choice) for losspart
    bmodel4 = bmodel4 + (structure_matrix_to_plotmatrix(Proba,4,hyperCon,numel(subjects),numel(sessions),20,0))/repet;  % p(best choice) for losscomp
    
    choice1=choice1+(structure_matrix_to_plotmatrix(hyperCho,1,hyperCon,numel(subjects),numel(sessions),20,-1))/repet;
    choice2=choice2+(structure_matrix_to_plotmatrix(hyperCho,2,hyperCon,numel(subjects),numel(sessions),20,-1))/repet;
    choice3=choice3+(structure_matrix_to_plotmatrix(hyperCho,3,hyperCon,numel(subjects),numel(sessions),20,-1))/repet;
    choice4=choice4+(structure_matrix_to_plotmatrix(hyperCho,4,hyperCon,numel(subjects),numel(sessions),20,-1))/repet;
    
end



%% REORGANIZE DATA

big =(mean(choice1)+mean(choice3))/2;
small=(mean(choice2)+mean(choice4))/2;

bbig=(mean(bmodel1)+mean(bmodel3))/2;
bsmall=(mean(bmodel2)+mean(bmodel4))/2;

magnitude=  [big;small];
bmagnitude= [bbig;bsmall];

magnitude_dif=magnitude(1,:)-magnitude(2,:);
bmagnitude_dif=bmagnitude(1,:)-bmagnitude(2,:);

%% PLOT THE SIMULATIONS

Colors(1,:)=[0.64 0.4 0.64];
Colors(2,:)=[0.64 0.4 0.64];
Colors(3,:)=[0.64 0.4 0.64];
Colors(4,:)=[0.64 0.4 0.64];
Colors(5,:)=[0.64 0.4 0.64];
Colors(6,:)=[0.64 0.4 0.64];
Colors(7,:)=[0.64 0.4 0.64];
Colors(8,:)=[0.64 0.4 0.64];

figure('Name','Learning Test correct choice','NumberTitle','off');
subplot(1,2,1);
BarsAndErrorPlotModel(magnitude,bmagnitude,Colors,0.5,1.0,12,0);
subplot(1,2,2);
BarsAndErrorPlotModel(magnitude_dif,bmagnitude_dif,Colors,-0.2,0.2,12,0);


%% PLOT TRANSFER TEST

figure('Name','Transfer Test','NumberTitle','off');
BarsAndErrorPlotModel(rating,mrating,Colors,0,1.0,12,0.2);


