%% 3. Solving for taps:
Vnn3Phi=full(Vnn3Phi);
VnmPrime3Phi=full(VnmPrime3Phi);




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
ArA=sqrt(Vnn3Phi(1,1,nn)./VnmPrime3Phi(1,1,r));
ArB=sqrt(Vnn3Phi(2,2,nn)./VnmPrime3Phi(2,2,r));
ArC=sqrt(Vnn3Phi(3,3,nn)./VnmPrime3Phi(3,3,r));

else
% ArA=R3Phi(1,r); 
% ArB=R3Phi(2,r); 
% ArC=R3Phi(3,r);


ArA=sqrt(RSquared3Phi(1,1,r)); 
ArB=sqrt(RSquared3Phi(2,2,r)); 
ArC=sqrt(RSquared3Phi(3,3,r));
end


% 
% 
% [U1,S1,V1]=svd(Vnn3Phi(:,:,nn)); 
% [U2,S2,V2]=svd(VnmPrime3Phi(:,:,r));
% 
% u1=U1(:,1)*sqrt(S1(1,1));
% 
% u2=U2(:,1)*sqrt(S2(1,1));
% 
% sol=fsolve(@(x) [real(u1-[x(1), 0, 0; 0, x(2), 0; 0, 0, x(3)]*u2.*exp(j*[x(4);x(5);x(6)]));...
%     imag(u1-[x(1), 0, 0; 0, x(2), 0; 0, 0, x(3)]*u2.*exp(j*[x(4);x(5);x(6)]))], [1; 1; 1; 0; 0 ; 0]);
% 
% ArA=sol(1); 
% ArB=sol(2); 
% ArC=sol(3);


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



% u1= [ 0.9964 - 0.0056i ; -0.5028 - 0.8614i;  -0.4929 + 0.8653i];

[U1,S1,V1]=svd(Vnn3Phi(:,:,nn));
[U2,S2,V2]=svd(VnmPrime3Phi(:,:,r));
% 
u1=U1(:,1)*sqrt(S1(1,1));

u2=U2(:,1)*sqrt(S2(1,1));
% 
sol=fsolve(@(x) [real(u1-[x(1), 1-x(1), 0; 0, 1, 0; 0, 1-x(3), x(3)]*u2.*exp(j*[x(4);x(5);x(6)]));...
    imag(u1-[x(1), 1-x(1), 0; 0, 1, 0; 0, 1-x(3), x(3)]*u2.*exp(j*[x(4);x(5);x(6)]))], [1; 1; 1; 0; 0 ; 0]);
% 
ArAB=abs(sol(1)); 
ArCB=abs(sol(3));



% 
% ArAB=R3Phi(1,r); 
% ArCB=R3Phi(3,r);
% 
% ArAB=sqrt(RSquared3Phi(1,1,r)); 
% ArCB=sqrt(RSquared3Phi(3,3,r)); 

% 
% ArAB=sqrt(UTilde(1,1)./UTildePrime(1,1));
% % ArBC=sqrt(UTilde(2,2)./UTildePrime(2,2));
% ArCB=sqrt(UTilde(3,3)./UTildePrime(3,3));



TapAB=round((-ArAB+1)./(0.00625));
TapCB=round((-ArCB+1)./(0.00625));
%     ArAB=1-0.00625*TapAB;
%     ArCB=1-0.00625*TapCB;
    Av=[ArAB 1-ArAB 0; 0 1 0; 0 1-ArCB ArCB];
              

     rr=find(Branch.OpenDeltaBranchNumbers==RegBranchNumber); % which 3Phi regulator number it is
Branch.OpenDeltaTaps(:,rr)=[TapAB;TapCB];
Branch.OpenDeltaAvs{rr}=Av;


       case 'ClosedDelta'


        
        

% 
% 
% ArAB=R3Phi(1,r); 
% ArBC=R3Phi(2,r); 
% ArCA=R3Phi(3,r);




% % 
% [U1,S1,V1]=svd(Vnn3Phi(:,:,nn)); 
% [U2,S2,V2]=svd(VnmPrime3Phi(:,:,r));
% 
% u1=U1(:,1)*sqrt(S1(1,1));
% u2=U2(:,1)*sqrt(S2(1,1));
% 
% sol=fsolve(@(x) [real(u1-[x(1), 1-x(1), 0; 0, x(2), 1-x(2); 1-x(3), 0, x(3)]*u2.*exp(j*[x(4);x(5);x(6)]));...
%     imag(u1-[x(1), 1-x(1), 0; 0, x(2), 1-x(2); 1-x(3), 0, x(3)]*u2.*exp(j*[x(4);x(5);x(6)]))], [1; 1; 1; 0; 0 ; 0]);
% 
% ArAB=abs(sol(1)); 
% ArBC=abs(sol(2)); 
% ArCA=abs(sol(3));




% 
% [R1,S1,~]=svd(RSquared3Phi);
% sol=abs(R1(:,1)*sqrt(S1(1,1)));
% 
% ArAB=sol(1); 
% ArBC=sol(2); 
% ArCA=sol(3);

ArAB=sqrt(RSquared3Phi(1,1,r)); 
ArBC=sqrt(RSquared3Phi(2,2,r)); 
ArCA=sqrt(RSquared3Phi(3,3,r));

% ArAB=sqrt(UTilde(1,1)./UTildePrime(1,1));
% ArBC=sqrt(UTilde(2,2)./UTildePrime(2,2));
% ArCA=sqrt(UTilde(3,3)./UTildePrime(3,3));





 TapAB=round((-ArAB+1)./(0.00625));
TapBC=round((-ArBC+1)./(0.00625));
TapCA=round((-ArCA+1)./(0.00625));

    ArAB=1-0.00625*TapAB;
ArBC=1-0.00625*TapBC;
 ArCA=1-0.00625*TapCA;
                        
 Av=[ArAB 1-ArAB 0; 0 ArBC 1-ArBC; 1-ArCA 0 ArCA];



            rr=find(Branch.ClosedDeltaBranchNumbers==RegBranchNumber); % which 3Phi regulator number it is
Branch.ClosedDeltaTaps(:,rr)=[TapAB;TapBC;TapCA];
Branch.ClosedDeltaAvs{rr}=Av;

           
   end
end


Network.Bus=Bus;
Network.Branch=Branch;