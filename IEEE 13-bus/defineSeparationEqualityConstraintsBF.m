
switch  RegulatorType
    
    case 'Wye'
diag(SnmPrime3Phi(:,:,r))==diag(Snm3Phi(:,:,ll));

    case 'ClosedDelta'
sum(diag(SnmPrime3Phi(:,:,r)))==sum(diag(Snm3Phi(:,:,ll)));
% sum(InmPrime3Phi(1,:,r))==0;
% sum(InmPrime3Phi(2,:,r))==0;
% sum(InmPrime3Phi(3,:,r))==0;
% sum(Inm3Phi(1,:,ll))==0;
% sum(Inm3Phi(2,:,ll))==0;
% sum(Inm3Phi(3,:,ll))==0;
% 
% sum(SnmPrime3Phi(1,:,r))==0;
% sum(SnmPrime3Phi(2,:,r))==0;
% sum(SnmPrime3Phi(3,:,r))==0;
% 
% 
% sum(Snm3Phi(1,:,3))==0;
% sum(Snm3Phi(2,:,3))==0;
% sum(Snm3Phi(3,:,3))==0;


% sum(sum(Inm3Phi(:,:,ll)))==sum(sum(InmPrime3Phi(:,:,r)));


% InmPrime3Phi(1,1,r)<=(RMAX.^2)*Inm3Phi(1,1,ll)+2*RMAX*(1-RMAX)*real(Inm3Phi(1,3,ll))+((1-RMIN).^2)*Inm3Phi(3,3,ll);
% InmPrime3Phi(1,1,r)>=(RMIN.^2)*Inm3Phi(1,1,ll)+2*RMAX*(1-RMIN)*real(Inm3Phi(1,3,ll));
% 
% 
% InmPrime3Phi(2,2,r)<=(RMAX.^2)*Inm3Phi(2,2,ll)+2*RMAX*(1-RMAX)*real(Inm3Phi(2,1,ll))+((1-RMIN).^2)*Inm3Phi(1,1,ll);
% InmPrime3Phi(2,2,r)>=(RMIN.^2)*Inm3Phi(2,2,ll)+2*RMAX*(1-RMIN)*real(Inm3Phi(2,1,ll));
% 
% 
% InmPrime3Phi(3,3,r)<=(RMAX.^2)*Inm3Phi(3,3,ll)+2*RMAX*(1-RMAX)*real(Inm3Phi(3,2,ll))+((1-RMIN).^2)*Inm3Phi(3,3,ll);
% InmPrime3Phi(3,3,r)>=(RMIN.^2)*Inm3Phi(3,3,ll)+2*RMAX*(1-RMIN)*real(Inm3Phi(3,2,ll));


% (RMAX.^2)* InmPrime3Phi(1,1,r)+(1-RMAX.^2)*InmPrime3Phi(3,3,r)+2*RMAX.*(1-RMAX).*real(InmPrime3Phi(1,3,r))>=Inm3Phi(1,1,ll);
% (RMAX.^2)* InmPrime3Phi(2,2,r)+(1-RMAX.^2)*InmPrime3Phi(1,1,r)+2*RMAX.*(1-RMAX).*real(InmPrime3Phi(2,1,r))>=Inm3Phi(2,2,ll);
% (RMAX.^2)* InmPrime3Phi(3,3,r)+(1-RMAX.^2)*InmPrime3Phi(2,2,r)+2*RMAX.*(1-RMAX).*real(InmPrime3Phi(3,2,r))>=Inm3Phi(3,3,ll);
% (RMIN.^2)* InmPrime3Phi(1,1,r)+2*RMAX.*(1-RMIN.^2)*real(InmPrime3Phi(1,3,r))<=Inm3Phi(1,1,ll);
% (RMIN.^2)* InmPrime3Phi(2,2,r)+2*RMAX.*(1-RMIN.^2)*real(InmPrime3Phi(2,1,r))<=Inm3Phi(2,2,ll);
% (RMIN.^2)* InmPrime3Phi(3,3,r)+2*RMAX.*(1-RMIN.^2)*real(InmPrime3Phi(3,2,r))<=Inm3Phi(3,3,ll);


% diag(SnmPrime3Phi(:,:,r))==diag(Snm3Phi(:,:,ll));



    case 'OpenDelta'
        
        sum(diag(SnmPrime3Phi(:,:,r)))==sum(diag(Snm3Phi(:,:,ll)));
% diag(SnmPrime3Phi(:,:,r))==diag(Snm3Phi(:,:,ll));



end
    
