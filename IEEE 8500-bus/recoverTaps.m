%% 3. Solving for taps:
Wnn3Phi=full(Wnn3Phi);
WnnPrime3Phi=full(WnnPrime3Phi);




for r=1:NRegs3Phi
     RegBranchNumber=Branch.Regs3PhiBranchNumbers(r);
     
         
     rr=find(Branch.RegulatorBranchNumbers==RegBranchNumber);% which regulator number it is
   RegulatorType=Branch.RegulatorTypes{rr};
   clear rr
   
     m=Branch.BusToNumbers(RegBranchNumber); % secondary
     n=Branch.BusFromNumbers(RegBranchNumber); % primary
    nn=find(Bus.ThreePhaseBusNumbers==n);
    mm=find(Bus.ThreePhaseBusNumbers==m);
    

   
   switch RegulatorType
       case 'Wye'
% % 


ArA=sqrt(WnnPrime3Phi(1,1,r)./Wnn3Phi(1,1,nn));
ArB=sqrt(WnnPrime3Phi(2,2,r)./Wnn3Phi(2,2,nn));
ArC=sqrt(WnnPrime3Phi(3,3,r)./Wnn3Phi(3,3,nn));


 Av=diag([ArA; ArB; ArC]);

TapA=round((ArA-1)./(0.00625));
TapB=round((ArB-1)./(0.00625));
TapC=round((ArC-1)./(0.00625));
% 
% ArA=1+0.00625*TapA;
% ArB=1+0.00625*TapB;
% ArC=1+0.00625*TapC;
Av=inv(diag([ArA; ArB; ArC]));

     rr=find(Branch.Wye3PhiBranchNumbers==RegBranchNumber); % which 3Phi regulator number it is
Branch.Wye3PhiTaps(:,rr)=[TapA;TapB;TapC];
Branch.Wye3PhiAvs{rr}=Av;
 

   end
end



Bus.Sg=Sg; 
Network.Bus=Bus;
Network.Branch=Branch;