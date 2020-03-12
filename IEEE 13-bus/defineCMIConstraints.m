for r=1:NRegs3Phi
    defineCommonWPrimeConstraints;
    defineSeparationEqualityConstraint;
    
    

        % Define bounds
ThetaMaxRadians=degrees2radians(120+Delta); 
ThetaMinRadians=degrees2radians(120-Delta); 
    

 
       UPrime=real(WnnPrime3Phi(:,:,r)); % resembles Um
    VPrime=imag(WnnPrime3Phi(:,:,r)); % resembles Wm
    
    U=real(Wnn3Phi(:,:,nn)); 
    V=imag(Wnn3Phi(:,:,nn));
    
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

VTildeMin=[0, (VMIN.^2).*sin(ThetaMaxRadians), -(VMAX.^2).*sin(ThetaMinRadians);
   -(VMAX.^2).*sin(ThetaMinRadians), 0, (VMIN.^2).*sin(ThetaMaxRadians); 
  (VMIN.^2).*sin(ThetaMaxRadians),  -(VMAX.^2).*sin(ThetaMinRadians), 0];

VTildeMax=[0, (VMAX.^2).*sin(ThetaMinRadians), -(VMIN.^2).*sin(ThetaMaxRadians);
   -(VMIN.^2).*sin(ThetaMaxRadians), 0, (VMAX.^2).*sin(ThetaMinRadians); 
   (VMAX.^2).*sin(ThetaMinRadians), -(VMIN.^2).*sin(ThetaMaxRadians), 0];

UHatMin=zeros(3);
UHatMax=zeros(3); 
VHatMin=zeros(3);
VHatMax=zeros(3); 

UHat(:,:,r)==0;
VHat(:,:,r)==0;


            
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
VTildeMin=[0, 3*(VMIN.^2).*sin(ThetaMaxRadians),...
    -3*(VMAX.^2).*sin(ThetaMinRadians);
 -3*(VMAX.^2).*sin(ThetaMinRadians), 0,...
  3*(VMIN.^2).*sin(ThetaMaxRadians); 
  3*(VMIN.^2).*sin(ThetaMaxRadians), ...
 -3*(VMAX.^2).*sin(ThetaMinRadians), 0];

VTildeMax=[0, 3*(VMAX.^2).*sin(ThetaMinRadians),...
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
    VHatMin=[(VMIN.^2)*sin(ThetaMaxRadians), ...
    -2*(VMAX.^2).*sin(ThetaMinRadians),...
    (VMIN.^2).*sin(ThetaMaxRadians);
    (VMIN.^2).*sin(ThetaMaxRadians), ...
   (VMIN.^2)*sin(ThetaMaxRadians),...
    -2*(VMAX.^2).*sin(ThetaMinRadians);
     -2*(VMAX.^2).*sin(ThetaMinRadians),...
     (VMIN.^2).*sin(ThetaMaxRadians),...
     (VMIN.^2)*sin(ThetaMaxRadians)];
    
    
%    checked
     VHatMax=[(VMAX.^2)*sin(ThetaMinRadians), ...
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



 VTildeMin=[0, ...
    (VMIN.^2).*sin(ThetaMaxRadians),...
   -3.*(VMAX.^2).*sin(ThetaMinRadians);
 -(VMAX.^2).*sin(ThetaMinRadians), ...
   0,...
 (VMIN.^2).*sin(ThetaMaxRadians); 
   3*(VMIN.^2).*sin(ThetaMaxRadians), ...
-(VMAX.^2).*sin(ThetaMinRadians),...
    0];



 VTildeMax=[0, ...
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



 VHatMin=[(VMIN.^2)*sin(ThetaMaxRadians), ...
    0,...
 (VMIN.^2)*sin(ThetaMaxRadians);
0, ...
   0,...
   0; 
   -(VMAX.^2)*sin(ThetaMinRadians),...
0,...
    -(VMAX.^2)*sin(ThetaMinRadians)];


 VHatMax=[(VMAX.^2)*sin(ThetaMinRadians), ...
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
    VTildePrime=D*VPrime*D.';
    VHatPrime=D*VPrime*F.';
    
    VTilde(:,:,r)==-VTilde(:,:,r).';
    
    
%     Trilinear to Linear:
    U==UTilde(:,:,r)+UHat(:,:,r)+UHat(:,:,r).'+F*UPrime*F.';
    V==VTilde(:,:,r)+VHat(:,:,r)-VHat(:,:,r).'+F*VPrime*F.';
   
    

%     UWBounds:
    UTildeMin(:)<=UTildePrime(:)<=UTildeMax(:); 
    UHatMin(:)<=UHatPrime(:)<=UHatMax(:); 
    VTildeMin(:)<=VTildePrime(:)<=VTildeMax(:); 
    VHatMin(:)<=VHatPrime(:)<=VHatMax(:); 
    
    
    
    RMinVec=[RMIN;RMIN;RMIN];
    RMaxVec=[RMAX;RMAX;RMAX];
    
    if strcmp(RegulatorType,'OpenDelta')
        RMinVec(2)=1;
        RMaxVec(2)=1;
    end
    

RMinVec<=R3Phi(:,r)<=RMaxVec;







    

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
w=VTilde(1,1,r);
x=RSquared3Phi(1,1,r);
y=VTildePrime(1,1);
xMin=RMinVec(1).^2;
xMax=RMaxVec(1).^2;
yMin=VTildeMin(1,1);
yMax=VTildeMax(1,1);
doMcCormick;
% 


w=VTilde(1,2,r);
x=RSquared3Phi(1,2,r);
y=VTildePrime(1,2);
xMin=RMinVec(1).*RMinVec(2);
xMax=RMaxVec(1).*RMaxVec(2);
yMin=VTildeMin(1,2);
yMax=VTildeMax(1,2);
doMcCormick;
% 
% % 
% % % 
w=VTilde(1,3,r);
x=RSquared3Phi(1,3,r);
y=VTildePrime(1,3);
xMin=RMinVec(1).*RMinVec(3);
xMax=RMaxVec(1).*RMaxVec(3);
yMin=VTildeMin(1,3);
yMax=VTildeMax(1,3);
doMcCormick;




% % 
w=VTilde(2,2,r);
x=RSquared3Phi(2,2,r);
y=VTildePrime(2,2);
xMin=RMinVec(2).*RMinVec(2);
xMax=RMaxVec(2).*RMaxVec(2);
yMin=VTildeMin(2,2);
yMax=VTildeMax(2,2);
doMcCormick;
% 
% 

w=VTilde(2,3,r);
x=RSquared3Phi(2,3,r);
y=VTildePrime(2,3);
xMin=RMinVec(2).*RMinVec(3);
xMax=RMaxVec(2).*RMaxVec(3);
yMin=VTildeMin(2,3);
yMax=VTildeMax(2,3);
doMcCormick;
% 
% 
w=VTilde(3,3,r);
x=RSquared3Phi(3,3,r);
y=VTildePrime(3,3);
xMin=RMinVec(3).*RMinVec(3);
xMax=RMaxVec(3).*RMaxVec(3);
yMin=VTildeMin(3,3);
yMax=VTildeMax(3,3);
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
w=VHat(1,1,r);
x=R3Phi(1,r);
y=VHatPrime(1,1);
xMin=RMinVec(1);
xMax=RMaxVec(1);
yMin=VHatMin(1,1);
yMax=VHatMax(1,1);
doMcCormick;


% 
% 

w=VHat(1,2,r);
x=R3Phi(1,r);
y=VHatPrime(1,2);
xMin=RMinVec(1);
xMax=RMaxVec(1);
yMin=VHatMin(1,2);
yMax=VHatMax(1,2);
doMcCormick;
% % 
% % 
% % 
w=VHat(1,3,r);
x=R3Phi(1,r);
y=VHatPrime(1,3);
xMin=RMinVec(1);
xMax=RMaxVec(1);
yMin=VHatMin(1,3);
yMax=VHatMax(1,3);
doMcCormick;


% 

w=VHat(2,1,r);
x=R3Phi(2,r);
y=VHatPrime(2,1);
xMin=RMinVec(2);
xMax=RMaxVec(2);
yMin=VHatMin(2,1);
yMax=VHatMax(2,1);
doMcCormick;

% 




w=VHat(2,2,r);
x=R3Phi(2,r);
y=VHatPrime(2,2);
xMin=RMinVec(2);
xMax=RMaxVec(2);
yMin=VHatMin(2,2);
yMax=VHatMax(2,2);
doMcCormick;

% 
% % 


w=VHat(2,3,r);
x=R3Phi(2,r);
y=VHatPrime(2,3);
xMin=RMinVec(2);
xMax=RMaxVec(2);
yMin=VHatMin(2,3);
yMax=VHatMax(2,3);
doMcCormick;

% 
w=VHat(3,1,r);
x=R3Phi(3,r);
y=VHatPrime(3,1);
xMin=RMinVec(3);
xMax=RMaxVec(3);
yMin=VHatMin(3,1);
yMax=VHatMax(3,1);
doMcCormick;


w=VHat(3,2,r);
x=R3Phi(3,r);
y=VHatPrime(3,2);
xMin=RMinVec(3);
xMax=RMaxVec(3);
yMin=VHatMin(3,2);
yMax=VHatMax(3,2);
doMcCormick;








w=VHat(3,3,r);
x=R3Phi(3,r);
y=VHatPrime(3,3);
xMin=RMinVec(3);
xMax=RMaxVec(3);
yMin=VHatMin(3,3);
yMax=VHatMax(3,3);
doMcCormick;




 %rank reinforcement

if RankConstraints
A=UPrime;
B=VPrime;


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
