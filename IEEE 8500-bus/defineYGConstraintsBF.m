for r=1:NRegs3Phi
    defineCommonVPrimeConstraintsBF;
    defineSeparationEqualityConstraintsBF;
    (RMIN.^2)*Vnn3Phi(:,:,nn)-VnmPrime3Phi(:,:,r)<=0;
(RMAX.^2)*Vnn3Phi(:,:,nn)-VnmPrime3Phi(:,:,r)>=0;

end