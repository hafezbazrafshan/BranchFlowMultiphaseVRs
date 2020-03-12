function [Network,BranchList] = genBranchList(Network,n)
if nargin<2
n=Network.Bus.SubstationNumber;
end

BranchList=Network.Bus.ToNeighborsBranchNumbers{n};


for idx=1:length(BranchList)
    ChildIdx=Network.Branch.BusToNumbers(BranchList(idx));
    [~,TempBranchList]=genBranchList(Network,ChildIdx);
    BranchList=[BranchList; TempBranchList];
end
 

Network.BranchList=BranchList;
        
