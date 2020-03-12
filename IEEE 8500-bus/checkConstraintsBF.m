PowerFlowConstraints.P=inf(1,NPhases);
PowerFlowConstrainst.Q=inf(1,NPhases);
VMinConstraints.Vnn3Phi=inf(3,NBuses3Phi);
VMinConstraints.Vnn2Phi=inf(2,NBuses2Phi);
VMinConstraints.Vnn1Phi=inf(1,NBuses1Phi);
VMaxConstraints.Vnn3Phi=inf(3,NBuses3Phi);
VMaxConstraints.Vnn2Phi=inf(2,NBuses2Phi);
VMaxConstraints.Vnn1Phi=inf(1,NBuses1Phi);
BranchConstraints.W3Phi.Lambdas=-inf(NBranches3Phi,6).';
BranchConstraints.W2Phi.Lambdas=-inf(NBranches2Phi,4).'; 
BranchConstraints.W1Phi.Lambdas=-inf(NBranches1Phi,2).';
BranchConstraints.WPrime3Phi.Lambdas=-inf(NRegs3Phi,6).';

W3Phi=full(W3Phi); 
W2Phi=full(W2Phi); 
W1Phi=full(W1Phi); 
WPrime3Phi=full(WPrime3Phi); 

% SlackVoltage constraint check
VMinConstraints.Vnn3Phi(1:3,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber)=...
    diag(vS*vS')-diag(Vnn3Phi(:,:,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber));
VMaxConstraints.Vnn3Phi(1:3,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber)=...
    diag(Vnn3Phi(:,:,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber))-diag(vS*vS');

for n=1:NBuses3Phi
    if Bus.ThreePhaseBusNumbers(n)~=Bus.SubstationNumber
    % voltage bounds constraint check
    VMinConstraints.Vnn3Phi(1:3,n)=...
    VMIN^2-diag(Vnn3Phi(:,:,n));
 VMaxConstraints.Vnn3Phi(1:3,n)=...
    diag( Vnn3Phi(:,:,n))-VMAX^2;
    end
end
for n=1:NBuses2Phi
        % voltage bounds constraint check
       VMinConstraints.Vnn2Phi(1:2,n)=...
     VMIN^2-diag(Vnn2Phi(:,:,n));
 VMaxConstraints.Vnn2Phi(1:2,n)=...
    diag( Vnn2Phi(:,:,n))-VMAX^2;
end

for n=1:NBuses1Phi
    
    % voltage bounds constraint check
     VMinConstraints.Vnn1Phi(1,n)=...
    VMIN^2-diag(Vnn1Phi(:,:,n));
 VMaxConstraints.Vnn1Phi(1,n)=...
    diag( Vnn1Phi(:,:,n))-VMAX^2;
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
    
