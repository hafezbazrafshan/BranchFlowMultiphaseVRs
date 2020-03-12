for r=1:NRegs3Phi
    defineCommonVPrimeConstraintsBF;
    defineSeparationEqualityConstraintsBF;
    
        %% Define bounds


    
              ThetaMaxRadians=degrees2radians(120+Delta); 
ThetaMinRadians=degrees2radians(120-Delta); 
    
       U=real(VnmPrime3Phi(:,:,r)); % resembles Um
    W=imag(VnmPrime3Phi(:,:,r)); % resembles Wm
    
    UPrime=real(Vnn3Phi(:,:,nn)); 
    WPrime=imag(Vnn3Phi(:,:,nn));

    switch RegulatorType
        
        case 'Wye'
            D=eye(3); 
F=zeros(3); 
% 
%   if r==1
%           ThetaMaxRadians=degrees2radians(125); 
% ThetaMinRadians=degrees2radians(115);    
%   end


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

        
        
%           if r==1
%           ThetaMaxRadians=degrees2radians(121); 
% ThetaMinRadians=degrees2radians(119);    
%   end
       

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
% 
% % checked
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

            




        case 'OpenDelta'
D=[1 -1 0;  0 1 0;  0 -1 1];
 F=[ 0 1 0; 0 0 0; 0 1 0];


  if r==1
          ThetaMaxRadians=degrees2radians(121); 
ThetaMinRadians=degrees2radians(119);    
  end
       


 
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
    
     
    

    %

    UTildePrime=D*UPrime*D';
    UHatPrime=D*UPrime*F';
    WTildePrime=D*WPrime*D';
    WHatPrime=D*WPrime*F';
    
    
    % Trilinear to Linear:
    U==UTilde(:,:,r)+UHat(:,:,r)+UHat(:,:,r).'+F*UPrime*F.';
    W==WTilde(:,:,r)+WHat(:,:,r)-WHat(:,:,r).'+F*WPrime*F.';
   
    WTilde(:,:,r)==-WTilde(:,:,r).';
    

    
    % UWBounds:
    UTildeMin(:)<=UTildePrime(:)<=UTildeMax(:); 
    UHatMin(:)<=UHatPrime(:)<=UHatMax(:); 
    WTildeMin(:)<=WTildePrime(:)<=WTildeMax(:); 
    WHatMin(:)<=WHatPrime(:)<=WHatMax(:); 
    
    
    RMinVec=[RMIN;RMIN;RMIN];
    RMaxVec=[RMAX;RMAX;RMAX];
    
    if strcmp(RegulatorType,'OpenDelta')
        RMinVec(2)=1;
        RMaxVec(2)=1;
    end
    

RMinVec<=R3Phi(:,r)<=RMaxVec;



    
% 
% 
w=RSquared3Phi(1,1,r); 
x=R3Phi(1,r); 
y=R3Phi(1,r);
xMin=RMinVec(1);
xMax=RMaxVec(1);
yMin=RMinVec(1);
yMax=RMaxVec(1);
doMcCormick;

if GangConstraints~=1
w=RSquared3Phi(1,2,r); 
x=R3Phi(1,r); 
y=R3Phi(2,r);
xMin=RMinVec(1);
xMax=RMaxVec(1);
yMin=RMinVec(2);
yMax=RMaxVec(2);
doMcCormick;


w=RSquared3Phi(1,3,r); 
x=R3Phi(1,r); 
y=R3Phi(3,r);
xMin=RMinVec(1);
xMax=RMaxVec(1);
yMin=RMinVec(3);
yMax=RMaxVec(3);
doMcCormick;

w=RSquared3Phi(2,2,r); 
x=R3Phi(2,r); 
y=R3Phi(2,r);
xMin=RMinVec(2);
xMax=RMaxVec(2);
yMin=RMinVec(2);
yMax=RMaxVec(2);
doMcCormick;


w=RSquared3Phi(2,3,r); 
x=R3Phi(2,r); 
y=R3Phi(3,r);
xMin=RMinVec(2);
xMax=RMaxVec(2);
yMin=RMinVec(3);
yMax=RMaxVec(3);
doMcCormick;


w=RSquared3Phi(3,3,r); 
x=R3Phi(3,r); 
y=R3Phi(3,r);
xMin=RMinVec(3);
xMax=RMaxVec(3);
yMin=RMinVec(3);
yMax=RMaxVec(3);
doMcCormick;
end



defineUTildeMcCormickConstraints;
defineWTildeMcCormickConstraints;

if ~strcmp(RegulatorType,'Wye')
defineUHatMcCormickConstraints;
defineWHatMcCormickConstraints;
 end
% 

% 
% % 
% 
if RankConstraints
A=U;
B=W;
% % 
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

AMin(:)<=U(:)<=AMax(:);
BMin(:)<=W(:)<=BMax(:);

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

[RSquared3Phi(:,:,r), R3Phi(:,r); R3Phi(:,r).', 1]>=0;

end