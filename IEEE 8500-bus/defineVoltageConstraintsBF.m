VoltageDeviationExpression=cvx(0);
ThermalLossExpression=cvx(0);




% SlackVoltage constraint
Vnn3Phi(:,:,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber)==vS*vS';





for n=1:NBuses3Phi
    if Bus.ThreePhaseBusNumbers(n)~=Bus.SubstationNumber
        % voltage bounds constraint
    VMIN^2 <= diag(Vnn3Phi(:,:,n)) <=VMAX^2;
%         imag(diag(Vnn3Phi(:,:,n)))==0;

%     VoltageDeviationExpression=VoltageDeviationExpression+sum(abs(diag(Vnn3Phi(:,:,n))-1));

    end
end
for n=1:NBuses2Phi
            % voltage bounds constraint
    VMIN^2 <= diag(Vnn2Phi(:,:,n)) <=VMAX^2;
%     imag(diag(Vnn2Phi(:,:,n)))==0;
      
                  VoltageDeviationExpression=VoltageDeviationExpression+sum(abs(diag(Vnn2Phi(:,:,n))-1));

end

for n=1:NBuses1Phi
    % voltage bounds constraint
    VMIN^2 <= diag(Vnn1Phi(:,:,n)) <=VMAX^2;
%         imag(diag(Vnn1Phi(:,:,n)))==0;

%               VoltageDeviationExpression=VoltageDeviationExpression+sum(abs(diag(Vnn1Phi(:,:,n))-1));

end

% VoltageDeviationExpression<=VoltageDeviation;





for l=1:NBranches
    
    
     n=Branch.BusFromNumbers(l); 
    m=Branch.BusToNumbers(l);
   
    VnnTilde=cvx(zeros(3));
    VmmTilde=cvx(zeros(3));
    
    
    
       if length(Bus.Phases{n})==3
        kk=find(Bus.ThreePhaseBusNumbers==n);
        VnnTilde(Bus.Phases{n}, Bus.Phases{n})=Vnn3Phi(:,:,kk); 
        
    elseif length(Bus.Phases{n})==2
        kk=find(Bus.TwoPhaseBusNumbers==n);
        VnnTilde(Bus.Phases{n}, Bus.Phases{n})=Vnn2Phi(:,:,kk); 
    else 
        kk=find(Bus.OnePhaseBusNumbers==n); 
        VnnTilde(Bus.Phases{n}, Bus.Phases{n})=Vnn1Phi(:,:,kk); 
       end
    
   
          if length(Bus.Phases{m})==3
        kk=find(Bus.ThreePhaseBusNumbers==m);
        VmmTilde(Bus.Phases{m}, Bus.Phases{m})=Vnn3Phi(:,:,kk); 
        
    elseif length(Bus.Phases{m})==2
        kk=find(Bus.TwoPhaseBusNumbers==m);
        VmmTilde(Bus.Phases{m}, Bus.Phases{m})=Vnn2Phi(:,:,kk); 
    else 
        kk=find(Bus.OnePhaseBusNumbers==m); 
        VmmTilde(Bus.Phases{m}, Bus.Phases{m})=Vnn1Phi(:,:,kk); 
   end
    
          
    if ~strcmp(Branch.Device{l},'Reg')
         SnmTilde=cvx(zeros(3));
            InmTilde=cvx(zeros(3));

    if length(Branch.Phases{l})==3
        ll=find(Branch.ThreePhaseBranchNumbers==l); 
        SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm3Phi(:,:,ll); 
         InmTilde(Branch.Phases{l},Branch.Phases{l})=Inm3Phi(:,:,ll); 

        W3Phi(:,:,ll)=[VnnTilde(Branch.Phases{l}, Branch.Phases{l}), SnmTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(SnmTilde(Branch.Phases{l},Branch.Phases{l}).'), InmTilde(Branch.Phases{l},Branch.Phases{l})];
         W3Phi(:,:,ll) >=0;
 
    elseif length(Branch.Phases{l})==2
      ll=find(Branch.TwoPhaseBranchNumbers==l); 
      SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm2Phi(:,:,ll);
            InmTilde(Branch.Phases{l},Branch.Phases{l})=Inm2Phi(:,:,ll);
       W2Phi(:,:,ll)=[VnnTilde(Branch.Phases{l}, Branch.Phases{l}), SnmTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(SnmTilde(Branch.Phases{l},Branch.Phases{l}).'), InmTilde(Branch.Phases{l},Branch.Phases{l})];
         W2Phi(:,:,ll) >=0;
         


    else
        ll=find(Branch.OnePhaseBranchNumbers==l); 
        SnmTilde(Branch.Phases{l}, Branch.Phases{l})=Snm1Phi(:,:,ll); 
        InmTilde(Branch.Phases{l},Branch.Phases{l})=Inm1Phi(:,:,ll);
          W1Phi(:,:,ll)=[VnnTilde(Branch.Phases{l}, Branch.Phases{l}), SnmTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(SnmTilde(Branch.Phases{l},Branch.Phases{l}).'), InmTilde(Branch.Phases{l},Branch.Phases{l})];
         W1Phi(:,:,ll) >=0;



    end
    
    ZNMTilde=zeros(3);
        
    
     ZNMTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.ZNM;
        VmmTilde(Branch.Phases{l},Branch.Phases{l})==VnnTilde(Branch.Phases{l},Branch.Phases{l})-...
        (ZNMTilde(Branch.Phases{l},Branch.Phases{l})*conj(SnmTilde(Branch.Phases{l},Branch.Phases{l}).')+...
        SnmTilde(Branch.Phases{l},Branch.Phases{l})*conj(ZNMTilde(Branch.Phases{l},Branch.Phases{l}).'))+...
        ZNMTilde(Branch.Phases{l},Branch.Phases{l})*InmTilde(Branch.Phases{l},Branch.Phases{l})*conj(ZNMTilde(Branch.Phases{l},Branch.Phases{l}).'); 

          ThermalLossExpression=ThermalLossExpression+...
        sum(real(diag(ZNMTilde(Branch.Phases{l},Branch.Phases{l})*InmTilde(Branch.Phases{l},Branch.Phases{l}))));
        
    else
        
                    VnmPrimeTilde=cvx(zeros(3));
                 SnmPrimeTilde=cvx(zeros(3));
            InmTilde=cvx(zeros(3));

                        SnmTilde=cvx(zeros(3));
            InmPrimeTilde=cvx(zeros(3));
            
          if length(Branch.Phases{l})==3
                      rr=find(Branch.Regs3PhiBranchNumbers==l);

        ll=find(Branch.ThreePhaseBranchNumbers==l); 
         SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm3Phi(:,:,ll); 
         InmTilde(Branch.Phases{l},Branch.Phases{l})=Inm3Phi(:,:,ll); 
       WPrime3Phi(:,:,rr)  =0*[VnnTilde(Branch.Phases{l}, Branch.Phases{l}), SnmTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(SnmTilde(Branch.Phases{l},Branch.Phases{l}).'), InmTilde(Branch.Phases{l},Branch.Phases{l})];
% WPrime3Phi(:,:,rr) >=0;        
        
        VnmPrimeTilde(Branch.Phases{l},Branch.Phases{l})=VnmPrime3Phi(:,:,rr);
        SnmPrimeTilde(Branch.Phases{l},Branch.Phases{l})=SnmPrime3Phi(:,:,rr);
         InmPrimeTilde(Branch.Phases{l},Branch.Phases{l})=InmPrime3Phi(:,:,rr); 
       W3Phi(:,:,ll)   =[VnmPrimeTilde(Branch.Phases{l}, Branch.Phases{l}), SnmPrimeTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(SnmPrimeTilde(Branch.Phases{l},Branch.Phases{l}).'), InmPrimeTilde(Branch.Phases{l},Branch.Phases{l})];
         
           W3Phi(:,:,ll)>=0;
            
         

    elseif length(Branch.Phases{l})==2
            rr=find(Branch.Wye2PhiBranchNumbers==l);
     ll=find(Branch.TwoPhaseBranchNumbers==l); 
      SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm2Phi(:,:,ll);
            InmTilde(Branch.Phases{l},Branch.Phases{l})=Inm2Phi(:,:,ll);
    WPrime2Phi(:,:,rr)   =0*[VnnTilde(Branch.Phases{l}, Branch.Phases{l}), SnmTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(SnmTilde(Branch.Phases{l},Branch.Phases{l}).'), InmTilde(Branch.Phases{l},Branch.Phases{l})];
% WPrime2Phi(:,:,rr) >=0;
         
            VnmPrimeTilde(Branch.Phases{l},Branch.Phases{l})=VnmPrime2Phi(:,:,rr);
        SnmPrimeTilde(Branch.Phases{l},Branch.Phases{l})=SnmPrime2Phi(:,:,rr); 
            InmPrimeTilde(Branch.Phases{l},Branch.Phases{l})=InmPrime2Phi(:,:,rr);
     W2Phi(:,:,ll)  =[VnmPrimeTilde(Branch.Phases{l}, Branch.Phases{l}), SnmPrimeTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(SnmPrimeTilde(Branch.Phases{l},Branch.Phases{l}).'), InmPrimeTilde(Branch.Phases{l},Branch.Phases{l})];
         
      W2Phi(:,:,ll) >=0;
         
       
         
          else
           rr=find(Branch.Wye1PhiBranchNumbers==l);
         ll=find(Branch.OnePhaseBranchNumbers==l); 
        SnmTilde(Branch.Phases{l}, Branch.Phases{l})=Snm1Phi(:,:,ll); 
        InmTilde(Branch.Phases{l},Branch.Phases{l})=Inm1Phi(:,:,ll);
         WPrime1Phi(:,:,rr) =0*[VnnTilde(Branch.Phases{l}, Branch.Phases{l}), SnmTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(SnmTilde(Branch.Phases{l},Branch.Phases{l}).'), InmTilde(Branch.Phases{l},Branch.Phases{l})];
%       WPrime1Phi(:,:,rr) >=0;
%          
         
         
               VnmPrimeTilde(Branch.Phases{l},Branch.Phases{l})=VnmPrime1Phi(:,:,rr);
        SnmPrimeTilde(Branch.Phases{l},Branch.Phases{l})=SnmPrime1Phi(:,:,rr); 
        InmPrimeTilde(Branch.Phases{l},Branch.Phases{l})=InmPrime1Phi(:,:,rr);
          W1Phi(:,:,ll)=[VnmPrimeTilde(Branch.Phases{l}, Branch.Phases{l}), SnmPrimeTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(SnmPrimeTilde(Branch.Phases{l},Branch.Phases{l}).'), InmPrimeTilde(Branch.Phases{l},Branch.Phases{l})];
        W1Phi(:,:,ll) >=0;
         
        
    end
    
    ZNMTilde=zeros(3);
        
    
     ZNMTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.ZNM;
        VmmTilde(Branch.Phases{l},Branch.Phases{l})==VnmPrimeTilde(Branch.Phases{l},Branch.Phases{l})-...
        (ZNMTilde(Branch.Phases{l},Branch.Phases{l})*conj(SnmPrimeTilde(Branch.Phases{l},Branch.Phases{l}).')+...
        SnmPrimeTilde(Branch.Phases{l},Branch.Phases{l})*conj(ZNMTilde(Branch.Phases{l},Branch.Phases{l}).'))+...
        ZNMTilde(Branch.Phases{l},Branch.Phases{l})*InmPrimeTilde(Branch.Phases{l},Branch.Phases{l})*conj(ZNMTilde(Branch.Phases{l},Branch.Phases{l}).'); 
    
      ThermalLossExpression=ThermalLossExpression+...
        sum(real(diag(ZNMTilde(Branch.Phases{l},Branch.Phases{l})*InmPrimeTilde(Branch.Phases{l},Branch.Phases{l}))));


    end
    
    
   
    

     
    
    
    
     
    
 
    
    
    

        
    end
    


    ThermalLoss==ThermalLossExpression;



    
