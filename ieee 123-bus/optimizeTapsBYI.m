function  [Network]=optimizeTapsBYI(Network)
defineCommonOptimizationParameters; %checked
defineCVXSettings; %checked
cvx_begin sdp
%% 1. Define variables
defineVariablesAndExpressionsBF; %checked
defineSeparationVariablesBF;%checked

%% 2. Define objective;
defineObjective;%checked
subject to:
%% 3. Constraints
defineVoltageConstraintsBF;%checked
definePowerBalanceConstraintsBF;%checked
defineYIConstraintsBF;%checked
cvx_end

%% 4. Check Constraints
checkConstraintsBF;

%% 5. Recover taps
recoverTapsBF;

%% 6. Return solution
defineCommonOptimizationOutputsBF;



