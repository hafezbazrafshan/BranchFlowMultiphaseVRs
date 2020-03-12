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
RegulatorType='ClosedDelta';
%% 2. Setting up initial network with default taps for wye
% if other regulator types, default taps are zero 
InitialNetwork=setupIEEE37(RegulatorType);
% InitialNetwork=load('IEEE13','InitialNetwork'); 
% InitialNetwork=InitialNetwork.InitialNetwork;
InitialNetwork.vS=vS;
InitialNetwork.VMIN=VMIN;
InitialNetwork.VMAX=VMAX;
InitialNetwork.RMIN=RMIN;
InitialNetwork.RMAX=RMAX;

for jj=1:length(InitialNetwork.Bus.SLoad)
    InitialNetwork.Bus.SLoad{jj}=1* InitialNetwork.Bus.SLoad{jj};
end
InitialNetwork.Bus.SLoadVec=1*InitialNetwork.Bus.SLoadVec;

 %% 3. Initial z-bus solve
disp('Solving initial load-flow');
[InitialNetwork]=zBusSolve(InitialNetwork);



%% 4. Optimization
% [CvxNetworkI]=optimizeFixedTaps(InitialNetwork);

Delta=3;
[CvxNetworkI]=optimizeTapsBMI(InitialNetwork,Delta, 1,0);
[NetworkBNLP]=optimizeTapsBNLP(InitialNetwork);

% [CvxNetworkGBF]=optimizeTapsYGBF(InitialNetwork);
% [CvxNetworkG]=optimizeTapsWyeG(InitialNetwork);
% [CvxNetworkIE]=optimizeTapsYIEBF(InitialNetwork,ThetaMax,ThetaMin);
% Delta=2;
% [CvxNetworkBOMGE]=optimizeTapsBYMI(InitialNetwork,Delta,1,1);
[CvxNetworkISolved]=zBusSolve(CvxNetworkI);
% [CvxNetworkGSolved]=zBusSolve(CvxNetworkG);
% [CvxNetworkGBFSolved]=zBusSolve(CvxNetworkGBF);
% [CvxNetworkIESolved]=zBusSolve(CvxNetworkBOMGE);
% 
[NetworkBNLPSolved]=zBusSolve(NetworkBNLP);


%% Print results
% FileName=['ComparePowerIn','Scale1','.txt'];
% if exist('Results')~=7
%     mkdir('Results');
% end
% cd('Results');
% FileID=fopen(FileName,'w');
% fprintf(FileID,' %-20s & %-20s & %-20s & %-20s & %-20s & %-20s & %-20s & %-20s & %-20s & %-20s \n',...
%    'Load-level', 'Method','Status','Opt. Val.','Feas. Obj.','Acc.','Taps','VMin', 'VMax', 'L2/L1');
% cd('..');
% printResultsPerIteration(FileID,InitialNetwork,'Default',1);
% printResultsPerIteration(FileID,CvxNetworkSolved,'WyeI',1);
% printResultsPerIteration(FileID,CvxNetworkGSolved,'WyeG',1);
% printResultsPerIteration(FileID,CvxNetworkESolved,'WyeIE',1);