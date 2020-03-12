for r=1:NRegs3Phi
defineCommonWPrime3PhiConstraints;
defineSeparation3PhiEqualityConstraint;
A=real(WnnPrime3Phi(:,:,r));
B=imag(WnnPrime3Phi(:,:,r));
defineWnnPrime3PhiOffDiagonalBounds; % constraints
approxDiagonalRankBounds3Phi; % constraints
APrime=real(Wnn3Phi(:,:,nn));
BPrime=imag(Wnn3Phi(:,:,nn));        
switch RegulatorType
    case 'Wye'


% 
(RMAX.^2).*A(1,2)<=APrime(1,2)<=(RMIN.^2).*A(1,2);
(RMAX.^2).*A(2,3)<=APrime(2,3)<=(RMIN.^2).*A(2,3);
(RMAX.^2).*A(3,1)<=APrime(3,1)<=(RMIN.^2).*A(3,1);


(RMIN.^2).*B(1,2)<=BPrime(1,2)<=(RMAX.^2).*B(1,2);
(RMIN.^2).*B(2,3)<=BPrime(2,3)<=(RMAX.^2).*B(2,3);
(RMIN.^2).*B(3,1)<=BPrime(3,1)<=(RMAX.^2).*B(3,1);

% % 
% RMIN<=Ra3Phi(1,r)<=RMAX;
% RMIN<=Rb3Phi(1,r)<=RMAX;
% RMIN<=Rc3Phi(1,r)<=RMAX;
% % 
% % 
% w=Raa3Phi(1,r); 
% x=Ra3Phi(1,r); 
% y=Ra3Phi(1,r);
% xMin=RMIN;
% xMax=RMAX;
% yMin=RMIN;
% yMax=RMAX;
% doMcCormick;
% 
% 
% 
% 
% w=Rbb3Phi(1,r); 
% x=Rb3Phi(1,r); 
% y=Rb3Phi(1,r);
% xMin=RMIN;
% xMax=RMAX;
% yMin=RMIN;
% yMax=RMAX;
% doMcCormick;
% 
% 
% w=Rcc3Phi(1,r); 
% x=Rc3Phi(1,r); 
% y=Rc3Phi(1,r);
% xMin=RMIN;
% xMax=RMAX;
% yMin=RMIN;
% yMax=RMAX;
% doMcCormick;
% 
% 
% 
% 
% 
% 
% w=Rab3Phi(1,r); 
% x=Ra3Phi(1,r); 
% y=Rb3Phi(1,r);
% xMin=RMIN;
% xMax=RMAX;
% yMin=RMIN;
% yMax=RMAX;
% doMcCormick;
% 
% 
% w=Rac3Phi(1,r); 
% x=Ra3Phi(1,r); 
% y=Rc3Phi(1,r);
% xMin=RMIN;
% xMax=RMAX;
% yMin=RMIN;
% yMax=RMAX;
% doMcCormick;
% 
% 
% w=Rbc3Phi(1,r); 
% x=Rb3Phi(1,r); 
% y=Rc3Phi(1,r);
% xMin=RMIN;
% xMax=RMAX;
% yMin=RMIN;
% yMax=RMAX;
% doMcCormick;
% 
% 
% APrime(1,1)==ARaa3Phi(1,r);
% w=ARaa3Phi(1,r);
% x=Raa3Phi(1,r);
% y=A(1,1);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=AMin(1,1);
% yMax=AMax(1,1);
% doMcCormick;
% 
% APrime(1,2)==ARab3Phi(1,r);
% w=ARab3Phi(1,r);
% x=Rab3Phi(1,r);
% y=A(1,2);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=AMin(1,2);
% yMax=AMax(1,2);
% doMcCormick;
% 
% 
% APrime(1,3)==ARac3Phi(1,r);
% w=ARac3Phi(1,r);
% x=Rac3Phi(1,r);
% y=A(1,3);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=AMin(1,3);
% yMax=AMax(1,3);
% doMcCormick;
% 
% 
% APrime(2,3)==ARbc3Phi(1,r);
% w=ARbc3Phi(1,r);
% x=Rbc3Phi(1,r);
% y=A(2,3);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=AMin(2,3);
% yMax=AMax(2,3);
% doMcCormick;
% 
% 
% APrime(2,2)==ARbb3Phi(1,r);
% w=ARbb3Phi(1,r);
% x=Rbb3Phi(1,r);
% y=A(2,2);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=AMin(2,2);
% yMax=AMax(2,2);
% doMcCormick;
% 
% 
% 
% APrime(3,3)==ARcc3Phi(1,r);
% w=ARcc3Phi(1,r);
% x=Rcc3Phi(1,r);
% y=A(3,3);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=AMin(3,3);
% yMax=AMax(3,3);
% doMcCormick;
% 
% 
% 
% 
% 
% BPrime(1,2)==BRab3Phi(1,r);
% w=BRab3Phi(1,r);
% x=Rab3Phi(1,r);
% y=B(1,2);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=BMin(1,2);
% yMax=BMax(1,2);
% doMcCormick;
% 
% 
% BPrime(1,3)==BRac3Phi(1,r);
% w=BRac3Phi(1,r);
% x=Rac3Phi(1,r);
% y=B(1,3);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=BMin(1,3);
% yMax=BMax(1,3);
% doMcCormick;
% 
% 
% BPrime(2,3)==BRbc3Phi(1,r);
% w=BRbc3Phi(1,r);
% x=Rbc3Phi(1,r);
% y=B(2,3);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=BMin(2,3);
% yMax=BMax(2,3);
% doMcCormick;
% 


    case 'ClosedDelta'
        D=[1 -1 0; 0 1 -1; -1 0 1];
        F=[0 1 0; 0 0 1; 1 0 0];
        aMatrix=D*A*D.';
        bMatrix=D*A*F.';
        cMatrix=F*A*F.';
        alphaMatrix=D*B*D.';
        betaMatrix=D*B*F.';
        kappaMatrix=F*B*F.';
        
        (RMIN.^2).*diag(aMatrix)+2*RMIN*diag(bMatrix)+diag(cMatrix)<=diag(APrime);
                (RMAX.^2).*diag(aMatrix)+2*RMAX*diag(bMatrix)+diag(cMatrix)>=diag(APrime);
                
                
(RMAX.^2)*aMatrix(1,2)+RMAX.*bMatrix(1,2)+RMIN.*bMatrix(2,1)+cMatrix(1,2)<=APrime(1,2);   
                (RMIN.^2)*aMatrix(1,2)+RMIN.*bMatrix(1,2)+RMAX.*bMatrix(2,1)+cMatrix(1,2)>=APrime(1,2);   
                
                (RMAX.^2)*aMatrix(2,3)+RMAX.*bMatrix(2,3)+RMIN.*bMatrix(3,2)+cMatrix(2,3)<=APrime(2,3);   
                (RMIN.^2)*aMatrix(2,3)+RMIN.*bMatrix(2,3)+RMAX.*bMatrix(3,2)+cMatrix(2,3)>=APrime(2,3);   
                
                (RMAX.^2)*aMatrix(3,1)+RMAX.*bMatrix(3,1)+RMIN.*bMatrix(1,3)+cMatrix(3,1)<=APrime(3,1);   
                (RMIN.^2)*aMatrix(3,1)+RMIN.*bMatrix(3,1)+RMAX.*bMatrix(1,3)+cMatrix(3,1)>=APrime(3,1);   
                
                
                
                                
(RMIN.^2)*alphaMatrix(1,2)+RMAX.*betaMatrix(1,2)-RMAX.*betaMatrix(2,1)+kappaMatrix(1,2)<=BPrime(1,2);   
                (RMAX.^2)*alphaMatrix(1,2)+RMIN.*betaMatrix(1,2)-RMIN.*betaMatrix(2,1)+kappaMatrix(1,2)>=BPrime(1,2);   
                
                (RMIN.^2)*alphaMatrix(2,3)+RMAX.*betaMatrix(2,3)-RMAX.*betaMatrix(3,2)+kappaMatrix(2,3)<=BPrime(2,3);   
                (RMAX.^2)*alphaMatrix(2,3)+RMIN.*betaMatrix(2,3)-RMIN.*betaMatrix(3,2)+kappaMatrix(2,3)>=BPrime(2,3);   
                
                (RMIN.^2)*alphaMatrix(3,1)+RMAX.*betaMatrix(3,1)-RMAX.*betaMatrix(1,3)+kappaMatrix(3,1)<=BPrime(3,1);   
                (RMAX.^2)*alphaMatrix(3,1)+RMIN.*betaMatrix(3,1)-RMIN.*betaMatrix(1,3)+kappaMatrix(3,1)>=BPrime(3,1);   


end
end





for r=1:NRegs2Phi
defineCommonWPrime2PhiConstraints;
defineSeparation2PhiEqualityConstraint;
Phases= Network.Branch.Phases{RegBranchNumber};
ATilde=real(WnnPrime2Phi(:,:,r));
BTilde=imag(WnnPrime2Phi(:,:,r));
APrimeTilde=real(   WTilde);
BPrimeTilde=imag(   WTilde);    
if isequal(Phases,[1;3])
    A=cvx(zeros(2));
    B=cvx(zeros(2));
    APrime=cvx(zeros(2));
    BPrime=cvx(zeros(2));
A(1,1)=ATilde(2,2); 
A(1,2)=ATilde(2,1); 
A(2,1)=ATilde(1,2); 
A(2,2)=ATilde(1,1);
B(1,1)=BTilde(2,2); 
B(1,2)=BTilde(2,1); 
B(2,1)=BTilde(1,2); 
B(2,2)=BTilde(1,1);

defineWnnPrime2PhiOffDiagonalBounds; % constraints
approxDiagonalRankBounds2Phi; 
% % 
APrime(1,1)=APrimeTilde(2,2); 
APrime(1,2)=APrimeTilde(2,1); 
APrime(2,1)=APrimeTilde(1,2); 
APrime(2,2)=APrimeTilde(1,1);
BPrime(1,1)=BPrimeTilde(2,2); 
BPrime(1,2)=BPrimeTilde(2,1); 
BPrime(2,1)=BPrimeTilde(1,2); 
BPrime(2,2)=BPrimeTilde(1,1);
% 
% % 
% % defineWnnPrime2PhiOffDiagonalBounds; % constraints
% % approxDiagonalRankBounds2Phi; % constraints
  (RMAX.^2).*A(1,2)<=APrime(1,2)<=(RMIN.^2).*A(1,2);
  (RMIN.^2).*B(1,2)<=BPrime(1,2)<=(RMAX.^2).*B(1,2);
% 
% 
% % 
% RMIN<=Ra2Phi(1,r)<=RMAX;
% RMIN<=Rb2Phi(1,r)<=RMAX;

% 
% w=Raa2Phi(1,r); 
% x=Ra2Phi(1,r); 
% y=Ra2Phi(1,r);
% xMin=RMIN;
% xMax=RMAX;
% yMin=RMIN;
% yMax=RMAX;
% doMcCormick;
% 
% 
% 
% 
% w=Rbb2Phi(1,r); 
% x=Rb2Phi(1,r); 
% y=Rb2Phi(1,r);
% xMin=RMIN;
% xMax=RMAX;
% yMin=RMIN;
% yMax=RMAX;
% doMcCormick;
% 
% 
% w=Rab2Phi(1,r); 
% x=Ra2Phi(1,r); 
% y=Rb2Phi(1,r);
% xMin=RMIN;
% xMax=RMAX;
% yMin=RMIN;
% yMax=RMAX;
% doMcCormick;
% 
% 
% 
% 
% 
% APrime(1,1)==ARaa2Phi(1,r);
% w=ARaa2Phi(1,r);
% x=Raa2Phi(1,r);
% y=A(1,1);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=AMin(1,1);
% yMax=AMax(1,1);
% doMcCormick;
% 
% APrime(1,2)==ARab2Phi(1,r);
% w=ARab2Phi(1,r);
% x=Rab2Phi(1,r);
% y=A(1,2);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=AMin(1,2);
% yMax=AMax(1,2);
% doMcCormick;
% 
% 
% APrime(2,2)==ARbb2Phi(1,r);
% w=ARbb2Phi(1,r);
% x=Rbb2Phi(1,r);
% y=A(2,2);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=AMin(2,2);
% yMax=AMax(2,2);
% doMcCormick;
% % % 
% % % 
% % % 
% BPrime(1,2)==BRab2Phi(1,r);
% w=BRab2Phi(1,r);
% x=Rab2Phi(1,r);
% y=B(1,2);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=BMin(1,2);
% yMax=BMax(1,2);
% doMcCormick;
% 
end
% 
end





for r=1:NRegs1Phi
defineCommonWPrime1PhiConstraints;
defineSeparation1PhiEqualityConstraint;
% 
% RMIN<=Ra1Phi(1,r)<=RMAX;
% w=Raa1Phi(1,r); 
% x=Ra1Phi(1,r); 
% y=Ra1Phi(1,r);
% xMin=RMIN;
% xMax=RMAX;
% yMin=RMIN;
% yMax=RMAX;
% doMcCormick;
% 
% 
% WTilde(1,1)==ARaa1Phi(1,r);
% w=ARaa1Phi(1,r);
% x=Raa1Phi(1,r);
% y=WnnPrime1Phi(1,1,r);
% xMin=RMIN.^2;
% xMax=RMAX.^2;
% yMin=VMIN.^2;
% yMax=VMAX.^2;
% doMcCormick;
end
    


