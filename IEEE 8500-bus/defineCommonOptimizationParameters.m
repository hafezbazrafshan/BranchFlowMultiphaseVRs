
Branch=Network.Branch;
Bus=Network.Bus;
vS=Network.vS;
VMIN=Network.VMIN;
VMAX=Network.VMAX;
RMIN=Network.RMIN;
RMAX=Network.RMAX;


NBuses=length(Bus.Numbers);
NBranches=length(Branch.Numbers);
NPhases=length(Bus.NonZeroPhaseNumbers);


% this separation is useful to count the variables
NBuses3Phi=length(Bus.ThreePhaseBusNumbers); % number of three-phase buses
NBuses2Phi=length(Bus.TwoPhaseBusNumbers); 
NBuses1Phi=length(Bus.OnePhaseBusNumbers); 
NBranches3Phi=length(Branch.ThreePhaseBranchNumbers);
NBranches2Phi=length(Branch.TwoPhaseBranchNumbers);
NBranches1Phi=length(Branch.OnePhaseBranchNumbers); 

NRegs3Phi=length(Branch.Regs3PhiBranchNumbers);
NRegs2Phi=length(Branch.Wye2PhiBranchNumbers);
NRegs1Phi=length(Branch.Wye1PhiBranchNumbers);