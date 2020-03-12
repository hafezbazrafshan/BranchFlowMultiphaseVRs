
switch  RegulatorType
    
    case 'Wye'
diag(SnmPrime3Phi(:,:,r))==diag(Snm3Phi(:,:,ll));

    case 'ClosedDelta'
sum(diag(SnmPrime3Phi(:,:,r)))==sum(diag(Snm3Phi(:,:,ll)));
% (RMAX.^2)* Inm3Phi(1,1,ll)+(1-RMAX.^2)*Inm3Phi(3,3,ll)+2*RMAX.*(1-RMAX).*real(Inm3Phi(1,3,ll))>=InmPrime3Phi(1,1,r);
% (RMAX.^2)* Inm3Phi(2,2,ll)+(1-RMAX.^2)*Inm3Phi(1,1,r)+2*RMAX.*(1-RMAX).*real(Inm3Phi(2,1,ll))>=InmPrime3Phi(2,2,r);
% (RMAX.^2)* Inm3Phi(3,3,ll)+(1-RMAX.^2)*Inm3Phi(2,2,r)+2*RMAX.*(1-RMAX).*real(Inm3Phi(3,2,ll))>=InmPrime3Phi(3,3,r);
% (RMIN.^2)* Inm3Phi(1,1,ll)+2*RMAX.*(1-RMIN.^2)*real(Inm3Phi(1,3,ll))<=Inm3Phi(1,1,r);
% (RMIN.^2)* Inm3Phi(2,2,ll)+2*RMAX.*(1-RMIN.^2)*real(Inm3Phi(2,1,ll))<=Inm3Phi(2,2,r);
% (RMIN.^2)* Inm3Phi(3,3,ll)+2*RMAX.*(1-RMIN.^2)*real(Inm3Phi(3,2,ll))<=Inm3Phi(3,3,r);

% diag(SnmPrime3Phi(:,:,r))==diag(Snm3Phi(:,:,ll));





    case 'OpenDelta'
        
        sum(diag(SnmPrime3Phi(:,:,r)))==sum(diag(Snm3Phi(:,:,ll)));
%         diag(SnmPrime3Phi(:,:,r))==diag(Snm3Phi(:,:,ll));

% diag(SnmPrime3Phi(:,:,r))==diag(Snm3Phi(:,:,ll));


(RMIN.^2)*Inm3Phi(1,1,ll)<=InmPrime3Phi(1,1,r)<=(RMAX.^2)*Inm3Phi(1,1,ll);
(RMIN.^2)*Inm3Phi(3,3,ll)<=InmPrime3Phi(3,3,r)<=(RMAX.^2)*Inm3Phi(3,3,ll);



end
    
