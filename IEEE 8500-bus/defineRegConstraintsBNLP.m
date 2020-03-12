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
    
  Constraints=[Constraints,  Anm3Phi(:,:,r)==diag(R3Phi(:,r))*D+F];
  Constraints=[Constraints,RMIN<=R3Phi(:,r)<=RMAX];
  Constraints=[Constraints,Anm3Phi(:,:,r)*vn3Phi(:,nn)==vnmPrime3Phi(:,r)];
  Constraints=[Constraints,inm3Phi(:,ll)==Anm3Phi(:,:,r)'*inmPrime3Phi(:,r)];
  
  assign(R3Phi(:,r),1); % initial value
    








end
% 
% 
% for r=1:NRegs2Phi
%     defineCommonvPrimeConstraints2PhiBNLP;
%     
%     
%     
%   Constraints=[Constraints,  Anm2Phi(:,:,r)==diag(R2Phi(:,r))];
%   Constraints=[Constraints,RMIN<=R2Phi(:,r)<=RMAX];
%   Constraints=[Constraints,vTilde==Anm2Phi(:,:,r)*vnmPrime2Phi(:,r)];
%   Constraints=[Constraints,Anm2Phi(:,:,r)'*inm2Phi(:,ll)==inmPrime2Phi(:,r)];
%   
%   assign(R2Phi(:,r),1); % initial value
%     
% 
% 
% 
% 
% 
% 
% 
% 
% end
% 
% 
% for r=1:NRegs1Phi
%     defineCommonvPrimeConstraints1PhiBNLP;
%     
%     
%     
%   Constraints=[Constraints,  Anm1Phi(:,:,r)==diag(R1Phi(:,r))];
%   Constraints=[Constraints,RMIN<=R1Phi(:,r)<=RMAX];
%   Constraints=[Constraints,vTilde==Anm1Phi(:,:,r)*vnmPrime1Phi(:,r)];
%   Constraints=[Constraints,Anm1Phi(:,:,r)'*inm1Phi(:,ll)==inmPrime1Phi(:,r)];
%   
%   assign(R1Phi(:,r),1); % initial value
%     
% 
% 
% 
% 
% 
% 
% 
% 
% end
% 
