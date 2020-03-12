VPRIMEMAX=VMAX;
VPRIMEMIN=VMIN;


ThetaMaxRadians=degrees2radians(ThetaMax); 
ThetaMinRadians=degrees2radians(ThetaMin); 

AMax=[VPRIMEMAX.^2, (VPRIMEMIN.^2).*cos(ThetaMinRadians), (VPRIMEMIN.^2).*cos(ThetaMinRadians);
    (VPRIMEMIN.^2).*cos(ThetaMinRadians), VPRIMEMAX.^2, (VPRIMEMIN.^2).*cos(ThetaMinRadians); 
    (VPRIMEMIN.^2).*cos(ThetaMinRadians), (VPRIMEMIN.^2).*cos(ThetaMinRadians), VPRIMEMAX.^2];

AMin=[VPRIMEMIN.^2, (VPRIMEMAX.^2).*cos(ThetaMaxRadians), (VPRIMEMAX.^2).*cos(ThetaMaxRadians);
   (VPRIMEMAX.^2).*cos(ThetaMaxRadians), VPRIMEMIN.^2, (VPRIMEMAX.^2).*cos(ThetaMaxRadians); 
    (VPRIMEMAX.^2).*cos(ThetaMaxRadians), (VPRIMEMAX.^2).*cos(ThetaMaxRadians), VPRIMEMIN.^2];

% 
BMax=[0, (VPRIMEMAX.^2).*sin(ThetaMinRadians), -(VPRIMEMIN.^2).*sin(ThetaMaxRadians);
   -(VPRIMEMIN.^2).*sin(ThetaMaxRadians), 0, (VPRIMEMAX.^2).*sin(ThetaMinRadians); 
   (VPRIMEMAX.^2).*sin(ThetaMinRadians), -(VPRIMEMIN.^2).*sin(ThetaMaxRadians), 0];

BMin=[0, (VPRIMEMIN.^2).*sin(ThetaMaxRadians), -(VPRIMEMAX.^2).*sin(ThetaMinRadians);
   -(VPRIMEMAX.^2).*sin(ThetaMinRadians), 0, (VPRIMEMIN.^2).*sin(ThetaMaxRadians); 
  (VPRIMEMIN.^2).*sin(ThetaMaxRadians),  -(VPRIMEMAX.^2).*sin(ThetaMinRadians), 0];

% WPrime bound constraints (mainly useful for off-diagonal)
vec(AMin)<=vec(A)<=vec(AMax);
vec(BMin)<=vec(B)<=vec(BMax);