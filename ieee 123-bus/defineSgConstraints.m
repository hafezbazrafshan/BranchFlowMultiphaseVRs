% SgConstraints
real(Sg3Phi(:))>=0;
% real(Sg3Phi(:))==0.01;
% imag(Sg3Phi(:))>=0;
% Sg3Phi(:)==0;
 % if you'd like to allow it set to nonzero
norms([real(Sg3Phi(:)).';imag(Sg3Phi(:)).'],2)<=0.1;
-real(Sg3Phi(:)).*tan(acos(0.9)) <=imag(Sg3Phi(:))<=real(Sg3Phi(:)).*tan(acos(0.9));

 
 
real(Sg2Phi(:))==0;
imag(Sg2Phi(:))==0;
%  norms([real(Sg2Phi(:)).';imag(Sg2Phi(:)).'],2)<=0.01;
%  -real(Sg2Phi(:)).*tan(acos(0.9)) <=imag(Sg2Phi(:))<=real(Sg2Phi(:)).*tan(acos(0.9));


 % if you'd like to allow it set to nonzero

real(Sg1Phi(:))==0;
imag(Sg1Phi(:))==0;
% norms([real(Sg1Phi(:)).';imag(Sg1Phi(:)).'],2)<=0.01;
%  -real(Sg1Phi(:)).*tan(acos(0.9)) <=imag(Sg1Phi(:))<=real(Sg1Phi(:)).*tan(acos(0.9));


 % if you'd like to allow it set to nonzero

Sg3Phi(:,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber)==0;