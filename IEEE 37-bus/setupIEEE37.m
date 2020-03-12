function Network=setupIEEE37(RegulatorType)

DataPath=[pwd,'/IEEE-37 feeder data'];
[LineBusesFromNames,LineBusesToNames,LineLengths,LineImpedanceCodes] = importLines([DataPath,'/Line Data.xls']);

% LineBusesFrom, LineBusesTo, LineLengths, LineDevice, LineCodes, 
% 
Epsilon=1e-6;

 %% Setting up the list of nodes, giving them a unique order from 1:N, setting the substation to node N+1
LineBusesFromNames=cellstr(num2str(LineBusesFromNames));
LineBusesToNames=cellstr(num2str(LineBusesToNames));
LineLengths=LineLengths;
LineImpedanceCodes=cellstr(num2str( LineImpedanceCodes));
LineDevices=cellstr(repmat('TrLine',length(LineImpedanceCodes),1)); % 0 is a regular line




%% Substation transformer configuration
LineBusesFromNames=[LineBusesFromNames;'SourceBus'];
LineBusesToNames=[LineBusesToNames; '799'];
LineImpedanceCodes=[LineImpedanceCodes;'2'];
LineLengths=[LineLengths;0]; % for transformers it doesn't matter
LineDevices=[LineDevices;'D-D'];

%% Xfm-1 transformer configuration
XfmIdx=find(strcmp(LineImpedanceCodes,'NaN'));
LineImpedanceCodes{XfmIdx}='2';
LineDevices{XfmIdx}='D-D';
LineBusesFromNames(XfmIdx)={'701'};
LineBusesToNames(XfmIdx)={'775'};

%% Regulator configuration
RegIdx=find(and(strcmp(LineBusesFromNames,'799'), strcmp(LineBusesToNames,'701')));
LineDevices{RegIdx}='Reg';


%% 3.  Organizing bus names
% collecting bus names
BusNames=unique([LineBusesFromNames;LineBusesToNames]);

%% Putting substation index at the very end:
Substation='SourceBus';
SubstationNumber=find(strcmp(BusNames,Substation));


% (this step is not necessary)
if SubstationNumber< length(BusNames) % if substation is not the end bus
    BusNames=[BusNames(1:SubstationNumber-1); BusNames(SubstationNumber+1:end); BusNames(SubstationNumber)];
end


% we don't take the regulator secondary in direct use (update this comment)
BusNamesWithRegs=[BusNames;'799r'];



%% Base voltages:
SBase=2500000; % from the substation transformer
VBase=4800/sqrt(3); % line to neutral conversion (secondary of the substation transformer)
ZBase=(VBase^2)/SBase;
YBase=1./ZBase;
LineImpedanceCodes=cellfun(@getCodesInNumbers,LineImpedanceCodes);


%% Impedances in Ohm per mile for all the line configurations
Zcfg(:,:,1)=[0.2926+0.1973i, 0.0673-0.0368i, 0.0337-0.0417i; 
                0.0673-0.0368i, 0.2646+0.1900i, 0.0673-0.0368i;
                0.0337-0.0417i,  0.0673-0.0368i, 0.2926+0.1973i]/5280;
Ycfg(:,:,1)=1j*(10^(-6))*[159.8   0   0;
    0        159.8   0;
   0        0     159.8]/5280;  % for configuration 721



Zcfg(:,:,2)= [0.4751+0.2973i, 0.1629-0.0326i, 0.1234-0.0607i; 
                    0.1629-0.0326i, 0.4488+0.2678i, 0.1629-0.0326i;
                  0.1234-0.0607i, 0.1629-0.0326i, 0.4751+0.2973i ]/5280;

Ycfg(:,:,2)=1j*(10^(-6))* [127.8306  0   0;
    0       127.8306   0;
   0 0  127.8306]/5280;  % for configuration 722

Zcfg(:,:,3)=[1.2936+0.6713i, 0.4871+0.2111i, 0.4585+0.1521i; 
    0.4871+0.2111i, 1.3022+0.6326i, 0.4871+0.2111i;
    0.4585+0.1521i, 0.4871+0.2111i, 1.2936+0.6713i]/5280;
Ycfg(:,:,3)=1j*(10^(-6))*[74.8405   0   0;
    0   74.8405   0;
    0   0    74.8405]/5280;


Zcfg(:,:,4)=[2.0952+0.7758i, 0.5204+0.2738i, 0.4926+0.2123i;
    0.5204+0.2738i, 2.1068+0.7398i, 0.5204+0.2738i;
    0.4926+0.2123i,  0.5204+0.2738i ,   2.0952+0.7758i]/5280;
Ycfg(:,:,4)=1j*(10^(-6))*[60.2483  0    0;
    0    60.2483   0;
   0  0        60.2483]/5280;


%% 3.  Organizing bus names
% collecting bus names
BusNames=unique([LineBusesFromNames;LineBusesToNames]);

%% Putting substation index at the very end:
% substation='799';
Substation='SourceBus';
SubstationNumber=find(strcmp(BusNames,Substation));


% (this step is not necessary)
if SubstationNumber< length(BusNames) % if substation is not the end bus
    BusNames=[BusNames(1:SubstationNumber-1); BusNames(SubstationNumber+1:end); BusNames(SubstationNumber)];
end



% we don't take the regulator secondary in direct use (update this comment)
BusNamesWithRegs=[BusNames;'799r'];  




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
            
            Zseries=Zcfg(:,:,LineImpedanceCodes(ii)-720);
            Yshunt=Ycfg(:,:,LineImpedanceCodes(ii)-720);
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
            
            switch RegulatorType
                case 'Wye'
                    if length(Branch.Phases{ii}==3)
                        Branch.RegulatorTypes=[Branch.RegulatorTypes;'Wye'];
                        Branch.Regs3PhiBranchNumbers=[Branch.Regs3PhiBranchNumbers;ii];
                        Branch.Wye3PhiBranchNumbers=[Branch.Wye3PhiBranchNumbers;ii];

TapA=0;
                        TapB=0;
                        TapC=0;
                        
                        
                                                Branch.Wye3PhiTaps=[Branch.Wye3PhiTaps,[TapA; TapB ;TapC ]]; % nominal taps

                        ArA=1-0.00625*TapA;
                        ArB=1-0.00625*TapB;
                        ArC=1-0.00625*TapC;
                        Av=diag([ArA; ArB; ArC]);
                        Branch.Wye3PhiAvs=[Branch.Wye3PhiAvs;Av];
                    elseif length(Branch.Phases{ii})==2
                           Branch.RegulatorTypes=[Branch.RegulatorTypes;'Wye2Phi'];
                        Branch.Regs2PhiBranchNumbers=[Branch.Regs2PhiBranchNumbers;ii];
                        Branch.Wye2PhiBranchNumbers=[Branch.Wye2PhiBranchNumbers;ii];
                        Branch.Wye2PhiTaps=[Branch.Wye2PhiTaps,[0; 0  ]];
                    else
                       Branch.RegulatorTypes=[Branch.RegulatorTypes;'Wye1Phi'];
                        Branch.Regs1PhiBranchNumbers=[Branch.Regs1PhiBranchNumbers;ii];
                        Branch.Wye1PhiBranchNumbers=[Branch.Wye1PhiBranchNumbers;ii];
                        Branch.Wye1PhiTaps=[Branch.Wye1PhiTaps,[0; 0  ]];
                    end
                case 'ClosedDelta'
                    Branch.RegulatorTypes=[Branch.RegulatorTypes;'ClosedDelta'];
                        Branch.Regs3PhiBranchNumbers=[Branch.Regs3PhiBranchNumbers;ii];
                        Branch.ClosedDeltaBranchNumbers=[Branch.ClosedDeltaBranchNumbers;ii];
                        TapAB=0;
                        TapBC=0;
                        TapCA=0;
                        
                Branch.ClosedDeltaTaps=[Branch.ClosedDeltaTaps,[TapAB; TapBC ;TapCA ]];

                        ArAB=1-0.00625*TapAB;
                        ArBC=1-0.00625*TapBC;
                        ArCA=1-0.00625*TapCA;
                        
                        Av=[ArAB 1-ArAB 0; 0 ArBC 1-ArBC; 1-ArCA 0 ArCA];
                        Branch.ClosedDeltaAvs=[Branch.ClosedDeltaAvs;Av];
                       
                case 'OpenDelta'
                     Branch.RegulatorTypes=[Branch.RegulatorTypes;'OpenDelta'];
                        Branch.Regs3PhiBranchNumbers=[Branch.Regs3PhiBranchNumbers;ii];
                        Branch.OpenDeltaBranchNumbers=[Branch.OpenDeltaBranchNumbers;ii];
                        Branch.OpenDeltaTaps=[Branch.OpenDeltaTaps,[0; 0 ]];
                         TapAB=0;
                        TapCB=0;
                        ArAB=1-0.00625*TapAB;
                        ArCB=1-0.00625*TapCB;
   
                                                Branch.OpenDeltaTaps=[Branch.OpenDeltaTaps,[TapAB; TapCB ]];

                        Av=[ArAB 1-ArAB 0; 0 1 0; 0 1-ArCB ArCB];
                       Branch.OpenDeltaAvs=[Branch.OpenDeltaAvs;Av];
                    
            end
            clear Zseries LineLength Yshunt YNMn YNMm YMNn YMNm AvailablePhases
            
            
       
            
            
        case 'D-D'
            % (modeled as GrW-GrW)
         % Transformer model
%          %*************************
                  
AvailablePhases=[1;2;3];

if strcmp(Branch.BusFromNames(ii),'SourceBus')
Zt  =0.01*[2+8i]*3;
else
      Zt=0.01*[0.09+1.81i]*((480/VBase).^2)*SBase./(500000); 
end


Yt=1./Zt;
Y2= (1/3) *[ 2*Yt, -Yt, -Yt; -Yt,2*Yt,-Yt; -Yt,-Yt,2*Yt];
Y1=diag([Yt;Yt;Yt]);


% Y2hat1=Y2+abs(Yt)*Epsilon*eye(3);
% Y2hat2=Y2+abs(Yt)*(Epsilon/2)*eye(3);


%                 YNMn=Y2hat1; 
%                 YNMm=Y2hat2;
%                  YMNn=Y2hat2;
%                 YMNm=Y2hat1;

  YNMn=Y1; 
                YNMm=Y1;
                 YMNn=Y1;
                YMNm=Y1;
                            ZNM=inv(Y1);

            
            Branch.Admittance{ii}.YNMn=YNMn;
            Branch.Admittance{ii}.YNMm=YNMm;
            Branch.Admittance{ii}.YMNn=YMNn;
            Branch.Admittance{ii}.YMNm=YMNm;
                                          Branch.Admittance{ii}.ZNM=ZNM;


            Branch.Phases{ii}=AvailablePhases;
            
            clear Zt Yt Y2 Y3 Y1 Y2hat1 Y2hat2 YNMn YNMm YMNn YMNm AvailablePhases
            
            %
        
            
        otherwise
            
            
            Zseries=Zcfg(:,:,LineImpedanceCodes(ii)-720);
            Yshunt=Ycfg(:,:,LineImpedanceCodes(ii)-720);
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


ConnectedPath = gen_path(38, Branch.CNodes.', Branch.BusFromNumbers, Branch.BusToNumbers);
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
[LoadBuses,LoadTypes,Ph1,Ph2,Ph3,Ph4,Ph5,Ph6] = importLoads([DataPath,'/Spot Loads']);
LoadBuses=cellstr(num2str(LoadBuses)); 
LoadTypes=cellstr(LoadTypes); 

UniformLoadModel='Y-PQ';
if strcmp(UniformLoadModel,'Y-PQ')
    LoadTypes(strcmp(LoadTypes,'Y-I'))={'Y-PQ'};
    LoadTypes(strcmp(LoadTypes,'Y-Z'))={'Y-PQ'};
    LoadTypes(strcmp(LoadTypes,'D-I'))={'D-PQ'}; % the conversion to wye is at a later point
    LoadTypes(strcmp(LoadTypes,'D-Z'))={'D-PQ'};
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


%% 5. No capacitor banks

Network=v2struct(Bus,Branch);

Network.RegulatorType=RegulatorType;




    
    