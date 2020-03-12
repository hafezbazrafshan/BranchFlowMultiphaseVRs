function Network=setupIEEE8500(RegulatorType)
DataPath=[pwd,'/IEEE-8500 feeder data'];
Epsilon=1e-5;
% importing lines
[LineNames,LineBusesFromNames,LinePhasesFrom,LineBusesToNames,...
    LinePhasesTo,LineLengths,LineUnits,LineImpedanceCodes,LineStatuses]=importLines([DataPath,'/Lines.csv']);
load([DataPath,'/lineDataSet2.mat']);
LineDataSet=lineDataSet;
clear lineDataSet % wrong name format saved
% importing transformers:
[TransformerNames,TransformerPhases,TransformerBusesFromNames,...
    TransformerBusesToNames,TransformerKVPri,TransformerKVSec,TransformerMVA,...
    TransformerConnPri,TransformerConnSec,TransformerXHL,TransformerRHL] =...
    importTransformers([DataPath,'/Transformers.csv']);

% importing regulators:
[RegulatorNames,RegulatorBusesFromNames,RegulatorPhasesFrom,...
    RegulatorBusesToNames,RegulatorPhasesTo,~,~,~,~,~,~]=importRegulators([DataPath,'/Regulators.csv']);
% importing capacitors
[CapacitorNames,CapacitorBus,CapacitorPhase,CapacitorKV,...
    CapacitorKVAR,CapacitorNumPhases,CapacitorConnection] = importCapacitors([DataPath,'/Capacitors.csv']) ;



%% Some readjustments:
% some simplification in modeling:
% a. removing open switches
NonSwitchLineIndices=find(strcmp(strtrim(LineStatuses),'open')==0);
LineNames=LineNames(NonSwitchLineIndices);
LineBusesFromNames=LineBusesFromNames(NonSwitchLineIndices);
LinePhasesFrom=LinePhasesFrom(NonSwitchLineIndices);
LineBusesToNames=LineBusesToNames(NonSwitchLineIndices);
LinePhasesTo=LinePhasesTo(NonSwitchLineIndices);
LineLengths=LineLengths(NonSwitchLineIndices);
LineUnits=LineUnits(NonSwitchLineIndices);
LineImpedanceCodes=strtrim(lower(LineImpedanceCodes(NonSwitchLineIndices)));
LineDevices=LineStatuses(NonSwitchLineIndices);  % devices seem like a better term for now
% all of the entries in LineDevices are empty because we have removed open
% switches.  They are all transmission lines now.
LineDevices=cellstr(repmat('TrLine',length(LineImpedanceCodes),1)); % 0 is a regular line


% %b. assuming connectors as ideal connectors 
ConnectorBusHolder={};
cnt=0;
ii=1;
while ii<=length(LineNames)
if (strcmp( strtrim(lower(LineImpedanceCodes(ii))),'1ph-connector')) ||...
    (LineLengths(ii)<0.01)

        cnt=cnt+1;
        idx2=find(strcmp(LineBusesFromNames,LineBusesToNames(ii)));
        LineBusesFromNames(idx2)=LineBusesFromNames(ii);
        
        IdxCap=find(strcmp(CapacitorBus,LineBusesToNames(ii)));
        if ~isempty(IdxCap)
            CapacitorBus(IdxCap)=repmat(LineBusesFromNames(ii),length(IdxCap),1);
        end
        
        
         IdxTrFrom=find(strcmp(TransformerBusesFromNames,LineBusesToNames(ii)));
        if ~isempty(IdxTrFrom)
            TransformerBusesFromNames(IdxTrFrom)=repmat(LineBusesFromNames(ii),length(IdxTrFrom),1);
        end
        
           IdxTrTo=find(strcmp(TransformerBusesToNames,LineBusesToNames(ii)));
        if ~isempty(IdxTrTo)
            TransformerBusesToNames(IdxTrTo)=repmat(LineBusesFromNames(ii),length(IdxTrTo),1);
        end
        
        
           
         IdxRegFrom=find(strcmp(RegulatorBusesFromNames,LineBusesToNames(ii)));
        if ~isempty(IdxRegFrom)
            RegulatorBusesFromNames(IdxRegFrom)=repmat(LineBusesFromNames(ii),length(IdxRegFrom),1);
        end
        
           IdxRegTo=find(strcmp(RegulatorBusesToNames,LineBusesToNames(ii)));
        if ~isempty(IdxRegTo)
            RegulatorBusesToNames(IdxRegTo)=repmat(LineBusesFromNames(ii),length(IdxRegTo),1);
        end
        % remove the connector from lines matrix
        LineNames(ii)=[];
        LineBusesFromNames(ii)=[];
        LinePhasesFrom(ii)=[];
        LineBusesToNames(ii)=[];
        LinePhasesTo(ii)=[];
        LineLengths(ii)=[];
        LineUnits(ii)=[];
        LineImpedanceCodes(ii)=[];
        LineDevices(ii)=[];
    else
        ii=ii+1;
    end
    
end
    




%% Short lines

% thus far we have gathered the required data for transmission lines
% most relevant are the following:
% LineBusesFromNames
% LineBusesToNames
% LineLengths
% LineImpedanceCodes
% LineDevices
% LinePhasesFrom
% LinePhasesTo
%% Adding transformers
% adding transformers to the line data set:
LineNames=[LineNames; TransformerNames];
LineBusesFromNames=[LineBusesFromNames;TransformerBusesFromNames];
LinePhasesFrom=[LinePhasesFrom;'ABC']; % all three-phase transformers
LineBusesToNames=[LineBusesToNames; TransformerBusesToNames];
LinePhasesTo=[LinePhasesTo; 'ABC'];
LineLengths=[LineLengths; 0];
LineUnits=[LineUnits;'0']; % for transformers it doesn't matter
LineImpedanceCodes=[LineImpedanceCodes;'2'];
LineDevices=[LineDevices; 'D-GW']; % only one transformer


% LineBusesFrom, LineBusesTo, LineLengths, LineDevice, LineCodes, 
% 

%% 3.  Organizing bus names
% collecting bus names:
BusNames=unique([LineBusesFromNames;LineBusesToNames;RegulatorBusesFromNames]);
% remove secondary of the regulators from the busNames but keeping them in
% the busNamesWithRegs

%% Regulators
% we don't take the regulator secondary in direct use (update this comment)
RegNumber1=find(strcmp(BusNames,'_HVMV_Sub_LSB'));
BusNames(RegNumber1)=[];
RegLineNumber1=find(strcmp(LineBusesFromNames,'_HVMV_Sub_LSB'));
LineBusesFromNames{RegLineNumber1}='regxfmr_HVMV_Sub_LSB';
LineDevices{RegLineNumber1}='Reg';

RegNumber2=find(strcmp(BusNames,'190-8593'));
BusNames(RegNumber2)=[];
RegLineNumber2=find(strcmp(LineBusesFromNames,'190-8593'));
LineBusesFromNames{RegLineNumber2}='regxfmr_190-8593';
LineDevices{RegLineNumber2}='Reg';


RegNumber3=find(strcmp(BusNames,'190-8581'));
BusNames(RegNumber3)=[];
RegLineNumber3=find(strcmp(LineBusesFromNames,'190-8581'));
LineBusesFromNames{RegLineNumber3}='regxfmr_190-8581';
LineDevices{RegLineNumber3}='Reg';



% 190-7361
% D6138608-3_INT
RegNumber4=find(strcmp(BusNames,'190-7361'));
BusNames(RegNumber4)=[];
RegLineNumber4=find(strcmp(LineBusesFromNames,'190-7361'));
LineBusesFromNames{RegLineNumber4}='D6138608-3_INT';
LineDevices{RegLineNumber4}='Reg';




%% Putting substation index at the very end:
% substation='regxfmr_HVMV_Sub_LSB';
Substation=TransformerBusesFromNames;
SubstationNumber=find(strcmp(BusNames,Substation));

if SubstationNumber< length(BusNames) % if substation is not the end bus
    BusNames=[BusNames(1:SubstationNumber-1); BusNames(SubstationNumber+1:end); BusNames(SubstationNumber)];
end

% D6138608-3_INT
BusNamesWithRegs=[BusNames;'_HVMV_Sub_LSB';'190-8593';'190-8581';'D6138608-3_INT'];
% remove secondary of the regulators from the busNames but keeping them in
% the busNamesWithRegs






 %% 4. Defining base quantities:
SBase=str2num(TransformerMVA)*1000*1000; % from the substation transformer
VBase=12.47*1000/sqrt(3); % line to neutral conversion (secondary of the substation transformer)
% VBase=115*1000/sqrt(3); % line to neutral conversion (secondary of the substation transformer)
ZBase=(VBase.^2)/SBase;
YBase=1./ZBase;






%% 5. Organize branch 
NBuses=length(BusNames);
NBranches=length(LineBusesFromNames);
LineBusesFromNumbers=getNumericNodeList( LineBusesFromNames, BusNames );
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
    
    
     BusInPhases=LinePhasesFrom(ii);
    BusOutPhases=LinePhasesTo(ii);
    
    if ~isequal(BusInPhases,BusOutPhases)
        fprintf('the line is not connected properly\n');
        fprintf('different phases at the two end of the line\n');
    end
    
    
    

    switch char(BusInPhases)
        case 'ABC'
            AvailablePhases=[1,2,3];
        case 'AB'
            AvailablePhases=[1,2];
        case 'BC'
            AvailablePhases=[2,3];
        case 'AC'
            AvailablePhases=[1,3];
        case 'A'
            AvailablePhases=[1];
        case 'B'
            AvailablePhases=[2];
        case 'C'
            AvailablePhases=[3];
    end
    
    
    
   


    
  
    
    

    switch char(LineDevices(ii))
        case 'Reg' % reg 1
          
                            LineImpedanceCode=LineImpedanceCodes(ii);
                                LineCodeNumber=find(strcmp(LineDataSet(:,1),lower(LineImpedanceCode)));
                                [Zseries,Yshunt,Nphases]=LineDataSet{LineCodeNumber,[3,4,2]};
              if Nphases~=length(char(BusInPhases))
                    fprintf('mismatch in the number of phases per line and the lineCode');
              end

    % length of the line:
    LineLength=LineLengths(ii);
    Yseries=inv(Zseries);
    % Ytilde

    YNMn=(Yseries/LineLength/YBase+0*Yshunt*LineLength/YBase);
    YNMm=(Yseries/LineLength/YBase);
    YMNn=(Yseries/LineLength/YBase);
    YMNm=(Yseries/LineLength/YBase+0*Yshunt*LineLength/YBase);
    ZNM=Zseries*LineLength/ZBase;
              Branch.Admittance{ii}.ZNM=ZNM;

    Branch.Admittance{ii}.YNMn=YNMn;
            Branch.Admittance{ii}.YNMm=YNMm;
            Branch.Admittance{ii}.YMNn=YMNn;
            Branch.Admittance{ii}.YMNm=YMNm;

            Branch.Phases{ii}=AvailablePhases;
            
    Branch.RegulatorBranchNumbers=[Branch.RegulatorBranchNumbers;ii];
    
     switch RegulatorType
                case 'Wye'
                        Branch.RegulatorTypes=[Branch.RegulatorTypes;'Wye'];
                        Branch.Regs3PhiBranchNumbers=[Branch.Regs3PhiBranchNumbers;ii];
                        Branch.Wye3PhiBranchNumbers=[Branch.Wye3PhiBranchNumbers;ii];
                        % putting default values
                        switch Branch.BusFromNames{ii}
                            case 'regxfmr_HVMV_Sub_LSB'
                                %                                TapA=2;
                                %                         TapB=2;
                                %                         TapC=1;
                                
                                TapA=0;
                                TapB=0;
                                TapC=0;
                                
                                Branch.Wye3PhiTaps=[Branch.Wye3PhiTaps,[TapA; TapB ;TapC]];
                                
                                
                            case 'regxfmr_190-8593'
                                %                                   TapA=10;
                                %                         TapB=5;
                                %                         TapC=2;
                                
                                
                                TapA=0;
                                TapB=0;
                                TapC=0;
                                
                                Branch.Wye3PhiTaps=[Branch.Wye3PhiTaps,[TapA; TapB ;TapC]];
                                
                            case 'regxfmr_190-8581'
                                %                                  TapA=16;
                                %                         TapB=11;
                                %                         TapC=1;
                                
                                TapA=0;
                                TapB=0;
                                TapC=0;
                                Branch.Wye3PhiTaps=[Branch.Wye3PhiTaps,[TapA; TapB ;TapC]];
                                
                            case 'D6138608-3_INT'
                                % case 'regxfmr_190-7361'
                                %                                  TapA=12;
                                %                         TapB=12;
                                %                         TapC=5;
                                
                                TapA=0;
                                TapB=0;
                                TapC=0;
                                Branch.Wye3PhiTaps=[Branch.Wye3PhiTaps,[TapA; TapB ;TapC]];
                                
                        end
                        ArA=1+0.00625*TapA;
                        ArB=1+0.00625*TapB;
                        ArC=1+0.00625*TapC;
                        Av=inv(diag([ArA; ArB; ArC]));
                        Branch.Wye3PhiAvs{end+1}=Av;
                  
                case 'ClosedDelta'
                    



%                         

                    Branch.RegulatorTypes=[Branch.RegulatorTypes;'ClosedDelta'];
                        Branch.Regs3PhiBranchNumbers=[Branch.Regs3PhiBranchNumbers;ii];
                        Branch.ClosedDeltaBranchNumbers=[Branch.ClosedDeltaBranchNumbers;ii];

                        
                          TapAB=0;
                        TapBC=0;
                        TapCA=0;
                        ArAB=1+0.00625*TapAB;
                        ArBC=1+0.00625*TapBC;
                        ArCA=1+0.00625*TapCA;
                        
                        
                                                Branch.ClosedDeltaTaps=[Branch.ClosedDeltaTaps,[TapAB; TapBC;TapCA ]];

                        Av=inv([ArAB 1-ArAB 0; 0 ArBC 1-ArBC; 1-ArCA 0 ArCA]);
                        Branch.ClosedDeltaAvs{end+1}=Av;                   
                case 'OpenDelta'
               
                     Branch.RegulatorTypes=[Branch.RegulatorTypes;'OpenDelta'];
                        Branch.Regs3PhiBranchNumbers=[Branch.Regs3PhiBranchNumbers;ii];
                        Branch.OpenDeltaBranchNumbers=[Branch.OpenDeltaBranchNumbers;ii];
                        TapAB=0;
                        TapCB=0;
                        ArAB=1+0.00625*TapAB;
                        ArCB=1+0.00625*TapCB;
                        Branch.OpenDeltaTaps=[Branch.OpenDeltaTaps,[TapAB; TapCB ]];

                        Av=inv([ArAB 1-ArAB 0; 0 1 0; 0 1-ArCB ArCB]);
                       Branch.OpenDeltaAvs{end+1}=Av;
                       
                       
         case 'Mixed'
             
             
             switch Branch.BusFromNames{ii}
                            case 'regxfmr_HVMV_Sub_LSB'
                               
                                Branch.RegulatorTypes=[Branch.RegulatorTypes;'Wye'];
                        Branch.Regs3PhiBranchNumbers=[Branch.Regs3PhiBranchNumbers;ii];
                        Branch.Wye3PhiBranchNumbers=[Branch.Wye3PhiBranchNumbers;ii];             
                                TapA=0;
                                TapB=0;
                                TapC=0;
                        Branch.Wye3PhiTaps=[Branch.Wye3PhiTaps,[TapA; TapB ;TapC]];
                        ArA=1+0.00625*TapA;
                        ArB=1+0.00625*TapB;
                        ArC=1+0.00625*TapC;
                        Av=inv(diag([ArA; ArB; ArC]));
                        Branch.Wye3PhiAvs{end+1}=Av;
                                
                                
                            case 'regxfmr_190-8593'
                                %                                   TapA=10;
                                %                         TapB=5;
                                %                         TapC=2;
                                
                                
                                Branch.RegulatorTypes=[Branch.RegulatorTypes;'ClosedDelta'];
                        Branch.Regs3PhiBranchNumbers=[Branch.Regs3PhiBranchNumbers;ii];
                        Branch.ClosedDeltaBranchNumbers=[Branch.ClosedDeltaBranchNumbers;ii];

                        
                          TapAB=0;
                        TapBC=0;
                        TapCA=0;
                        ArAB=1+0.00625*TapAB;
                        ArBC=1+0.00625*TapBC;
                        ArCA=1+0.00625*TapCA;
                        
                        
                                                Branch.ClosedDeltaTaps=[Branch.ClosedDeltaTaps,[TapAB; TapBC;TapCA ]];

                        Av=inv([ArAB 1-ArAB 0; 0 ArBC 1-ArBC; 1-ArCA 0 ArCA]);
                        Branch.ClosedDeltaAvs{end+1}=Av;   
                                
                            case 'regxfmr_190-8581'
                                %                                  TapA=16;
                                %                         TapB=11;
                                %                         TapC=1;
                                
                                Branch.RegulatorTypes=[Branch.RegulatorTypes;'ClosedDelta'];
                        Branch.Regs3PhiBranchNumbers=[Branch.Regs3PhiBranchNumbers;ii];
                        Branch.ClosedDeltaBranchNumbers=[Branch.ClosedDeltaBranchNumbers;ii];
                         TapAB=0;
                        TapBC=0;
                        TapCA=0;
                        ArAB=1+0.00625*TapAB;
                        ArBC=1+0.00625*TapBC;
                        ArCA=1+0.00625*TapCA;
                        
                        
                                                Branch.ClosedDeltaTaps=[Branch.ClosedDeltaTaps,[TapAB; TapBC;TapCA ]];

                        Av=inv([ArAB 1-ArAB 0; 0 ArBC 1-ArBC; 1-ArCA 0 ArCA]);
                        Branch.ClosedDeltaAvs{end+1}=Av;   
                                 
                            case 'D6138608-3_INT'
                                % case 'regxfmr_190-7361'
                                %                                  TapA=12;
                                %                         TapB=12;
                                %                         TapC=5;
                                
                        Branch.RegulatorTypes=[Branch.RegulatorTypes;'Wye'];
                        Branch.Regs3PhiBranchNumbers=[Branch.Regs3PhiBranchNumbers;ii];
                        Branch.Wye3PhiBranchNumbers=[Branch.Wye3PhiBranchNumbers;ii];             
                                TapA=0;
                                TapB=0;
                                TapC=0;
                        Branch.Wye3PhiTaps=[Branch.Wye3PhiTaps,[TapA; TapB ;TapC]];
                        ArA=1+0.00625*TapA;
                        ArB=1+0.00625*TapB;
                        ArC=1+0.00625*TapC;
                        Av=inv(diag([ArA; ArB; ArC]));
                        Branch.Wye3PhiAvs{end+1}=Av;
                                
                        end
                       
                          
                    
            end
            clear Zseries LineLength Yshunt YNMn YNMm YMNn YMNm AvailablePhases
            
            
           
    
 
    
    
  
    
    
    

        case 'D-GW'
            
%             
            AvailablePhases=[1;2;3];
           Zt=0.01*(str2num(TransformerRHL)+sqrt(-1)*str2num(TransformerXHL))*3;

            Yt=1./Zt;
% % 
% %             
            Y1=diag([Yt; Yt; Yt]); 
          Y2=(1/3) *[2* Yt, -Yt, -Yt;
                            -Yt, 2*Yt, -Yt; 
                            -Yt, -Yt, 2*Yt]; 
                        
           Y3=(1/sqrt(3))*[-Yt, Yt, 0; 
                                    0, -Yt, Yt; 
                                    Yt, 0, -Yt]; 
%                                 
% %                 
% %                                 
             Y2Hat=Y2+Epsilon*abs(Yt)*eye(3);    
% %        
%             
%             %
%             YNMn=Y2Hat;
%             YNMm=-Y3;
%             YMNn=-Y3.';
%             YMNm=Y1;
               YNMn=Y1;
            YNMm=Y1;
            YMNn=Y1;
            YMNm=Y1;
            
            ZNM=inv(Y1);
              Branch.Admittance{ii}.ZNM=ZNM;
%             
%                      LineImpedanceCode=LineImpedanceCodes(10);
%                                 LineCodeNumber=find(strcmp(LineDataSet(:,1),lower(LineImpedanceCode)));
%                                 [Zseries,Yshunt,Nphases]=LineDataSet{LineCodeNumber,[3,4,2]};
%               if Nphases~=length(char(BusInPhases))
%                     fprintf('mismatch in the number of phases per line and the lineCode');
%               end
% % 
% %     % length of the line:
%     LineLength=0.001;
%     Yseries=inv(Zseries);
%     % Ytilde
% 
%     YNMn=(Yseries/LineLength/YBase+0*Yshunt*LineLength/YBase);
%     YNMm=(Yseries/LineLength/YBase);
%     YMNn=(Yseries/LineLength/YBase);
%     YMNm=(Yseries/LineLength/YBase+0*Yshunt*LineLength/YBase);
    Branch.Admittance{ii}.YNMn=YNMn;
            Branch.Admittance{ii}.YNMm=YNMm;
            Branch.Admittance{ii}.YMNn=YMNn;
            Branch.Admittance{ii}.YMNm=YMNm;
            Branch.Phases{ii}=AvailablePhases;
            
            

            
            clear Zt Yt Y2 Y3 Y1 Y2Hat1 Y2Hat2 YNMn YNMm YMNn YMNm AvailablePhases
%     
        
        otherwise
            
         LineImpedanceCode=LineImpedanceCodes(ii);
                                LineCodeNumber=find(strcmp(LineDataSet(:,1),lower(LineImpedanceCode)));
                                [Zseries,Yshunt,Nphases]=LineDataSet{LineCodeNumber,[3,4,2]};
              if Nphases~=length(char(BusInPhases))
                    fprintf('mismatch in the number of phases per line and the lineCode');
              end

    % length of the line:
    LineLength=LineLengths(ii);
    Yseries=inv(Zseries);
    % Ytilde

    YNMn=(Yseries/LineLength/YBase+0*Yshunt*LineLength/YBase);
    YNMm=(Yseries/LineLength/YBase);
    YMNn=(Yseries/LineLength/YBase);
    YMNm=(Yseries/LineLength/YBase+0*Yshunt*LineLength/YBase);
    ZNM=Zseries*LineLength/ZBase;
              Branch.Admittance{ii}.ZNM=ZNM;
    Branch.Admittance{ii}.YNMn=YNMn;
            Branch.Admittance{ii}.YNMm=YNMm;
            Branch.Admittance{ii}.YMNn=YMNn;
            Branch.Admittance{ii}.YMNm=YMNm;
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




%% Bus

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
 Bus.SLoadVecA=[];
 Bus.SLoadVecB=[];
 Bus.SLoadVecC=[];
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
 SL=sparse(zeros((NBuses-1)*3,1));
[TrName,TrBusName] =importLoadXfmrs([DataPath,'/LoadXfmrs.csv']);
 load([DataPath,'/PQloads.mat']); 
 for ii=1:length(TrBusName)
     BusNumber=find(strcmp(BusNames,TrBusName(ii)));
     TrNameForPhase=char(TrName(ii));
     LoadNumber= find( and(strcmp(strtrim(lower(Element)),['transformer.',lower(char(TrName(ii)))]), Terminal==1));
    if ~isempty(LoadNumber)
     SLoad1Phase=1000*(PkW(LoadNumber(1))+sqrt(-1)*Qkvar(LoadNumber(1)))/SBase;
         Phase=TrNameForPhase(end); 
            switch Phase
             case 'A'
               
                SL((BusNumber-1)*3+1)=SLoad1Phase;
             case 'B'
              SL((BusNumber-1)*3+2)=SLoad1Phase;
             case 'C'
                    SL((BusNumber-1)*3+3)=SLoad1Phase;            
         end
    end

 end
 
 
 for jj=1:NBuses-1
     
     SVec=SL((jj-1)*3+1:(jj-1)*3+3);
     Bus.SLoad{jj}=SVec(Bus.Phases{jj});
 end
     
 
% converting load to vector (needed for later)
Bus.SLoadVec=cell2mat(Bus.SLoad);
 
% for ii=1:NBuses
%     NodePhases=Bus.Phases{ii};
%     PhaseA=sum(find(NodePhases==1)); 
%     PhaseB=sum(find(NodePhases==2)); 
%     PhaseC=sum(find(NodePhases==3));
%     if PhaseA
%         
%     Bus.SLoadVecA=[Bus.SLoadVecA;Bus.SLoad{ii}(1)];
%     end
%      if PhaseB
%     Bus.SLoadVecB=[Bus.SLoadVecB;Bus.SLoad{ii}(2)];
%      end
%      if PhaseC
%     Bus.SLoadVecC=[Bus.SLoadVecC;Bus.SLoad{ii}(3)];
%      end
% end




%% %% 6. Adding Ycap to Bus
Bus.CapacitorNumbers=[];
for ii=1:length(CapacitorNames)
    BusNumber=find(strcmp(Bus.Names,CapacitorBus(ii)));
    if ~ismember(BusNumber,Bus.CapacitorNumbers)
    Bus.CapacitorNumbers=[Bus.CapacitorNumbers;BusNumber];
     NodePhases=Bus.Phases{BusNumber};
     Bus.YCap{BusNumber}=zeros(length(NodePhases),1);
    end
    Phase=char(CapacitorPhase(ii));
    YCap=sqrt(-1)*CapacitorKVAR(ii)*1000/SBase;
   

    switch Phase
        case 'A'
            YCapIdx=find(NodePhases==1);
            Bus.YCap{BusNumber}(YCapIdx,1)=YCap;
        case 'B'
              YCapIdx=find(NodePhases==2);
            Bus.YCap{BusNumber}(YCapIdx,1)=YCap;
            
        case 'C'
         YCapIdx=find(NodePhases==3);
            Bus.YCap{BusNumber}(YCapIdx,1)=YCap;
            
        case 'ABC'

            Bus.YCap{BusNumber}=[YCap/3;YCap/3;YCap/3];
          
            
      
            
            
            
    end
    
 
end

Network=v2struct(Bus,Branch);







Network.RegulatorType=RegulatorType;



