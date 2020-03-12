function path = gen_path(n, inc_mat, sNodes, rNodes)

tempPath=[n];
BranchIndex=find(sNodes==n);
children=find(inc_mat(BranchIndex,:)==-1);

for idx=1:length(children)
    childIdx=children(idx);
    tempPath=[tempPath, gen_path(childIdx,inc_mat, sNodes, rNodes)];
end
 
path=tempPath;

        
