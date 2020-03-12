function [ Network] =zBusSolve(Network)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


Network.Solution=[];



NBuses=length(Network.Bus.Numbers);
[Network.YBus,Network.Y,Network.YNS,...
    Network.YSN,Network.YSS]=getYBus(Network.Branch,Network.Bus); % this needs to be update to only take network
Network.Solution.w=-Network.Y\(Network.YNS*Network.vS);
wCheck=NaN(3*(NBuses),1);
wCheck(Network.Bus.NonZeroPhaseNumbers,1)=[Network.Solution.w;Network.vS];
Network.Solution.w3Phase=reshape(wCheck,3,NBuses).';
Network.Solution.v =performZBus( Network.Solution.w,Network.Branch, Network.Bus,...
    Network.Y,Network.YNS,100,Network.vS,Network.VMIN,Network.VMAX); % we don't use the bounds
vCheck=NaN(3*(NBuses),1);
vCheck(Network.Bus.NonZeroPhaseNumbers,1)=[Network.Solution.v];
Network.Solution.v3Phase=reshape(vCheck,3,NBuses).';
% adding n' of the regulators to the labels:
NRegs=length(Network.Branch.RegulatorBranchNumbers);
Network.Solution.v3PhaseRegs=NaN(NRegs,3);
for r=1:NRegs
     l=Network.Branch.RegulatorBranchNumbers(r);
     n=Network.Branch.BusFromNumbers(l);
     m=Network.Branch.BusToNumbers(l);
     switch char(Network.Branch.RegulatorTypes(r))
         case 'Wye'
             if length(Network.Branch.Phases{l})==3
         rr=find(Network.Branch.Wye3PhiBranchNumbers==l); % which 3Phi regulator number it is
%             TapA=Network.Branch.Wye3PhiTaps(1,rr); 
%             TapB=Network.Branch.Wye3PhiTaps(2,rr);
%             TapC=Network.Branch.Wye3PhiTaps(3,rr);
%             ArA=1-0.00625*TapA;
%             ArB=1-0.00625*TapB;
%             ArC=1-0.00625*TapC;
%             Av=diag([ArA; ArB; ArC]);
Av=Network.Branch.Wye3PhiAvs{rr};
             elseif length(Network.Branch.Phases{l})==2
                        rr=find(Network.Branch.Wye2PhiBranchNumbers==l); % which 3Phi regulator number it is
%             Tap1=Network.Branch.Wye2PhiTaps(1,rr); 
%             Tap2=Network.Branch.Wye2PhiTaps(2,rr);
%             Ar1=1-0.00625*Tap1;
%             Ar2=1-0.00625*Tap2;
%             Av=diag([Ar1;Ar2]);
Av=Network.Branch.Wye2PhiAvs{rr};

                 else
                        rr=find(Network.Branch.Wye1PhiBranchNumbers==l); % which 3Phi regulator number it is
%             Tap1=Network.Branch.Wye1PhiTaps(1,rr); 
%             Ar1=1-0.00625*Tap1;
%             Av=Ar1;
Av=Network.Branch.Wye1PhiAvs{rr};

                 end
         case 'OpenDelta'
                      rr=find(Network.Branch.OpenDeltaBranchNumbers==l); % which 3Phi regulator number it is
%                              TapAB=Network.Branch.OpenDeltaTaps(1,rr); 
%             TapCB=Network.Branch.OpenDeltaTaps(2,rr);
%             ArAB=1-0.00625*TapAB;
%             ArCB=1-0.00625*TapCB;
%    
%             Av=[ArAB 1-ArAB 0; 0 1 0; 0 1-ArCB ArCB];    
Av=Network.Branch.OpenDeltaAvs{rr};

            
         case 'ClosedDelta'
                      rr=find(Network.Branch.ClosedDeltaBranchNumbers==l); % which 3Phi regulator number it is
%                TapAB=Network.Branch.ClosedDeltaTaps(1,rr); 
%             TapBC=Network.Branch.ClosedDeltaTaps(2,rr);
%                         TapCA=Network.Branch.ClosedDeltaTaps(3,rr);
% 
%             ArAB=1-0.00625*TapAB;
%             ArBC=1-0.00625*TapBC;
%             ArCA=1-0.00625*TapCA;
%    
%             Av=[ArAB 1-ArAB 0; 0 ArBC 1-ArBC; 1-ArCA 0 ArCA];
            Av=Network.Branch.ClosedDeltaAvs{rr};



     end
     
     
     Network.Solution.v3PhaseRegs(r,Network.Branch.Phases{l})=(inv(Av)*Network.Solution.v3Phase(n,Network.Branch.Phases{l}).').'; % three phases
     Network.Solution.w3PhaseRegs(r,Network.Branch.Phases{l})=(inv(Av)*Network.Solution.w3Phase(n,Network.Branch.Phases{l}).').';
end
        
Network.Solution.vMag=[abs(Network.Solution.v3Phase);abs(Network.Solution.v3PhaseRegs)];
% Network.Solution.vMag=[abs(Network.Solution.v3Phase)];

Network.Solution.vPhase=[radian2degrees(angle(Network.Solution.v3Phase)); radian2degrees(angle(Network.Solution.v3PhaseRegs))];
Network.Solution.vMin=min(abs(Network.Solution.vMag(:)));
Network.Solution.vMax=max(abs(Network.Solution.vMag(:)));
Network.Solution.iS=[Network.YSN, Network.YSS]*Network.Solution.v;
Network.Solution.S0=Network.vS.*conj(Network.Solution.iS);
Network.Solution.PowerImport=sum(real(Network.Solution.S0));
Network.Solution.ThermalLoss=computeThermalLoss(Network);
Network.Solution.VoltageDeviation=sum(abs(abs(Network.Solution.v(:)).^2-1));
Network.Solution.AverageVoltage=sum(abs(Network.Solution.v(:)))./length(Network.Solution.v(:));
Network.Solution.MaxVoltageFromAverage=max(abs(Network.Solution.v(:))-Network.Solution.AverageVoltage);
Network.Solution.VoltageUnbalanceIndex=Network.Solution.MaxVoltageFromAverage./Network.Solution.AverageVoltage;
Network.Solution.MaxAngle=max(max(abs(repmat([120; -240; 120],1,NRegs)...
    -[1 -1 0; 0 1 -1; -1 0 1]*radian2degrees(angle(Network.Solution.v3PhaseRegs).'))));


if ~isfield(Network.Bus,'SgVec')
Network.Solution.OptimalValue=Network.Solution.PowerImport;
else
Network.Solution.OptimalValue=Network.Solution.PowerImport+sum(real(Network.Bus.SgVec));
end
% Network.Solution.OptimalValue=Network.Solution.ThermalLoss;


end

