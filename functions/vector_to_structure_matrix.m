%% From vectrors to structure matrices
% example Qvalues{28}=[1x 384] --> hyperQ[{28,4} = [96 x 4]
% function [a]=vector_to_matrix(vectors,sessions,trials);
% rows=numel(vectors);
% for n=1:rows;
%     for m=1:sessions;
%         data=vectors{n};
%         data=data';
%         a{n,m}=data(1+trials*(m-1):trials+trials*(m-1),:);
%     end
% end

function [a]=vector_to_structure_matrix(vectors,sessions,trials);

rows=numel(vectors);

for n=1:rows;
    for m=1:sessions;
        data=vectors{n};
        dime=size(data);
        if dime(2)>dime(1);    
        data=data';
        end
        a{n,m}=data(1+trials*(m-1):trials+trials*(m-1),:);
    end
end