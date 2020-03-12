for r=1:NRegs3Phi
    defineCommonVPrimeConstraintsBF;
    defineSeparationEqualityConstraintsBF;
    (RMIN.^2)*VnmPrime3Phi(:,:,r)-Vnn3Phi(:,:,nn)<=0;
(RMAX.^2)*VnmPrime3Phi(:,:,r)-Vnn3Phi(:,:,nn)>=0;

end