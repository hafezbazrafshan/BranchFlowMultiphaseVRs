%% 3. Solving for taps:
Wnn3Phi=full(Wnn3Phi);
WnnPrime3Phi=full(WnnPrime3Phi);
WnnPrime2Phi=full(WnnPrime2Phi);
WnnPrime1Phi=full(WnnPrime1Phi);



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

% if  ~exist ('R3Phi','var')
ArA=sqrt(Wnn3Phi(1,1,nn)./WnnPrime3Phi(1,1,r));
ArB=sqrt(Wnn3Phi(2,2,nn)./WnnPrime3Phi(2,2,r));
ArC=sqrt(Wnn3Phi(3,3,nn)./WnnPrime3Phi(3,3,r));

% else
% ArA=R3Phi(1,r); 
% ArB=R3Phi(2,r); 
% ArC=R3Phi(3,r);
% end


 Av=diag([ArA; ArB; ArC]);

TapA=round((-ArA+1)./(0.00625));
TapB=round((-ArB+1)./(0.00625));
TapC=round((-ArC+1)./(0.00625));
% 
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
    ArAB=1-0.00625*TapAB;
    ArCB=1-0.00625*TapCB;
    Av=[ArAB 1-ArAB 0; 0 1 0; 0 1-ArCB ArCB];
              

     rr=find(Branch.OpenDeltaBranchNumbers==RegBranchNumber); % which 3Phi regulator number it is
Branch.OpenDeltaTaps(:,rr)=[TapAB;TapCB];
Branch.OpenDeltaAvs{rr}=Av;

        case 'ClosedDelta'


        
                
%         
% D=[1 -1 0; 0 1 -1; -1 0 1];
%         F=[0 1 0; 0 0 1; 1 0 0];
%          APrime=real(Vnn3Phi(:,:,nn));
%          BPrime=imag(Vnn3Phi(:,:,nn));
%                A=real(VnmPrime3Phi(:,:,r));
%          B=imag(VnmPrime3Phi(:,:,r));
% aMatrix=D*A*D.';
%         bMatrix=D*A*F.';
%         cMatrix=F*A*F.';
% 
%         
%         
% DeltaAB=bMatrix(1,1).^2-aMatrix(1,1)*(cMatrix(1,1)-APrime(1,1));
% rAB1=(-bMatrix(1,1)+sqrt(DeltaAB))./(aMatrix(1,1));
% ArAB=rAB1;
% DeltaBC=bMatrix(2,2).^2-aMatrix(2,2)*(cMatrix(2,2)-APrime(2,2));
% rBC=(-bMatrix(2,2)+sqrt(DeltaBC))./(aMatrix(2,2));
% ArBC=rBC;
% 
% DeltaCA=bMatrix(3,3).^2-aMatrix(3,3)*(cMatrix(3,3)-APrime(3,3));
% rCA=(-bMatrix(3,3)+sqrt(DeltaCA))./(aMatrix(3,3));
% ArCA=rCA;

% % 
ArAB=R3Phi(1,r); 
ArBC=R3Phi(2,r); 
ArCA=R3Phi(3,r);




 TapAB=round((-ArAB+1)./(0.00625));
TapBC=round((-ArBC+1)./(0.00625));
TapCA=round((-ArCA+1)./(0.00625));
% 
    ArAB=1-0.00625*TapAB;
ArBC=1-0.00625*TapBC;
 ArCA=1-0.00625*TapCA;
%                         
 Av=[ArAB 1-ArAB 0; 0 ArBC 1-ArBC; 1-ArCA 0 ArCA];



            rr=find(Branch.ClosedDeltaBranchNumbers==RegBranchNumber); % which 3Phi regulator number it is
Branch.ClosedDeltaTaps(:,rr)=[TapAB;TapBC;TapCA];
Branch.ClosedDeltaAvs{rr}=Av;

           
   end

      

end


for r=1:NRegs2Phi
     RegBranchNumber=Branch.Regs2PhiBranchNumbers(r);
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



%  if  ~exist ('R2Phi','var')
Ar1=sqrt(WTilde(1,1)./WnnPrime2Phi(1,1,r));
Ar2=sqrt(WTilde(2,2)./WnnPrime2Phi(2,2,r));
%  else
%      Ar1=R2Phi(2,r);
%      Ar2=R2Phi(1,r);
%  end


Tap1=round((-Ar1+1)./(0.00625));
Tap2=round((-Ar2+1)./(0.00625));

Ar1=1-0.00625*Tap1;
Ar2=1-0.00625*Tap2;
Av=diag([Ar1; Ar2]);

     rr=find(Branch.Wye2PhiBranchNumbers==RegBranchNumber); % which 3Phi regulator number it is
Branch.Wye2PhiTaps(:,rr)=[Tap1;Tap2];
Branch.Wye2PhiAvs{rr}=Av;
 
end
   


for r=1:NRegs1Phi
     RegBranchNumber=Branch.Regs1PhiBranchNumbers(r);
 m=Branch.BusToNumbers(RegBranchNumber); % secondary
     n=Branch.BusFromNumbers(RegBranchNumber); % primary
 if length(Bus.Phases{n})==3
    nn=find(Bus.ThreePhaseBusNumbers==n);
    WTilde=Wnn3Phi(Branch.Phases{RegBranchNumber},Branch.Phases{RegBranchNumber},nn);
     elseif length(Bus.Phases{n})==2
             nn=find(Bus.TwoPhaseBusNumbers==n);
             WTilde=Wnn2Phi(Branch.Phases{RegBranchNumber},Branch.Phases{RegBranchNumber},nn);
 else
     nn=find(Bus.OnePhaseBusNumbers==n);
      WTilde=Wnn1Phi(:,:,nn);
 end
    mm=find(Bus.OnePhaseBusNumbers==m);
    
% 
%  if  ~exist ('R1Phi','var')
Ar1=sqrt(WTilde(1,1)./WnnPrime1Phi(1,1,r));
%  else
%      Ar1=R1Phi(1,r);
%  end

Tap1=round((-Ar1+1)./(0.00625));

Ar1=1-0.00625*Tap1;
Av=Ar1;

     rr=find(Branch.Wye1PhiBranchNumbers==RegBranchNumber); % which 3Phi regulator number it is
Branch.Wye1PhiTaps(:,rr)=[Tap1];
Branch.Wye1PhiAvs{rr}=Av;
 
   end

Bus.Sg=Sg; 
Network.Bus=Bus;
Network.Branch=Branch;