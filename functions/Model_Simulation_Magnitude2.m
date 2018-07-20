
function [Pc, PcPT] = Model_Simulation_Magnitude2(params,s,s2,s3,a,r,r2,c,c2,ss,model,test)

% s : the actual state (4 x 2 session)
% s2: the global state 1-4
% s3: whether or not this is a "complete feedback" state
% a : the choice (correct or incorrect)
% r : obtained outcome in absolute value
% c : counterfactual outcome in absolute value
% r2: obtained outcome in relative value
% c2: counterfactual outcome in relative value
% ss: transfer test symbols

beta    = params(1); % choice randomness
alphaQf = params(2); % factual learning rate
alphaQc = params(3); % counterfactual learning rate
w       = params(4); % weight parameter

nsessions=floor(length(s)/80);

Q       = zeros(4*nsessions,2); % Qvalues
N       = zeros(4*nsessions,1); % trial count
V       = zeros(4*nsessions,1); % context value (in terms of valence AND magnitude)

if model ==2
    Q = Q+0.5;
end

if model ==3
    Qc = Q+0.5;
end

Pc=zeros(1,length(s))+0.5;
Cm=zeros(1,length(s))+0.5;

for i = 1:length(s)
    
    if test == 1
        
        % The model decision
        Pc(i)=1/(1+exp((Q(s(i),1)-Q(s(i),2))*(beta)));
        Cm(i)=RandomChoice([(1-Pc(i)) Pc(i)]);
        a(i)=Cm(i);
        
        % The task contingency
        r2(i)=(RandomChoice([0.75-(a(i)-1)/2 0.25+(a(i)-1)/2])-1); % relative, context-dependent, value (1/0)
        c2(i)=(RandomChoice([0.25+(a(i)-1)/2 0.75-(a(i)-1)/2])-1); % relative, context-dependent, value (1/0)
        r(i)=(r2(i)-1.*(s2(i)>2))/(10-9*mod(s2(i),2)); % absolute, "real" value, first term become punishment, second adjust magnitude
        c(i)=(c2(i)-1.*(s2(i)>2))/(10-9*mod(s2(i),2)); % absolute, "real" value, first term become punishment, second adjust magnitude
        
    end
    
    if model==1     % ABSOLUTE
        
        deltaI =  r(i) - Q(s(i),a(i));
        deltaC =  (c(i) - Q(s(i),3-a(i)))*(s3(i)==0);
        
        Q(s(i),a(i)) = Q(s(i),a(i)) + alphaQf * deltaI;
        Q(s(i),3-a(i)) = Q(s(i),3-a(i)) + alphaQc * deltaC;
        
    elseif model==2 % RELATIVE
                
        N(s(i))= N(s(i))+1;
        Rtot =  (r(i)+c(i)*(s3(i)==0));
        V(s(i)) = V(s(i))*((N(s(i))-1)/N(s(i))) + Rtot/N(s(i));
        
        if V(s(i))~=0
            deltaI =  r2(i)  - Q(s(i),a(i));
            deltaC =  (c2(i) - Q(s(i),3-a(i)))*(s3(i)==0);
            Q(s(i),a(i))   = Q(s(i),a(i))   + alphaQf * deltaI;
            Q(s(i),3-a(i)) = Q(s(i),3-a(i)) + alphaQc * deltaC;
        end        
        
    elseif model==3 % HYBRID
        
        Qt=Q*w+Qc*(1-w);
        
        % the absolute learner
        deltaI =  r(i) -  Q(s(i),a(i));
        deltaC =  (c(i) - Q(s(i),3-a(i)))*(s3(i)==0);
        Q(s(i),a(i))   = Q(s(i),a(i)) +   alphaQf * deltaI;
        Q(s(i),3-a(i)) = Q(s(i),3-a(i)) + alphaQc * deltaC;
        
        % the relative learner
        N(s(i))= N(s(i))+1;
        Rtot =  (r(i)+c(i)*(s3(i)==0));
        V(s(i)) = V(s(i))*((N(s(i))-1)/N(s(i))) + Rtot/N(s(i));
        
        if V(s(i))~=0
            deltaIc = r2(i) -  Qc(s(i),a(i));
            deltaCc = (c2(i) - Qc(s(i),3-a(i)))*(s3(i)==0);
            Qc(s(i),a(i))   = Qc(s(i),a(i))   + alphaQf * deltaIc;
            Qc(s(i),3-a(i)) = Qc(s(i),3-a(i)) + alphaQc * deltaCc;
        end
        
        Pc(i)=1/(1+exp((Qt(s(i),1)-Qt(s(i),2)) * (beta)));
        
    end
end

%% Transfer Test

if test ~= 1
    
    Qf(1)=Q(5,2);
    Qf(2)=Q(5,1);
    Qf(3)=Q(6,2);
    Qf(4)=Q(6,1);
    Qf(5)=Q(7,2);
    Qf(6)=Q(7,1);
    Qf(7)=Q(8,2);
    Qf(8)=Q(8,1);
    
    if model==3
        Qf(1)=Qt(5,2);
        Qf(2)=Qt(5,1);
        Qf(3)=Qt(6,2);
        Qf(4)=Qt(6,1);
        Qf(5)=Qt(7,2);
        Qf(6)=Qt(7,1);
        Qf(7)=Qt(8,2);
        Qf(8)=Qt(8,1);
    end
    
    PcPT=zeros(1,length(ss));
    
    for i = 1:length(ss)
        
        PcPT(i)  = 1/(1+exp((Qf(ss(i,1)) - Qf(ss(i,2))) * (beta)));
        
    end
end

end
