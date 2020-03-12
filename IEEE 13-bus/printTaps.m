CurrentDirectory=pwd;
cd('/Users/hafez/Documents/MATLAB/ThreePhaseVRs/Journal/IEEE 13-bus/Results/');
IEEE13=load('FinalRun'); 
CYI=IEEE13.CYISolved.Branch.Wye3PhiTaps;
CYG=IEEE13.CYGSolved.Branch.Wye3PhiTaps; 
BYM=IEEE13.BYMSolved.Branch.Wye3PhiTaps; 
BCM=IEEE13.BCMSolved.Branch.ClosedDeltaTaps;
BOM=IEEE13.BOMSolved.Branch.OpenDeltaTaps;

cd(CurrentDirectory); 

FileName=['TapsPrinted','.txt'];
FileID=fopen(FileName,'w');
fprintf(FileID,' %-20s & %-20s  & %-20s & %-20s  %-20s  & %-20s  \n',...
 'Method', 'CYI','CYG','BYM','BCM','BOM');
fprintf(FileID,' %-20s & %-20s  & %-20s & %-20s  %-20s  & %-20s \n', ...
    '13-1', [num2str(CYI(1,1)), ',',num2str(CYI(2,1)),',',num2str(CYI(3,1))],...
   [num2str(CYG(1,1)), ',',num2str(CYG(2,1)),',',num2str(CYG(3,1))],...
  [num2str(BYM(1,1)), ',',num2str(BYM(2,1)),',',num2str(BYM(3,1))],...
  [num2str(BCM(1,1)), ',',num2str(BCM(2,1)),',',num2str(BCM(3,1))],...
  [num2str(BOM(1,1)), ',',num2str(0),',',num2str(BOM(2,1))]);
fclose(FileID);