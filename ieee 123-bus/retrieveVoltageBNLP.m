function Network=retrieveVoltageBNLP(Network)

dbstop if error

vn3Phi=Network.Optimization.Variables.vn3Phi;
vn2Phi=Network.Optimization.Variables.vn2Phi;
vn1Phi=Network.Optimization.Variables.vn1Phi;
NBuses=length(Network.Bus.Numbers);


InitialVoltage3Phase=NaN(NBuses,3);
for n=1:NBuses
    
    if length(Network.Bus.Phases{n})==3
        nn=find(Network.Bus.ThreePhaseBusNumbers==n);
    InitialVoltage3Phase(n,Network.Bus.Phases{n})=vn3Phi(:,nn).';
    elseif length(Network.Bus.Phases{n})==2
        nn=find(Network.Bus.TwoPhaseBusNumbers==n);
        InitialVoltage3Phase(n,Network.Bus.Phases{n})=vn2Phi(:,nn).';
    else
        
        nn=find(Network.Bus.OnePhaseBusNumbers==n);
        InitialVoltage3Phase(n,Network.Bus.Phases{n})=vn1Phi(:,nn).';
    end
    
    


end


InitialVoltage=vec(InitialVoltage3Phase.');
InitialVoltage=InitialVoltage(Network.Bus.NonZeroPhaseNumbers);

Network.Optimization.InitialVoltage=InitialVoltage;
Network.Optimization.InitialVoltage3Phase=InitialVoltage3Phase;


end