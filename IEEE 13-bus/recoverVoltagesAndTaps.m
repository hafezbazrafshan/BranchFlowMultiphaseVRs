dbstop if error;
BranchList=Network.BranchList;
vn3Phi=zeros(3,NBuses3Phi); 
vn2Phi=zeros(2,NBuses2Phi);
vn1Phi=zeros(1,NBuses1Phi);

inm3Phi=zeros(3,NBranches3Phi); 
inm2Phi=zeros(2,NBranches2Phi); 
inm1Phi=zeros(1,NBranches1Phi); 

vnmPrime3Phi=zeros(3,NRegs3Phi); 
inmPrime3Phi=zeros(3,NRegs3Phi); 




n=Bus.SubstationNumber;
        nn=find(Bus.ThreePhaseBusNumbers==n); 
vn3Phi(:,nn)=vS;

for i=1:length(BranchList)
    l=BranchList(i);
    n=Branch.BusFromNumbers(l);
    m=Branch.BusToNumbers(l);
    VnnTilde=zeros(3);
    SnmTilde=zeros(3);
    vnTilde=zeros(3,1);
     ZnmTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.ZNM;
     
      % things I use
    if length(Bus.Phases{n})==3
        nn=find(Bus.ThreePhaseBusNumbers==n); 
        VnnTilde=Vnn3Phi(:,:,nn);
        vnTilde=vn3Phi(:,nn);
    elseif length(Bus.Phases{n})==2
        nn=find(Bus.TwoPhaseBusNumbers==n); 
        VnnTilde(Bus.Phases{n}, Bus.Phases{n})=Vnn2Phi(:,:,nn);
        vnTilde(Bus.Phases{n})=vn2Phi(:,nn);
    else
        nn=find(Bus.OnePhaseBusNumbers==n); 
        VnnTilde(Bus.Phases{n},Bus.Phases{n})=Vnn1Phi(:,:,nn); 
        vnTilde(Bus.Phases{n})=vn1Phi(:,nn);
    end
    
    if length(Branch.Phases{l})==3
        ll=find(Branch.ThreePhaseBranchNumbers==l); 
        SnmTilde=Snm3Phi(:,:,ll); 
    elseif length(Branch.Phases{l})==2
        ll=find(Branch.TwoPhaseBranchNumbers==l); 
        SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm2Phi(:,:,ll); 
    else
        ll=find(Branch.OnePhaseBranchNumbers==l); 
        SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm1Phi(:,:,ll); 
    end
    
    
    % things I compute
    vmTilde=zeros(3,1);
    inmTilde=zeros(3,1);
    
    inmTilde=(1./trace(VnnTilde))*SnmTilde'*vnTilde;

    
    
   switch char(Branch.Device{l})
       
       case 'Reg'
           
           % additional things I compute
         SnmPrimeTilde=zeros(3,3);
         inmPrimeTilde=zeros(3,1);
         vnmPrimeTilde=zeros(3,1);
         
%         
%         
%      
        r=find(Branch.RegulatorBranchNumbers==l);
        RegulatorType=Branch.RegulatorTypes{r};
%         
        if length(Branch.Phases{l})==3
            
            rr=find(Branch.Regs3PhiBranchNumbers==l); % three phase regulator number
        SnmPrimeTilde=SnmPrime3Phi(:,:,rr);
        switch RegulatorType
            case 'Wye'
%                 AnmTilde=diag(R3Phi(:,rr));
                
[U2,S2,V2]=svd(VnmPrime3Phi(:,:,rr));


u2=U2(:,1)*sqrt(S2(1,1));

sol=fsolve(@(x) [real(vnTilde-[x(1), 0, 0; 0, x(2), 0; 0, 0, x(3)]*u2.*exp(j*[x(4);x(5);x(6)]));...
    imag(vnTilde-[x(1), 0, 0; 0, x(2), 0; 0, 0, x(3)]*u2.*exp(j*[x(4);x(5);x(6)]))], [1; 1; 1; 0; 0 ; 0]);

ArA=sol(1); 
ArB=sol(2); 
ArC=sol(3);
vnmPrimeTilde=u2.*exp(j*sol(4:6));

 Av=diag([ArA; ArB; ArC]);
% vnmPrimeTilde=inv(Av)*vnTilde;


TapA=round((-ArA+1)./(0.00625));
TapB=round((-ArB+1)./(0.00625));
TapC=round((-ArC+1)./(0.00625));


     rrr=find(Branch.Wye3PhiBranchNumbers==l); % which wye 3Phi regulator number it is
Branch.Wye3PhiTaps(:,rrr)=[TapA;TapB;TapC];
Branch.Wye3PhiAvs{rrr}=Av;

                
            case 'ClosedDelta'
%                 ArAB=R3Phi(1,rr);
%                 ArBC=R3Phi(2,rr);
%                 ArCA=R3Phi(3,rr);
                
%                 
% ArAB=sqrt(RSquared3Phi(1,1,r)); 
% ArBC=sqrt(RSquared3Phi(2,2,r)); 
% ArCA=sqrt(RSquared3Phi(3,3,r));
%                 AnmTilde=[ArAB, 1-ArAB, 0; 0, ArBC, 1-ArBC; 1-ArCA, 0, ArCA];

%                 
%                 
[U1,S1,V1]=svd(Vnn3Phi(:,:,nn)); 
[U2,S2,V2]=svd(VnmPrime3Phi(:,:,rr));

u1=U1(:,1)*sqrt(S1(1,1));
% u1=vnTilde;

u2=U2(:,1)*sqrt(S2(1,1));
% 
sol=fsolve(@(x) [real(u1-[x(1), 1-x(1), 0; 0, x(2), 1-x(2); 1-x(3), 0, x(3)]*u2.*exp(j*[x(4);x(5);x(6)]));...
    imag(u1-[x(1), 1-x(1), 0; 0, x(2), 1-x(2); 1-x(3), 0, x(3)]*u2.*exp(j*[x(4);x(5);x(6)]))], [1; 1; 1; 0; 0 ; 0]);


sol=fsolve(@(x) [real(u1-[x(1), 1-x(1), 0; 0, x(2), 1-x(2); 1-x(3), 0, x(3)]*u2);...
    imag(u1-[x(1), 1-x(1), 0; 0, x(2), 1-x(2); 1-x(3), 0, x(3)]*u2)], [1; 1; 1]);

ArAB=sol(1); 
ArBC=sol(2); 
ArCA=sol(3);
vnmPrimeTilde=u2.*exp(j*sol(4:6));

                

 TapAB=round((-ArAB+1)./(0.00625));
TapBC=round((-ArBC+1)./(0.00625));
TapCA=round((-ArCA+1)./(0.00625));

 Av=[ArAB 1-ArAB 0; 0 ArBC 1-ArBC; 1-ArCA 0 ArCA];
 
 vnmPrimeTilde=inv(Av)*vnTilde;



            rrr=find(Branch.ClosedDeltaBranchNumbers==l); % which 3Phi regulator number it is
Branch.ClosedDeltaTaps(:,rrr)=[TapAB;TapBC;TapCA];
Branch.ClosedDeltaAvs{rrr}=Av;

                
            case 'OpenDelta'
                ArAB=R3Phi(1,rr);
                ArCB=R3Phi(3,rr);
%                 AnmTilde=[ArAB, 1-ArAB, 0; 0, 1, 0; 0, 1-ArCB, ArCB];


[U1,S1,V1]=svd(Vnn3Phi(:,:,nn));
[U2,S2,V2]=svd(VnmPrime3Phi(:,:,rr));
% 
u1=U1(:,1)*sqrt(S1(1,1));

u2=U2(:,1)*sqrt(S2(1,1));
% 
sol=fsolve(@(x) [real(u1-[x(1), 1-x(1), 0; 0, 1, 0; 0, 1-x(3), x(3)]*u2.*exp(j*[x(4);x(5);x(6)]));...
    imag(u1-[x(1), 1-x(1), 0; 0, 1, 0; 0, 1-x(3), x(3)]*u2.*exp(j*[x(4);x(5);x(6)]))], [1; 1; 1; 0; 0 ; 0]);
% 
ArAB=abs(sol(1)); 
ArCB=abs(sol(3));
vnmPrimeTilde=u2.*exp(j*sol(4:6));


TapAB=round((-ArAB+1)./(0.00625));
TapCB=round((-ArCB+1)./(0.00625));
    ArAB=1-0.00625*TapAB;
    ArCB=1-0.00625*TapCB;
    Av=[ArAB 1-ArAB 0; 0 1 0; 0 1-ArCB ArCB];
              

     rrr=find(Branch.OpenDeltaBranchNumbers==l); % which 3Phi regulator number it is
Branch.OpenDeltaTaps(:,rrr)=[TapAB;TapCB];
Branch.OpenDeltaAvs{rrr}=Av;


                
        
        end
        
        
         inmPrimeTilde=diag(1./vnmPrimeTilde)'*diag(SnmPrimeTilde');
%                          inmPrimeTilde=(1./trace(VnmPrimeTilde))*SnmPrimeTilde'*vnmPrimeTilde;
        inmPrime3Phi(:,rr)=inmPrimeTilde;
        elseif length(Branch.Phases{l})==2
             rr=find(Branch.Wye2PhaseBranchNumbers==l); % two phase regulator number
        SnmPrimeTilde(Branch.Phases{l},Branch.Phases{l})=SnmPrime2Phi(:,:,rr);
            AnmTilde(Branch.Phases{l},Branch.Phases{l})=diag(R2Phi(:,rr));
                vnmPrimeTilde(Branch.Phases{l})=AnmTilde(Branch.Phases{l},Branch.Phases{l})\vnTilde(Branch.Phases{l});
                inmPrimeTilde=diag(1./vnmPrimeTilde)'*diag(SnmPrimeTilde');
%                 inmPrimeTilde=(1./trace(VnmPrimeTilde))*SnmPrimeTilde'*vnmPrimeTilde;
               
         inmPrime2Phi(:,rr)=inmPrimeTilde(Branch.Phases{l});   
        else
            
            rr=find(Branch.Wye1PhaseBranchNumbers==l); % one phase regulator number
        SnmPrimeTilde(Branch.Phases{l},Branch.Phases{l})=SnmPrime1Phi(:,:,rr);
            AnmTilde(Branch.Phases{l},Branch.Phases{l})=diag(R1Phi(:,rr));
                vnmPrimeTilde(Branch.Phases{l})=AnmTilde(Branch.Phases{l},Branch.Phases{l})\vnTilde(Branch.Phases{l});
                inmPrimeTilde=diag(1./vnmPrimeTilde)'*diag(SnmPrimeTilde');
                %                 inmPrimeTilde=(1./trace(VnmPrimeTilde))*SnmPrimeTilde'*vnmPrimeTilde;

%          
         inmPrime1Phi(:,rr)=inmPrimeTilde(Branch.Phases{l});   

            
        end
        
        
                vmTilde=vnmPrimeTilde-ZnmTilde*inmPrimeTilde;

        
        if length(Branch.Phases{l})==3
        mm=find(Bus.ThreePhaseBusNumbers==m); 
           vn3Phi(:,mm)=vmTilde;
         elseif length(Branch.Phases{l})==2
        mm=find(Bus.TwoPhaseBusNumbers==m); 
        vn2Phi(:,mm)=vmTilde(Branch.Phases{l});
        else
        mm=find(Bus.OnePhaseBusNumbers==m); 
        vn1Phi(:,mm)=vmTilde(Branch.Phases{l});
        end
        
    

           
           
       otherwise
           
          
    
    
    % things I compute
        
        vmTilde=vnTilde-ZnmTilde*inmTilde;
        
        if length(Branch.Phases{l})==3
        ll=find(Branch.ThreePhaseBranchNumbers==l);
        inm3Phi(:,ll)=inmTilde;
        mm=find(Bus.ThreePhaseBusNumbers==m); 
        vn3Phi(:,mm)=vmTilde;
         elseif length(Branch.Phases{l})==2
            ll=find(Branch.TwoPhaseBranchNumbers==l);
            inm2Phi(:,ll)=inmTilde(Branch.Phases{l});
        mm=find(Bus.TwoPhaseBusNumbers==m); 
        vn2Phi(:,mm)=vmTilde(Branch.Phases{l});
        else
            ll=find(Branch.OnePhaseBranchNumbers==l);  
            inm1Phi(:,ll)=inmTilde(Branch.Phases{l});
        mm=find(Bus.OnePhaseBusNumbers==m); 
        vn1Phi(:,mm)=vmTilde(Branch.Phases{l});
        end
        
    end
    
    
    
    
%     
%     
        
           
end





Voltage3PhaseEstimate=NaN(NBuses,3);
for n=1:NBuses
    
    if length(Network.Bus.Phases{n})==3
        nn=find(Network.Bus.ThreePhaseBusNumbers==n);
    Voltage3PhaseEstimate(n,Network.Bus.Phases{n})=vn3Phi(:,nn).';
    elseif length(Network.Bus.Phases{n})==2
        nn=find(Network.Bus.TwoPhaseBusNumbers==n);
        Voltage3PhaseEstimate(n,Network.Bus.Phases{n})=vn2Phi(:,nn).';
    else
        
        nn=find(Network.Bus.OnePhaseBusNumbers==n);
        Voltage3PhaseEstimate(n,Network.Bus.Phases{n})=vn1Phi(:,nn).';
    end
    
    


end


VoltageEstimate=vec(Voltage3PhaseEstimate.');
VoltageEstimate=VoltageEstimate(Network.Bus.NonZeroPhaseNumbers);




Network.Bus=Bus;
Network.Branch=Branch;


Network.Optimization.VoltageEstimate=VoltageEstimate;
Network.Optimization.Voltage3PhaseEstimate=Voltage3PhaseEstimate;
Network.Optimization.InitialVoltage=VoltageEstimate; % similar 
