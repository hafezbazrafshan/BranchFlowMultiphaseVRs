clear all;
clc;
%% Constants
v0Mags=[1;1;1];
v0Phases=degrees2radians([0;-120;120]); 
vS=v0Mags.*exp(sqrt(-1)*v0Phases); 
VMIN=0.95;
VMAX=1.05;
RMIN=0.9;
RMAX=1.1;




RegulatorType='Mixed';
InitialNetworkMixed=setupIEEE8500(RegulatorType);
InitialNetworkMixed.vS=vS;
InitialNetworkMixed.VMIN=VMIN;
InitialNetworkMixed.VMAX=VMAX;
InitialNetworkMixed.RMIN=RMIN;
InitialNetworkMixed.RMAX=RMAX;





%% 3. Initial z-bus solve
disp('Solving initial load-flow');
[InitialNetworkMixed]=zBusSolve(InitialNetworkMixed);





Delta=5;
[BMM]=optimizeTapsBMISg(InitialNetworkMixed,Delta,1,0);

BMN=optimizeTapsBNLP(InitialNetworkMixed); 





%%



[BMMSolved]=zBusSolve(BMM);


[BMNSolved]=zBusSolve(BMN);




%% Print results
FileName=['CompareWBNLPSg','.txt'];
if exist('Results')~=7
    mkdir('Results');
end
cd('Results');
save('FinalRunBNLPSg'); 
FileID=fopen(FileName,'w');
fprintf(FileID,' %-10s & %-10s  & %-10s & %-10s & %-10s & %-10s & %-10s & %-10s &  %-10s & %-10s  & %-10s & %-10s\n',...
   'Network', 'RegType','Method','Opt. Val.','Feas. Obj.','Gap.','VMin', 'VMax', 'VUnbalance','MaxAngle','L2L1','CompTime');
cd('..');



printResultsPerIteration(FileID,BMMSolved,'BM');
printResultsPerIteration(FileID,BMNSolved,'BN');





% 