    for r=1:NRegs3Phi
    defineCommonVPrimeConstraintsBF;
    defineSeparationEqualityConstraintsBF;
    
        %% Define bounds
        

  
              ThetaMaxRadians=degrees2radians(120+Delta); 
ThetaMinRadians=degrees2radians(120-Delta); 


    UPrime=real(VnmPrime3Phi(:,:,r)); % resembles Um
    WPrime=imag(VnmPrime3Phi(:,:,r)); % resembles Wm
    
    U=real(Vnn3Phi(:,:,nn)); 
    W=imag(Vnn3Phi(:,:,nn));
switch RegulatorType
        
        case 'Wye'
            D=eye(3); 
F=zeros(3); 

UTildeMin=[VMIN.^2, (VMAX.^2).*cos(ThetaMaxRadians), (VMAX.^2).*cos(ThetaMaxRadians);
   (VMAX.^2).*cos(ThetaMaxRadians), VMIN.^2, (VMAX.^2).*cos(ThetaMaxRadians); 
    (VMAX.^2).*cos(ThetaMaxRadians), (VMAX.^2).*cos(ThetaMaxRadians), VMIN.^2];

UTildeMax=[VMAX.^2, (VMIN.^2).*cos(ThetaMinRadians), (VMIN.^2).*cos(ThetaMinRadians);
    (VMIN.^2).*cos(ThetaMinRadians), VMAX.^2, (VMIN.^2).*cos(ThetaMinRadians); 
    (VMIN.^2).*cos(ThetaMinRadians), (VMIN.^2).*cos(ThetaMinRadians), VMAX.^2];

WTildeMin=[0, (VMIN.^2).*sin(ThetaMaxRadians), -(VMAX.^2).*sin(ThetaMinRadians);
   -(VMAX.^2).*sin(ThetaMinRadians), 0, (VMIN.^2).*sin(ThetaMaxRadians); 
  (VMIN.^2).*sin(ThetaMaxRadians),  -(VMAX.^2).*sin(ThetaMinRadians), 0];

WTildeMax=[0, (VMAX.^2).*sin(ThetaMinRadians), -(VMIN.^2).*sin(ThetaMaxRadians);
   -(VMIN.^2).*sin(ThetaMaxRadians), 0, (VMAX.^2).*sin(ThetaMinRadians); 
   (VMAX.^2).*sin(ThetaMinRadians), -(VMIN.^2).*sin(ThetaMaxRadians), 0];

UHatMin=zeros(3);
UHatMax=zeros(3); 
WHatMin=zeros(3);
WHatMax=zeros(3); 

UHat(:,:,r)==0;
WHat(:,:,r)==0; 







            
        case 'ClosedDelta'
         D=[1 -1 0; 0 1 -1; -1 0 1];
        F=[0 1 0; 0 0 1; 1 0 0];

        



% checked
UTildeMin=[2*(VMIN.^2)*(1-cos(ThetaMinRadians)), ...
    2*(VMAX.^2).*cos(ThetaMaxRadians)-(VMIN.^2)*cos(ThetaMinRadians)-VMAX.^2,...
   2*(VMAX.^2).*cos(ThetaMaxRadians)-(VMIN.^2)*cos(ThetaMinRadians)-VMAX.^2;
  2*(VMAX.^2).*cos(ThetaMaxRadians)-(VMIN.^2)*cos(ThetaMinRadians)-VMAX.^2, ...
   2*(VMIN.^2)*(1-cos(ThetaMinRadians)),...
   2*(VMAX.^2).*cos(ThetaMaxRadians)-(VMIN.^2)*cos(ThetaMinRadians)-VMAX.^2; 
   2*(VMAX.^2).*cos(ThetaMaxRadians)-(VMIN.^2)*cos(ThetaMinRadians)-VMAX.^2, ...
  2*(VMAX.^2).*cos(ThetaMaxRadians)-(VMIN.^2)*cos(ThetaMinRadians)-VMAX.^2,...
    2*(VMIN.^2)*(1-cos(ThetaMinRadians))];

UTildeMax=[2*(VMAX.^2)*(1-cos(ThetaMaxRadians)), ...
    2*(VMIN.^2).*cos(ThetaMinRadians)-(VMAX.^2)*cos(ThetaMaxRadians)-VMIN.^2,...
     2*(VMIN.^2).*cos(ThetaMinRadians)-(VMAX.^2)*cos(ThetaMaxRadians)-VMIN.^2;
   2*(VMIN.^2).*cos(ThetaMinRadians)-(VMAX.^2)*cos(ThetaMaxRadians)-VMIN.^2, ...
   2*(VMAX.^2)*(1-cos(ThetaMaxRadians)),...
    2*(VMIN.^2).*cos(ThetaMinRadians)-(VMAX.^2)*cos(ThetaMaxRadians)-VMIN.^2; 
   2*(VMIN.^2).*cos(ThetaMinRadians)-(VMAX.^2)*cos(ThetaMaxRadians)-VMIN.^2, ...
   2*(VMIN.^2).*cos(ThetaMinRadians)-(VMAX.^2)*cos(ThetaMaxRadians)-VMIN.^2,...
   2*(VMAX.^2)*(1-cos(ThetaMaxRadians))];

% checked
WTildeMin=[0, 3*(VMIN.^2).*sin(ThetaMaxRadians),...
    -3*(VMAX.^2).*sin(ThetaMinRadians);
 -3*(VMAX.^2).*sin(ThetaMinRadians), 0,...
  3*(VMIN.^2).*sin(ThetaMaxRadians); 
  3*(VMIN.^2).*sin(ThetaMaxRadians), ...
 -3*(VMAX.^2).*sin(ThetaMinRadians), 0];

WTildeMax=[0, 3*(VMAX.^2).*sin(ThetaMinRadians),...
    -3*(VMIN.^2).*sin(ThetaMaxRadians);
  -3*(VMIN.^2).*sin(ThetaMaxRadians), 0,...
  3*(VMAX.^2).*sin(ThetaMinRadians); 
  3*(VMAX.^2).*sin(ThetaMinRadians), ...
  -3*(VMIN.^2).*sin(ThetaMaxRadians), 0];
% 
% 
% checked
UHatMin=[(VMAX.^2)*cos(ThetaMaxRadians)-VMAX.^2, ...
    (VMAX.^2).*cos(ThetaMaxRadians)-(VMIN.^2)*cos(ThetaMinRadians),...
    (VMIN.^2)-(VMIN.^2)*cos(ThetaMinRadians);
     (VMIN.^2)-(VMIN.^2)*cos(ThetaMinRadians),...
     (VMAX.^2)*cos(ThetaMaxRadians)-VMAX.^2,...
      (VMAX.^2).*cos(ThetaMaxRadians)-(VMIN.^2)*cos(ThetaMinRadians);
       (VMAX.^2).*cos(ThetaMaxRadians)-(VMIN.^2)*cos(ThetaMinRadians),...
        (VMIN.^2)-(VMIN.^2)*cos(ThetaMinRadians),...
        (VMAX.^2)*cos(ThetaMaxRadians)-VMAX.^2];
    
    
    
    % checked
    UHatMax=[(VMIN.^2)*cos(ThetaMinRadians)-VMIN.^2, ...
    (VMIN.^2).*cos(ThetaMinRadians)-(VMAX.^2)*cos(ThetaMaxRadians),...
    (VMAX^2)-(VMAX.^2)*cos(ThetaMaxRadians);
   (VMAX^2)-(VMAX.^2)*cos(ThetaMaxRadians),...
     (VMIN.^2)*cos(ThetaMinRadians)-VMIN.^2,...
       (VMIN.^2).*cos(ThetaMinRadians)-(VMAX.^2)*cos(ThetaMaxRadians);
        (VMIN.^2).*cos(ThetaMinRadians)-(VMAX.^2)*cos(ThetaMaxRadians),...
        (VMAX^2)-(VMAX.^2)*cos(ThetaMaxRadians),...
        (VMIN.^2)*cos(ThetaMinRadians)-VMIN.^2];
    
    
    % checked
    WHatMin=[(VMIN.^2)*sin(ThetaMaxRadians), ...
    -2*(VMAX.^2).*sin(ThetaMinRadians),...
    (VMIN.^2).*sin(ThetaMaxRadians);
    (VMIN.^2).*sin(ThetaMaxRadians), ...
   (VMIN.^2)*sin(ThetaMaxRadians),...
    -2*(VMAX.^2).*sin(ThetaMinRadians);
     -2*(VMAX.^2).*sin(ThetaMinRadians),...
     (VMIN.^2).*sin(ThetaMaxRadians),...
     (VMIN.^2)*sin(ThetaMaxRadians)];
    
    
    % checked
     WHatMax=[(VMAX.^2)*sin(ThetaMinRadians), ...
    -2*(VMIN.^2).*sin(ThetaMaxRadians),...
    (VMAX.^2).*sin(ThetaMinRadians);
   (VMAX.^2).*sin(ThetaMinRadians), ...
   (VMAX.^2)*sin(ThetaMinRadians),...
     -2*(VMIN.^2).*sin(ThetaMaxRadians);
      -2*(VMIN.^2).*sin(ThetaMaxRadians),...
      (VMAX.^2).*sin(ThetaMinRadians),...
     (VMAX.^2)*sin(ThetaMinRadians)];

            



% 

        case 'OpenDelta'
D=[1 -1 0;  0 1 0;  0 -1 1];
 F=[ 0 1 0; 0 0 0; 0 1 0];
 
 UTildeMin=[2*(VMIN.^2)*(1-cos(ThetaMinRadians)), ...
    (VMAX.^2).*cos(ThetaMaxRadians)-(VMAX.^2),...
   (VMAX.^2).*cos(ThetaMaxRadians)-2*(VMIN.^2)*cos(ThetaMinRadians)+VMIN.^2;
(VMAX.^2).*cos(ThetaMaxRadians)-(VMAX.^2), ...
   VMIN.^2,...
   (VMAX.^2).*cos(ThetaMaxRadians)-(VMAX.^2); 
   (VMAX.^2).*cos(ThetaMaxRadians)-2*(VMIN.^2)*cos(ThetaMinRadians)+VMIN.^2,...
 (VMAX.^2).*cos(ThetaMaxRadians)-(VMAX.^2),...
    2*(VMIN.^2)*(1-cos(ThetaMinRadians))];



 UTildeMax=[2*(VMAX.^2)*(1-cos(ThetaMaxRadians)), ...
    (VMIN.^2).*cos(ThetaMinRadians)-(VMIN.^2),...
   (VMIN.^2).*cos(ThetaMinRadians)-2*(VMAX.^2)*cos(ThetaMaxRadians)+VMAX.^2;
 (VMIN.^2).*cos(ThetaMinRadians)-(VMIN.^2), ...
   VMAX.^2,...
   (VMIN.^2).*cos(ThetaMinRadians)-(VMIN.^2); 
   (VMIN.^2).*cos(ThetaMinRadians)-2*(VMAX.^2)*cos(ThetaMaxRadians)+VMAX.^2, ...
 (VMIN.^2).*cos(ThetaMinRadians)-(VMIN.^2),...
    2*(VMAX.^2)*(1-cos(ThetaMaxRadians))];



 WTildeMin=[0, ...
    (VMIN.^2).*sin(ThetaMaxRadians),...
   -3.*(VMAX.^2).*sin(ThetaMinRadians);
 -(VMAX.^2).*sin(ThetaMinRadians), ...
   0,...
 (VMIN.^2).*sin(ThetaMaxRadians); 
   3*(VMIN.^2).*sin(ThetaMaxRadians), ...
-(VMAX.^2).*sin(ThetaMinRadians),...
    0];



 WTildeMax=[0, ...
    (VMAX.^2).*sin(ThetaMinRadians),...
   -3.*(VMIN.^2).*sin(ThetaMaxRadians);
 -(VMIN.^2).*sin(ThetaMaxRadians), ...
   0,...
 (VMAX.^2).*sin(ThetaMinRadians); 
    3.*(VMAX.^2).*sin(ThetaMinRadians), ...
 -(VMIN.^2).*sin(ThetaMaxRadians),...
    0];


 UHatMin=[(VMAX.^2)*cos(ThetaMaxRadians)-VMAX.^2, ...
    0,...
   (VMAX.^2)*cos(ThetaMaxRadians)-VMAX.^2;
VMIN.^2, ...
   0,...
   VMIN.^2; 
   (VMAX.^2)*cos(ThetaMaxRadians)-VMAX.^2,...
0,...
    (VMAX.^2)*cos(ThetaMaxRadians)-VMAX.^2];


 UHatMax=[(VMIN.^2)*cos(ThetaMinRadians)-VMIN.^2, ...
    0,...
   (VMIN.^2)*cos(ThetaMinRadians)-VMIN.^2;
VMAX.^2, ...
   0,...
   VMAX.^2 
   (VMIN.^2)*cos(ThetaMinRadians)-VMIN.^2,...
0,...
    (VMIN.^2)*cos(ThetaMinRadians)-VMIN.^2];



 WHatMin=[(VMIN.^2)*sin(ThetaMaxRadians), ...
    0,...
 (VMIN.^2)*sin(ThetaMaxRadians);
0, ...
   0,...
   0; 
   -(VMAX.^2)*sin(ThetaMinRadians),...
0,...
    -(VMAX.^2)*sin(ThetaMinRadians)];


 WHatMax=[(VMAX.^2)*sin(ThetaMinRadians), ...
    0,...
 (VMAX.^2)*sin(ThetaMinRadians);
0, ...
   0,...
   0; 
   -(VMIN.^2)*sin(ThetaMaxRadians),...
0,...
    -(VMIN.^2)*sin(ThetaMaxRadians)];

    end    
    
    
    
      

    %%
% 
    UTildePrime=D*UPrime*D.';
    UHatPrime=D*UPrime*F.';
    WTildePrime=D*WPrime*D.';
    WHatPrime=D*WPrime*F.';
    
    
    % Trilinear to Linear:
    U==UTilde(:,:,r)+UHat(:,:,r)+UHat(:,:,r).'+F*UPrime*F.';
    W==WTilde(:,:,r)+WHat(:,:,r)-WHat(:,:,r).'+F*WPrime*F.';
   
    
    WTilde(:,:,r)==-WTilde(:,:,r).';
%     
%     % UWBounds:
    UTildeMin(:)<=UTildePrime(:)<=UTildeMax(:); 
    UHatMin(:)<=UHatPrime(:)<=UHatMax(:); 
    WTildeMin(:)<=WTildePrime(:)<=WTildeMax(:); 
    WHatMin(:)<=WHatPrime(:)<=WHatMax(:); 
    
    
%     
    RMinVec=[RMIN;RMIN;RMIN];
    RMaxVec=[RMAX;RMAX;RMAX];
%     
    if strcmp(RegulatorType,'OpenDelta')
        RMinVec(2)=1;
        RMaxVec(2)=1;
    end
%     
% 
[RSquared3Phi(:,:,r), R3Phi(:,r); R3Phi(:,r).', 1]>=0;
defineRSquaredMcCormickConstraints;
defineUTildeMcCormickConstraints;
defineWTildeMcCormickConstraints;
defineUHatMcCormickConstraints;
defineWHatMcCormickConstraints;

% 

% 
% 


%  rank reinforcement

if RankConstraints

%% Voltage
A=UPrime;
B=WPrime;



AMin=[VMIN.^2, (VMAX.^2).*cos(ThetaMaxRadians), (VMAX.^2).*cos(ThetaMaxRadians);
   (VMAX.^2).*cos(ThetaMaxRadians), VMIN.^2, (VMAX.^2).*cos(ThetaMaxRadians); 
    (VMAX.^2).*cos(ThetaMaxRadians), (VMAX.^2).*cos(ThetaMaxRadians), VMIN.^2];

AMax=[VMAX.^2, (VMIN.^2).*cos(ThetaMinRadians), (VMIN.^2).*cos(ThetaMinRadians);
    (VMIN.^2).*cos(ThetaMinRadians), VMAX.^2, (VMIN.^2).*cos(ThetaMinRadians); 
    (VMIN.^2).*cos(ThetaMinRadians), (VMIN.^2).*cos(ThetaMinRadians), VMAX.^2];

BMin=[0, (VMIN.^2).*sin(ThetaMaxRadians), -(VMAX.^2).*sin(ThetaMinRadians);
   -(VMAX.^2).*sin(ThetaMinRadians), 0, (VMIN.^2).*sin(ThetaMaxRadians); 
  (VMIN.^2).*sin(ThetaMaxRadians),  -(VMAX.^2).*sin(ThetaMinRadians), 0];

BMax=[0, (VMAX.^2).*sin(ThetaMinRadians), -(VMIN.^2).*sin(ThetaMaxRadians);
   -(VMIN.^2).*sin(ThetaMaxRadians), 0, (VMAX.^2).*sin(ThetaMinRadians); 
   (VMAX.^2).*sin(ThetaMinRadians), -(VMIN.^2).*sin(ThetaMaxRadians), 0];



approxDiagonalRankBounds;


end


if GangConstraints
R3Phi(1,:)==R3Phi(2,:); 
R3Phi(1,:)==R3Phi(3,:); 

RSquared3Phi(1,1,:)==RSquared3Phi(1,2,:);
RSquared3Phi(1,1,:)==RSquared3Phi(1,3,:);
RSquared3Phi(1,1,:)==RSquared3Phi(2,2,:);
RSquared3Phi(1,1,:)==RSquared3Phi(2,3,:);
RSquared3Phi(1,1,:)==RSquared3Phi(3,3,:);

end

[RSquared3Phi(:,:,r), R3Phi(:,r); R3Phi(:,r)', 1]>=0;


end


for r=1:NRegs2Phi
    defineCommonVPrimeConstraints2PhiBF;
    defineSeparationEqualityConstraints2PhiBF;


    
ThetaMaxRadians=degrees2radians(120+Delta); 
ThetaMinRadians=degrees2radians(120-Delta); 

UTildeMax=[VMAX.^2, (VMIN.^2).*cos(ThetaMinRadians);
    (VMIN.^2).*cos(ThetaMinRadians), VMAX.^2];
    

UTildeMin=[VMIN.^2, (VMAX.^2).*cos(ThetaMaxRadians);
   (VMAX.^2).*cos(ThetaMaxRadians), VMIN.^2];
 

% 
WTildeMax=[0, (VMAX.^2).*sin(ThetaMinRadians);
   -(VMIN.^2).*sin(ThetaMaxRadians), 0];

WTildeMin=[0, (VMIN.^2).*sin(ThetaMaxRadians);
   -(VMAX.^2).*sin(ThetaMinRadians), 0];
% 
% 
% 
% 
Phases= Network.Branch.Phases{RegBranchNumber};
UPrimeTilde=real(VnmPrime2Phi(:,:,r));
WPrimeTilde=imag(VnmPrime2Phi(:,:,r));
UofVTilde=real(   VTilde);
WofVTilde=imag(   VTilde);    
if isequal(Phases,[1;3])
    U=cvx(zeros(2));
    W=cvx(zeros(2));
    UPrime=cvx(zeros(2));
    WPrime=cvx(zeros(2));
UPrime(1,1)=UPrimeTilde(2,2); 
UPrime(1,2)=UPrimeTilde(2,1); 
UPrime(2,1)=UPrimeTilde(1,2); 
UPrime(2,2)=UPrimeTilde(1,1);
WPrime(1,1)=WPrimeTilde(2,2); 
WPrime(1,2)=WPrimeTilde(2,1); 
WPrime(2,1)=WPrimeTilde(1,2); 
WPrime(2,2)=WPrimeTilde(1,1);
% 
U(1,1)=UofVTilde(2,2); 
U(1,2)=UofVTilde(2,1); 
U(2,1)=UofVTilde(1,2); 
U(2,2)=UofVTilde(1,1);
W(1,1)=WofVTilde(2,2); 
W(1,2)=WofVTilde(2,1); 
W(2,1)=WofVTilde(1,2); 
W(2,2)=WofVTilde(1,1);
% 
% % % 
% 
% 
% 
% 
% % WPrime bound constraints (mainly useful for off-diagonal)
UTildeMin(:)<=UPrime(:)<=UTildeMax(:);
WTildeMin(:)<=WPrime(:)<=WTildeMax(:);
    % Trilinear to Linear:
    U==UTilde2Phi(:,:,r);
    W==WTilde2Phi(:,:,r);
   
WTilde2Phi(:,:,r)==-WTilde2Phi(:,:,r).';

RMIN<=R2Phi(:,r)<=RMAX;




w=RSquared2Phi(1,1,r); 
x=R2Phi(1,r); 
y=R2Phi(1,r);
xMin=RMIN;
xMax=RMAX;
yMin=RMIN;
yMax=RMAX;
doMcCormick;




w=RSquared2Phi(1,2,r); 
x=R2Phi(1,r); 
y=R2Phi(2,r);
xMin=RMIN;
xMax=RMAX;
yMin=RMIN;
yMax=RMAX;
doMcCormick;


w=RSquared2Phi(2,2,r); 
x=R2Phi(2,r); 
y=R2Phi(2,r);
xMin=RMIN;
xMax=RMAX;
yMin=RMIN;
yMax=RMAX;
doMcCormick;





w=UTilde2Phi(1,1,r);
x=RSquared2Phi(1,1,r);
y=UPrime(1,1);
xMin=RMIN.^2;
xMax=RMAX.^2;
yMin=UTildeMin(1,1);
yMax=UTildeMax(1,1);
doMcCormick;

% 
w=UTilde2Phi(1,2,r);
x=RSquared2Phi(1,2,r);
y=UPrime(1,2);
xMin=RMIN.^2;
xMax=RMAX.^2;
yMin=UTildeMin(1,2);
yMax=UTildeMax(1,2);
doMcCormick;


w=UTilde2Phi(2,2,r);
x=RSquared2Phi(2,2,r);
y=UPrime(2,2);
xMin=RMIN.^2;
xMax=RMAX.^2;
yMin=UTildeMin(2,2);
yMax=UTildeMax(2,2);
doMcCormick;



w=WTilde2Phi(1,1,r);
x=RSquared2Phi(1,1,r);
y=WPrime(1,1);
xMin=RMIN.^2;
xMax=RMAX.^2;
yMin=WTildeMin(1,1);
yMax=WTildeMax(1,1);
doMcCormick;


w=WTilde2Phi(1,2,r);
x=RSquared2Phi(1,2,r);
y=WPrime(1,2);
xMin=RMIN.^2;
xMax=RMAX.^2;
yMin=WTildeMin(1,2);
yMax=WTildeMax(1,2);
doMcCormick;


w=WTilde2Phi(2,2,r);
x=RSquared2Phi(2,2,r);
y=WPrime(2,2);
xMin=RMIN.^2;
xMax=RMAX.^2;
yMin=WTildeMin(2,2);
yMax=WTildeMax(2,2);
doMcCormick;





if RankConstraints

A=UPrime;
B=WPrime;

AMin=UTildeMin;

AMax=UTildeMax;

BMin=WTildeMin;

BMax=WTildeMax;



approxDiagonalRankBounds2Phi;

end



if GangConstraints
R2Phi(1,:)==R2Phi(2,:); 

RSquared2Phi(1,1,:)==RSquared2Phi(1,2,:);
RSquared2Phi(1,1,:)==RSquared2Phi(2,2,:);
end


[RSquared2Phi(:,:,r), R2Phi(:,r); R2Phi(:,r)', 1]>=0;



end
end




for r=1:NRegs1Phi
    defineCommonVPrimeConstraints1PhiBF;
    defineSeparationEqualityConstraints1PhiBF;
    

%     
    
UTildeMax=VMAX.^2;
UTildeMin=VMIN.^2;
U=VTilde;
UPrime=VnmPrime1Phi(1,1,r);

    U==UTilde1Phi(:,r);
    UTildeMin(:)<=UPrime(:)<=UTildeMax(:);

    
        RMIN<=R1Phi(1,r)<=RMAX;
w=RSquared1Phi(1,r); 
x=R1Phi(1,r); 
y=R1Phi(1,r);
xMin=RMIN;
xMax=RMAX;
yMin=RMIN;
yMax=RMAX;
doMcCormick;

w=UTilde1Phi(1,r);
x=RSquared1Phi(1,r);
y=UPrime;
xMin=RMIN.^2;
xMax=RMAX.^2;
yMin=VMIN.^2;
yMax=VMAX.^2;
doMcCormick;


[RSquared1Phi(:,:,r), R1Phi(:,r); R1Phi(:,r)', 1]>=0;

end

