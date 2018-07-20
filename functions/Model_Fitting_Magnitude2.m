function lik = Model_Fitting_Magnitude2(params,s,s2,a,r,c,r2,c2,aa,ss,model,fit_test)

% s : the actual state (4 x 2 session)
% s2: whether or not this is a "complete feedback" state
% a : the choice (correct or incorrect)
% r : obtained outcome in absolute value
% c : counterfactual outcome in absolute value
% r2: obtained outcome in relative value
% c2: counterfactual outcome in relative value
% aa: actions in transfer test
% ss: symbols in transfer test

beta    = params(1); % choice randomness
alphaQf = params(2); % factual learning rate
alphaQc = params(3); % counterfactual learning rate
w       = params(4); % weight parameter

nsessions=floor(length(a)/80);

Q       = zeros(4*nsessions,2); % Qvalues
N       = zeros(4*nsessions,1); % trial count
V       = zeros(4*nsessions,1); % context value (in terms of valence AND magnitude)

if model ==2
    Q = Q+0.5;
end

if model ==3
    Qc = Q+0.5;
end


lik=0;

for i = 1:length(a)
    
    if (a(i))
        
        if model==1 % ABSOLUTE
            
            lik = lik + beta * Q(s(i),a(i)) - log(sum(exp(beta * Q(s(i),:))));
            
            deltaI =  r(i) - Q(s(i),a(i));
            deltaC =  (c(i) - Q(s(i),3-a(i)))*(s2(i)==0);
            
            Q(s(i),a(i)) = Q(s(i),a(i)) + alphaQf * deltaI;
            Q(s(i),3-a(i)) = Q(s(i),3-a(i)) + alphaQc * deltaC;
            
        elseif model==2 % RELATIVE
            
            lik = lik + beta * Q(s(i),a(i)) - log(sum(exp(beta * Q(s(i),:))));
            
            N(s(i))= N(s(i))+1;
            Rtot =  (r(i)+c(i)*(s2(i)==0));
            V(s(i)) = V(s(i))*((N(s(i))-1)/N(s(i))) + Rtot/N(s(i));
            
            if V(s(i))~=0
                deltaI =  r2(i)  - Q(s(i),a(i));
                deltaC =  (c2(i) - Q(s(i),3-a(i)))*(s2(i)==0);
                Q(s(i),a(i))   = Q(s(i),a(i))   + alphaQf * deltaI;
                Q(s(i),3-a(i)) = Q(s(i),3-a(i)) + alphaQc * deltaC;
            end
            
        elseif model==3 % HYBRID
            
            Qt=Q*w+Qc*(1-w);
            lik = lik + beta * Qt(s(i),a(i)) - log(sum(exp(beta * Qt(s(i),:))));
            
            % the absolute learner
            deltaI =  r(i) -  Q(s(i),a(i));
            deltaC =  (c(i) - Q(s(i),3-a(i)))*(s2(i)==0);
            Q(s(i),a(i))   = Q(s(i),a(i)) +   alphaQf * deltaI;
            Q(s(i),3-a(i)) = Q(s(i),3-a(i)) + alphaQc * deltaC;
            
            % the relative learner
            N(s(i))= N(s(i))+1;
            Rtot =  (r(i)+c(i)*(s2(i)==0));
            V(s(i)) = V(s(i))*((N(s(i))-1)/N(s(i))) + Rtot/N(s(i));
            
            if V(s(i))~=0
                deltaIc = r2(i) -  Qc(s(i),a(i));
                deltaCc = (c2(i) - Qc(s(i),3-a(i)))*(s2(i)==0);
                Qc(s(i),a(i))   = Qc(s(i),a(i))   + alphaQf * deltaIc;
                Qc(s(i),3-a(i)) = Qc(s(i),3-a(i)) + alphaQc * deltaCc;
            end
         end
    end
end

%% Transfer Test
% the final Q-values are from last session

if fit_test ~= 1 % different from "learning test only"
    
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
    
    if fit_test == 2 % "transfer test only"
        lik=0;
    end
    
    for i = 1:length(aa)
        
        if (aa(i))
            
            lik = lik + beta * Qf(ss(i,aa(i))) - log(sum(exp(beta * Qf(ss(i,:)))));
            
        end
    end
end

lik = -lik;

end
