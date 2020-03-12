for r=1:NRegs3Phi
     defineCommonWPrimeConstraints;
defineSeparationEqualityConstraint;
    
    (RMIN.^2)*diag(Wnn3Phi(:,:,nn))-diag(WnnPrime3Phi(:,:,r))<=0;
        (RMAX.^2)*diag(Wnn3Phi(:,:,nn))-diag(WnnPrime3Phi(:,:,r))>=0;



end


