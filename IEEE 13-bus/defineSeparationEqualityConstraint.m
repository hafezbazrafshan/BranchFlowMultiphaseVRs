

switch  RegulatorType
    
    case 'Wye'
SnmPrime3Phi(:,r)==SnnPrime3Phi(:,r);

    case 'ClosedDelta'
sum(SnmPrime3Phi(:,r))==sum(SnnPrime3Phi(:,r));








    case 'OpenDelta'
        
sum(SnmPrime3Phi(:,r))==sum(SnmPrime3Phi(:,r));




end
    
    
