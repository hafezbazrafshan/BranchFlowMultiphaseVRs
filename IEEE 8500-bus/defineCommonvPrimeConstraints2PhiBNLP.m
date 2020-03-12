 RegBranchNumber=Branch.Wye2PhiBranchNumbers(r);
 rr=find(Branch.RegulatorBranchNumbers==RegBranchNumber);% which regulator number it is

     n=Branch.BusFromNumbers(RegBranchNumber); % primary
    ll=find(Branch.TwoPhaseBranchNumbers==RegBranchNumber);

vTilde=sdpvar(2,1,'full','complex'); 
     
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
         
         
Constraints=[Constraints,abs(vnmPrime2Phi(:,r))<=VMAX];
Constraints=[Constraints,real(vnmPrime2Phi(:,r)).^2+imag(vnmPrime2Phi(:,r)).^2>=VMIN.^2];
assign(vnmPrime2Phi(:,r),Network.Solution.v3PhaseRegs(rr,Branch.Phases{RegBranchNumber}).'); % initial value

   clear rr;







