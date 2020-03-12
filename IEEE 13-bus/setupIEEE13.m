function Network=setupIEEE13(RegulatorType)
DataPath=[pwd,'/IEEE 13-bus feeder data'];
[LineBusesFromNames,LineBusesToNames,LineLengths,LineImpedanceCodes] = importLines([DataPath,'/Line Data.xls']);

LineBusesFromNames=cellfun(@(x) num2str(x),LineBusesFromNames,'UniformOutput',false);
LineBusesToNames=cellfun(@(x) num2str(x),LineBusesToNames,'UniformOutput',false);
LineLengths=cellfun(@(x) x,LineLengths,'UniformOutput',true);
LineImpedanceCodes=cellfun(@getCodesInString, LineImpedanceCodes,'UniformOutput',false);
LineDevices=cellstr(repmat('TrLine',length(LineImpedanceCodes),1)); % 0 is a regular line

%% Substation transformer configuration
LineBusesFromNames=[LineBusesFromNames;'SourceBus'];
LineBusesToNames=[LineBusesToNames; '650'];
LineImpedanceCodes=[LineImpedanceCodes;'2'];
LineLengths=[LineLengths;0]; % for transformers it doesn't matter
LineDevices=[LineDevices;'D-GW'];

%% Xfm-1 configuration
XfmIdx=find(strcmp(LineImpedanceCodes,'XFM-1'));
LineImpedanceCodes{XfmIdx}='2';
LineDevices{XfmIdx}='GW-GW';



%% Switch configuration
SwitchIdx=find(strcmp(LineImpedanceCodes,'Switch'));
LineImpedanceCodes{SwitchIdx}='601';
LineDevices{SwitchIdx}='Switch';



%% Regulator configuration
RegIdx=find(and(strcmp(LineBusesFromNames,'650'), strcmp(LineBusesToNames,'632')));
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
BusNamesWithRegs=[BusNames;'650r'];







% Base voltages:
SBase=5000000; % from the substation transformer
VBase=4160/sqrt(3); % line to neutral conversion (secondary of the substation transformer)
% VBase=115000/sqrt(3); % line to neutral conversion (secondary of the substation transformer)

ZBase=(VBase^2)/SBase;
YBase=1./ZBase;
LineImpedanceCodes=cellfun(@getCodesInNumbers,LineImpedanceCodes);


%% Impedances in Ohm per mile for all the line configurations
Zcfg(:,:,1) = [	0.3465+1.0179i	0.1560+0.5017i	0.1580+0.4236i	; ...
    0.1560+0.5017i	0.3375+1.0478i	0.1535+0.3849i	; ...
    0.1580+0.4236i	0.1535+0.3849i	0.3414+1.0348i	; ...
    ]/5280;
Ycfg(:,:,1)=1j*(10^(-6)) * [  6.2998   -1.9958   -1.2595
    -1.9958   5.9597   -0.7417
    -1.2595 -0.7417    5.6386] /5280;


Zcfg(:,:,2) = [	0.7526+1.1814i	0.1580+0.4236i	0.1560+0.5017i	; ...
    0.1580+0.4236i	0.7475+1.1983i	0.1535+0.3849i	; ...
    0.1560+0.5017i	0.1535+0.3849i	0.7436+1.2112i	; ...
    ] /5280;

Ycfg(:,:,2)=1j*(10^(-6))  * [ 5.6990   -1.0817   -1.6905
    -1.0817    5.1795   -0.6588
    -1.6905 -0.6588      5.4246]/5280;





% Configuration 603 only includes phases b, c
Zcfg(:,:,3)= [0 0 0;
    0	1.3294+1.3471i	0.2066+0.4591i	; ...
    0  0.2066+0.4591i	1.3238+1.3569i]/5280 ;
Ycfg(:,:,3)=1j*(10^(-6)) *[0 0 0; 0 4.7097 -0.8999; 0 -0.8999 4.6658]/5280;




%Configuration 604 only includes phase a, c
Zcfg(:,:,4)=[1.3238+1.3569i 0 0.2066+0.4591i;
    0  0 0;
    0.2066+0.4591i  0 1.3294+1.3471i]/5280;


Ycfg(:,:,4)=1j*(10^(-6)) *[4.6658 0 -0.8999;
    0 0 0;
    -0.8999 0  4.7097]/5280;




% Configuration 605 only includes phase c
Zcfg(:,:,5)=[0 0 0;
    0 0 0;
    0 0 1.3292+1.3475i]/5280;
Ycfg(:,:,5)=1j*(10^(-6)) *[0 0 0; 0 0 0; 0 0 4.5193]/5280;




Zcfg(:,:,6)=[0.7982+0.4463i,0.3192+0.0328i,0.2849-0.0143i;
    0.3192+0.0328i,0.7891+0.4041i,0.3192+0.0328i;
    0.2849-0.0143i,0.3192+0.0328i,0.7982+0.4463i]/5280;
Ycfg(:,:,6)=1j*(10^(-6)) *[96.8897    0   0
    0 96.8897    0
    0 0      96.8897]/5280;




%Configuration 607 only includes phase a
Zcfg(:,:,7)=[1.3425+0.5124i 0 0; 0 0 0; 0 0 0]/5280;
Ycfg(:,:,7)=1j*(10^(-6)) *[88.9912 0 0; 0 0 0; 0 0 0]/5280;





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
            
            Zseries=Zcfg(:,:,LineImpedanceCodes(ii)-600);
            Yshunt=Ycfg(:,:,LineImpedanceCodes(ii)-600);
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
                         TapAB=0;
                        TapCB=0;
                        ArAB=1-0.00625*TapAB;
                        ArCB=1-0.00625*TapCB;
                           Branch.OpenDeltaTaps=[Branch.OpenDeltaTaps,[TapAB; TapCB ]];

                        Av=[ArAB 1-ArAB 0; 0 1 0; 0 1-ArCB ArCB];
                       Branch.OpenDeltaAvs=[Branch.OpenDeltaAvs;Av];
                    
            end
            clear Zseries LineLength Yshunt YNMn YNMm YMNn YMNm AvailablePhases
            
            
        case 'Switch'
                 Zseries=Zcfg(:,:,LineImpedanceCodes(ii)-600);
            Yshunt=Ycfg(:,:,LineImpedanceCodes(ii)-600);
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
            Zt  =0.01*[1+8i]*3*(500000)/SBase;
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
            
            %
%             YNMn=Y2Hat;
%             YNMm=-Y3;
%             YMNn=-Y3.';
%             YMNm=Y1;
%             
            
%             
% 
            YNMn=Y1;
            YNMm=Y1;
            YMNn=Y1;
            YMNm=Y1;
            ZNM=inv(Y1); 
%            % *************************
 
%           
            
            Branch.Admittance{ii}.YNMn=YNMn;
            Branch.Admittance{ii}.YNMm=YNMm;
            Branch.Admittance{ii}.YMNn=YMNn;
            Branch.Admittance{ii}.YMNm=YMNm;
            Branch.Admittance{ii}.ZNM=ZNM;

            Branch.Phases{ii}=AvailablePhases;
            
            clear Zt Yt Y2 Y3 Y1 Y2hat1 Y2hat2 YNMn YNMm YMNn YMNm AvailablePhases
            
            %
        case 'GW-GW'
            
            % transformer model
            %*************************
            Zt=0.01*[1.1+2i]*500000/SBase;
            Yt=1./Zt;
            AvailablePhases=[1;2;3];
            Y1=diag([Yt;Yt;Yt]);
            
            
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
            
            
            Zseries=Zcfg(:,:,LineImpedanceCodes(ii)-600);
            Yshunt=Ycfg(:,:,LineImpedanceCodes(ii)-600);
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
% 
% ConnectedPath = gen_path(14, Branch.CNodes.', Branch.BusFromNumbers, Branch.BusToNumbers);
% Branch.ConnectedPath=[ConnectedPath,setdiff([1:NBuses],ConnectedPath)];


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
[LoadBuses,LoadTypes,Ph1,Ph2,Ph3,Ph4,Ph5,Ph6] = importLoads([DataPath,'/Spot Load Data']);

UniformLoadModel='Y-PQ';
if strcmp(UniformLoadModel,'Y-PQ')
    LoadTypes(strcmp(LoadTypes,'Y-I'))={'Y-PQ'};
    LoadTypes(strcmp(LoadTypes,'Y-Z'))={'Y-PQ'};
    LoadTypes(strcmp(LoadTypes,'D-I'))={'D-PQ'}; % the conversion to wye is at a later point
    LoadTypes(strcmp(LoadTypes,'D-Z'))={'D-PQ'};
end



for ii=1:length(LoadBuses)
    
    BusNumber=find(strcmp(BusNames,LoadBuses(ii)));
    
    PLoad=[Ph1(ii), 1*Ph3(ii), Ph5(ii)]*1000/SBase;
    QLoad=[Ph2(ii),1* Ph4(ii),Ph6(ii)]*1000/SBase;
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


 % taking care of distributed load:
    PLoad=1*[17 66 117]*1000/SBase;
    QLoad=1*[10 38 68]*1000/SBase;
     SLoad=1*(PLoad+1j*QLoad).';
Bus.SLoad{find(strcmp(BusNames,'632'))}=Bus.SLoad{find(strcmp(BusNames,'632'))}+(1/2)*SLoad;
Bus.SLoad{find(strcmp(BusNames,'671'))}=Bus.SLoad{find(strcmp(BusNames,'671'))}+(1/2)*SLoad;

% converting load to vector (needed for later)
Bus.SLoadVec=cell2mat(Bus.SLoad);







%% Shunt capacitors
[CapacitorBuses, Q1,Q2,Q3]=importCapacitors([DataPath,'/Cap Data']);

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

Network=genBranchList(Network);

















    
    