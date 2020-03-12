function Network=setupIEEE123MoreRegs(RegulatorType)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

DataPath=[pwd,'/IEEE-123 feeder data'];
[LineBusesFromNames,LineBusesToNames,LineLengths,LineImpedanceCodes] = importLines([DataPath,'/line data.xls']);
LineBusesFromNames=strtrim(cellstr(num2str(LineBusesFromNames)));
LineBusesToNames=strtrim(cellstr(num2str(LineBusesToNames)));
LineLengths=LineLengths;
LineImpedanceCodes=strtrim(cellstr(num2str( LineImpedanceCodes)));
LineDevices=cellstr(repmat('TrLine',length(LineImpedanceCodes),1)); % 0 is a regular line



%  [capacitorBuses,capA,capB,capC] = importcapacitors([DataPath,'/cap data']);

%% Switch configuration
LineBusesFromNames=[LineBusesFromNames;'13';'18';'60';'61';'97';'150'];
LineBusesToNames=[LineBusesToNames;'152';'135';'160';'61s';'197';'149'];
LineLengths=[LineLengths; 10;10;10;10;10;10];
LineImpedanceCodes=[LineImpedanceCodes;'1';'1';'1';'1';'1';'1'];% switch assumed of configuration one 
LineDevices=[LineDevices; {'Switch'}; {'Switch'}; {'Switch'}; {'Switch'}; {'Switch'}; {'Switch'}];

%% Xfm-1 configuration
LineBusesFromNames=[LineBusesFromNames;'61s']; 
LineBusesToNames=[LineBusesToNames;'610']; 
LineLengths=[LineLengths;0]; 
LineImpedanceCodes=[LineImpedanceCodes;0];
LineDevices=[LineDevices;'D-D']; 

%% Substation transformer:
LineBusesFromNames=[LineBusesFromNames; 'SourceBus']; 
LineBusesToNames=[LineBusesToNames;'150']; 
LineImpedanceCodes=[LineImpedanceCodes;2]; 
LineLengths=[LineLengths;0];
LineDevices=[LineDevices; {'D-GW'}]; 



%% Regulator
RegIdx1=find(and(strcmp( LineBusesFromNames,'150'), strcmp(LineBusesToNames,'149'))); 
LineDevices{RegIdx1}='Reg'; 

RegIdx2=find(and(strcmp(LineBusesFromNames,'9'), strcmp(LineBusesToNames,'14'))); 
LineDevices{RegIdx2}='Reg'; 

RegIdx3=find(and(strcmp(LineBusesFromNames,'25'), strcmp(LineBusesToNames,'26'))); 
LineDevices{RegIdx3}='Reg'; 

RegIdx4=find(and(strcmp(LineBusesFromNames,'160'), strcmp(LineBusesToNames,'67'))); 
LineDevices{RegIdx4}='Reg'; 


RegIdx5=find(and(strcmp(LineBusesFromNames,'91'), strcmp(LineBusesToNames,'93'))); 
LineDevices{RegIdx5}='Reg'; 



RegIdx6=find(and(strcmp(LineBusesFromNames,'77'), strcmp(LineBusesToNames,'78'))); 
LineDevices{RegIdx6}='Reg'; 




RegIdx7=find(and(strcmp(LineBusesFromNames,'35'), strcmp(LineBusesToNames,'40'))); 
LineDevices{RegIdx7}='Reg'; 



RegIdx8=find(and(strcmp(LineBusesFromNames,'81'), strcmp(LineBusesToNames,'82'))); 
LineDevices{RegIdx8}='Reg'; 





%% 3.  Organizing bus names
% collecting bus names
BusNames=unique([LineBusesFromNames;LineBusesToNames]);

BusNamesWithRegs=[BusNames;'150r'; '9r'; '25r';'160r';'93r';'77r';'101r';'35r'];


%% Putting substation index at the very end:
Substation='SourceBus';
SubstationNumber=find(strcmp(BusNames,Substation));


% (this step is not necessary)
if SubstationNumber< length(BusNames) % if substation is not the end bus
    BusNames=[BusNames(1:SubstationNumber-1); BusNames(SubstationNumber+1:end); BusNames(SubstationNumber)];
end

%% Base voltages:
SBase=5000*1000; % from the substation transformer
VBase=4160/sqrt(3); % line to neutral conversion (secondary of the substation transformer)
% for calculation of impedances
ZBase=VBase^2/SBase;
YBase=1./ZBase;
LineImpedanceCodes=cellfun(@getCodesInNumbers,LineImpedanceCodes);


%% Line Codes (must match the ones from openDSS)
% (12 configurations)
Zcfg(:,:,1)= [0.4576+1.0780i   0.1560+0.5017i   0.1535+0.3849i;
    0.1560+0.5017i     0.4666+1.0482i   0.1580+0.4236i;
    0.1535+0.3849i       0.1580+0.4236i    0.4615+1.0651i]/5280;
Ycfg(:,:,1)=1j*(10^(-6))*[5.6765   -1.8319   -0.6982;
    -1.8319        5.9809   -1.1645;
    -0.6982         -1.1645      5.3971]/5280;


Zcfg(:,:,2)= [0.4666+1.0482i   0.1580+0.4236i   0.1560+0.5017i;
    0.1580+0.4236i 0.4615+1.0651i   0.1535+0.3849i;
    0.1560+0.5017i      0.1535+0.3849i        0.4576+1.0780i]/5280;

Ycfg(:,:,2)=1j*(10^(-6))* [5.9809   -1.1645   -1.8319;
    -1.1645       5.3971   -0.6982;
    -1.8319 -0.6982 5.6765]/5280;

Zcfg(:,:,3)=[0.4615+1.0651i   0.1535+0.3849i   0.1580+0.4236i;
    0.1535+0.3849i  0.4576+1.0780i   0.1560+0.5017i;
    0.1580+0.4236i    0.1560+0.5017i  0.4666+1.0482i]/5280;
Ycfg(:,:,3)=1j*(10^(-6))*[5.3971   -0.6982   -1.1645;
    -0.6982   5.6765   -1.8319;
    -1.1645   -1.8319    5.9809]/5280;


Zcfg(:,:,4)=[0.4615+1.0651i   0.1580+0.4236i   0.1535+0.3849i;
    0.1580+0.4236i 0.4666+1.0482i   0.1560+0.5017i;
    0.1535+0.3849i        0.1560+0.5017i      0.4576+1.0780i]/5280;
Ycfg(:,:,4)=1j*(10^(-6))*[5.3971   -1.1645   -0.6982;
    -1.1645    5.9809   -1.8319;
    -0.6982  -1.8319         5.6765]/5280;


Zcfg(:,:,5)=[0.4666+1.0482i   0.1560+0.5017i   0.1580+0.4236i;
    0.1560+0.5017i  0.4576+1.0780i   0.1535+0.3849i;
    0.1580+0.4236i         0.1535+0.3849i         0.4615+1.0651i]/5280;
Ycfg(:,:,5)=1j*(10^(-6))*[5.9809   -1.8319   -1.1645
    -1.8319      5.6765   -0.6982
    -1.1645      -0.6982          5.3971]/5280;


Zcfg(:,:,6)=[ 0.4576+1.0780i   0.1535+0.3849i   0.1560+0.5017i
    0.1535+0.3849i 0.4615+1.0651i   0.1580+0.4236i
    0.1560+0.5017i       0.1580+0.4236i       0.4666+1.0482i]/5280;
Ycfg(:,:,6)=1j*(10^(-6))*[5.6765   -0.6982   -1.8319
    -0.6982    5.3971   -1.1645
    -1.8319     -1.1645       5.9809]/5280;



Zcfg(:,:,7)=[0.4576+1.0780i      0                   0.1535+0.3849i;
    0                             0                   0;
    0.1535+0.3849i       0         0.4615+1.0651i]/5280;

Ycfg(:,:,7)=1j*(10^(-6))*[5.1154    0   -1.0549;
    0    0 0;
    -1.0549 0         5.1704]/5280;

Zcfg(:,:,8)=[ 0.4576+1.0780i   0.1535+0.3849i   0.0000;
    0.1535+0.3849i 0.4615+1.0651i     0.0000 ;
    0.0000             0.0000  0.0000]/5280;
Ycfg(:,:,8)=1j*(10^(-6))*[5.1154   -1.0549    0.0000
    -1.0549   5.1704    0.0000
    0.0000          0.0000  0.0000]/5280;

Zcfg(:,:,9)=[1.3292+1.3475i   0   0;
    0 0 0;
    0 0 0] /5280;
Ycfg(:,:,9)=1j*(10^(-6))*[4.5193    0.0000    0.0000
    0  0.0000    0.0000
    0      0      0.0000]/5280;


Zcfg(:,:,10)=[0 0 0;
    0 1.3292+1.3475i    0;
    0  0 0]/5280;
Ycfg(:,:,10)=1j*(10^(-6))*[0 0 0;
    0 4.5193 0;
    0 0 0]/5280;



Zcfg(:,:,11)=[ 0   0   0;
    0  0   0;
    0 0   1.3292+1.3475i]/5280;
Ycfg(:,:,11)=1j*(10^(-6))*[ 0  0   0;
    0   0   0;
    0    0  4.5193]/5280;

Zcfg(:,:,12)=[ 1.5209+0.7521i   0.5198+0.2775i   0.4924+0.2157i;
    0.5198+0.2775i 1.5329+0.7162i   0.5198+0.2775i;
    0.4924+0.2157i        0.5198+0.2775i         1.5209+0.7521i]/5280;
Ycfg(:,:,12)=1j*(10^(-6))*[67.2242  0    0;
    0 67.2242    0;
    0       0    67.2242]/5280;



%% 5. Create Ytilde and Ybranch
% Ybranch is simplified to be without Yshunt (for testing purposes)
% Ytilde considers Yshunt and Ycaps
NBuses=length(BusNames);
NBranches=length(LineBusesFromNames);
LineBusesFromNumbers=getNumericNodeList( LineBusesFromNames, BusNames ); % you find the location in BusNames of the given index
LineBusesToNumbers=getNumericNodeList(LineBusesToNames,BusNames);








Branch=struct;
Branch.Numbers=zeros(NBranches,1);
Branch.BusFromNames=cell(NBranches,1);
Branch.BusFromNumbers=zeros(NBranches,1);
Branch.BusToNames=cell(NBranches,1);
Branch.BusToNumbers=zeros(NBranches,1);
Branch.Device=cell(NBranches,1);
Branch.Admittance=cell(NBranches,1);
Branch.Phases=cell(NBranches,1);
Branch.ThreePhaseBranchNumbers=[];
Branch.TwoPhaseBranchNumbers=[];
Branch.OnePhaseBranchNumbers=[];
Branch.RegulatorBranchNumbers=[];
Branch.Regs3PhiBranchNumbers=[];
Branch.Regs2PhiBranchNumbers=[];
Branch.Regs1PhiBranchNumbers=[];
Branch.Wye3PhiBranchNumbers=[];
Branch.Wye2PhiBranchNumbers=[];
Branch.Wye1PhiBranchNumbers=[];
Branch.OpenDeltaBranchNumbers=[];
Branch.ClosedDeltaBranchNumbers=[];
Branch.Wye3PhiTaps=[];
Branch.Wye2PhiTaps=[];
Branch.Wye1PhiTaps=[];
Branch.Wye3PhiAvs={};
Branch.Wye2PhiAvs={};
Branch.Wye1PhiAvs={};
Branch.OpenDeltaTaps=[];
Branch.OpenDeltaAvs={};
Branch.ClosedDeltaTaps=[];
Branch.ClosedDeltaAvs={};
Branch.CNodes=zeros(NBranches,NBuses);
Branch.RegulatorTypes={};



% traverse the network
for ii=1:NBranches
    
    Branch.BusFromNames(ii)=LineBusesFromNames(ii);
    Branch.BusFromNumbers(ii)=LineBusesFromNumbers(ii);
    Branch.BusToNames(ii)=LineBusesToNames(ii);
    Branch.BusToNumbers(ii)=LineBusesToNumbers(ii);
    Branch.Device(ii)=LineDevices(ii);
    Branch.Numbers(ii)=ii;
    
    
    
    Branch.CNodes(ii,Branch.BusFromNumbers(ii))=1;
    Branch.CNodes(ii,Branch.BusToNumbers(ii))=-1;
    % The remaining properties depend on device:
    % AvailablePhaseSet
    % AdmittanceMatrix
    
    % If the device is regulator additionally we need
    % RegulatorType, since we need to optimize the taps
    
    switch char(LineDevices(ii))
        case 'Reg' % reg 1
            
            Zseries=Zcfg(:,:,LineImpedanceCodes(ii));
            Yshunt=Ycfg(:,:,LineImpedanceCodes(ii));
            AvailablePhases=find(any(Zseries)).';
            Zseries=Zseries(AvailablePhases,AvailablePhases);
            Yshunt=Yshunt(AvailablePhases,AvailablePhases);
            % length of the line:
            LineLength=LineLengths(ii);
            
            
            YNMn=( inv(Zseries*LineLength)/YBase+0*Yshunt*LineLength/YBase);
            YNMm=(inv(Zseries*LineLength)/YBase);
            YMNn=(inv(Zseries*LineLength)/YBase);
            YMNm=(inv(Zseries*LineLength)/YBase+0*Yshunt*LineLength/YBase);
            ZNM=Zseries*LineLength/ZBase;
            
            Branch.Admittance{ii}.YNMn=YNMn;
            Branch.Admittance{ii}.YNMm=YNMm;
            Branch.Admittance{ii}.YMNn=YMNn;
            Branch.Admittance{ii}.YMNm=YMNm;
            Branch.Admittance{ii}.ZNM=ZNM;
            Branch.Phases{ii}=AvailablePhases;
            Branch.RegulatorBranchNumbers=[Branch.RegulatorBranchNumbers;ii];
            
            
            if length(Branch.Phases{ii})==3
            switch RegulatorType
                case 'Wye'
                    
                        Branch.RegulatorTypes=[Branch.RegulatorTypes;'Wye'];
                        Branch.Regs3PhiBranchNumbers=[Branch.Regs3PhiBranchNumbers;ii];
                        Branch.Wye3PhiBranchNumbers=[Branch.Wye3PhiBranchNumbers;ii];
%                               TapA=10;
%                         TapB=8;
%                         TapC=11;
TapA=0;
TapB=0;
TapC=0;
                        Branch.Wye3PhiTaps=[Branch.Wye3PhiTaps,[TapA; TapB ;TapC ]]; % nominal taps
                  

                        ArA=1-0.00625*TapA;
                        ArB=1-0.00625*TapB;
                        ArC=1-0.00625*TapC;
                        Av=diag([ArA; ArB; ArC]);
                        Branch.Wye3PhiAvs=[Branch.Wye3PhiAvs;Av];
                    
                case 'ClosedDelta'
                    Branch.RegulatorTypes=[Branch.RegulatorTypes;'ClosedDelta'];
                        Branch.Regs3PhiBranchNumbers=[Branch.Regs3PhiBranchNumbers;ii];
                        Branch.ClosedDeltaBranchNumbers=[Branch.ClosedDeltaBranchNumbers;ii];
                        TapAB=0;
                        TapBC=0;
                        TapCA=0;
                        
                        ArAB=1-0.00625*TapAB;
                        ArBC=1-0.00625*TapBC;
                        ArCA=1-0.00625*TapCA;
                                                Branch.ClosedDeltaTaps=[Branch.ClosedDeltaTaps,[TapAB; TapBC ;TapCA ]];

                        Av=[ArAB 1-ArAB 0; 0 ArBC 1-ArBC; 1-ArCA 0 ArCA];
                        Branch.ClosedDeltaAvs=[Branch.ClosedDeltaAvs;Av];
                       
                case 'OpenDelta'
                     Branch.RegulatorTypes=[Branch.RegulatorTypes;'OpenDelta'];
                        Branch.Regs3PhiBranchNumbers=[Branch.Regs3PhiBranchNumbers;ii];
                        Branch.OpenDeltaBranchNumbers=[Branch.OpenDeltaBranchNumbers;ii];
                         TapAB=0;
                        TapCB=0;
                        ArAB=1-0.00625*TapAB;
                        ArCB=1-0.00625*TapCB;
   
                        
                                                Branch.OpenDeltaTaps=[Branch.OpenDeltaTaps,[TapAB; TapCB ]];

                        Av=[ArAB 1-ArAB 0; 0 1 0; 0 1-ArCB ArCB];
                       Branch.OpenDeltaAvs=[Branch.OpenDeltaAvs;Av];
                       
                case 'Mixed'
                    switch Branch.BusFromNames{ii}
                        case '150'
                            Branch.RegulatorTypes=[Branch.RegulatorTypes;'ClosedDelta'];
                        Branch.Regs3PhiBranchNumbers=[Branch.Regs3PhiBranchNumbers;ii];
                        Branch.ClosedDeltaBranchNumbers=[Branch.ClosedDeltaBranchNumbers;ii];
                        TapAB=0;
                        TapBC=0;
                        TapCA=0;
                        
                        ArAB=1-0.00625*TapAB;
                        ArBC=1-0.00625*TapBC;
                        ArCA=1-0.00625*TapCA;
                                                Branch.ClosedDeltaTaps=[Branch.ClosedDeltaTaps,[TapAB; TapBC ;TapCA ]];

                        Av=[ArAB 1-ArAB 0; 0 ArBC 1-ArBC; 1-ArCA 0 ArCA];
                        Branch.ClosedDeltaAvs=[Branch.ClosedDeltaAvs;Av];
                            
                        case '160'
                            Branch.RegulatorTypes=[Branch.RegulatorTypes;'OpenDelta'];
                        Branch.Regs3PhiBranchNumbers=[Branch.Regs3PhiBranchNumbers;ii];
                        Branch.OpenDeltaBranchNumbers=[Branch.OpenDeltaBranchNumbers;ii];
                         TapAB=0;
                        TapCB=0;
                        ArAB=1-0.00625*TapAB;
                        ArCB=1-0.00625*TapCB;
   
                        
                                                Branch.OpenDeltaTaps=[Branch.OpenDeltaTaps,[TapAB; TapCB ]];

                        Av=[ArAB 1-ArAB 0; 0 1 0; 0 1-ArCB ArCB];
                       Branch.OpenDeltaAvs=[Branch.OpenDeltaAvs;Av];
                    end
                    
                    
                    
                    end
            
                    elseif length(Branch.Phases{ii})==2
                           Branch.RegulatorTypes=[Branch.RegulatorTypes;'Wye'];
                        Branch.Regs2PhiBranchNumbers=[Branch.Regs2PhiBranchNumbers;ii];
                        Branch.Wye2PhiBranchNumbers=[Branch.Wye2PhiBranchNumbers;ii];       
                        Branch.Wye2PhiTaps=[Branch.Wye2PhiTaps,[0; 0  ]];  
                        Tap1=0;
                        Tap2=0;
                        Ar1=1-0.00625*Tap1;
                        Ar2=1-0.00625*Tap2; 
                        Av=diag([Ar1; Ar2]);
                        Branch.Wye2PhiAvs=[Branch.Wye2PhiAvs;Av];

                    else
                       Branch.RegulatorTypes=[Branch.RegulatorTypes;'Wye'];
                        Branch.Regs1PhiBranchNumbers=[Branch.Regs1PhiBranchNumbers;ii];
                        Branch.Wye1PhiBranchNumbers=[Branch.Wye1PhiBranchNumbers;ii];
                        Branch.Wye1PhiTaps=[Branch.Wye1PhiTaps,0];
                      Tap=0;
                      Av=1-0.00625*Tap;
                      Branch.Wye1PhiAvs=[Branch.Wye1PhiAvs;Av];
                    end
            
            clear Zseries LineLength Yshunt YNMn YNMm YMNn YMNm AvailablePhases
            
            
        case 'Switch'
                 Zseries=Zcfg(:,:,LineImpedanceCodes(ii));
            Yshunt=Ycfg(:,:,LineImpedanceCodes(ii));
            AvailablePhases=find(any(Zseries)).';
            Zseries=Zseries(AvailablePhases,AvailablePhases);
            Yshunt=Yshunt(AvailablePhases,AvailablePhases);
            % length of the line:
            LineLength=10;
            Yseries=inv(Zseries);
            % Ytilde
            
            YNMn=(Yseries/LineLength/YBase+0*Yshunt*LineLength/YBase);
            YNMm=(Yseries/LineLength/YBase);
            YMNn=(Yseries/LineLength/YBase);
            YMNm=(Yseries/LineLength/YBase+0*Yshunt*LineLength/YBase);
            ZNM=Zseries*LineLength/ZBase;
            Branch.Admittance{ii}.YNMn=YNMn;
            Branch.Admittance{ii}.YNMm=YNMm;
            Branch.Admittance{ii}.YMNn=YMNn;
            Branch.Admittance{ii}.YMNm=YMNm;
            Branch.Admittance{ii}.ZNM=ZNM;
            Branch.Phases{ii}=AvailablePhases;
            
            
            clear Zseries LineLength Yshunt YNMn YNMm YMNn YMNm AvailablePhases
            
            
            
            
            
        case 'D-GW'
            % (modeled as GrW-GrW)
         % Transformer model
%          %*************************
            AvailablePhases=[1;2;3];
Zt=0.01*(1+sqrt(-1)*8)*3;        
Yt=1./Zt;
            Y1=diag([Yt;Yt;Yt]);
             Y2=(1/3) *[2* Yt, -Yt, -Yt;
                            -Yt, 2*Yt, -Yt; 
                            -Yt, -Yt, 2*Yt]; 
                        
           Y3=(1/sqrt(3))*[-Yt, Yt, 0; 
                                    0, -Yt, Yt; 
                                    Yt, 0, -Yt]; 
%                                 
%                 
             Epsilon=1e-6;             
             Y2Hat=Y2+Epsilon*abs(Yt)*eye(3);    
%        
            
            
%             YNMn=Y2Hat;
%             YNMm=-Y3;
%             YMNn=-Y3.';
%             YMNm=Y1;
            
            
%             

            YNMn=Y1;
            YNMm=Y1;
            YMNn=Y1;
            YMNm=Y1;
            ZNM=inv(Y1); 
           % *************************
 
%           
            
            Branch.Admittance{ii}.YNMn=YNMn;
            Branch.Admittance{ii}.YNMm=YNMm;
            Branch.Admittance{ii}.YMNn=YMNn;
            Branch.Admittance{ii}.YMNm=YMNm;
            Branch.Admittance{ii}.ZNM=ZNM;

            Branch.Phases{ii}=AvailablePhases;
            
            clear Zt Yt Y2 Y3 Y1 Y2hat1 Y2hat2 YNMn YNMm YMNn YMNm AvailablePhases
            
            %
        case 'D-D'
            
            % transformer model
            %*************************
            Zt=0.01*(1.27+2.72i)*(SBase/150000)*3;
            Yt=1./Zt;
            AvailablePhases=[1;2;3];
            Y1=diag([Yt;Yt;Yt]);
              Y2=(1/3) *[2* Yt, -Yt, -Yt;
                            -Yt, 2*Yt, -Yt; 
                            -Yt, -Yt, 2*Yt]; 
                   Epsilon=1e-6;             
             Y2Hat=Y2+Epsilon*abs(Yt)*eye(3);    
%        
            
            %
%             YNMn=Y2Hat;
%             YNMm=Y2;
%             YMNn=Y2;
%             YMNm=Y2Hat;          
%                         
            
            
            YNMn=Y1;
            YNMm=Y1;
            YMNn=Y1;
            YMNm=Y1;
            ZNM=inv(Y1); 

            %************************
            
            Branch.Admittance{ii}.YNMn=YNMn;
            Branch.Admittance{ii}.YNMm=YNMm;
            Branch.Admittance{ii}.YMNn=YMNn;
            Branch.Admittance{ii}.YMNm=YMNm;
            Branch.Admittance{ii}.ZNM=ZNM;
            Branch.Phases{ii}=AvailablePhases;
            
            clear Zt Yt Y2 Y2hat1 Y2hat2 YNMn YNMm YMNn YMNm AvailablePhases
            
            
        otherwise
            
            
            Zseries=Zcfg(:,:,LineImpedanceCodes(ii));
            Yshunt=Ycfg(:,:,LineImpedanceCodes(ii));
            AvailablePhases=find(any(Zseries)).';
            Zseries=Zseries(AvailablePhases,AvailablePhases);
            Yshunt=Yshunt(AvailablePhases,AvailablePhases);
            % length of the line:
            LineLength=LineLengths(ii);
            Yseries=inv(Zseries);
      

            % Ytilde
            
            YNMn=(Yseries/LineLength/YBase+0*Yshunt*LineLength/YBase);
            YNMm=(Yseries/LineLength/YBase);
            YMNn=(Yseries/LineLength/YBase);
            YMNm=(Yseries/LineLength/YBase+0*Yshunt*LineLength/YBase);
           ZNM=Zseries*LineLength/ZBase;
            Branch.Admittance{ii}.YNMn=YNMn;
            Branch.Admittance{ii}.YNMm=YNMm;
            Branch.Admittance{ii}.YMNn=YMNn;
            Branch.Admittance{ii}.YMNm=YMNm;
           Branch.Admittance{ii}.ZNM=ZNM;
            Branch.Phases{ii}=AvailablePhases;
            
            
            clear Zseries LineLength Yshunt YNMn YNMm YMNn YMNm AvailablePhases
            
    end
    
    
    
    if length(Branch.Phases{ii})==3
        Branch.ThreePhaseBranchNumbers=[Branch.ThreePhaseBranchNumbers;Branch.Numbers(ii)];
    elseif length(Branch.Phases{ii})==2
        Branch.TwoPhaseBranchNumbers=[Branch.TwoPhaseBranchNumbers;Branch.Numbers(ii)];
    else
        Branch.OnePhaseBranchNumbers=[Branch.OnePhaseBranchNumbers;Branch.Numbers(ii)];
    end
    
end

ConnectedPath = gen_path(124, Branch.CNodes.', Branch.BusFromNumbers, Branch.BusToNumbers);
Branch.ConnectedPath=[ConnectedPath,setdiff([1:NBuses],ConnectedPath)];


Bus=struct;
Bus.Names=cell(NBuses,1);
Bus.Numbers=zeros(NBuses,1);
Bus.ToNeighbors=cell(NBuses,1);
Bus.ToNeighborsBranchNumbers=cell(NBuses,1);
Bus.FromNeighbors=cell(NBuses,1);
Bus.FromNeighborsBranchNumbers=cell(NBuses,1);
Bus.Phases=cell(NBuses,1);
Bus.ThreePhaseBusNumbers=[];
Bus.TwoPhaseBusNumbers=[];
Bus.OnePhaseBusNumbers=[];
Bus.ToNeighborsDevice=cell(NBuses,1);
Bus.FromNeighborsDevice=cell(NBuses,1);
Bus.SLoad=cell(NBuses,1);
Bus.YCap=cell(NBuses,1);
Bus.ToNeighborsRegulatorBranchNumbers=cell(NBuses,1);
Bus.FromNeighborsRegulatorBranchNumbers=cell(NBuses,1);
Bus.ToNeighborsNonRegulatorBranchNumbers=cell(NBuses,1);
Bus.FromNeighborsNonRegulatorBranchNumbers=cell(NBuses,1);
Bus.SubstationName=Substation;
Bus.SubstationNumber=find(strcmp(BusNames,Substation));
Bus.NonZeroPhaseNumbers=(1:3*NBuses).';
Bus.SLoadVec=[];
Bus.SBase=SBase;
Bus.VBase=VBase;
for ii=1:NBuses
    Bus.Names{ii}=BusNames{ii};
    Bus.Numbers(ii)=ii;
    Bus.ToNeighbors{ii}=Branch.BusToNumbers(Branch.BusFromNumbers==ii);
    Bus.ToNeighborsBranchNumbers{ii}=Branch.Numbers(Branch.BusFromNumbers==ii);
    Bus.FromNeighbors{ii}=Branch.BusFromNumbers(Branch.BusToNumbers==ii);
    Bus.FromNeighborsBranchNumbers{ii}=Branch.Numbers(Branch.BusToNumbers==ii);
    Bus.ToNeighborsDevice{ii}=Branch.Device(Bus.ToNeighborsBranchNumbers{ii});
    Bus.FromNeighborsDevice{ii}=Branch.Device(Bus.FromNeighborsBranchNumbers{ii});
    if find(strcmp(Bus.ToNeighborsDevice{ii},'Reg'))
        jj=find(strcmp(Bus.ToNeighborsDevice{ii},'Reg'));
        Bus.ToNeighborsRegulatorBranchNumbers{ii}=Bus.ToNeighborsBranchNumbers{ii}(jj);
    end
    if find(strcmp(Bus.FromNeighborsDevice{ii},'Reg'))
        jj=find(strcmp(Bus.FromNeighborsDevice{ii},'Reg'));
        Bus.FromNeighborsRegulatorBranchNumbers{ii}=Bus.FromNeighborsBranchNumbers{ii}(jj);
    end
    
    Bus.ToNeighborsNonRegulatorBranchNumbers{ii}=setdiff(Bus.ToNeighborsBranchNumbers{ii}, Bus.ToNeighborsRegulatorBranchNumbers{ii});
    Bus.FromNeighborsNonRegulatorBranchNumbers{ii}=setdiff(Bus.FromNeighborsBranchNumbers{ii}, Bus.FromNeighborsRegulatorBranchNumbers{ii});
    Bus.NumberOfNeighbors{ii}=length(Bus.ToNeighborsBranchNumbers{ii})+length(Bus.FromNeighborsBranchNumbers);
    
    
    PhaseSet=[];
    for jj=1:length(Bus.FromNeighborsBranchNumbers{ii})
        PhaseSet=union(PhaseSet,Branch.Phases{Bus.FromNeighborsBranchNumbers{ii}(jj)});
    end
    for jj=1:length(Bus.ToNeighborsBranchNumbers{ii})
        PhaseSet=union(PhaseSet,Branch.Phases{Bus.ToNeighborsBranchNumbers{ii}(jj)});
    end
    
    Bus.Phases{ii}=PhaseSet;
    Bus.SLoad{ii}=zeros(length(PhaseSet),1);
    MissingPhases=setdiff([1;2;3],PhaseSet);
    if ~isempty(MissingPhases)
        Bus.NonZeroPhaseNumbers( (ii-1)*3+MissingPhases)=0;
    end
    
    clear PhaseSet
    
    
    if length(Bus.Phases{ii})==3
        Bus.ThreePhaseBusNumbers=[Bus.ThreePhaseBusNumbers;Bus.Numbers(ii)];
    elseif length(Bus.Phases{ii})==2
        Bus.TwoPhaseBusNumbers=[Bus.TwoPhaseBusNumbers;Bus.Numbers(ii)];
    else
        Bus.OnePhaseBusNumbers=[Bus.OnePhaseBusNumbers;Bus.Numbers(ii)];
    end
    
    
    
end


Bus.NonZeroPhaseNumbers=find(Bus.NonZeroPhaseNumbers);



%% 4. Setting up loads:
[LoadBuses,LoadTypes,Ph1,Ph2,Ph3,Ph4,Ph5,Ph6] = importLoads([DataPath,'/spot loads data']);
LoadBuses=strtrim(cellstr(num2str(LoadBuses))); 
LoadTypes=strtrim(cellstr(LoadTypes)); 


UniformLoadModel='Y-PQ';
if strcmp(UniformLoadModel,'Y-PQ')
    LoadTypes(strcmp(LoadTypes,'Y-I'))={'Y-PQ'};
    LoadTypes(strcmp(LoadTypes,'Y-Z'))={'Y-PQ'};
    LoadTypes(strcmp(LoadTypes,'D-I'))={'D-PQ'}; % the conversion to wye is at a later point
    LoadTypes(strcmp(LoadTypes,'D-Z'))={'D-PQ'};
        LoadTypes(strcmp(LoadTypes,'Y-PR'))={'Y-PQ'};

end



for ii=1:length(LoadBuses)
    
    BusNumber=find(strcmp(BusNames,LoadBuses(ii)));
    
    PLoad=[Ph1(ii), Ph3(ii), Ph5(ii)]*1000/SBase;
    QLoad=[Ph2(ii), Ph4(ii), Ph6(ii)]*1000/SBase;
    SLoad=1*(PLoad+1j*QLoad).';
    
    
    
    switch LoadTypes{ii}
        
        
        
        case 'Y-PQ'
            
            
        case 'D-PQ'
            if strcmp(UniformLoadModel,'Y-PQ')
                SLoad=convertSLoadToWye(SLoad);
                
            end
            
        otherwise
            SLoad=zeros(size(SLoad));
    end
    
    Bus.SLoad{BusNumber}=SLoad(Bus.Phases{BusNumber});
    
    
end



% converting load to vector (needed for later)
Bus.SLoadVec=cell2mat(Bus.SLoad);







%% Shunt capacitors
[CapacitorBuses, Q1,Q2,Q3]=importCapacitors([DataPath,'/cap data']);
CapacitorBuses=strtrim(cellstr(num2str(CapacitorBuses))); 

for ii=1:length(CapacitorBuses)
    BusNumber=find(strcmp(BusNames,CapacitorBuses{ii}));
    Bus.YCap{ii}=[];
    for jj=1:length(Bus.Phases{BusNumber})
        switch Bus.Phases{BusNumber}(jj)
            case 1
            Bus.YCap{BusNumber}=[Bus.YCap{BusNumber};sqrt(-1)*Q1(ii)*1000./SBase];
            case 2
            Bus.YCap{BusNumber}=[Bus.YCap{BusNumber};sqrt(-1)*Q2(ii)*1000./SBase];
            case 3
            Bus.YCap{BusNumber}=[Bus.YCap{BusNumber};sqrt(-1)*Q3(ii)*1000./SBase];
        end
    end
end

Network=v2struct(Bus,Branch,SBase,VBase);





Network.RegulatorType=RegulatorType;








