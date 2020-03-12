Network.Optimization.Status=cvx_status;

Network.Optimization.Variables.Wnn3Phi=full(Wnn3Phi);
Network.Optimization.Variables.Wnm3Phi=full(Wnm3Phi);
Network.Optimization.Variables.Wnn2Phi=full(Wnn2Phi);
Network.Optimization.Variables.Wnm2Phi=full(Wnm2Phi);
Network.Optimization.Variables.Wnn1Phi=full(Wnn1Phi);
Network.Optimization.Variables.Wnm1Phi=full(Wnm1Phi);
Network.Optimization.Variables.WnnPrime3Phi=full(WnnPrime3Phi); 
Network.Optimization.Variables.WnmPrime3Phi=full(WnmPrime3Phi);
Network.Optimization.Variables.SIn=full(SIn);
Network.Optimization.Variables.Sg=full(Sg);
Network.Optimization.Variables.ThermalLoss=full(ThermalLoss);
Network.Optimization.Variables.VoltageDeviation=full(VoltageDeviation);


Network.Optimization.PlaceHolders.W3Phi=full(W3Phi);
Network.Optimization.PlaceHolders.W2Phi=full(W2Phi);
Network.Optimization.PlaceHolders.W1Phi=full(W1Phi);
Network.Optimization.PlaceHolders.WPrime3Phi=full(WPrime3Phi);
Network.Optimization.Constraints.PowerFlowConstraints.P=PowerFlowConstraintsP;
Network.Optimization.Constraints.PowerFlowConstraints.Q=PowerFlowConstraintsQ;
Network.Optimization.Constraints.WMinConstraints.Wnn3Phi=WMinConstraints.Wnn3Phi;
Network.Optimization.Constraints.WMinConstraints.Wnn2Phi=WMinConstraints.Wnn2Phi;
Network.Optimization.Constraints.WMinConstraints.Wnn1Phi=WMinConstraints.Wnn1Phi;
Network.Optimization.Constraints.WMaxConstraints.Wnn3Phi=WMaxConstraints.Wnn3Phi;
Network.Optimization.Constraints.WMaxConstraints.Wnn2Phi=WMaxConstraints.Wnn2Phi;
Network.Optimization.Constraints.WMaxConstraints.Wnn1Phi=WMaxConstraints.Wnn1Phi;
Network.Optimization.Constraints.BranchConstraints.W3PhiLambdas=BranchConstraints.W3Phi.Lambdas;
Network.Optimization.Constraints.BranchConstraints.W2PhiLambdas=BranchConstraints.W2Phi.Lambdas;
Network.Optimization.Constraints.BranchConstraints.W1PhiLambdas=BranchConstraints.W1Phi.Lambdas;
Network.Optimization.Constraints.BranchConstraints.WPrime3PhiLambdas=BranchConstraints.WPrime3Phi.Lambdas;
% Network.Optimization.Constraints.BranchConstraints.WPrime2PhiLambdas=BranchConstraints.WPrime2Phi.Lambdas;
% Network.Optimization.Constraints.BranchConstraints.WPrime1PhiLambdas=BranchConstraints.WPrime1Phi.Lambdas;
Network.Optimization.L2L1=mean([Network.Optimization.Constraints.BranchConstraints.W3PhiLambdas(end-1,:)...
     ./Network.Optimization.Constraints.BranchConstraints.W3PhiLambdas(end,:),...
     Network.Optimization.Constraints.BranchConstraints.W2PhiLambdas(end-1,:)...
     ./Network.Optimization.Constraints.BranchConstraints.W2PhiLambdas(end,:),...
     Network.Optimization.Constraints.BranchConstraints.W1PhiLambdas(end-1,:)...
     ./Network.Optimization.Constraints.BranchConstraints.W1PhiLambdas(end,:)]);
Network.Optimization.Constraints.SgConstraints=SgConstraints;


Network.Optimization.OptimalValue=Objective/Scale;
Network.Optimization.TimeInfo=cvx_toc;

