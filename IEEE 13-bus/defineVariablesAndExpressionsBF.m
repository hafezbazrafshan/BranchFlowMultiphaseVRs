variable Vnn3Phi(3,3, NBuses3Phi) hermitian semidefinite
variable Inm3Phi(3,3,NBranches3Phi) hermitian semidefinite
variable Snm3Phi(3,3,NBranches3Phi) complex

variable Vnn2Phi(2,2, NBuses2Phi) hermitian semidefinite
variable Inm2Phi(2,2,NBranches2Phi) hermitian semidefinite
variable Snm2Phi(2,2,NBranches2Phi) complex



variable Vnn1Phi(1,1, NBuses1Phi) hermitian semidefinite
variable Inm1Phi(1,1,NBranches1Phi) hermitian semidefinite
variable Snm1Phi(1,1,NBranches1Phi) complex



variable SIn(3,1) complex
variable ThermalLoss





variable VoltageDeviation

% create a placeholder 
expression W3Phi(6,6,NBranches3Phi);
expression W2Phi(4,4,NBranches2Phi); 
expression W1Phi(2,2,NBranches1Phi);
expression ThermalLossExpression
expression VoltageDeviationExpression