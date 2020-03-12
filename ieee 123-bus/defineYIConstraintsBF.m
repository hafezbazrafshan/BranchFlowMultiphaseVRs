for r=1:NRegs3Phi
    defineCommonVPrimeConstraintsBF; %checked
    defineSeparationEqualityConstraintsBF; %checked
    (RMIN.^2)*diag(real(VnmPrime3Phi(:,:,r)))<=diag(real(Vnn3Phi(:,:,nn)))<= (RMAX.^2)*diag(real(VnmPrime3Phi(:,:,r)));


end


for r=1:NRegs2Phi
    defineCommonVPrimeConstraints2PhiBF; %checked
    defineSeparationEqualityConstraints2PhiBF;%checked
    (RMIN.^2)*diag(real(VnmPrime2Phi(:,:,r)))<=diag(real(VTilde))<= (RMAX.^2)*diag(real(VnmPrime2Phi(:,:,r)));


end



for r=1:NRegs1Phi
    defineCommonVPrimeConstraints1PhiBF;%checked
    defineSeparationEqualityConstraints1PhiBF;%checked
    (RMIN.^2)*diag(real(VnmPrime1Phi(:,:,r)))<=diag(real(VTilde))<= (RMAX.^2)*diag(real(VnmPrime1Phi(:,:,r)));
    

end