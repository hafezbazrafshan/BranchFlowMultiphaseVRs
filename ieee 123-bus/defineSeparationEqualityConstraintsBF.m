
switch  RegulatorType
    
    case 'Wye'
diag(SnmPrime3Phi(:,:,r))==diag(Snm3Phi(:,:,ll));

    case 'ClosedDelta'
sum(diag(SnmPrime3Phi(:,:,r)))==sum(diag(Snm3Phi(:,:,ll)));
% (RMAX.^2)* InmPrime3Phi(1,1,r)+(1-RMAX.^2)*InmPrime3Phi(3,3,r)+2*RMAX.*(1-RMAX).*real(InmPrime3Phi(1,3,r))>=Inm3Phi(1,1,ll);
% (RMAX.^2)* InmPrime3Phi(2,2,r)+(1-RMAX.^2)*InmPrime3Phi(1,1,r)+2*RMAX.*(1-RMAX).*real(InmPrime3Phi(2,1,r))>=Inm3Phi(2,2,ll);
% (RMAX.^2)* InmPrime3Phi(3,3,r)+(1-RMAX.^2)*InmPrime3Phi(2,2,r)+2*RMAX.*(1-RMAX).*real(InmPrime3Phi(3,2,r))>=Inm3Phi(3,3,ll);
% (RMIN.^2)* InmPrime3Phi(1,1,r)+2*RMAX.*(1-RMIN.^2)*real(InmPrime3Phi(1,3,r))<=Inm3Phi(1,1,ll);
% (RMIN.^2)* InmPrime3Phi(2,2,r)+2*RMAX.*(1-RMIN.^2)*real(InmPrime3Phi(2,1,r))<=Inm3Phi(2,2,ll);
% (RMIN.^2)* InmPrime3Phi(3,3,r)+2*RMAX.*(1-RMIN.^2)*real(InmPrime3Phi(3,2,r))<=Inm3Phi(3,3,ll);

% diag(SnmPrime3Phi(:,:,r))==diag(Snm3Phi(:,:,ll));


% SnmPrime3Phi(:,:,r)==Snm3Phi(:,:,ll);



    case 'OpenDelta'
        
        sum(diag(SnmPrime3Phi(:,:,r)))==sum(diag(Snm3Phi(:,:,ll)));
%         diag(SnmPrime3Phi(:,:,r))==diag(Snm3Phi(:,:,ll));
% diag(SnmPrime3Phi(:,:,r))==diag(Snm3Phi(:,:,ll));

% 
% (RMIN.^2)*InmPrime3Phi(1,1,r)<=Inm3Phi(1,1,ll)<=(RMAX.^2)*InmPrime3Phi(1,1,r);
% (RMIN.^2)*InmPrime3Phi(3,3,r)<=Inm3Phi(3,3,ll)<=(RMAX.^2)*InmPrime3Phi(3,3,r);
% 


end
    
