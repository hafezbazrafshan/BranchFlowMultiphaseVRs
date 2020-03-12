 RegBranchNumber=Branch.Wye1PhiBranchNumbers(r);
 rr=find(Branch.RegulatorBranchNumbers==RegBranchNumber);% which regulator number it is
   clear rr;

     n=Branch.BusFromNumbers(RegBranchNumber); % primary
    ll=find(Branch.OnePhaseBranchNumbers==RegBranchNumber);

     
     if length(Bus.Phases{n})==3
    nn=find(Bus.ThreePhaseBusNumbers==n);
    VTilde=Vnn3Phi(Branch.Phases{RegBranchNumber},Branch.Phases{RegBranchNumber},nn);
     elseif length(Bus.Phases{n})==2
             nn=find(Bus.TwoPhaseBusNumbers==n);
             PhiIdx=find(Bus.Phases{n}==Branch.Phases{RegBranchNumber}); 
             VTilde=Vnn2Phi(PhiIdx,PhiIdx,nn);
     else 
         nn=find(Bus.OnePhaseBusNumbers==n); 
         VTilde=Vnn1Phi(:,:,nn);
     end
         
          
    





VMIN.^2<=diag(real(VnmPrime1Phi(:,:,r)))<=VMAX.^2;









