variable Wnn3Phi(3,3, NBuses3Phi) hermitian semidefinite
variable Wnm3Phi(3,3,NBranches3Phi) complex
variable SIn(3,1) complex
variable Sg(NPhases,1) complex
variable ThermalLoss



variable WnnPrime3Phi(3,3,NRegs3Phi) hermitian semidefinite
variable WnmPrime3Phi(3,3,NRegs3Phi) complex
variable VoltageDeviation

% create a placeholder 
expression W3Phi(6,6,NBranches3Phi);
expression WPrime3Phi(6,6,NRegs3Phi);
expression ThermalLossExpression
expression VoltageDeviationExpression