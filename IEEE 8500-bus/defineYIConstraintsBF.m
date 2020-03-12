for r=1:NRegs3Phi
    defineCommonVPrimeConstraintsBF;
    defineSeparationEqualityConstraintsBF;
(RMIN.^2)*diag(real(Vnn3Phi(:,:,nn)))<=diag(real(VnmPrime3Phi(:,:,r)))<= (RMAX.^2)*diag(real(Vnn3Phi(:,:,nn)));


end