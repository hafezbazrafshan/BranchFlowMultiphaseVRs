function [Nodes, Q1,Q2,Q3]=importCapacitors(filename)



%% Import the data
[~, ~, raw] = xlsread(filename,'Sheet1');
raw = raw(5:end-1,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};


Nodes=cellfun(@(x) num2str(x), raw(:,1),'UniformOutput',false);
Q1=cellfun(@zeroForNan, raw(:,2));
Q2=cellfun(@zeroForNan, raw(:,3));
Q3=cellfun(@zeroForNan, raw(:,4));



return;