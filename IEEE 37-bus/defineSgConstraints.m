% % SgConstraints
% real(Sg3Phi(:))==0;
% imag(Sg3Phi(:))==0;
 % if you'd like to allow it set to nonzero
% norms([real(Sg3Phi(end)).';imag(Sg3Phi(end)).'],2)<=1;
% real(Sg3Phi(1:2,4:end))==0;
% imag(Sg3Phi(1:2,4:end))==0;

real(Sg3Phi(:))==0;
imag(Sg3Phi(:))==0;

%  real(Sg2Phi(:))==0; % no distributed generation 
%  imag(Sg2Phi(:))==0;
%  % if you'd like to allow it set to nonzero


% 
%  real(Sg1Phi(:))==0; % no distributed generation 
%  imag(Sg1Phi(:))==0;
 % if you'd like to allow it set to nonzero

Sg3Phi(:,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber)==0;