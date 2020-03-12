for r=1:NRegs3Phi
    defineCommonvPrimeConstraintsBNLP;
    
    switch RegulatorType
       
        case 'Wye'
            D=eye(3); 
            F=zeros(3); 
            
        case 'ClosedDelta'
             D=[1 -1 0; 0 1 -1; -1 0 1];
        F=[0 1 0; 0 0 1; 1 0 0];
        
        case 'OpenDelta'
            D=[1 -1 0;  0 1 0;  0 -1 1];
 F=[ 0 1 0; 0 0 0; 0 1 0];
 Constraints=[Constraints,R3Phi(2,r)==1];
            
    end
    
  Constraints=[Constraints,  Anm(:,:,r)==diag(R3Phi(:,r))*D+F];
  Constraints=[Constraints,RMIN<=R3Phi(:,r)<=RMAX];
  Constraints=[Constraints,vn3Phi(:,nn)==Anm*vnmPrime3Phi(:,r)];
  Constraints=[Constraints,Anm(:,:,r)'*inm3Phi(:,ll)==inmPrime3Phi(:,r)];
  
  
  
  assign(R3Phi(:,r),1); % initial value
    








end
