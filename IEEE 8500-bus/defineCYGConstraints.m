for r=1:NRegs3Phi
     defineCommonWPrimeConstraints;
defineSeparationEqualityConstraint;
    
    (RMIN.^2)*Wnn3Phi(:,:,nn)-WnnPrime3Phi(:,:,r)<=0;
        (RMAX.^2)*Wnn3Phi(:,:,nn)-WnnPrime3Phi(:,:,r)>=0;



end


