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
    
%     if Bus.ThreePhaseBusNumbers(n)==8

        A=real(Wnn3Phi(:,:,n));
        B=imag(Wnn3Phi(:,:,n));
        
        defineWnn3PhiOffDiagonalBounds;
% prepare expressions
        DA12Var=DA12(1,n);
        OA12Var=OA12(1,n);
        OB12Var=OB12(1,n);
        
         DA23Var=DA23(1,n);
        OA23Var=OA23(1,n);
        OB23Var=OB23(1,n);
        
          DA31Var=DA31(1,n);
        OA31Var=OA31(1,n);
        OB31Var=OB31(1,n);
        
        
        %         
        A12A23Var=A12A23(1,n);
        B12B23Var=B12B23(1,n);
        A31A22Var=A31A22(1,n);
        
        A23B12Var=A23B12(1,n);
        A12B23Var=A12B23(1,n);
        A22B31Var=A22B31(1,n);
        
        
        A11A23Var=A11A23(1,n);
        A31A12Var=A31A12(1,n);
        B31B12Var=B31B12(1,n);
        
        A11B23Var=A11B23(1,n);
        A12B31Var=A12B31(1,n);
        A31B12Var=A31B12(1,n);
        
        
        A12A33Var=A12A33(1,n);
        A31A23Var=A31A23(1,n);
        B31B23Var=B31B23(1,n);
        
        A33B12Var=A33B12(1,n);
        A23B31Var=A23B31(1,n);
        A31B23Var=A31B23(1,n);
        
        approxRankConstraintsWnn3Phi;

%     end
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


end
    
