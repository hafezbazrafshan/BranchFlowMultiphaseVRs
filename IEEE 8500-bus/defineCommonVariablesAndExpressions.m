variable Wnn3Phi(3,3, NBuses3Phi) hermitian semidefinite
variable Wnm3Phi(3,3,NBranches3Phi) complex
variable Wnn2Phi(2,2,NBuses2Phi) hermitian semidefinite
variable Wnm2Phi(2,2,NBranches2Phi) complex
variable Wnn1Phi(1,1,NBuses1Phi) hermitian semidefinite
variable Wnm1Phi(1,1,NBranches1Phi) complex 
variable SIn(3,1) complex
variable Sg(NPhases,1) complex
variable ThermalLoss




variable VoltageDeviation

% create a placeholder 
expression W3Phi(6,6,NBranches3Phi);
expression W2Phi(4,4,NBranches2Phi); 
expression W1Phi(2,2,NBranches1Phi);
expression WPrime3Phi(6,6,NRegs3Phi);
expression ThermalLossExpression
expression VoltageDeviationExpression