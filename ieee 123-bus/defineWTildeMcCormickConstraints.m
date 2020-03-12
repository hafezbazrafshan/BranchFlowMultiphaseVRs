%% WTilde McCormick
% 
% 
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
w=WTilde(1,3,r);
x=RSquared3Phi(1,3,r);
y=WTildePrime(1,3);
xMin=RMinVec(1).*RMinVec(3);
xMax=RMaxVec(1).*RMaxVec(3);
yMin=WTildeMin(1,3);
yMax=WTildeMax(1,3);
doMcCormick;

% 
w=WTilde(2,2,r);
x=RSquared3Phi(2,2,r);
y=WTildePrime(2,2);
xMin=RMinVec(2).*RMinVec(2);
xMax=RMaxVec(2).*RMaxVec(2);
yMin=WTildeMin(2,2);
yMax=WTildeMax(2,2);
doMcCormick;



w=WTilde(2,3,r);
x=RSquared3Phi(2,3,r);
y=WTildePrime(2,3);
xMin=RMinVec(2).*RMinVec(3);
xMax=RMaxVec(2).*RMaxVec(3);
yMin=WTildeMin(2,3);
yMax=WTildeMax(2,3);
doMcCormick;
% 


w=WTilde(3,3,r);
x=RSquared3Phi(3,3,r);
y=WTildePrime(3,3);
xMin=RMinVec(3).*RMinVec(3);
xMax=RMaxVec(3).*RMaxVec(3);
yMin=WTildeMin(3,3);
yMax=WTildeMax(3,3);
doMcCormick;
