 RegBranchNumber=Branch.Wye1PhiBranchNumbers(r);
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
     else 
         nn=find(Bus.OnePhaseBusNumbers==n); 
         WTilde=Wnn1Phi(:,:,nn);
     end
         
    mm=find(Bus.OnePhaseBusNumbers==m);
          
    


WPrime1Phi(:,:,r)=[WnnPrime1Phi(:,:,r), WnmPrime1Phi(:,:,r);
   conj(WnmPrime1Phi(:,:,r)).', Wnn1Phi(:,:,mm)];
WPrime1Phi(:,:,r)>=0;


VMIN.^2<=diag(real(WnnPrime1Phi(:,:,r)))<=VMAX.^2;
% diag(imag(WnnPrime1Phi(:,:,r)))==0;








