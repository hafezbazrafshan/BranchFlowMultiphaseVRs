% SgConstraints
% Constraints=[Constraints,real(Sg3Phi(1,3))==0.1718];
% Constraints=[Constraints,real(Sg3Phi(2,3))==0.1169];
% Constraints=[Constraints,real(Sg3Phi(3,3))==0.1542];
% 
% Constraints=[Constraints, 
% real(Sg3Phi(1:2,4:end))==0;
% imag(Sg3Phi(1:2,4:end))==0;];

Constraints=[Constraints, real(Sg3Phi(:))==0]; % no distributed generation 
Constraints=[Constraints, imag(Sg3Phi(:))==0];
% Constraints=[Constraints, norms([real(Sg3Phi(end)).';imag(Sg3Phi(end)).'],2)<=1];
 % if you'd like to allow it set to nonzero

 Constraints=[Constraints,real(Sg2Phi(:))==0]; % no distributed generation 
 Constraints=[Constraints,imag(Sg2Phi(:))==0];
 % if you'd like to allow it set to nonzero



 Constraints=[Constraints,real(Sg1Phi(:))==0]; % no distributed generation 
 Constraints=[Constraints,imag(Sg1Phi(:))==0];
 % if you'd like to allow it set to nonzero

Constraints=[Constraints,Sg3Phi(:,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber)==0];