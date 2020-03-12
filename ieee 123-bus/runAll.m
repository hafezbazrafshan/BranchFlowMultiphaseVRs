clear all;
clc;
%% Constants
v0Mags=[1;1;1];
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
InitialNetwork=setupIEEE123(RegulatorType);
% InitialNetwork=load('IEEE13','InitialNetwork'); 
% InitialNetwork=InitialNetwork.InitialNetwork;
InitialNetwork.vS=vS;
InitialNetwork.VMIN=VMIN;
InitialNetwork.VMAX=VMAX;
InitialNetwork.RMIN=RMIN;
InitialNetwork.RMAX=RMAX;


%% 2. Setting up initial network with default taps for wye
% if other regulator types, default taps are zero 
RegulatorType='ClosedDelta';
InitialNetworkClosedDelta=setupIEEE123(RegulatorType);
InitialNetworkClosedDelta.vS=vS;
InitialNetworkClosedDelta.VMIN=VMIN;
InitialNetworkClosedDelta.VMAX=VMAX;
InitialNetworkClosedDelta.RMIN=RMIN;
InitialNetworkClosedDelta.RMAX=RMAX;


RegulatorType='OpenDelta';
InitialNetworkOpenDelta=setupIEEE123(RegulatorType);
InitialNetworkOpenDelta.vS=vS;
InitialNetworkOpenDelta.VMIN=VMIN;
InitialNetworkOpenDelta.VMAX=VMAX;
InitialNetworkOpenDelta.RMIN=RMIN;
InitialNetworkOpenDelta.RMAX=RMAX;



RegulatorType='Mixed';
InitialNetworkMixed=setupIEEE123(RegulatorType);
InitialNetworkMixed.vS=vS;
InitialNetworkMixed.VMIN=VMIN;
InitialNetworkMixed.VMAX=VMAX;
InitialNetworkMixed.RMIN=RMIN;
InitialNetworkMixed.RMAX=RMAX;





%% 3. Initial z-bus solve
disp('Solving initial load-flow');
[InitialNetwork]=zBusSolve(InitialNetwork);
[InitialNetworkClosedDelta]=zBusSolve(InitialNetworkClosedDelta);
[InitialNetworkOpenDelta]=zBusSolve(InitialNetworkOpenDelta);
[InitialNetworkMixed]=zBusSolve(InitialNetworkMixed);




%% 4. Optimization
[CYI]=optimizeTapsCYI(InitialNetwork);
[CYG]=optimizeTapsCYG(InitialNetwork);

Delta=5;
[BYM]=optimizeTapsBMI(InitialNetwork,Delta, 1,0);

Delta=10;
[BCM]=optimizeTapsBMI(InitialNetworkClosedDelta,Delta,1,0);

Delta=15;
[BOM]=optimizeTapsBMI(InitialNetworkOpenDelta,Delta,1,0);


Delta=15;
[BMM]=optimizeTapsBMI(InitialNetworkMixed,Delta,1,0);

% BYN=optimizeTapsBNLP(InitialNetwork); 
% BCN=optimizeTapsBNLP(InitialNetworkClosedDelta); 
% BON=optimizeTapsBNLP(InitialNetworkOpenDelta); 
% BMN=optimizeTapsBNLP(InitialNetworkMixed); 





%%


[CYISolved]=zBusSolve(CYI);
[CYGSolved]=zBusSolve(CYG);

[BYMSolved]=zBusSolve(BYM);
[BCMSolved]=zBusSolve(BCM);
[BOMSolved]=zBusSolve(BOM);
[BMMSolved]=zBusSolve(BMM);


% [BYNSolved]=zBusSolve(BYN);
% [BCNSolved]=zBusSolve(BCN);
% [BONSolved]=zBusSolve(BON);
% [BMNSolved]=zBusSolve(BMN);




%% Print results
FileName=['ComparePowerIn','Scale1','.txt'];
if exist('Results')~=7
    mkdir('Results');
end
cd('Results');
save('FinalRun'); 
FileID=fopen(FileName,'w');
fprintf(FileID,' %-10s & %-10s  & %-10s & %-10s & %-10s & %-10s & %-10s & %-10s &  %-10s & %-10s  & %-10s & %-10s\n',...
   'Network', 'RegType','Method','Opt. Val.','Feas. Obj.','Gap.','VMin', 'VMax', 'VUnbalance','MaxAngle','L2L1','CompTime');
cd('..');



printResultsPerIteration(FileID,InitialNetwork,'Default');
printResultsPerIteration(FileID,CYISolved,'CI');
printResultsPerIteration(FileID,CYGSolved,'CG');
printResultsPerIteration(FileID,BYMSolved,'BM');
printResultsPerIteration(FileID,BCMSolved,'BM');
printResultsPerIteration(FileID,BOMSolved,'BM');
printResultsPerIteration(FileID,BMMSolved,'BM');
% printResultsPerIteration(FileID,BYNSolved,'BN');
% printResultsPerIteration(FileID,BCNSolved,'BN');
% printResultsPerIteration(FileID,BONSolved,'BN');
% printResultsPerIteration(FileID,BMNSolved,'BN');





% 