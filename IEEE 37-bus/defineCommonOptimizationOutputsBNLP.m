
Sg=cell(NBuses,1); 
for n=1:NBuses
if length(Bus.Phases{n})==3
nn=find(Bus.ThreePhaseBusNumbers==n); 
Sg{n}=value(Sg3Phi(:,nn)); 
elseif length(Bus.Phases{n})==2
nn=find(Bus.TwoPhaseBusNumbers==n); 
Sg{n}=value(Sg2Phi(:,nn));
 else
nn=find(Bus.OnePhaseBusNumbers==n); 
Sg{n}=value(Sg1Phi(:,nn));
end
end

Network.Bus.Sg=Sg;
Network.Bus.SgVec=cell2mat(Network.Bus.Sg);

Network.Optimization.Status=BNLP.info;

Network.Optimization.Variables.vn3Phi=value(vn3Phi);
Network.Optimization.Variables.inm3Phi=value(inm3Phi);
Network.Optimization.Variables.vnmPrime3Phi=value(vnmPrime3Phi); 
Network.Optimization.Variables.inmPrime3Phi=value(inmPrime3Phi);

Network.Optimization.Variables.vn2Phi=value(vn2Phi);
Network.Optimization.Variables.inm2Phi=value(inm2Phi);
Network.Optimization.Variables.vn1Phi=value(vn1Phi);
Network.Optimization.Variables.inm1Phi=value(inm1Phi);
Network.Optimization.Variables.SIn=value(SIn);



Network.Optimization.Constraints.PowerFlowConstraints.P=PowerFlowConstraintsP;
Network.Optimization.Constraints.PowerFlowConstraints.Q=PowerFlowConstraintsQ;
Network.Optimization.Constraints.VMinConstraints.vn3Phi=VMinConstraints.vn3Phi;
Network.Optimization.Constraints.VMinConstraints.vn2Phi=VMinConstraints.vn2Phi;
Network.Optimization.Constraints.VMinConstraints.vn1Phi=VMinConstraints.vn1Phi;
Network.Optimization.Constraints.VMaxConstraints.vn3Phi=VMaxConstraints.vn3Phi;
Network.Optimization.Constraints.VMaxConstraints.vn2Phi=VMaxConstraints.vn2Phi;
Network.Optimization.Constraints.VMaxConstraints.vn1Phi=VMaxConstraints.vn1Phi;
Network.Optimization.OptimalValue=value(Objective)/Scale;
Network.Optimization.TimeInfo=BNLP.solvertime;

