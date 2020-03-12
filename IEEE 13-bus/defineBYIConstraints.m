for r=1:NRegs3Phi
    defineCommonVPrimeConstraintsBF; %checked
    defineSeparationEqualityConstraintsBF; %checked
(RMIN.^2)*diag(real(VnmPrime3Phi(:,:,r)))<=diag(real(Vnn3Phi(:,:,nn)))<= (RMAX.^2)*diag(real(VnmPrime3Phi(:,:,r)));

    

end