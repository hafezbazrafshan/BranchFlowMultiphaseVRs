for r=1:NRegs3Phi
    defineCommonVPrimeConstraintsBF;
    defineSeparationEqualityConstraintsBF;
    (RMIN.^2)*VnmPrime3Phi(:,:,r)-Vnn3Phi(:,:,nn)<=0;
(RMAX.^2)*VnmPrime3Phi(:,:,r)-Vnn3Phi(:,:,nn)>=0;


    (RMIN.^2)*Inm3Phi(:,:,ll)-InmPrime3Phi(:,:,r)<=0;
(RMAX.^2)*Inm3Phi(:,:,ll)-InmPrime3Phi(:,:,r)>=0;

end


for r=1:NRegs2Phi
    defineCommonVPrimeConstraints2PhiBF;
    defineSeparationEqualityConstraints2PhiBF;
    (RMIN.^2)*VnmPrime2Phi(:,:,r)-VTilde<=0;
(RMAX.^2)*VnmPrime2Phi(:,:,r)-VTilde>=0;


   (RMIN.^2)*Inm2Phi(:,:,ll)-InmPrime2Phi(:,:,r)<=0;
(RMAX.^2)*Inm2Phi(:,:,ll)-InmPrime2Phi(:,:,r)>=0;

end


for r=1:NRegs1Phi
    defineCommonVPrimeConstraints1PhiBF;
    defineSeparationEqualityConstraints1PhiBF;
        (RMIN.^2)*diag(real(VnmPrime1Phi(:,:,r)))<=diag(real(VTilde))<= (RMAX.^2)*diag(real(VnmPrime1Phi(:,:,r)));


   (RMIN.^2)*Inm1Phi(:,:,ll)-InmPrime1Phi(:,:,r)<=0;
(RMAX.^2)*Inm1Phi(:,:,ll)-InmPrime1Phi(:,:,r)>=0;

end