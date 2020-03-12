 RegBranchNumber=Branch.Regs3PhiBranchNumbers(r);
 rr=find(Branch.RegulatorBranchNumbers==RegBranchNumber);% which regulator number it is
   RegulatorType=Branch.RegulatorTypes{rr};
   clear rr;

     n=Branch.BusFromNumbers(RegBranchNumber); % primary
     m=Branch.BusToNumbers(RegBranchNumber); % secondary
    nn=find(Bus.ThreePhaseBusNumbers==n);
    mm=find(Bus.ThreePhaseBusNumbers==m);
    ll=find(Branch.ThreePhaseBranchNumbers==RegBranchNumber);
          
    




Constraints=[Constraints,abs(vnmPrime3Phi(:,r))<=VMAX];
Constraints=[Constraints,real(vnmPrime3Phi(:,r)).^2+imag(vnmPrime3Phi(:,r)).^2>=VMIN.^2];
assign(vnmPrime3Phi(:,r),1); % initial value





