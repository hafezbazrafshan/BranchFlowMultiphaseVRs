
for r=1:NRegs3Phi
    defineCommonWPrime3PhiConstraints;
    defineSeparation3PhiEqualityConstraint;
    

end


for r=1:NRegs2Phi
defineCommonWPrime2PhiConstraints;
defineSeparation2PhiEqualityConstraint;



end


for r=1:NRegs1Phi
defineCommonWPrime1PhiConstraints;
defineSeparation1PhiEqualityConstraint;



end

