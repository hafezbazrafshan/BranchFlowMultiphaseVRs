VoltageDeviationExpression=cvx(0);




% SlackVoltage constraint
Wnn3Phi(:,:,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber)==vS*vS';





for n=1:NBuses3Phi
    if Bus.ThreePhaseBusNumbers(n)~=Bus.SubstationNumber
        % voltage bounds constraint
    VMIN^2 <= diag(Wnn3Phi(:,:,n)) <=VMAX^2;
        imag(diag(Wnn3Phi(:,:,n)))==0;

    VoltageDeviationExpression=VoltageDeviationExpression+sum((abs(diag(Wnn3Phi(:,:,n))-1)));

 
    end
end
for n=1:NBuses2Phi
            % voltage bounds constraint
    VMIN^2 <= diag(Wnn2Phi(:,:,n)) <=VMAX^2;
    imag(diag(Wnn2Phi(:,:,n)))==0;
      
                  VoltageDeviationExpression=VoltageDeviationExpression+sum((abs(diag(Wnn2Phi(:,:,n))-1)));

end

for n=1:NBuses1Phi
    % voltage bounds constraint
    VMIN^2 <= diag(Wnn1Phi(:,:,n)) <=VMAX^2;
        imag(diag(Wnn1Phi(:,:,n)))==0;

              VoltageDeviationExpression=VoltageDeviationExpression+sum((abs(diag(Wnn1Phi(:,:,n))-1)));

end

VoltageDeviationExpression<=VoltageDeviation;





for l=1:NBranches
    n=Branch.BusFromNumbers(l); 
    m=Branch.BusToNumbers(l);
    WnmTilde=cvx(zeros(3));
    WnnTilde=cvx(zeros(3));
    WmmTilde=cvx(zeros(3));
    
    if length(Bus.Phases{n})==3
        kk=find(Bus.ThreePhaseBusNumbers==n);
        WnnTilde(Bus.Phases{n}, Bus.Phases{n})=Wnn3Phi(:,:,kk); 
    elseif length(Bus.Phases{n})==2
        kk=find(Bus.TwoPhaseBusNumbers==n);
        WnnTilde(Bus.Phases{n}, Bus.Phases{n})=Wnn2Phi(:,:,kk); 
    else 
        kk=find(Bus.OnePhaseBusNumbers==n); 
        WnnTilde(Bus.Phases{n}, Bus.Phases{n})=Wnn1Phi(:,:,kk); 
    end
    
    
     if length(Bus.Phases{m})==3
        kk=find(Bus.ThreePhaseBusNumbers==m);
        WmmTilde(Bus.Phases{m}, Bus.Phases{m})=Wnn3Phi(:,:,kk); 
    elseif length(Bus.Phases{m})==2
        kk=find(Bus.TwoPhaseBusNumbers==m);
        WmmTilde(Bus.Phases{m}, Bus.Phases{m})=Wnn2Phi(:,:,kk); 
    else 
        kk=find(Bus.OnePhaseBusNumbers==m); 
        WmmTilde(Bus.Phases{m}, Bus.Phases{m})=Wnn1Phi(:,:,kk); 
     end
    
    
      if ~strcmp(Branch.Device{l},'Reg')
    if length(Branch.Phases{l})==3
        ll=find(Branch.ThreePhaseBranchNumbers==l); 
        WnmTilde(Branch.Phases{l},Branch.Phases{l})=Wnm3Phi(:,:,ll); 
        W3Phi(:,:,ll)=[WnnTilde(Branch.Phases{l}, Branch.Phases{l}), WnmTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(WnmTilde(Branch.Phases{l},Branch.Phases{l}).'), WmmTilde(Branch.Phases{l},Branch.Phases{l})];
         W3Phi(:,:,ll) >=0;
 
    elseif length(Branch.Phases{l})==2
      ll=find(Branch.TwoPhaseBranchNumbers==l); 
      WnmTilde(Branch.Phases{l},Branch.Phases{l})=Wnm2Phi(:,:,ll);
       W2Phi(:,:,ll)=[WnnTilde(Branch.Phases{l}, Branch.Phases{l}), WnmTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(WnmTilde(Branch.Phases{l},Branch.Phases{l}).'), WmmTilde(Branch.Phases{l},Branch.Phases{l})];
         W2Phi(:,:,ll) >=0;
         


    else
        ll=find(Branch.OnePhaseBranchNumbers==l); 
        WnmTilde(Branch.Phases{l}, Branch.Phases{l})=Wnm1Phi(:,:,ll); 
          W1Phi(:,:,ll)=[WnnTilde(Branch.Phases{l}, Branch.Phases{l}), WnmTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(WnmTilde(Branch.Phases{l},Branch.Phases{l}).'), WmmTilde(Branch.Phases{l},Branch.Phases{l})];
         W1Phi(:,:,ll) >=0;



    end
    else
        
      WnnPrimeTilde=cvx(zeros(3)); 
      WnmPrimeTilde=cvx(zeros(3));
        
            if length(Branch.Phases{l})==3
        ll=find(Branch.ThreePhaseBranchNumbers==l); 
        rr=find(Branch.Regs3PhiBranchNumbers==l); % which three-phase regualtor it is
        WnnPrimeTilde(Branch.Phases{l},Branch.Phases{l})=WnnPrime3Phi(:,:,rr);
        WnmPrimeTilde(Branch.Phases{l},Branch.Phases{l})=WnmPrime3Phi(:,:,rr); 
        W3Phi(:,:,ll)=[WnnPrimeTilde(Branch.Phases{l}, Branch.Phases{l}), WnmPrimeTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(WnmPrimeTilde(Branch.Phases{l},Branch.Phases{l}).'), WmmTilde(Branch.Phases{l},Branch.Phases{l})];
         W3Phi(:,:,ll) >=0;
            elseif length(Branch.Phases{l})==2
                
                  ll=find(Branch.TwoPhaseBranchNumbers==l); 
        rr=find(Branch.Wye2PhiBranchNumbers==l); % which two-phase regualtor it is
        WnnPrimeTilde(Branch.Phases{l},Branch.Phases{l})=WnnPrime2Phi(:,:,rr);
        WnmPrimeTilde(Branch.Phases{l},Branch.Phases{l})=WnmPrime2Phi(:,:,rr); 
        W2Phi(:,:,ll)=[WnnPrimeTilde(Branch.Phases{l}, Branch.Phases{l}), WnmPrimeTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(WnmPrimeTilde(Branch.Phases{l},Branch.Phases{l}).'), WmmTilde(Branch.Phases{l},Branch.Phases{l})];
         W2Phi(:,:,ll) >=0;
                
            else
                              ll=find(Branch.OnePhaseBranchNumbers==l); 
        rr=find(Branch.Wye1PhiBranchNumbers==l); % which two-phase regualtor it is
        WnnPrimeTilde(Branch.Phases{l},Branch.Phases{l})=WnnPrime1Phi(:,:,rr);
        WnmPrimeTilde(Branch.Phases{l},Branch.Phases{l})=WnmPrime1Phi(:,:,rr); 
        W1Phi(:,:,ll)=[WnnPrimeTilde(Branch.Phases{l}, Branch.Phases{l}), WnmPrimeTilde(Branch.Phases{l}, Branch.Phases{l});...
         conj(WnmPrimeTilde(Branch.Phases{l},Branch.Phases{l}).'), WmmTilde(Branch.Phases{l},Branch.Phases{l})];
         W1Phi(:,:,ll) >=0;
                
                
        


      end
      end

end
    
