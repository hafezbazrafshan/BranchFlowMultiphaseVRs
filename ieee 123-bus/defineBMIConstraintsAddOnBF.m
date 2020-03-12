for r=1:NRegs3Phi
    defineCommonVPrimeConstraintsBF;
    [Vnn3Phi(:,:,nn),vnm3Phi(:,r); vnm3Phi(:,r)', 1]>=0; 
[VnmPrime3Phi(:,:,r), vnmPrime3Phi(:,r); vnmPrime3Phi(:,r)', 1]>=0;
    defineSeparationEqualityConstraintsBF;
    
        %% Define bounds
        

  
              ThetaMaxRadians=degrees2radians(120+Delta); 
ThetaMinRadians=degrees2radians(120-Delta); 


   
switch RegulatorType
        
        case 'Wye'
            D=eye(3); 
F=zeros(3); 


% vrMin=[VMIN; VMAX*cos(degrees2radians(-125)); VMAX*cos(degrees2radians(125))];
% vrMax=[VMAX; VMIN*cos(degrees2radians(-115)); VMIN*cos(degrees2radians(115))];


vrMin=[-VMAX; -VMAX;-VMAX];
vrMax=[VMAX;VMAX;VMAX];
viMin=vrMin;
viMax=vrMax;
% viMin=[0; VMAX*sin(degrees2radians(-115)); VMIN*sin(degrees2radians(125))];
% viMax=[0; VMIN*sin(degrees2radians(-125)); VMAX*sin(degrees2radians(115))];






            
        case 'ClosedDelta'
         D=[1 -1 0; 0 1 -1; -1 0 1];
        F=[0 1 0; 0 0 1; 1 0 0];

        




% 

        case 'OpenDelta'
D=[1 -1 0;  0 1 0;  0 -1 1];
 F=[ 0 1 0; 0 0 0; 0 1 0];


    end    
    
    
    
      

    %%
% 
    
%     
    RMinVec=[RMIN;RMIN;RMIN];
    RMaxVec=[RMAX;RMAX;RMAX];
%     
%     
% 
x=real(vnmPrime3Phi(:,r)); 
y=R3Phi(:,r);
w=real(vnm3Phi(:,r));
xMin=vrMin;
xMax=vrMax;
yMin=RMinVec;
yMax=RMaxVec;
wMin=viMin;
wMax=viMax;
doMcCormick;
wMin<=w<=wMax;


x=imag(vnmPrime3Phi(:,r)); 
y=R3Phi(:,r);
w=imag(vnm3Phi(:,r));
xMin=viMin;
xMax=viMax;
yMin=RMinVec;
yMax=RMaxVec;
wMin=viMin;
wMax=viMax;
doMcCormick;
wMin<=w<=wMax;

if RankConstraints

%% Voltage
A=real(VnmPrime3Phi(:,:,r));
B=imag(VnmPrime3Phi(:,:,r));



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

end



end


for r=1:NRegs2Phi
    defineCommonVPrimeConstraints2PhiBF;
    defineSeparationEqualityConstraints2PhiBF;

    
    [VTilde,vnm2Phi(:,r); vnm2Phi(:,r)', 1]>=0; 
[VnmPrime2Phi(:,:,r), vnmPrime2Phi(:,r); vnmPrime2Phi(:,r)', 1]>=0;
    
    
    
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
% vrMin=[VMIN; VMAX*cos(degrees2radians(125))];
% vrMax=[VMAX; VMIN*cos(degrees2radians(115))];
% 
% 
% viMin=[0; VMIN*sin(degrees2radians(125))];
% viMax=[0; VMAX*sin(degrees2radians(115))];

vrMin=vrMin([1,3]);
vrMax=vrMax([1,3]);
viMin=vrMin;
viMax=vrMax;


    RMinVec=[RMIN;RMIN];
    RMaxVec=[RMAX;RMAX];
end
 



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

end




    
x=real(vnmPrime2Phi(:,r)); 
y=R2Phi(:,r);
w=real(vnm2Phi(:,r));
xMin=vrMin;
xMax=vrMax;
yMin=RMinVec;
yMax=RMaxVec;
wMin=viMin;
wMax=viMax;
doMcCormick;
wMin<=w<=wMax;


x=imag(vnmPrime2Phi(:,r)); 
y=R2Phi(:,r);
w=imag(vnm2Phi(:,r));
xMin=viMin;
xMax=viMax;
yMin=RMinVec;
yMax=RMaxVec;
wMin=viMin;
wMax=viMax;
doMcCormick;
wMin<=w<=wMax;



end





for r=1:NRegs1Phi

defineCommonVPrimeConstraints1PhiBF;
    defineSeparationEqualityConstraints1PhiBF;
    
    
    [VTilde,vnm1Phi(:,r); vnm1Phi(:,r)', 1]>=0; 
[VnmPrime1Phi(:,:,r), vnmPrime1Phi(:,r); vnmPrime1Phi(:,r)', 1]>=0;
    
%     
%     vrMin=[VMIN; VMAX*cos(degrees2radians(-125)); VMAX*cos(degrees2radians(125))];
% vrMax=[VMAX; VMIN*cos(degrees2radians(-115)); VMIN*cos(degrees2radians(115))];
% 
% 
% viMin=[0; VMAX*sin(degrees2radians(-115)); VMIN*sin(degrees2radians(125))];
% viMax=[0; VMIN*sin(degrees2radians(-125)); VMAX*sin(degrees2radians(115))];

vrMin=-VMAX;
vrmax=VMAX;
viMin=vrMin;
viMax=vrMax;

PhiIdx=1;
vrMin=vrMin(PhiIdx);
vrMax=vrMax(PhiIdx);

viMin=viMin(PhiIdx);
viMax=viMax(PhiIdx);


    
    
    
x=real(vnmPrime1Phi(:,r)); 
y=R1Phi(:,r);
w=real(vnm1Phi(:,r));
xMin=vrMin;
xMax=vrMax;
yMin=RMinVec;
yMax=RMaxVec;
wMin=viMin;
wMax=viMax;
doMcCormick;
wMin<=w<=wMax;


x=imag(vnmPrime1Phi(:,r)); 
y=R1Phi(:,r);
w=imag(vnm1Phi(:,r));
xMin=viMin;
xMax=viMax;
yMin=RMinVec;
yMax=RMaxVec;
wMin=viMin;
wMax=viMax;
doMcCormick;
wMin<=w<=wMax;
end

