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
RegulatorType='Mixed';
%% 2. Setting up initial network with default taps for wye
% if other regulator types, default taps are zero 
InitialNetwork=setupIEEE123(RegulatorType);
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



%%
ThetaMax=120+5;
ThetaMin=120-5;

% [CvxNetwork]=optimizeFixedTaps(InitialNetwork);

% [CvxNetworkBF]=optimizeFixedTapsBF(InitialNetwork);
% [CvxNetworkI]=optimizeTapsBYI(InitialNetwork);
% [CvxNetworkGBF]=optimizeTapsBYG(InitialNetwork);
% [CvxNetworkG]=optimizeTapsCYG(InitialNetwork);
% [CvxNetworkI]=optimizeTapsCYI(InitialNetwork);
Delta=3;
tic
[CvxNetworkBYMI]=optimizeTapsBMISg(InitialNetwork,Delta,1,0);
toc

[NetworkBNLP]=optimizeTapsBNLP(InitialNetwork);

% [CvxNetworkIE]=optimizeTapsYIEBF(InitialNetwork,ThetaMax,ThetaMin);
% Delta=3;
% [CvxNetworkBCMIE]=optimizeTapsBYMI(InitialNetwork,Delta,1,0);

% % 
% [CvxNetworkISolved]=zBusSolve(CvxNetworkI);
% [CvxNetworkGBFSolved]=zBusSolve(CvxNetworkGBF);
% [CvxNetworkGSolved]=zBusSolve(CvxNetworkG);
% [CvxNetworkBCMIESolved]=zBusSolve(CvxNetworkBCMIE);

% [CvxNetworkISolved]=zBusSolve(CvxNetworkI);
[CvxNetworkBYMISolved]=zBusSolve(CvxNetworkBYMI);
%%
[NetworkBNLPSolved]=zBusSolve(NetworkBNLP);


% NetworkBNLP2=retrieveVoltageBNLP(NetworkBNLP);
% [NetworkBNLPSolved2]=zBusSolveInitialize(NetworkBNLP2);



% %% Print results
% FileName=['ComparePowerIn','Scale10000LessAngleSeparation','.txt'];
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