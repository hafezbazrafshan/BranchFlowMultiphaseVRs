
switch  RegulatorType
    
    case 'Wye'
        
SnnPrime3Phi(:,r)==SnmPrime3Phi(:,r);
(RMIN.^2)*diag(real(WnnPrime3Phi(:,:,r)))<=diag(real(Wnn3Phi(:,:,nn)))<= (RMAX.^2)*diag(real(WnnPrime3Phi(:,:,r)));

    otherwise
 sum(SnnPrime3Phi(:,r))==sum(SnmPrime3Phi(:,r));

end
    
