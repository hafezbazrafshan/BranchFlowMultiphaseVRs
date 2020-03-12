Scale=1;
% Objective=Scale*(real(sum(SIn))+real(sum(sum(Sg3Phi)))+real(sum(sum(Sg2Phi)))+real(sum(sum(Sg1Phi))));
Objective=Scale*(real(sum(SIn)));
% Objective=Scale*(0.1*(sum(abs(R1Phi))+sum(sum(abs(R2Phi)))+sum(sum(abs(R3Phi))))+0.9*(real(sum(SIn))));
minimize (Objective)
% or thermal loss
% Objective=Scale*(ThermalLoss);
% minimize (Objective);
