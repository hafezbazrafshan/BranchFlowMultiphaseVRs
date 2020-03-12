VoltageDeviationExpression=cvx(0);




% SlackVoltage constraint
Vnn3Phi(:,:,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber)==vS*vS';





for n=1:NBuses3Phi
    if Bus.ThreePhaseBusNumbers(n)~=Bus.SubstationNumber
        % voltage bounds constraint
    VMIN^2 <= diag(Vnn3Phi(:,:,n)) <=VMAX^2;
        imag(diag(Vnn3Phi(:,:,n)))==0;

    VoltageDeviationExpression=VoltageDeviationExpression+sum(abs(diag(Vnn3Phi(:,:,n))-1));

    end
end
for n=1:NBuses2Phi
            % voltage bounds constraint
    VMIN^2 <= diag(Vnn2Phi(:,:,n)) <=VMAX^2;
    imag(diag(Vnn2Phi(:,:,n)))==0;
      
                  VoltageDeviationExpression=VoltageDeviationExpression+sum(abs(diag(Vnn2Phi(:,:,n))-1));

end

for n=1:NBuses1Phi
    % voltage bounds constraint
    VMIN^2 <= diag(Vnn1Phi(:,:,n)) <=VMAX^2;
        imag(diag(Vnn1Phi(:,:,n)))==0;

              VoltageDeviationExpression=VoltageDeviationExpression+sum(abs(diag(Vnn1Phi(:,:,n))-1));

end

VoltageDeviationExpression<=VoltageDeviation;





for l=1:NBranches
    n=Branch.BusFromNumbers(l); 
    m=Branch.BusToNumbers(l);
    SnmTilde=cvx(zeros(3));
    VnnTilde=cvx(zeros(3));
    VmmTilde=cvx(zeros(3));
    InmTilde=cvx(zeros(3));
    
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
    
    if ~strcmp(Branch.Device{l},'Reg')
    ZNMTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.ZNM;
    else
        
       if length(Branch.Phases{l})==3
               rr=find(Branch.Regs3PhiBranchNumbers==l); 
        if strcmp(Branch.RegulatorTypes(rr),'Wye') 
                     rrr=find(Branch.Wye3PhiBranchNumbers==l);
                    Av=Branch.Wye3PhiAvs{rrr};
                 elseif strcmp(Branch.RegulatorTypes(rr),'ClosedDelta')
                     rrr=find(Branch.ClosedDeltaBranchNumbers==l);
                     Av=Branch.ClosedDeltaAvs{rrr};
                 else
                     rrr=find(Branch.OpenDeltaBranchNumbers==l);
                     Av=Branch.OpenDeltaAvs{rrr};
        end
        
      elseif length(Branch.Phases{l})==2
                 rr=find(Branch.Wye2PhiBranchNumbers==l);
                    Av=Branch.Wye2PhiAvs{rr};
            else 
                 rrr=find(Branch.Wye1PhiBranchNumbers==l);
                    Av=Branch.Wye1PhiAvs{rrr};
end
            
   
    ZNMTilde(Branch.Phases{l},Branch.Phases{l})=Av*Branch.Admittance{l}.ZNM*Av.';

        
    end
    
    VmmTilde(Branch.Phases{l},Branch.Phases{l})==VnnTilde(Branch.Phases{l},Branch.Phases{l})-...
        (ZNMTilde(Branch.Phases{l},Branch.Phases{l})*conj(SnmTilde(Branch.Phases{l},Branch.Phases{l}).')+...
        SnmTilde(Branch.Phases{l},Branch.Phases{l})*conj(ZNMTilde(Branch.Phases{l},Branch.Phases{l}).'))+...
        ZNMTilde(Branch.Phases{l},Branch.Phases{l})*InmTilde(Branch.Phases{l},Branch.Phases{l})*conj(ZNMTilde(Branch.Phases{l},Branch.Phases{l}).'); 


end


    
