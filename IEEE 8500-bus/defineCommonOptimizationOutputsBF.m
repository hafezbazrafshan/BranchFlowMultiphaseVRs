if exist('Sg3Phi')
Sg=cell(NBuses,1); 
for n=1:NBuses
if length(Bus.Phases{n})==3
nn=find(Bus.ThreePhaseBusNumbers==n); 
Sg{n}=Sg3Phi(:,nn); 
elseif length(Bus.Phases{n})==2
nn=find(Bus.TwoPhaseBusNumbers==n); 
Sg{n}=Sg2Phi(:,nn);
 else
nn=find(Bus.OnePhaseBusNumbers==n); 
Sg{n}=Sg1Phi(:,nn);
end
end

Network.Bus.Sg=Sg;
Network.Bus.SgVec=cell2mat(Network.Bus.Sg);
end

Network.Optimization.Status=cvx_status;

Network.Optimization.Variables.Vnn3Phi=full(Vnn3Phi);
Network.Optimization.Variables.Snm3Phi=full(Snm3Phi);
Network.Optimization.Variables.Inm3Phi=full(Inm3Phi);
Network.Optimization.Variables.Vnn2Phi=full(Vnn2Phi);
Network.Optimization.Variables.Snm2Phi=full(Snm2Phi);
Network.Optimization.Variables.Inm2Phi=full(Inm2Phi);
Network.Optimization.Variables.Vnn1Phi=full(Vnn1Phi);
Network.Optimization.Variables.Snm1Phi=full(Snm1Phi);
Network.Optimization.Variables.Inm1Phi=full(Inm1Phi);
Network.Optimization.Variables.VnmPrime3Phi=full(VnmPrime3Phi); 
Network.Optimization.Variables.SnmPrime3Phi=full(SnmPrime3Phi);
Network.Optimization.Variables.SIn=full(SIn);
Network.Optimization.Variables.ThermalLoss=full(ThermalLoss);
Network.Optimization.Variables.VoltageDeviation=full(VoltageDeviation);


Network.Optimization.PlaceHolders.W3Phi=full(W3Phi);
Network.Optimization.PlaceHolders.W2Phi=full(W2Phi);
Network.Optimization.PlaceHolders.W1Phi=full(W1Phi);
% Network.Optimization.PlaceHolders.WPrime3Phi=full(WPrime3Phi);
Network.Optimization.Constraints.PowerFlowConstraints.P=PowerFlowConstraintsP;
Network.Optimization.Constraints.PowerFlowConstraints.Q=PowerFlowConstraintsQ;
Network.Optimization.Constraints.VMinConstraints.Vnn3Phi=VMinConstraints.Vnn3Phi;
Network.Optimization.Constraints.VMinConstraints.Vnn2Phi=VMinConstraints.Vnn2Phi;
Network.Optimization.Constraints.VMinConstraints.Vnn1Phi=VMinConstraints.Vnn1Phi;
Network.Optimization.Constraints.VMaxConstraints.Vnn3Phi=VMaxConstraints.Vnn3Phi;
Network.Optimization.Constraints.VMaxConstraints.Vnn2Phi=VMaxConstraints.Vnn2Phi;
Network.Optimization.Constraints.VMaxConstraints.Vnn1Phi=VMaxConstraints.Vnn1Phi;
Network.Optimization.Constraints.BranchConstraints.W3PhiLambdas=BranchConstraints.W3Phi.Lambdas;
Network.Optimization.Constraints.BranchConstraints.W2PhiLambdas=BranchConstraints.W2Phi.Lambdas;
Network.Optimization.Constraints.BranchConstraints.W1PhiLambdas=BranchConstraints.W1Phi.Lambdas;
Network.Optimization.Constraints.BranchConstraints.WPrime3PhiLambdas=BranchConstraints.WPrime3Phi.Lambdas;

Network.Optimization.L2L1=mean([Network.Optimization.Constraints.BranchConstraints.W3PhiLambdas(end-1,:)...
     ./Network.Optimization.Constraints.BranchConstraints.W3PhiLambdas(end,:),...
     Network.Optimization.Constraints.BranchConstraints.W2PhiLambdas(end-1,:)...
     ./Network.Optimization.Constraints.BranchConstraints.W2PhiLambdas(end,:),...
     Network.Optimization.Constraints.BranchConstraints.W1PhiLambdas(end-1,:)...
     ./Network.Optimization.Constraints.BranchConstraints.W1PhiLambdas(end,:)]);

Network.Optimization.OptimalValue=Objective/Scale;

