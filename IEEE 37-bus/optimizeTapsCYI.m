function  [Network]=optimizeTapsCYI(Network)
defineCommonOptimizationParameters;
defineCVXSettings;
cvx_begin sdp
%% 1. Define variables
defineCommonVariablesAndExpressions; %checked
defineSeparationVariables; %checked
%% 2. Define objective;
defineObjective % checked
subject to:
%% 3. Constraints
defineCommonWConstraints; %checked
% defineSgConstraints; %checked
Sg==0;
definePowerFlowConstraintsSeparation; %checked
defineCYIConstraints;%checked
cvx_end

%% 4. Check Constraints
checkConstraints;

%% 5. Recover taps
recoverTaps;

%% 6. Return solution
defineCommonOptimizationOutputs;



