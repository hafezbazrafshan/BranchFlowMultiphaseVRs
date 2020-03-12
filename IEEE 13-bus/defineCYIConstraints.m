for r=1:NRegs3Phi
     defineCommonWPrimeConstraints; %checked
defineSeparationEqualityConstraint; %checked

    (RMIN.^2)*diag(WnnPrime3Phi(:,:,r))-diag(Wnn3Phi(:,:,nn))<=0; %checked
        (RMAX.^2)*diag(WnnPrime3Phi(:,:,r))-diag(Wnn3Phi(:,:,nn))>=0; %checked


        
        

end