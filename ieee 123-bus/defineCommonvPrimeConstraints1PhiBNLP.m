 RegBranchNumber=Branch.Wye1PhiBranchNumbers(r);
 rr=find(Branch.RegulatorBranchNumbers==RegBranchNumber);% which regulator number it is

     n=Branch.BusFromNumbers(RegBranchNumber); % primary
    ll=find(Branch.OnePhaseBranchNumbers==RegBranchNumber);

vTilde=sdpvar(1,1,'full','complex'); 

     
     if length(Bus.Phases{n})==3
    nn=find(Bus.ThreePhaseBusNumbers==n);
    vTilde=vn3Phi(Branch.Phases{RegBranchNumber},nn);
     elseif length(Bus.Phases{n})==2
             nn=find(Bus.TwoPhaseBusNumbers==n);
             PhiIdx=find(Bus.Phases{n}==Branch.Phases{RegBranchNumber}); 
             vTilde=vn2Phi(PhiIdx,nn);
     else 
         nn=find(Bus.OnePhaseBusNumbers==n); 
         vTilde=vn1Phi(:,nn);
     end
         
          
    





Constraints=[Constraints,abs(vnmPrime1Phi(:,r))<=VMAX];
Constraints=[Constraints,real(vnmPrime1Phi(:,r)).^2+imag(vnmPrime1Phi(:,r)).^2>=VMIN.^2];
assign(vnmPrime1Phi(:,r),Network.Solution.v3PhaseRegs(rr,Branch.Phases{RegBranchNumber}).'); % initial value
   clear rr;








