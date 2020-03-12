% SgConstraints
% Constraints=[Constraints,real(Sg3Phi(1,3))==0.1718];
% Constraints=[Constraints,real(Sg3Phi(2,3))==0.1169];
% Constraints=[Constraints,real(Sg3Phi(3,3))==0.1542];



% 
Constraints=[Constraints, norms([real(Sg3Phi(:)).';imag(Sg3Phi(:)).'],2)<=0.001,
-real(Sg3Phi(:)).*tan(acos(0.9)) <=imag(Sg3Phi(:))<=real(Sg3Phi(:)).*tan(acos(0.9))];

 
 
% Constraints=[Constraints, norms([real(Sg2Phi(:)).';imag(Sg2Phi(:)).'],2)<=0.01;
%  -real(Sg2Phi(:)).*tan(acos(0.9)) <=imag(Sg2Phi(:))<=real(Sg2Phi(:)).*tan(acos(0.9))];


 % if you'd like to allow it set to nonzero


% Constraints=[Constraints, norms([real(Sg1Phi(:)).';imag(Sg1Phi(:)).'],2)<=0.01];
%  -real(Sg1Phi(:)).*tan(acos(0.9)) <=imag(Sg1Phi(:))<=real(Sg1Phi(:)).*tan(acos(0.9))];



Constraints=[Constraints, real(Sg3Phi(:))>=0]; % no distributed generation 
% Constraints=[Constraints,real(Sg3Phi(:))==0];
% Constraints=[Constraints, imag(Sg3Phi(:))==0];
% Constraints=[Constraints,abs(Sg3Phi(:))<=0.01];


 % if you'd like to allow it set to nonzero
% 
 Constraints=[Constraints,real(Sg2Phi(:))==0]; % no distributed generation 
 Constraints=[Constraints,imag(Sg2Phi(:))==0];
 % if you'd like to allow it set to nonzero


% 
 Constraints=[Constraints,real(Sg1Phi(:))==0]; % no distributed generation 
 Constraints=[Constraints,imag(Sg1Phi(:))==0];
 % if you'd like to allow it set to nonzero

Constraints=[Constraints,Sg3Phi(:,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber)==0];