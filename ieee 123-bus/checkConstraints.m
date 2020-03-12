PowerFlowConstraints.P=inf(1,NPhases);
PowerFlowConstrainst.Q=inf(1,NPhases);
WMinConstraints.Wnn3Phi=inf(3,NBuses3Phi);
WMinConstraints.Wnn2Phi=inf(2,NBuses2Phi);
WMinConstraints.Wnn1Phi=inf(1,NBuses1Phi);
WMaxConstraints.Wnn3Phi=inf(3,NBuses3Phi);
WMaxConstraints.Wnn2Phi=inf(2,NBuses2Phi);
WMaxConstraints.Wnn1Phi=inf(1,NBuses1Phi);
BranchConstraints.W3Phi.Lambdas=-inf(NBranches3Phi,6).';
BranchConstraints.W2Phi.Lambdas=-inf(NBranches2Phi,4).'; 
BranchConstraints.W1Phi.Lambdas=-inf(NBranches1Phi,2).';
BranchConstraints.WPrime3Phi.Lambdas=-inf(NRegs3Phi,6).';
BranchConstraints.WPrime2Phi.Lambdas=-inf(NRegs2Phi,4).'; 
BranchConstraints.WPrime1Phi.Lambdas=-inf(NRegs1Phi,2).';
W3Phi=full(W3Phi); 
W2Phi=full(W2Phi); 
W1Phi=full(W1Phi); 
WPrime3Phi=full(WPrime3Phi); 
WPrime2Phi=full(WPrime2Phi); 
WPrime1Phi=full(WPrime1Phi); 


SgConstraints=inf(NPhases,1).'; 
% SgConstraint check:
SgConstraints=(Sg-0).';
% SlackVoltage constraint check
WMinConstraints.Wnn3Phi(1:3,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber)=...
    diag(vS*vS')-diag(Wnn3Phi(:,:,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber));
WMaxConstraints.Wnn3Phi(1:3,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber)=...
    diag(Wnn3Phi(:,:,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber))-diag(vS*vS');

for n=1:NBuses3Phi
    if Bus.ThreePhaseBusNumbers(n)~=Bus.SubstationNumber
    % voltage bounds constraint check
    WMinConstraints.Wnn3Phi(1:3,n)=...
    VMIN^2-diag(Wnn3Phi(:,:,n));
 WMaxConstraints.Wnn3Phi(1:3,n)=...
    diag( Wnn3Phi(:,:,n))-VMAX^2;
    end
end
for n=1:NBuses2Phi
        % voltage bounds constraint check
       WMinConstraints.Wnn2Phi(1:2,n)=...
     VMIN^2-diag(Wnn2Phi(:,:,n));
 WMaxConstraints.Wnn2Phi(1:2,n)=...
    diag( Wnn2Phi(:,:,n))-VMAX^2;
end

for n=1:NBuses1Phi
    
    % voltage bounds constraint check
     WMinConstraints.Wnn1Phi(1,n)=...
    VMIN^2-diag(Wnn1Phi(:,:,n));
 WMaxConstraints.Wnn1Phi(1,n)=...
    diag( Wnn1Phi(:,:,n))-VMAX^2;
end



for l=1:NBranches
 
    if length(Branch.Phases{l})==3
        ll=find(Branch.ThreePhaseBranchNumbers==l); 
         % Branch constraint check
         BranchConstraints.W3Phi.Lambdas(:,ll)=sort(eig(W3Phi(:,:,ll)));
    elseif length(Branch.Phases{l})==2
      ll=find(Branch.TwoPhaseBranchNumbers==l);        
         % Branch constraint check
                  BranchConstraints.W2Phi.Lambdas(:,ll)=sort(eig(W2Phi(:,:,ll)));

    else
        ll=find(Branch.OnePhaseBranchNumbers==l); 
         % Branch constraint check
                  BranchConstraints.W1Phi.Lambdas(:,ll)=sort(eig(W1Phi(:,:,ll)));
    end

end
    

for r=1:NRegs3Phi
 
   
         BranchConstraints.WPrime3Phi.Lambdas(:,r)=sort(eig(WPrime3Phi(:,:,r)));
  

end


for r=1:NRegs2Phi
 
   
         BranchConstraints.WPrime2Phi.Lambdas(:,r)=sort(eig(WPrime2Phi(:,:,r)));
  

end


for r=1:NRegs1Phi
 
   
         BranchConstraints.WPrime1Phi.Lambdas(:,r)=sort(eig(WPrime1Phi(:,:,r)));
  

end
