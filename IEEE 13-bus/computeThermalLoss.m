function [ThermalLoss ] = computeThermalLoss( Network )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


ThermalLoss=0;
Branch=Network.Branch;
NBranches=length(Branch.Numbers);
v3Phase=Network.Solution.v3Phase;
v3PhaseRegs=Network.Solution.v3PhaseRegs;
for ii=1:NBranches
    n=Network.Branch.BusFromNumbers(ii); 
    m=Network.Branch.BusToNumbers(ii);
    PhaseSet=Network.Branch.Phases{ii};
    
    switch Branch.Device{ii}
        
        case 'Reg'
            r=find(Branch.RegulatorBranchNumbers==ii);% which regulator number it is
            RegulatorType=Branch.RegulatorTypes{r};
            switch char(RegulatorType)
            case 'Wye'
                if length(Branch.Phases{ii}==3)
            rrr=find(Branch.Wye3PhiBranchNumbers==ii); % which 3Phi regulator number it is
           Av=Branch.Wye3PhiAvs{rrr};
                end
                case 'OpenDelta'
           rrr=find(Branch.OpenDeltaBranchNumbers==ii); % which 3Phi regulator number it is
           Av=Branch.OpenDeltaAvs{rrr};

                case 'ClosedDelta'
                           rrr=find(Branch.ClosedDeltaBranchNumbers==ii); % which 3Phi regulator number it is
                            Av=Branch.ClosedDeltaAvs{rrr};
            end 
%                             
         ThermalLoss=ThermalLoss+real( v3Phase(n,PhaseSet)*conj(inv(Av.')*  Network.Branch.Admittance{ii}.YNMn*inv(Av)*(v3Phase(n,PhaseSet).')-...
       inv(Av.')* Network.Branch.Admittance{ii}.YNMm*(v3Phase(m,PhaseSet).')))+...
        real( v3Phase(m,PhaseSet)*conj(  Network.Branch.Admittance{ii}.YMNm*(v3Phase(m,PhaseSet).')-...
        Network.Branch.Admittance{ii}.YMNn*inv(Av)*(v3Phase(n,PhaseSet).')));     

 

        otherwise
    ThermalLoss=ThermalLoss+real( v3Phase(n,PhaseSet)*conj(  Network.Branch.Admittance{ii}.YNMn*(v3Phase(n,PhaseSet).')-...
        Network.Branch.Admittance{ii}.YNMm*(v3Phase(m,PhaseSet).')))+...
        real( v3Phase(m,PhaseSet)*conj(  Network.Branch.Admittance{ii}.YMNm*(v3Phase(m,PhaseSet).')-...
        Network.Branch.Admittance{ii}.YMNn*(v3Phase(n,PhaseSet).')));
            end
    
end
