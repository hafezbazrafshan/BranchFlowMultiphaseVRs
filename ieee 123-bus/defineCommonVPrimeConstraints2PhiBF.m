 RegBranchNumber=Branch.Wye2PhiBranchNumbers(r);
 rr=find(Branch.RegulatorBranchNumbers==RegBranchNumber);% which regulator number it is
   clear rr;

     n=Branch.BusFromNumbers(RegBranchNumber); % primary
    ll=find(Branch.TwoPhaseBranchNumbers==RegBranchNumber);

     
     if length(Bus.Phases{n})==3
    nn=find(Bus.ThreePhaseBusNumbers==n);
    VTilde=Vnn3Phi(Branch.Phases{RegBranchNumber},Branch.Phases{RegBranchNumber},nn);
     elseif length(Bus.Phases{n})==2
             nn=find(Bus.TwoPhaseBusNumbers==n);
             VTilde=Vnn2Phi(:,:,nn);
     end
         
         
VMIN.^2<=diag(real(VnmPrime2Phi(:,:,r)))<=VMAX.^2;
diag(imag(VnmPrime2Phi(:,:,r)))==0;








