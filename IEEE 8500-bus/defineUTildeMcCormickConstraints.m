%% UTilde McCormick
w=UTilde(1,1,r);
x=RSquared3Phi(1,1,r);
y=UTildePrime(1,1);
xMin=RMinVec(1).^2;
xMax=RMaxVec(1).^2;
yMin=UTildeMin(1,1);
yMax=UTildeMax(1,1);
doMcCormick;

% 
w=UTilde(1,2,r);
x=RSquared3Phi(1,2,r);
y=UTildePrime(1,2);
xMin=RMinVec(1).*RMinVec(2);
xMax=RMaxVec(1).*RMaxVec(2);
yMin=UTildeMin(1,2);
yMax=UTildeMax(1,2);
doMcCormick;
% 
% 
% % % 
w=UTilde(1,3,r);
x=RSquared3Phi(1,3,r);
y=UTildePrime(1,3);
xMin=RMinVec(1).*RMinVec(3);
xMax=RMaxVec(1).*RMaxVec(3);
yMin=UTildeMin(1,3);
yMax=UTildeMax(1,3);
doMcCormick;


w=UTilde(2,2,r);
x=RSquared3Phi(2,2,r);
y=UTildePrime(2,2);
xMin=RMinVec(2).*RMinVec(2);
xMax=RMaxVec(2).*RMaxVec(2);
yMin=UTildeMin(2,2);
yMax=UTildeMax(2,2);
doMcCormick;



w=UTilde(2,3,r);
x=RSquared3Phi(2,3,r);
y=UTildePrime(2,3);
xMin=RMinVec(2).*RMinVec(3);
xMax=RMaxVec(2).*RMaxVec(3);
yMin=UTildeMin(2,3);
yMax=UTildeMax(2,3);
doMcCormick;



w=UTilde(3,3,r);
x=RSquared3Phi(3,3,r);
y=UTildePrime(3,3);
xMin=RMinVec(3).*RMinVec(3);
xMax=RMaxVec(3).*RMaxVec(3);
yMin=UTildeMin(3,3);
yMax=UTildeMax(3,3);
doMcCormick;
