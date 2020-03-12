
% prepare expressions
        DA12Var=DAR12(1,r);
        OA12Var=OAR12(1,r);
        OB12Var=OBR12(1,r);
        
         DA23Var=DAR23(1,r);
        OA23Var=OAR23(1,r);
        OB23Var=OBR23(1,r);
        
          DA31Var=DAR31(1,r);
        OA31Var=OAR31(1,r);
        OB31Var=OBR31(1,r);
        
        
        %         
        A12A23Var=A12A23R(1,r);
        B12B23Var=B12B23R(1,r);
        A31A22Var=A31A22R(1,r);
        
        A23B12Var=A23B12R(1,r);
        A12B23Var=A12B23R(1,r);
        A22B31Var=A22B31R(1,r);
        
        
        A11A23Var=A11A23R(1,r);
        A31A12Var=A31A12R(1,r);
        B31B12Var=B31B12R(1,r);
        
        A11B23Var=A11B23R(1,r);
        A12B31Var=A12B31R(1,r);
        A31B12Var=A31B12R(1,r);
        
        
        A12A33Var=A12A33R(1,r);
        A31A23Var=A31A23R(1,r);
        B31B23Var=B31B23R(1,r);
        
        A33B12Var=A33B12R(1,r);
        A23B31Var=A23B31R(1,r);
        A31B23Var=A31B23R(1,r);
        

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



DA23Var==OA23Var+OB23Var;
w=DA23Var;
x=A(2,2);
y=A(3,3);
xMin=AMin(2,2);
xMax=AMax(2,2);
yMin=AMin(3,3);
yMax=AMax(3,3);
doMcCormick;



w=OA23Var;
x=A(2,3);
y=A(2,3);
xMin=AMin(2,3);
xMax=AMax(2,3);
yMin=AMin(2,3);
yMax=AMax(2,3);
doMcCormick;



w=OB23Var;
x=B(2,3);
y=B(2,3);
xMin=BMin(2,3);
xMax=BMax(2,3);
yMin=BMin(2,3);
yMax=BMax(2,3);
doMcCormick;


DA31Var==OA31Var+OB31Var;
w=DA31Var;
x=A(3,3);
y=A(1,1);
xMin=AMin(3,3);
xMax=AMax(3,3);
yMin=AMin(1,1);
yMax=AMax(1,1);
doMcCormick;


w=OA31Var;
x=A(3,1);
y=A(3,1);
xMin=AMin(3,1);
xMax=AMax(3,1);
yMin=AMin(3,1);
yMax=AMax(3,1);
doMcCormick;

w=OB31Var;
x=B(3,1);
y=B(3,1);
xMin=BMin(3,1);
xMax=BMax(3,1);
yMin=BMin(3,1);
yMax=BMax(3,1);
doMcCormick;
% 
% 

A12A23Var-B12B23Var-A31A22Var==0;
A23B12Var+A12B23Var+A22B31Var==0;

A11A23Var-A31A12Var+B31B12Var==0;
A11B23Var+A12B31Var+A31B12Var==0;


A12A33Var-A31A23Var+B31B23Var==0;
A33B12Var+A23B31Var+A31B23Var==0;

% 
w=A12A23Var;
x=A(1,2);
y=A(2,3);
xMin=AMin(1,2);
xMax=AMax(1,2);
yMin=AMin(2,3);
yMax=AMax(2,3);
doMcCormick;


w=B12B23Var;
x=B(1,2);
y=B(2,3);
xMin=BMin(1,2);
xMax=BMax(1,2);
yMin=BMin(2,3);
yMax=BMax(2,3);
doMcCormick;


w=A31A22Var;
x=A(3,1);
y=A(2,2);
xMin=AMin(3,1);
xMax=AMax(3,1);
yMin=AMin(2,2);
yMax=AMax(2,2);
doMcCormick;



w=A23B12Var;
x=A(2,3);
y=B(1,2);
xMin=AMin(2,3);
xMax=AMax(2,3);
yMin=BMin(1,2);
yMax=BMax(1,2);
doMcCormick;


w=A12B23Var;
x=A(1,2);
y=B(2,3);
xMin=AMin(1,2);
xMax=AMax(1,2);
yMin=BMin(2,3);
yMax=BMax(2,3);
doMcCormick;


w=A22B31Var;
x=A(2,2);
y=B(3,1);
xMin=AMin(2,2);
xMax=AMax(2,2);
yMin=BMin(3,1);
yMax=BMax(3,1);
doMcCormick;
% 

w=A11A23Var;
x=A(1,1);
y=A(2,3);
xMin=AMin(1,1);
xMax=AMax(1,1);
yMin=AMin(2,3);
yMax=AMax(2,3);
doMcCormick;
% 


w=A31A12Var;
x=A(3,1);
y=A(1,2);
xMin=AMin(3,1);
xMax=AMax(3,1);
yMin=AMin(1,2);
yMax=AMax(1,2);
doMcCormick;
% 

w=B31B12Var;
x=B(3,1);
y=B(1,2);
xMin=BMin(3,1);
xMax=BMax(3,1);
yMin=BMin(1,2);
yMax=BMax(1,2);
doMcCormick;


% 
w=A11B23Var;
x=A(1,1);
y=B(2,3);
xMin=AMin(1,1);
xMax=AMax(1,1);
yMin=BMin(2,3);
yMax=BMax(2,3);
doMcCormick;

% 
w=A12B31Var;
x=A(1,2);
y=B(3,1);
xMin=AMin(1,2);
xMax=AMax(1,2);
yMin=BMin(3,1);
yMax=BMax(3,1);
doMcCormick;


w=A31B12Var;
x=A(3,1);
y=B(1,2);
xMin=AMin(3,1);
xMax=AMax(3,1);
yMin=BMin(1,2);
yMax=BMax(1,2);
doMcCormick;
% 
% 
% 
w=A12A33Var;
x=A(1,2);
y=A(3,3);
xMin=AMin(1,2);
xMax=AMax(1,2);
yMin=AMin(3,3);
yMax=AMax(3,3);
doMcCormick;
% % 
% 
w=A31A23Var;
x=A(3,1);
y=A(2,3);
xMin=AMin(3,1);
xMax=AMax(3,1);
yMin=AMin(2,3);
yMax=AMax(2,3);
doMcCormick;
% 
% 
w=B31B23Var;
x=B(3,1);
y=B(2,3);
xMin=BMin(3,1);
xMax=BMax(3,1);
yMin=BMin(2,3);
yMax=BMax(2,3);
doMcCormick;
% 
% 
w=A33B12Var;
x=A(3,3);
y=B(1,2);
xMin=AMin(3,3);
xMax=AMax(3,3);
yMin=BMin(1,2);
yMax=BMax(1,2);
doMcCormick;


w=A23B31Var;
x=A(2,3);
y=B(3,1);
xMin=AMin(2,3);
xMax=AMax(2,3);
yMin=BMin(3,1);
yMax=BMax(3,1);
doMcCormick;



w=A31B23Var;
x=A(3,1);
y=B(2,3);
xMin=AMin(3,1);
xMax=AMax(3,1);
yMin=BMin(2,3);
yMax=BMax(2,3);
doMcCormick;
% 
