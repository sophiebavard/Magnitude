clear
addpath functions

%% Select experiment

[expe] = listdlg('PromptString','Select an experiment',...
    'SelectionMode','single',...
    'ListString',{'Experiment 1 (N=20)','Experiment 2 (N=40)'}) ;

[fit_test] = listdlg('PromptString','Select a fitting method',...
    'SelectionMode','single',...
    'ListString',{'Learning test', 'Transfer test','Both'}) ;

% cond 1 Gain 1E  tv1= comp tv0= part
% cond 2 Gain 10c tv1= part tv0= comp
% cond 3 Loss 1E  tv1= comp tv0= part
% cond 4 Loss 10c tv1= part tv0= comp

%% Data extraction

if expe == 1
    load('Data_expe1.mat');
elseif expe == 2
    load('Data_expe2.mat');
end

% fitting 3 models: ABS, REL, HYB
whichmodel = 1:3; 
    
%% Model Fitting

options = optimset('Algorithm', 'interior-point', 'Display', 'off', 'MaxIter', 1000,'MaxFunEval',1000);

% The option Display is set to off, which means that the optimization algorithm will run silently, without showing the output of each iteration.
% The option MaxIter is set to 10000, which means that the algorithm will perform a maximum of 10,000 iterations.

nsub = 0;

for sub = subjects
    
    nsub = nsub + 1;
    
    for model = whichmodel
        
        if expe == 1
            
            [parameters(nsub,:,model),ll(nsub,model),~,~,~]=fmincon(@(x) ...
                Model_Fitting_Magnitude1(x,con{nsub},cho{nsub},out{nsub},out2{nsub},aa{nsub},ss{nsub},model,fit_test),[1 .5 .5 .5],[],[],[],[],[0 0 0 0],[Inf 1 1 1],[], options);
            
        elseif expe == 2
            
            [parameters(nsub,:,model),ll(nsub,model),~,~,~]=fmincon(@(x) ...
                Model_Fitting_Magnitude2(x,con{nsub},con3{nsub},cho{nsub},out{nsub},cou{nsub},out2{nsub},cou2{nsub},aa{nsub},ss{nsub},model,fit_test),[1 .5 .5 .5],[],[],[],[],[0 0 0 0],[Inf 1 1 1],[], options);            

        end
    end
end


%% BIC comparison

% number of free parameters
nfpm=[3 3 4] - (expe==1); % no counterfactual learning rate for experiment 1

% for each model BIC depends on loglikelihood and number of trials
for n=whichmodel
    bic(:,n)=-2*-ll(:,n)+nfpm(n)*log(160*(fit_test~=2)+112*(fit_test~=1));
end


%% save data

if  fit_test == 3
    save(strcat('Magnitude_Optimization_expe',num2str(expe)));
elseif fit_test == 2
    save(strcat('Magnitude_Optimization_TransferTest_expe',num2str(expe)));
elseif fit_test==1
    save(strcat('Magnitude_Optimization_LearningTest_expe',num2str(expe)));
end

