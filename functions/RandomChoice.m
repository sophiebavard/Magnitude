% Originally from Mehdi Khamassi
% generate model random choices
function chiffre = RandomChoice(p)
%rand('state',sum(100*clock));

% p is a vector of N elements representing probabilities of occurence of N concurrent options

% function drand01 consists in stochastically choosing among possible
% options depending on their respective probabilities

% chiffre is the output of drand01. It is an integer containing the number
% of the option that was chosen by drand01

j = rand(1);
i = 0;
cumul = 0;
onContinue = true;
while onContinue,
    i = i + 1;
    cumul = cumul + p(i);
    if ((j <= cumul)|(i == length(p))),
        onContinue = false;
    end
end
chiffre = i;