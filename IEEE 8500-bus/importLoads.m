function [Nodes, LoadTypes, Ph1, Ph2, Ph3, Ph4, Ph5, Ph6]=importLoads(filename)



%% Import the data
[~, ~, raw] = xlsread(filename,'Sheet1');
raw = raw(5:end-1,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};

Nodes=cellfun(@(x) num2str(x), raw(:,1),'UniformOutput',false);
LoadTypes=cellfun(@(x) x,raw(:,2),'UniformOutput',false);
Ph1=cellfun(@(x) x, raw(:,3));
Ph2=cellfun(@(x) x, raw(:,4));
Ph3=cellfun(@(x) x, raw(:,5));
Ph4=cellfun(@(x) x, raw(:,6));
Ph5=cellfun(@(x) x, raw(:,7));
Ph6=cellfun(@(x) x, raw(:,8));


return;