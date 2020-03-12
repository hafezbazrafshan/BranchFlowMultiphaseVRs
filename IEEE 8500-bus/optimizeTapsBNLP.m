function  [Network]=optimizeTapsBNLP(Network)
defineCommonOptimizationParameters;
%% 1. Define variables

% common variables
vn3Phi=sdpvar(3,NBuses3Phi,'full','complex');
inm3Phi=sdpvar(3,NBranches3Phi,'full','complex'); 
Sg3Phi=sdpvar(3,NBuses3Phi,'full','complex'); 


vn2Phi=sdpvar(2,NBuses2Phi,'full','complex');
inm2Phi=sdpvar(2,NBranches2Phi,'full','complex'); 
Sg2Phi=sdpvar(2,NBuses2Phi,'full','complex'); 


vn1Phi=sdpvar(1,NBuses1Phi,'full','complex');
inm1Phi=sdpvar(1,NBranches1Phi,'full','complex'); 
Sg1Phi=sdpvar(1,NBuses1Phi,'full','complex'); 

SIn=sdpvar(3,1,'full','complex'); 


% regs separation
 vnmPrime3Phi=sdpvar(3,NRegs3Phi,'full','complex') ;
 inmPrime3Phi=sdpvar(3,NRegs3Phi,'full','complex') ;
 Anm3Phi=sdpvar(3,3,NRegs3Phi,'full');
 R3Phi=sdpvar(3,NRegs3Phi,'full');
 
 
% vnmPrime2Phi=sdpvar(2,NRegs2Phi,'full','complex') ;
%  inmPrime2Phi=sdpvar(2,NRegs2Phi,'full','complex') ;
%  Anm2Phi=sdpvar(2,2,NRegs2Phi,'full');
%  R2Phi=sdpvar(2,NRegs2Phi,'full');

 
%   vnmPrime1Phi=sdpvar(1,NRegs1Phi,'full','complex') ;
%  inmPrime1Phi=sdpvar(1,NRegs1Phi,'full','complex') ;
%  Anm1Phi=sdpvar(1,1,NRegs3Phi,'full');
%  R1Phi=sdpvar(1,NRegs3Phi,'full');


%% 2. Define objective;
Scale=1;
Objective=Scale*(real(sum(SIn))+real(sum(sum(Sg3Phi)))+real(sum(sum(Sg2Phi)))+real(sum(sum(Sg1Phi))));

%% 3. Constraints
Constraints=[];
defineVoltageConstraintsBNLP;
definePowerBalanceConstraintsBNLP;
defineSgConstraintsBNLP;
defineRegConstraintsBNLP;



Options=sdpsettings('solver','IPOPT','verbose',1,'usex0',1);
BNLP=optimize(Constraints,Objective,Options);




%% 4. Check Constraints
checkConstraintsBNLP;

%% 5. Recover taps
recoverTapsBNLP;

%% 6. Return solution
defineCommonOptimizationOutputsBNLP;



