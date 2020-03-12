 RegBranchNumber=Branch.Wye2PhiBranchNumbers(r);
 rr=find(Branch.RegulatorBranchNumbers==RegBranchNumber);% which regulator number it is
   clear rr;

     m=Branch.BusToNumbers(RegBranchNumber); % secondary
     n=Branch.BusFromNumbers(RegBranchNumber); % primary
     
     if length(Bus.Phases{n})==3
    nn=find(Bus.ThreePhaseBusNumbers==n);
    WTilde=Wnn3Phi(Branch.Phases{RegBranchNumber},Branch.Phases{RegBranchNumber},nn);
     elseif length(Bus.Phases{n})==2
             nn=find(Bus.TwoPhaseBusNumbers==n);
             WTilde=Wnn2Phi(:,:,nn);
     end
         
    mm=find(Bus.TwoPhaseBusNumbers==m);
          
    


WPrime2Phi(:,:,r)=[WnnPrime2Phi(:,:,r), WnmPrime2Phi(:,:,r);
   conj(WnmPrime2Phi(:,:,r)).', Wnn2Phi(:,:,mm)];
WPrime2Phi(:,:,r)>=0;


VMIN.^2<=diag(real(WnnPrime2Phi(:,:,r)))<=VMAX.^2;
diag(imag(WnnPrime2Phi(:,:,r)))==0;








