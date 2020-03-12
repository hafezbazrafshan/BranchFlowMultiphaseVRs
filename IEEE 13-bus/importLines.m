function [NodeA,NodeB,Lengthft,Config] = importLines(filename)



%% Import the data
[~, ~, raw] = xlsread(filename,'Sheet1','','basic');
raw = raw(4:end,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};

NodeA=raw(:,1);
NodeB=raw(:,2);
Lengthft=raw(:,3);
Config=raw(:,4);

return;