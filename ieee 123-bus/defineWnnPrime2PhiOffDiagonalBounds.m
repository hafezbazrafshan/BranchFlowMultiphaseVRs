


ThetaMaxRadians=degrees2radians(ThetaMax); 
ThetaMinRadians=degrees2radians(ThetaMin); 

AMax=[VMAX.^2, (VMIN.^2).*cos(ThetaMinRadians);
    (VMIN.^2).*cos(ThetaMinRadians), VMAX.^2];
    

AMin=[VMIN.^2, (VMAX.^2).*cos(ThetaMaxRadians);
   (VMAX.^2).*cos(ThetaMaxRadians), VMIN.^2];
 

% 
BMax=[0, (VMAX.^2).*sin(ThetaMinRadians);
   -(VMIN.^2).*sin(ThetaMaxRadians), 0];

BMin=[0, (VMIN.^2).*sin(ThetaMaxRadians);
   -(VMAX.^2).*sin(ThetaMinRadians), 0];

% WPrime bound constraints (mainly useful for off-diagonal)
AMin(:)<=A(:)<=AMax(:);
BMin(:)<=B(:)<=BMax(:);