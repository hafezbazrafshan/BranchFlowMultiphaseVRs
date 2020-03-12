
% prepare expressions
        DA12Var=DA12(1,n);
        OA12Var=OA12(1,n);
        OB12Var=OB12(1,n);
        
         DA23Var=DA23(1,n);
        OA23Var=OA23(1,n);
        OB23Var=OB23(1,n);
        
          DA31Var=DA31(1,n);
        OA31Var=OA31(1,n);
        OB31Var=OB31(1,n);
        
        
        %         
        A12A23Var=A12A23(1,n);
        B12B23Var=B12B23(1,n);
        A31A22Var=A31A22(1,n);
        
        A23B12Var=A23B12(1,n);
        A12B23Var=A12B23(1,n);
        A22B31Var=A22B31(1,n);
        
        
        A11A23Var=A11A23(1,n);
        A31A12Var=A31A12(1,n);
        B31B12Var=B31B12(1,n);
        
        A11B23Var=A11B23(1,n);
        A12B31Var=A12B31(1,n);
        A31B12Var=A31B12(1,n);
        
        
        A12A33Var=A12A33(1,n);
        A31A23Var=A31A23(1,n);
        B31B23Var=B31B23(1,n);
        
        A33B12Var=A33B12(1,n);
        A23B31Var=A23B31(1,n);
        A31B23Var=A31B23(1,n);
        

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

