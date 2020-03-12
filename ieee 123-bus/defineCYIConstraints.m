for r=1:NRegs3Phi
     defineCommonWPrimeConstraints;
defineSeparationEqualityConstraint;
% 
    (RMIN.^2)*diag(WnnPrime3Phi(:,:,r))-diag(Wnn3Phi(:,:,nn))<=0;
        (RMAX.^2)*diag(WnnPrime3Phi(:,:,r))-diag(Wnn3Phi(:,:,nn))>=0;

        



end



for r=1:NRegs2Phi
defineCommonWPrime2PhiConstraints;
defineSeparation2PhiEqualityConstraint;
   (RMIN.^2)*diag(WnnPrime2Phi(:,:,r))-diag(WTilde)<=0;
        (RMAX.^2)*diag(WnnPrime2Phi(:,:,r))-diag(WTilde)>=0;



end


for r=1:NRegs1Phi
defineCommonWPrime1PhiConstraints;
defineSeparation1PhiEqualityConstraint;

(RMIN.^2)*diag(WnnPrime1Phi(:,:,r))<=diag(WTilde)<= (RMAX.^2)*diag(WnnPrime1Phi(:,:,r));


end