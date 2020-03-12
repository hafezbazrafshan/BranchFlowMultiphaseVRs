function  [Network]=optimizeFixedTapsBF(Network)
defineCommonOptimizationParameters;
defineCVXSettings;
cvx_begin sdp
%% 1. Define variables
defineBFVariablesAndExpressions;
% defineBFSeparationVariables;

%% 2. Define objective;
defineObjective;
subject to:
%% 3. Constraints
defineCommonVConstraints;
definePowerFlowFixedTapsBF;
% defineYIConstraintsBF;
cvx_end

%% 4. Check Constraints
% checkConstraintsBF;

%% 5. Recover taps
% recoverTapsBF;

%% 6. Return solution
% defineCommonOptimizationOutputsBF;



