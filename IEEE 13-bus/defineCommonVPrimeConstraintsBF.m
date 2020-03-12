 RegBranchNumber=Branch.Regs3PhiBranchNumbers(r);
 rr=find(Branch.RegulatorBranchNumbers==RegBranchNumber);% which regulator number it is
   RegulatorType=Branch.RegulatorTypes{rr};
   clear rr;

     n=Branch.BusFromNumbers(RegBranchNumber); % primary
     m=Branch.BusToNumbers(RegBranchNumber); % secondary
    nn=find(Bus.ThreePhaseBusNumbers==n);
    mm=find(Bus.ThreePhaseBusNumbers==m);
    ll=find(Branch.ThreePhaseBranchNumbers==RegBranchNumber);
          
    




VMIN.^2<=diag(real(VnmPrime3Phi(:,:,r)))<=VMAX.^2;
diag(imag(VnmPrime3Phi(:,:,r)))==0;





