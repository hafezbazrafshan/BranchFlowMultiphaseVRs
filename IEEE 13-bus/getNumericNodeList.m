function [ sNodes ] = getNumericNodeList( LineBuses, BusNames )
% the index of strings in LineBuses within busNames



sNodes=zeros(length(LineBuses),1); 
for jj=1:length(LineBuses) 
    sNodes(jj)=find(strcmp(BusNames,LineBuses(jj))); 
    
end



end
