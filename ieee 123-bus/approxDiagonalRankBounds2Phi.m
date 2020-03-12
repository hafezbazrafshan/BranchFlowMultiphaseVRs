
% prepare expressions
        DA12Var=DAR2Phi12(1,r);
        OA12Var=OAR2Phi12(1,r);
        OB12Var=OBR2Phi12(1,r);
        
      
        
      
        

% 
% 
% 
% McCormick rank relaxation

% 
DA12Var==OA12Var+OB12Var;
w=DA12Var;
x=A(1,1);
y=A(2,2);
xMin=AMin(1,1);
xMax=AMax(1,1);
yMin=AMin(2,2);
yMax=AMax(2,2);
doMcCormick;

% 
% 
w=OA12Var;
x=A(1,2);
y=A(1,2);
xMin=AMin(1,2);
xMax=AMax(1,2);
yMin=AMin(1,2);
yMax=AMax(1,2);
doMcCormick;



w=OB12Var;
x=B(1,2);
y=B(1,2);
xMin=BMin(1,2);
xMax=BMax(1,2);
yMin=BMin(1,2);
yMax=BMax(1,2);
doMcCormick;


