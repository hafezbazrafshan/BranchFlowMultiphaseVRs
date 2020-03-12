
switch  RegulatorType
    
    case 'Wye'
        
SnnPrime3Phi(:,r)==SnmPrime3Phi(:,r);
    otherwise
 sum(SnnPrime3Phi(:,r))==sum(SnmPrime3Phi(:,r));

end
    
