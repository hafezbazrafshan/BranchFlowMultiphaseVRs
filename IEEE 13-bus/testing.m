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
RegulatorType='ClosedDelta';
%% 2. Setting up initial network with default taps for wye
% if other regulator types, default taps are zero 
InitialNetwork=setupIEEE13(RegulatorType);
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
Delta=1;
RankConstraints=1;
GangConstraints=0;
% [CvxNetworkCYI]=optimizeTapsCYI(InitialNetwork);
% [CvxNetworkCYMI]=optimizeTapsCYMI(InitialNetwork,Delta,RankConstraints,GangConstraints);
[CvxNetworkBYMI]=optimizeTapsBMI(InitialNetwork,Delta,RankConstraints,GangConstraints);
[NetworkBNLP]=optimizeTapsBNLP(InitialNetwork);




% [CvxNetworkI]=optimizeTapsBYI(InitialNetwork);
% [CvxNetworkBYG]=optimizeTapsBYG(InitialNetwork);
% [CvxNetworkCYG]=optimizeTapsCYG(InitialNetwork);
% [CvxNetworkIE]=optimizeTapsBYMI(InitialNetwork,Delta,RankConstraints,GangConstraints);
% [CvxNetworkCYISolved]=zBusSolve(CvxNetworkCYI);
% [CvxNetworkCYMISolved]=zBusSolve(CvxNetworkCYMI);
[CvxNetworkBYMISolved]=zBusSolve(CvxNetworkBYMI);
[NetworkBNLPSolved1]=zBusSolve(NetworkBNLP);

% [NetworkBNLP2]=retrieveVoltageBNLP(NetworkBNLP);
% [NetworkBNLPSolved2]=zBusSolveInitialize(NetworkBNLP2);



% [CvxNetworkBYGSolved]=zBusSolve(CvxNetworkBYG);
% [CvxNetworkCYGSolved]=zBusSolve(CvxNetworkCYG);
% [CvxNetworkIESolved]=zBusSolve(CvxNetworkIE);
% 


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