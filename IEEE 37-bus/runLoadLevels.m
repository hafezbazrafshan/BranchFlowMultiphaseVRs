clear all;
clc;

%% Constants
v0Mags=[1.0;1.0;1.0];
v0Phases=degrees2radians([0;-120;120]); 
vS=v0Mags.*exp(sqrt(-1)*v0Phases); 
VMIN=0.9;
VMAX=1.1;
RMIN=0.9;
RMAX=1.1;
%% 1. Deciding on regulator types
RegulatorType='Wye';
%% 2. Setting up initial network with default taps for wye
% if other regulator types, default taps are zero 
InitialIEEE13Network=setupIEEE13(RegulatorType);
InitialIEEE13Network.vS=vS;
InitialIEEE13Network.VMIN=VMIN;
InitialIEEE13Network.VMAX=VMAX;
InitialIEEE13Network.RMIN=RMIN;
InitialIEEE13Network.RMAX=RMAX;


%% For enhanced McCormick
ThetaDiff=5;
ThetaMax=120+ThetaDiff;
ThetaMin=120-ThetaDiff;

%% Load Levels
LoadLevels=(0:0.25:1).';
InitialNetworks=cell(length(LoadLevels),1);
CPINetworks=cell(length(LoadLevels),1);
CPGNetworks=cell(length(LoadLevels),1);
EPINetworks=cell(length(LoadLevels),1);
EPGNetworks=cell(length(LoadLevels),1); 
CPIENetworks=cell(length(LoadLevels),1);
EPIENetworks=cell(length(LoadLevels),1);
 


%% create chart
FileName=['LoadLevelVoltDevObj',num2str(ThetaDiff),'.txt'];
if exist('Results')~=7
    mkdir('Results');
end
cd('Results');
FileID=fopen(FileName,'w');
fprintf(FileID,' %-20s & %-20s & %-20s & %-20s & %-20s & %-20s & %-20s & %-20s & %-20s & %-20s \n',...
   'Load-level', 'Method','Status','Opt. Val.','Feas. Obj.','Acc.','Taps','VMin', 'VMax', 'L2/L1');
cd('..');

for ii=1:length(LoadLevels)
    
    % changing load levels
    InitialNetwork=InitialIEEE13Network;
    for jj=1:length(InitialNetwork.Bus.SLoad)
    InitialNetwork.Bus.SLoad{jj}=LoadLevels(ii)* InitialNetwork.Bus.SLoad{jj};
    end
    InitialNetwork.Bus.SLoadVec=LoadLevels(ii)*InitialNetwork.Bus.SLoadVec;
    
     %% 3. Initial z-bus solve
disp('Solving initial load-flow');
[InitialNetwork]=zBusSolve(InitialNetwork);


%% 4. Optimization
[CPINetwork]=optimizeTapsCPI(InitialNetwork);
[CPGNetwork]=optimizeTapsCPG(InitialNetwork);
[EPINetwork]=optimizeTapsEPI(InitialNetwork);
[EPGNetwork]=optimizeTapsEPG(InitialNetwork);
[CPIENetwork]=optimizeTapsCPIE(InitialNetwork,ThetaMax,ThetaMin);
[EPIENetwork]=optimizeTapsEPIE(InitialNetwork,ThetaMax,ThetaMin);

%% 5. Solve for voltages
[CPINetwork]=zBusSolve(CPINetwork);
[CPGNetwork]=zBusSolve(CPGNetwork);
[EPINetwork]=zBusSolve(EPINetwork);
[EPGNetwork]=zBusSolve(EPGNetwork);
 [CPIENetwork]=zBusSolve(CPIENetwork);
[EPIENetwork]=zBusSolve(EPIENetwork);
       

%% 6. Store 
InitialNetworks{ii}=InitialNetwork;
CPINetworks{ii}=CPINetwork;
CPGNetworks{ii}=CPGNetwork;
EPINetworks{ii}=EPINetwork;
EPGNetworks{ii}=EPGNetwork;

CPIENetworks{ii}=CPIENetwork;
EPIENetworks{ii}=EPIENetwork;


%% 7. Output

printResultsPerIteration(FileID,InitialNetwork,'Default',LoadLevels(ii));
printResultsPerIteration(FileID,CPINetwork,'CPI',LoadLevels(ii));
printResultsPerIteration(FileID,CPGNetwork,'CPG',LoadLevels(ii));
printResultsPerIteration(FileID,EPINetwork,'EPI',LoadLevels(ii));
printResultsPerIteration(FileID,EPGNetwork,'EPG',LoadLevels(ii));
printResultsPerIteration(FileID,CPIENetwork,'CPIE',LoadLevels(ii));
printResultsPerIteration(FileID,EPIENetwork,'EPIE',LoadLevels(ii));



end