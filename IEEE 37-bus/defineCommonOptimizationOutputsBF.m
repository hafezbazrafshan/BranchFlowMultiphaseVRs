Network.Optimization.Status=cvx_status;

Network.Optimization.Variables.Vnn3Phi=full(Vnn3Phi);
Network.Optimization.Variables.Snm3Phi=full(Snm3Phi);
Network.Optimization.Variables.Inm3Phi=full(Inm3Phi);
Network.Optimization.Variables.VnmPrime3Phi=full(VnmPrime3Phi); 
Network.Optimization.Variables.SnmPrime3Phi=full(SnmPrime3Phi);
Network.Optimization.Variables.SIn=full(SIn);
Network.Optimization.Variables.ThermalLoss=full(ThermalLoss);
Network.Optimization.Variables.VoltageDeviation=full(VoltageDeviation);


Network.Optimization.PlaceHolders.W3Phi=full(W3Phi);
Network.Optimization.PlaceHolders.WPrime3Phi=full(WPrime3Phi);
Network.Optimization.Constraints.PowerFlowConstraints.P=PowerFlowConstraintsP;
Network.Optimization.Constraints.PowerFlowConstraints.Q=PowerFlowConstraintsQ;
Network.Optimization.Constraints.VMinConstraints.Vnn3Phi=VMinConstraints.Vnn3Phi;
Network.Optimization.Constraints.VMaxConstraints.Vnn3Phi=VMaxConstraints.Vnn3Phi;
Network.Optimization.Constraints.BranchConstraints.W3PhiLambdas=BranchConstraints.W3Phi.Lambdas;
Network.Optimization.Constraints.BranchConstraints.WPrime3PhiLambdas=BranchConstraints.WPrime3Phi.Lambdas;

Network.Optimization.L2L1=mean(Network.Optimization.Constraints.BranchConstraints.W3PhiLambdas(end-1,:)...
     ./Network.Optimization.Constraints.BranchConstraints.W3PhiLambdas(end,:));

Network.Optimization.OptimalValue=Objective/Scale;
Network.Optimization.TimeInfo=cvx_toc;

