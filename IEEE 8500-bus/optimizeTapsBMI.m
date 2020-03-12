function  [Network]=optimizeTapsBMI(Network,Delta, RankConstraints, GangConstraints)
defineCommonOptimizationParameters;
defineCVXSettings;
cvx_begin sdp
%% 1. Define variables
defineVariablesAndExpressionsBF;
defineSeparationVariablesBF;
defineRegMcCormickVariablesBF;

if RankConstraints
defineVariablesForApproxRegRankConstraints;
end


%% 2. Define objective;
defineObjective;
subject to:
%% 3. Constraints
defineVoltageConstraintsBF;
definePowerBalanceConstraintsBF;
defineBMIConstraintsBF;
cvx_end
Network.Optimization.TimeInfo=cvx_toc;

%% 4. Check Constraints
checkConstraintsBF;

%% 5. Recover taps
recoverTapsBF;

%% 6. Return solution
defineCommonOptimizationOutputsBF;



