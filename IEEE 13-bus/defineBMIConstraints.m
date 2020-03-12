for r=1:NRegs3Phi
    defineCommonVPrimeConstraintsBF;
    defineSeparationEqualityConstraintsBF;
    
    

        % Define bounds
    
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










% % checked
UHatMin=[(VMAX.^2)*cos(ThetaMaxRadians)-VMAX.^2, ...
    (VMAX.^2).*cos(ThetaMaxRadians)-(VMIN.^2)*cos(ThetaMinRadians),...
    (VMIN.^2)-(VMIN.^2)*cos(ThetaMinRadians);
     (VMIN.^2)-(VMIN.^2)*cos(ThetaMinRadians),...
     (VMAX.^2)*cos(ThetaMaxRadians)-VMAX.^2,...
      (VMAX.^2).*cos(ThetaMaxRadians)-(VMIN.^2)*cos(ThetaMinRadians);
       (VMAX.^2).*cos(ThetaMaxRadians)-(VMIN.^2)*cos(ThetaMinRadians),...
        (VMIN.^2)-(VMIN.^2)*cos(ThetaMinRadians),...
        (VMAX.^2)*cos(ThetaMaxRadians)-VMAX.^2];
    
    
    
%     checked
    UHatMax=[(VMIN.^2)*cos(ThetaMinRadians)-VMIN.^2, ...
    (VMIN.^2).*cos(ThetaMinRadians)-(VMAX.^2)*cos(ThetaMaxRadians),...
    (VMAX^2)-(VMAX.^2)*cos(ThetaMaxRadians);
   (VMAX^2)-(VMAX.^2)*cos(ThetaMaxRadians),...
     (VMIN.^2)*cos(ThetaMinRadians)-VMIN.^2,...
       (VMIN.^2).*cos(ThetaMinRadians)-(VMAX.^2)*cos(ThetaMaxRadians);
        (VMIN.^2).*cos(ThetaMinRadians)-(VMAX.^2)*cos(ThetaMaxRadians),...
        (VMAX^2)-(VMAX.^2)*cos(ThetaMaxRadians),...
        (VMIN.^2)*cos(ThetaMinRadians)-VMIN.^2];
    
    
%     checked
    WHatMin=[(VMIN.^2)*sin(ThetaMaxRadians), ...
    -2*(VMAX.^2).*sin(ThetaMinRadians),...
    (VMIN.^2).*sin(ThetaMaxRadians);
    (VMIN.^2).*sin(ThetaMaxRadians), ...
   (VMIN.^2)*sin(ThetaMaxRadians),...
    -2*(VMAX.^2).*sin(ThetaMinRadians);
     -2*(VMAX.^2).*sin(ThetaMinRadians),...
     (VMIN.^2).*sin(ThetaMaxRadians),...
     (VMIN.^2)*sin(ThetaMaxRadians)];
    
    
%    checked
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
% 
%     %
% 
    UTildePrime=D*UPrime*D.';
    UHatPrime=D*UPrime*F.';
    WTildePrime=D*WPrime*D.';
    WHatPrime=D*WPrime*F.';
    
    WTilde(:,:,r)==-WTilde(:,:,r).';
    
    
%     Trilinear to Linear:
    U==UTilde(:,:,r)+UHat(:,:,r)+UHat(:,:,r).'+F*UPrime*F.';
    W==WTilde(:,:,r)+WHat(:,:,r)-WHat(:,:,r).'+F*WPrime*F.';
   
    

%     UWBounds:
    UTildeMin(:)<=UTildePrime(:)<=UTildeMax(:); 
    UHatMin(:)<=UHatPrime(:)<=UHatMax(:); 
    WTildeMin(:)<=WTildePrime(:)<=WTildeMax(:); 
    WHatMin(:)<=WHatPrime(:)<=WHatMax(:); 
    
    
    
    RMinVec=[RMIN;RMIN;RMIN];
    RMaxVec=[RMAX;RMAX;RMAX];
    
    if strcmp(RegulatorType,'OpenDelta')
        RMinVec(2)=1;
        RMaxVec(2)=1;
        RSquared3Phi(1,2,r)==R3Phi(1,r);
        RSquared3Phi(2,3,r)==R3Phi(3,r);
        RSquared3Phi(2,2,r)==1;
    end
    

RMinVec<=R3Phi(:,r)<=RMaxVec;
RMIN.^2<=vec(RSquared3Phi(:,:,r))<=RMAX.^2;







    

% % 
w=RSquared3Phi(1,1,r); 
x=R3Phi(1,r); 
y=R3Phi(1,r);
xMin=RMinVec(1);
xMax=RMaxVec(1);
yMin=RMinVec(1);
yMax=RMaxVec(1);
doMcCormick;
% 
% 
w=RSquared3Phi(1,2,r); 
x=R3Phi(1,r); 
y=R3Phi(2,r);
xMin=RMinVec(1);
xMax=RMaxVec(1);
yMin=RMinVec(2);
yMax=RMaxVec(2);
doMcCormick;
% 
% 
w=RSquared3Phi(1,3,r); 
x=R3Phi(1,r); 
y=R3Phi(3,r);
xMin=RMinVec(1);
xMax=RMaxVec(1);
yMin=RMinVec(3);
yMax=RMaxVec(3);
doMcCormick;
% 
w=RSquared3Phi(2,2,r); 
x=R3Phi(2,r); 
y=R3Phi(2,r);
xMin=RMinVec(2);
xMax=RMaxVec(2);
yMin=RMinVec(2);
yMax=RMaxVec(2);
doMcCormick;
% 
% 
w=RSquared3Phi(2,3,r); 
x=R3Phi(2,r); 
y=R3Phi(3,r);
xMin=RMinVec(2);
xMax=RMaxVec(2);
yMin=RMinVec(3);
yMax=RMaxVec(3);
doMcCormick;
% 
% 
w=RSquared3Phi(3,3,r); 
x=R3Phi(3,r); 
y=R3Phi(3,r);
xMin=RMinVec(3);
xMax=RMaxVec(3);
yMin=RMinVec(3);
yMax=RMaxVec(3);
doMcCormick;


%% Rank 1 approximate for RSquared3Phi
% [RSquared3Phi, R3Phi; R3Phi.', 1]>=0;

% R11R22(1,r)-R12R21(1,r)==0;
% R11R33(1,r)-R13R31(1,r)==0;
% R22R33(1,r)-R23R32(1,r)==0;
% R12R23(1,r)-R13R22(1,r)==0;
% R11R23(1,r)-R13R21(1,r)==0;
% R12R33(1,r)-R13R32(1,r)==0;
% 
% w=R11R22(1,r);
% x=RSquared3Phi(1,1,r);
% y=RSquared3Phi(2,2,r);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=RMIN.^2;
% yMax=RMAX.^2;
% doMcCormick;
% 
% 
% w=R11R33(1,r);
% x=RSquared3Phi(1,1,r);
% y=RSquared3Phi(3,3,r);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=RMIN.^2;
% yMax=RMAX.^2;
% doMcCormick;
% 
% 
% w=R12R21(1,r);
% x=RSquared3Phi(1,2,r);
% y=RSquared3Phi(2,1,r);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=RMIN.^2;
% yMax=RMAX.^2;
% doMcCormick;
% 
% 
% w=R13R31(1,r);
% x=RSquared3Phi(1,3,r);
% y=RSquared3Phi(3,1,r);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=RMIN.^2;
% yMax=RMAX.^2;
% doMcCormick;
% 
% 
% 
% w=R22R33(1,r);
% x=RSquared3Phi(2,2,r);
% y=RSquared3Phi(3,3,r);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=RMIN.^2;
% yMax=RMAX.^2
% doMcCormick;
% 
% 
% w=R23R32(1,r);
% x=RSquared3Phi(2,3,r);
% y=RSquared3Phi(3,2,r);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=RMIN.^2;
% yMax=RMAX.^2;
% doMcCormick;
% 
% 
% w=R12R23(1,r);
% x=RSquared3Phi(1,2,r);
% y=RSquared3Phi(2,3,r);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=RMIN.^2;
% yMax=RMAX.^2;
% doMcCormick;
% 
% 
% w=R13R22(1,r);
% x=RSquared3Phi(1,3,r);
% y=RSquared3Phi(2,2,r);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=RMIN.^2;
% yMax=RMAX.^2;
% doMcCormick;
% 
% 
% w=R11R23(1,r);
% x=RSquared3Phi(1,1,r);
% y=RSquared3Phi(2,3,r);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=RMIN.^2;
% yMax=RMAX.^2
% doMcCormick;
% 
% 
% w=R13R21(1,r);
% x=RSquared3Phi(1,3,r);
% y=RSquared3Phi(2,1,r);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=RMIN.^2;
% yMax=RMAX.^2
% doMcCormick;
% 
% 
% w=R12R33(1,r);
% x=RSquared3Phi(1,2,r);
% y=RSquared3Phi(3,3,r);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=RMIN.^2;
% yMax=RMAX.^2
% doMcCormick;
% 
% 
% w=R13R32(1,r);
% x=RSquared3Phi(1,3,r);
% y=RSquared3Phi(3,2,r);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=RMIN.^2;
% yMax=RMAX.^2
% doMcCormick;
% 

% % 
% % 
% % 
% % 
% %% UTilde McCormick
w=UTilde(1,1,r);
x=RSquared3Phi(1,1,r);
y=UTildePrime(1,1);
xMin=RMinVec(1).^2;
xMax=RMaxVec(1).^2;
yMin=UTildeMin(1,1);
yMax=UTildeMax(1,1);
doMcCormick;
% 
% % 
w=UTilde(1,2,r);
x=RSquared3Phi(1,2,r);
y=UTildePrime(1,2);
xMin=RMinVec(1).*RMinVec(2);
xMax=RMaxVec(1).*RMaxVec(2);
yMin=UTildeMin(1,2);
yMax=UTildeMax(1,2);
doMcCormick;
% % 
% % 
% % % 
w=UTilde(1,3,r);
x=RSquared3Phi(1,3,r);
y=UTildePrime(1,3);
xMin=RMinVec(1).*RMinVec(3);
xMax=RMaxVec(1).*RMaxVec(3);
yMin=UTildeMin(1,3);
yMax=UTildeMax(1,3);
doMcCormick;
% 
% 
w=UTilde(2,2,r);
x=RSquared3Phi(2,2,r);
y=UTildePrime(2,2);
xMin=RMinVec(2).*RMinVec(2);
xMax=RMaxVec(2).*RMaxVec(2);
yMin=UTildeMin(2,2);
yMax=UTildeMax(2,2);
doMcCormick;

% % 
% % 
w=UTilde(2,3,r);
x=RSquared3Phi(2,3,r);
y=UTildePrime(2,3);
xMin=RMinVec(2).*RMinVec(3);
xMax=RMaxVec(2).*RMaxVec(3);
yMin=UTildeMin(2,3);
yMax=UTildeMax(2,3);
doMcCormick;
% % % % % 
% 
% 
w=UTilde(3,3,r);
x=RSquared3Phi(3,3,r);
y=UTildePrime(3,3);
xMin=RMinVec(3).*RMinVec(3);
xMax=RMaxVec(3).*RMaxVec(3);
yMin=UTildeMin(3,3);
yMax=UTildeMax(3,3);
doMcCormick;
% 
% % % 
% %% WTilde McCormick
% % 
% % 
w=WTilde(1,1,r);
x=RSquared3Phi(1,1,r);
y=WTildePrime(1,1);
xMin=RMinVec(1).^2;
xMax=RMaxVec(1).^2;
yMin=WTildeMin(1,1);
yMax=WTildeMax(1,1);
doMcCormick;
% 

w=WTilde(1,2,r);
x=RSquared3Phi(1,2,r);
y=WTildePrime(1,2);
xMin=RMinVec(1).*RMinVec(2);
xMax=RMaxVec(1).*RMaxVec(2);
yMin=WTildeMin(1,2);
yMax=WTildeMax(1,2);
doMcCormick;
% 
% % 
% % % 
w=WTilde(1,3,r);
x=RSquared3Phi(1,3,r);
y=WTildePrime(1,3);
xMin=RMinVec(1).*RMinVec(3);
xMax=RMaxVec(1).*RMaxVec(3);
yMin=WTildeMin(1,3);
yMax=WTildeMax(1,3);
doMcCormick;

% % 
w=WTilde(2,2,r);
x=RSquared3Phi(2,2,r);
y=WTildePrime(2,2);
xMin=RMinVec(2).*RMinVec(2);
xMax=RMaxVec(2).*RMaxVec(2);
yMin=WTildeMin(2,2);
yMax=WTildeMax(2,2);
doMcCormick;
% 
% 
% % 
w=WTilde(2,3,r);
x=RSquared3Phi(2,3,r);
y=WTildePrime(2,3);
xMin=RMinVec(2).*RMinVec(3);
xMax=RMaxVec(2).*RMaxVec(3);
yMin=WTildeMin(2,3);
yMax=WTildeMax(2,3);
doMcCormick;

% 
% 
w=WTilde(3,3,r);
x=RSquared3Phi(3,3,r);
y=WTildePrime(3,3);
xMin=RMinVec(3).*RMinVec(3);
xMax=RMaxVec(3).*RMaxVec(3);
yMin=WTildeMin(3,3);
yMax=WTildeMax(3,3);
doMcCormick;
% 
% 
% % UHat McCormick
w=UHat(1,1,r);
x=R3Phi(1,r);
y=UHatPrime(1,1);
xMin=RMinVec(1);
xMax=RMaxVec(1);
yMin=UHatMin(1,1);
yMax=UHatMax(1,1);
doMcCormick;


% % % 
w=UHat(1,2,r);
x=R3Phi(1,r);
y=UHatPrime(1,2);
xMin=RMinVec(1);
xMax=RMaxVec(1);
yMin=UHatMin(1,2);
yMax=UHatMax(1,2);
doMcCormick;


% 
w=UHat(1,3,r);
x=R3Phi(1,r);
y=UHatPrime(1,3);
xMin=RMinVec(1);
xMax=RMaxVec(1);
yMin=UHatMin(1,3);
yMax=UHatMax(1,3);
doMcCormick;




w=UHat(2,1,r);
x=R3Phi(2,r);
y=UHatPrime(2,1);
xMin=RMinVec(2);
xMax=RMaxVec(2);
yMin=UHatMin(2,1);
yMax=UHatMax(2,1);
doMcCormick;


w=UHat(2,2,r);
x=R3Phi(2,r);
y=UHatPrime(2,2);
xMin=RMinVec(2);
xMax=RMaxVec(2);
yMin=UHatMin(2,2);
yMax=UHatMax(2,2);
doMcCormick;
% 

% % 
w=UHat(2,3,r);
x=R3Phi(2,r);
y=UHatPrime(2,3);
xMin=RMinVec(2);
xMax=RMaxVec(2);
yMin=UHatMin(2,3);
yMax=UHatMax(2,3);
doMcCormick;


w=UHat(3,1,r);
x=R3Phi(3,r);
y=UHatPrime(3,1);
xMin=RMinVec(3);
xMax=RMaxVec(3);
yMin=UHatMin(3,1);
yMax=UHatMax(3,1);
doMcCormick;
% % 
% 
w=UHat(3,2,r);
x=R3Phi(3,r);
y=UHatPrime(3,2);
xMin=RMinVec(3);
xMax=RMaxVec(3);
yMin=UHatMin(3,2);
yMax=UHatMax(3,2);
doMcCormick;



w=UHat(3,3,r);
x=R3Phi(3,r);
y=UHatPrime(3,3);
xMin=RMinVec(3);
xMax=RMaxVec(3);
yMin=UHatMin(3,3);
yMax=UHatMax(3,3);
doMcCormick;
% 


%% WHat McCormick
% % 
w=WHat(1,1,r);
x=R3Phi(1,r);
y=WHatPrime(1,1);
xMin=RMinVec(1);
xMax=RMaxVec(1);
yMin=WHatMin(1,1);
yMax=WHatMax(1,1);
doMcCormick;


% 
% 
% 
w=WHat(1,2,r);
x=R3Phi(1,r);
y=WHatPrime(1,2);
xMin=RMinVec(1);
xMax=RMaxVec(1);
yMin=WHatMin(1,2);
yMax=WHatMax(1,2);
doMcCormick;
% % 
% % 
% % 
w=WHat(1,3,r);
x=R3Phi(1,r);
y=WHatPrime(1,3);
xMin=RMinVec(1);
xMax=RMaxVec(1);
yMin=WHatMin(1,3);
yMax=WHatMax(1,3);
doMcCormick;


% 

w=WHat(2,1,r);
x=R3Phi(2,r);
y=WHatPrime(2,1);
xMin=RMinVec(2);
xMax=RMaxVec(2);
yMin=WHatMin(2,1);
yMax=WHatMax(2,1);
doMcCormick;


w=WHat(2,2,r);
x=R3Phi(2,r);
y=WHatPrime(2,2);
xMin=RMinVec(2);
xMax=RMaxVec(2);
yMin=WHatMin(2,2);
yMax=WHatMax(2,2);
doMcCormick;

% 
% % 
w=WHat(2,3,r);
x=R3Phi(2,r);
y=WHatPrime(2,3);
xMin=RMinVec(2);
xMax=RMaxVec(2);
yMin=WHatMin(2,3);
yMax=WHatMax(2,3);
doMcCormick;

% 
w=WHat(3,1,r);
x=R3Phi(3,r);
y=WHatPrime(3,1);
xMin=RMinVec(3);
xMax=RMaxVec(3);
yMin=WHatMin(3,1);
yMax=WHatMax(3,1);
doMcCormick;


w=WHat(3,2,r);
x=R3Phi(3,r);
y=WHatPrime(3,2);
xMin=RMinVec(3);
xMax=RMaxVec(3);
yMin=WHatMin(3,2);
yMax=WHatMax(3,2);
doMcCormick;



w=WHat(3,3,r);
x=R3Phi(3,r);
y=WHatPrime(3,3);
xMin=RMinVec(3);
xMax=RMaxVec(3);
yMin=WHatMin(3,3);
yMax=WHatMax(3,3);
doMcCormick;




 %rank reinforcement

if RankConstraints
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

% 
% 
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







end
