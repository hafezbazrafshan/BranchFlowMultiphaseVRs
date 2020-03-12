PowerFlowConstraints.P=inf(1,NPhases);
PowerFlowConstrainst.Q=inf(1,NPhases);
VMinConstraints.vn3Phi=inf(3,NBuses3Phi);
VMinConstraints.vn2Phi=inf(2,NBuses2Phi);
VMinConstraints.vn1Phi=inf(1,NBuses1Phi);
VMaxConstraints.vn3Phi=inf(3,NBuses3Phi);
VMaxConstraints.vn2Phi=inf(2,NBuses2Phi);
VMaxConstraints.vn1Phi=inf(1,NBuses1Phi);



% SlackVoltage constraint check
VMinConstraints.vn3Phi(1:3,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber)=...
    -vS+vn3Phi(:,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber);
VMaxConstraints.vn3Phi(1:3,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber)=...
    vn3Phi(:,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber)-vS;

for n=1:NBuses3Phi
    if Bus.ThreePhaseBusNumbers(n)~=Bus.SubstationNumber
    % voltage bounds constraint check
    VMinConstraints.vn3Phi(1:3,n)=...
    VMIN-abs(vn3Phi(:,n));
 VMaxConstraints.vn3Phi(1:3,n)=...
    abs(vn3Phi(:,n))-VMAX;
    end
end
for n=1:NBuses2Phi
        % voltage bounds constraint check
       VMinConstraints.vn2Phi(1:2,n)=...
     VMIN-abs(vn2Phi(:,n));
 VMaxConstraints.vn2Phi(1:2,n)=...
     abs(vn2Phi(:,n))-VMAX;
end

for n=1:NBuses1Phi
    
    % voltage bounds constraint check
     VMinConstraints.vn1Phi(1,n)=...
    VMIN-abs(vn1Phi(:,n));
 VMaxConstraints.vn1Phi(1,n)=...
    abs(vn1Phi(:,n))-VMAX;
end


