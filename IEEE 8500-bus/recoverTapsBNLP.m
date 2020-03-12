%% 3. Solving for taps:


R3Phi=value(R3Phi);
% R2Phi=value(R2Phi); 
% R1Phi=value(R1Phi);

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


ArA=R3Phi(1,r); 
ArB=R3Phi(2,r); 
ArC=R3Phi(3,r);



%  Av=diag([ArA; ArB; ArC]);

TapA=round((ArA-1)./(0.00625));
TapB=round((ArB-1)./(0.00625));
TapC=round((ArC-1)./(0.00625));
% 
% ArA=1+0.00625*TapA;
% ArB=1+0.00625*TapB;
% ArC=1+0.00625*TapC;
% 


Av=inv(diag([ArA; ArB; ArC]));

     rr=find(Branch.Wye3PhiBranchNumbers==RegBranchNumber); % which 3Phi regulator number it is
Branch.Wye3PhiTaps(:,rr)=[TapA;TapB;TapC];
Branch.Wye3PhiAvs{rr}=Av;
 

       case 'OpenDelta'




% 
ArAB=R3Phi(1,r); 
ArCB=R3Phi(3,r);




TapAB=round((ArAB-1)./(0.00625));
TapCB=round((ArCB-1)./(0.00625));
%     ArAB=1+0.00625*TapAB;
%     ArCB=1+0.00625*TapCB;
    Av=inv([ArAB 1-ArAB 0; 0 1 0; 0 1-ArCB ArCB]);
              
              

     rr=find(Branch.OpenDeltaBranchNumbers==RegBranchNumber); % which 3Phi regulator number it is
Branch.OpenDeltaTaps(:,rr)=[TapAB;TapCB];
Branch.OpenDeltaAvs{rr}=Av;


       case 'ClosedDelta'


        
        



ArAB=R3Phi(1,r); 
ArBC=R3Phi(2,r); 
ArCA=R3Phi(3,r);






 TapAB=round((ArAB-1)./(0.00625));
TapBC=round((ArBC-1)./(0.00625));
TapCA=round((ArCA-1)./(0.00625));
% 
%     ArAB=1+0.00625*TapAB;
% ArBC=1+0.00625*TapBC;
%  ArCA=1+0.00625*TapCA;
%                         
 Av=inv([ArAB 1-ArAB 0; 0 ArBC 1-ArBC; 1-ArCA 0 ArCA]);


            rr=find(Branch.ClosedDeltaBranchNumbers==RegBranchNumber); % which 3Phi regulator number it is
Branch.ClosedDeltaTaps(:,rr)=[TapAB;TapBC;TapCA];
Branch.ClosedDeltaAvs{rr}=Av;

           
   end
end


% 
% for r=1:NRegs2Phi
%      RegBranchNumber=Branch.Regs2PhiBranchNumbers(r);
%  m=Branch.BusToNumbers(RegBranchNumber); % secondary
%      n=Branch.BusFromNumbers(RegBranchNumber); % primary
% 
%     
% 
%      Ar1=R2Phi(1,r);
%      Ar2=R2Phi(2,r);
% 
% 
% 
% 
% Tap1=round((-Ar1+1)./(0.00625));
% Tap2=round((-Ar2+1)./(0.00625));
% 
% % Ar1=1-0.00625*Tap1;
% % Ar2=1-0.00625*Tap2;
% Av=diag([Ar1; Ar2]);
% 
%      rr=find(Branch.Wye2PhiBranchNumbers==RegBranchNumber); % which 3Phi regulator number it is
% Branch.Wye2PhiTaps(:,rr)=[Tap1;Tap2];
% Branch.Wye2PhiAvs{rr}=Av;
%  
% end
%    
% 
% 
% for r=1:NRegs1Phi
%      RegBranchNumber=Branch.Regs1PhiBranchNumbers(r);
%  m=Branch.BusToNumbers(RegBranchNumber); % secondary
%      n=Branch.BusFromNumbers(RegBranchNumber); % primary
%  
%     
% 
% 
%     Ar1=R1Phi(1,r);
% 
% 
% 
% Tap1=round((-Ar1+1)./(0.00625));
% 
% % Ar1=1-0.00625*Tap1;
% Av=Ar1;
% 
%      rr=find(Branch.Wye1PhiBranchNumbers==RegBranchNumber); % which 3Phi regulator number it is
% Branch.Wye1PhiTaps(:,rr)=[Tap1];
% Branch.Wye1PhiAvs{rr}=Av;
%  
%    end



Network.Bus=Bus;
Network.Branch=Branch;