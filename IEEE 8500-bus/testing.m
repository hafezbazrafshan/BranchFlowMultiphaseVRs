clear all;
clc;
%% Constants
v0Mags=[1.05; 1.05; 1.05];
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
InitialNetwork=setupIEEE8500(RegulatorType);
InitialNetwork.vS=vS;
InitialNetwork.VMIN=VMIN;
InitialNetwork.VMAX=VMAX;
InitialNetwork.RMIN=RMIN;
InitialNetwork.RMAX=RMAX;

for jj=1:length(InitialNetwork.Bus.SLoad)
    InitialNetwork.Bus.SLoad{jj}= InitialNetwork.Bus.SLoad{jj};
end
InitialNetwork.Bus.SLoadVec=InitialNetwork.Bus.SLoadVec;

 %% 3. Initial z-bus solve
disp('Solving initial load-flow');
[InitialNetwork]=zBusSolve(InitialNetwork);



%% 4. Optimization

% [CvxNetwork]=optimizeFixedTapsBF(InitialNetwork);
% [CvxNetwork]=optimizeFixedTaps(InitialNetwork);
% 
% [CvxNetworkI]=optimizeTapsYIBF(InitialNetwork);
% [CvxNetworkBYG]=optimizeTapsBYG(InitialNetwork);
% [CvxNetworkG]=optimizeTapsWyeG(InitialNetwork);

% [CvxNetworkI]=optimizeTapsCYI(InitialNetwork);

Delta=15;
[CvxNetworkBMI]=optimizeTapsBMI(InitialNetwork,Delta, 1,0);
% [NetworkBNLP]=optimizeTapsBNLP(InitialNetwork);

% [CvxNetworkCYG]=optimizeTapsCYG(InitialNetwork);
%  [CvxNetworkBYG]=optimizeTapsBYG(InitialNetwork);

% [CvxNetworkISolved]=zBusSolve(CvxNetworkI);
% [CvxNetworkGSolved]=zBusSolve(CvxNetworkCYG);
% [CvxNetworkBYGSolved]=zBusSolve(CvxNetworkBYG);

% [CvxNetworkGBFSolved]=zBusSolve(CvxNetworkGBF);
[CvxNetworkBMISolved]=zBusSolve(CvxNetworkBMI);
% [NetworkBNLPSolved]=zBusSolve(NetworkBNLP);



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