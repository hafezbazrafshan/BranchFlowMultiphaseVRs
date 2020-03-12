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
if  ~exist ('R3Phi','var')
ArA=sqrt(Wnn3Phi(1,1,nn)./WnnPrime3Phi(1,1,r));
ArB=sqrt(Wnn3Phi(2,2,nn)./WnnPrime3Phi(2,2,r));
ArC=sqrt(Wnn3Phi(3,3,nn)./WnnPrime3Phi(3,3,r));
else
    ArA=R3Phi(1,r); 
ArB=R3Phi(2,r); 
ArC=R3Phi(3,r);
end
Av=diag([ArA; ArB; ArC]);

TapA=round((-ArA+1)./(0.00625));
TapB=round((-ArB+1)./(0.00625));
TapC=round((-ArC+1)./(0.00625));
% % 
% ArA=1-0.00625*TapA;
% ArB=1-0.00625*TapB;
% ArC=1-0.00625*TapC;
Av=diag([ArA; ArB; ArC]);

     rr=find(Branch.Wye3PhiBranchNumbers==RegBranchNumber); % which 3Phi regulator number it is
Branch.Wye3PhiTaps(:,rr)=[TapA;TapB;TapC];
Branch.Wye3PhiAvs{rr}=Av;
 


       case 'OpenDelta'





ArAB=R3Phi(1,r); 
ArCB=R3Phi(3,r);




TapAB=round((-ArAB+1)./(0.00625));
TapCB=round((-ArCB+1)./(0.00625));
%     ArAB=1-0.00625*TapAB;
%     ArCB=1-0.00625*TapCB;
    Av=[ArAB 1-ArAB 0; 0 1 0; 0 1-ArCB ArCB];
              

     rr=find(Branch.OpenDeltaBranchNumbers==RegBranchNumber); % which 3Phi regulator number it is
Branch.OpenDeltaTaps(:,rr)=[TapAB;TapCB];
Branch.OpenDeltaAvs{rr}=Av;


 case 'ClosedDelta'


        
        



ArAB=R3Phi(1,r); 
ArBC=R3Phi(2,r); 
ArCA=R3Phi(3,r);







 TapAB=round((-ArAB+1)./(0.00625));
TapBC=round((-ArBC+1)./(0.00625));
TapCA=round((-ArCA+1)./(0.00625));
% 
%     ArAB=1-0.00625*TapAB;
% ArBC=1-0.00625*TapBC;
%  ArCA=1-0.00625*TapCA;
                        
 Av=[ArAB 1-ArAB 0; 0 ArBC 1-ArBC; 1-ArCA 0 ArCA];



            rr=find(Branch.ClosedDeltaBranchNumbers==RegBranchNumber); % which 3Phi regulator number it is
Branch.ClosedDeltaTaps(:,rr)=[TapAB;TapBC;TapCA];
Branch.ClosedDeltaAvs{rr}=Av;

           
   end

   
end

Bus.Sg=Sg; 
Network.Bus=Bus;
Network.Branch=Branch;