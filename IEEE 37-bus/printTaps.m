CurrentDirectory=pwd;
cd('/Users/hafez/Documents/MATLAB/ThreePhaseVRs/Journal/IEEE 37-bus/Results/');
IEEE37=load('FinalRun'); 
CYI=IEEE37.CYISolved.Branch.Wye3PhiTaps;
CYG=IEEE37.CYGSolved.Branch.Wye3PhiTaps; 
BYM=IEEE37.BYMSolved.Branch.Wye3PhiTaps; 
BCM=IEEE37.BCMSolved.Branch.ClosedDeltaTaps;
BOM=IEEE37.BOMSolved.Branch.OpenDeltaTaps;

cd(CurrentDirectory); 

FileName=['TapsPrinted','.txt'];
FileID=fopen(FileName,'w');
fprintf(FileID,' %-20s & %-20s  & %-20s & %-20s  %-20s  & %-20s  \n',...
 'Method', 'CYI', 'CYG','BYM','BCM','BOM');
fprintf(FileID,' %-20s & %-20s  & %-20s & %-20s  %-20s  & %-20s  \n', ...
    '37-1', [num2str(CYI(1,1)), ',',num2str(CYI(2,1)),',',num2str(CYI(3,1))],...
   [num2str(CYG(1,1)), ',',num2str(CYG(2,1)),',',num2str(CYG(3,1))],...
  [num2str(BYM(1,1)), ',',num2str(BYM(2,1)),',',num2str(BYM(3,1))],...
  [num2str(BCM(1,1)), ',',num2str(BCM(2,1)),',',num2str(BCM(3,1))],...
  [num2str(BOM(1,1)), ',',num2str(0),',',num2str(BOM(2,1))]);
fclose(FileID);