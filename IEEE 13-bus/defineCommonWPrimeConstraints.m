 RegBranchNumber=Branch.Regs3PhiBranchNumbers(r);
 rr=find(Branch.RegulatorBranchNumbers==RegBranchNumber);% which regulator number it is
   RegulatorType=Branch.RegulatorTypes{rr};
   clear rr;

     m=Branch.BusToNumbers(RegBranchNumber); % secondary
     n=Branch.BusFromNumbers(RegBranchNumber); % primary
    nn=find(Bus.ThreePhaseBusNumbers==n);
    mm=find(Bus.ThreePhaseBusNumbers==m);
          
    


WPrime3Phi(:,:,r)=[WnnPrime3Phi(:,:,r), WnmPrime3Phi(:,:,r);
   conj(WnmPrime3Phi(:,:,r)).', Wnn3Phi(:,:,mm)];
WPrime3Phi(:,:,r)>=0;



VMIN.^2<=diag(real(WnnPrime3Phi(:,:,r)))<=VMAX.^2;
diag(imag(WnnPrime3Phi(:,:,r)))==0;








