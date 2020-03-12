%%  implementing power flow equations per node and per phase
PhiCnt=0;
ThermalLossExpression=cvx(0);

for n=1:NBuses
    PhaseSet=Bus.Phases{n};
      % allocating correct indices
        WnnTilde=cvx(zeros(3));
        YCapTilde=zeros(3);
        if ~isempty(Bus.YCap{n})
        YCapTilde(PhaseSet,PhaseSet)=diag(Bus.YCap{n});
        end
     if length(PhaseSet)==3
            nn=find(Bus.ThreePhaseBusNumbers==n);
            WnnTilde(PhaseSet,PhaseSet)=Wnn3Phi(:,:,nn);
        elseif length(PhaseSet)==2
            nn=find(Bus.TwoPhaseBusNumbers==n);
            WnnTilde(PhaseSet,PhaseSet)=Wnn2Phi(:,:,nn);
        else
            nn=find(Bus.OnePhaseBusNumbers==n);
            WnnTilde(PhaseSet,PhaseSet)=Wnn1Phi(:,:,nn);
     end
        
     
    for Phi=1:length(PhaseSet)
        PhiCnt=PhiCnt+1;
         EnTilde=zeros(3);
        EnTilde(PhaseSet(Phi),PhaseSet(Phi))=1;
      
      %  To neighbors regular lines or transformers
        ToNeighborsNonRegSum=cvx(0);
        
        for jj=1:length(Bus.ToNeighborsNonRegulatorBranchNumbers{n})
            l=Bus.ToNeighborsNonRegulatorBranchNumbers{n}(jj); % branch number
            WnmTilde=cvx(zeros(3));
            YNMnTilde=zeros(3); 
            YNMmTilde=zeros(3); 

            YNMnTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YNMn;
                YNMmTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YNMm;

            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l})=Wnm3Phi(:,:,ll);
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l})=Wnm2Phi(:,:,ll);
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                 WnmTilde(Branch.Phases{l},Branch.Phases{l})=Wnm1Phi(:,:,ll);
            end

            ToNeighborsNonRegSum=ToNeighborsNonRegSum+...
                trace( conj(YNMnTilde.')*EnTilde*WnnTilde)-...
                 trace( conj(YNMmTilde.')*EnTilde*WnmTilde);

        end
  
       % from neighbors regular lines or transformers
        
               FromNeighborsNonRegSum=cvx(0);
        
       for jj=1:length(Bus.FromNeighborsNonRegulatorBranchNumbers{n})
            l=Bus.FromNeighborsNonRegulatorBranchNumbers{n}(jj); % branch number
            WnmTilde=cvx(zeros(3));
            YNMnTilde=zeros(3); 
            YNMmTilde=zeros(3); 
          
            
            YNMnTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YMNm; % because we are the recipient
                YNMmTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YMNn;

            
            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l})=conj(Wnm3Phi(:,:,ll).');
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                WnmTilde(Branch.Phases{l},Branch.Phases{l})=conj(Wnm2Phi(:,:,ll).');
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                 WnmTilde(Branch.Phases{l},Branch.Phases{l})=conj(Wnm1Phi(:,:,ll).');
            end
   
            FromNeighborsNonRegSum=FromNeighborsNonRegSum+...
                trace( conj(YNMnTilde.')*EnTilde*WnnTilde)-...
                 trace( conj(YNMmTilde.')*EnTilde*WnmTilde);
       end
        

        
        
       
        ToNeighborsRegSum=cvx(0); % here n is the primary (because it's a to bus neighbor)
       
        
        % instead of the composite line model we use the new power flow formulation
     for jj=1:length(Bus.ToNeighborsRegulatorBranchNumbers{n})
            l=Bus.ToNeighborsRegulatorBranchNumbers{n}(jj); % branch number
            YNMnTilde=zeros(3); 
            YNMmTilde=zeros(3); 
            YNMnTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YNMn;
                YNMmTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YNMm;

%      
            
            for PhiPrime=1:length(PhaseSet)
                UnmTilde=cvx(zeros(3));
                if length(Branch.Phases{l})==3
                rr=find(Branch.Regs3PhiBranchNumbers==l); 
                UnmTilde(Branch.Phases{l},Branch.Phases{l})=UPhiPhiPrime3Phi(:,:,rr,Phi,PhiPrime);
            elseif length(Branch.Phases{l})==2
                rr=find(Branch.Regs2PhiBranchNumbers==l); 
                UnmTilde(Branch.Phases{l},Branch.Phases{l})=UPhiPhiPrime2Phi(:,:,rr,Phi,PhiPrime);
                else 
              rr=find(Branch.Regs1PhiBranchNumbers==l); 
                UnmTilde(Branch.Phases{l},Branch.Phases{l})=UPhiPhiPrime1Phi(:,:,rr,Phi,PhiPrime);
            end
                ToNeighborsRegSum=ToNeighborsRegSum+...
                trace( conj(YNMnTilde.')*UnmTilde);
            end
    
              PsinmTilde=cvx(zeros(3));
               if length(Branch.Phases{l})==3
                rr=find(Branch.Regs3PhiBranchNumbers==l); 
                PsinmTilde(Branch.Phases{l},Branch.Phases{l})=PsiPhi3Phi(:,:,rr,Phi);
            elseif length(Branch.Phases{l})==2
                rr=find(Branch.Regs2PhiBranchNumbers==l); 
                PsinmTilde(Branch.Phases{l},Branch.Phases{l})=PsiPhi2Phi(:,:,rr,Phi);
                else 
              rr=find(Branch.Regs1PhiBranchNumbers==l); 
                PsinmTilde(Branch.Phases{l},Branch.Phases{l})=PsiPhi1Phi(:,:,rr,Phi);
            end
              ToNeighborsRegSum=ToNeighborsRegSum-...
                 trace( conj(YNMmTilde.')*PsinmTilde);
        end

           
        FromNeighborsRegSum=cvx(0);
       
    

        
      for jj=1:length(Bus.FromNeighborsRegulatorBranchNumbers{n})
            l=Bus.FromNeighborsRegulatorBranchNumbers{n}(jj); % branch number
            YNMnTilde=zeros(3); 
            YNMmTilde=zeros(3); 
          
            
            YNMnTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YMNm; % because we are the recipient
                YNMmTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.YMNn;

       
            FromNeighborsRegSum=FromNeighborsRegSum+...
                trace( conj(YNMnTilde.')*EnTilde*WnnTilde);
            
            
             
            for PhiPrime=1:length(PhaseSet)
                 PsinmTilde=cvx(zeros(3));
               if length(Branch.Phases{l})==3
                rr=find(Branch.Regs3PhiBranchNumbers==l); 
                PsinmTilde(Branch.Phases{l},Branch.Phases{l})=conj(PsiPhi3Phi(:,:,rr,PhiPrime).');
            elseif length(Branch.Phases{l})==2
                rr=find(Branch.Regs2PhiBranchNumbers==l); 
                PsinmTilde(Branch.Phases{l},Branch.Phases{l})=conj(PsiPhi2Phi(:,:,rr,PhiPrime).');
                else 
              rr=find(Branch.Regs1PhiBranchNumbers==l); 
                PsinmTilde(Branch.Phases{l},Branch.Phases{l})=conj(PsiPhi1Phi(:,:,rr,PhiPrime).');
            end
                FromNeighborsRegSum=FromNeighborsRegSum-...
                trace( conj(YNMmTilde.')*EnTilde*PsinmTilde);
            end
            
     end

        
      
     
     if n~=Bus.SubstationNumber
   real( Sg(PhiCnt))-real(Bus.SLoad{n}(Phi))==real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
       ToNeighborsRegSum+ FromNeighborsRegSum+trace( conj(YCapTilde.')*EnTilde*WnnTilde));
       imag(Sg(PhiCnt)) -imag(Bus.SLoad{n}(Phi))==imag(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
            ToNeighborsRegSum+ FromNeighborsRegSum+trace( conj(YCapTilde.')*EnTilde*WnnTilde));

        
         PowerFlowConstraintsP(PhiCnt)=real( Sg(PhiCnt))-real(Bus.SLoad{n}(Phi))-...
        real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
       ToNeighborsRegSum+ FromNeighborsRegSum+trace( conj(YCapTilde.')*EnTilde*WnnTilde));
   
      
         PowerFlowConstraintsQ(PhiCnt)=real( Sg(PhiCnt))-real(Bus.SLoad{n}(Phi))-...
        real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
       ToNeighborsRegSum+ FromNeighborsRegSum+trace( conj(YCapTilde.')*EnTilde*WnnTilde));
   
      
      ThermalLossExpression=ThermalLossExpression+ real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
         ToNeighborsRegSum+ FromNeighborsRegSum);
   
     else
     real(SIn(Phi,1))-real(Bus.SLoad{n}(Phi))==real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
         ToNeighborsRegSum+ FromNeighborsRegSum+trace( conj(YCapTilde.')*EnTilde*WnnTilde));
     
              imag(SIn(Phi,1))-imag(Bus.SLoad{n}(Phi))==imag(ToNeighborsNonRegSum+FromNeighborsNonRegSum+....
                  ToNeighborsRegSum+ FromNeighborsRegSum+trace( conj(YCapTilde.')*EnTilde*WnnTilde));
  
              Sg(PhiCnt)==0;
              
                 
      ThermalLossExpression=ThermalLossExpression+ real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
         ToNeighborsRegSum+ FromNeighborsRegSum);
              
              PowerFlowConstraintsP(PhiCnt)= real(SIn(Phi,1))-real(Bus.SLoad{n}(Phi))-...
                  real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
         ToNeighborsRegSum+ FromNeighborsRegSum+trace( conj(YCapTilde.')*EnTilde*WnnTilde));
     
     PowerFlowConstraintsQ(PhiCnt)=  imag(SIn(Phi,1))-imag(Bus.SLoad{n}(Phi))-...
         imag(ToNeighborsNonRegSum+FromNeighborsNonRegSum+....
                  ToNeighborsRegSum+ FromNeighborsRegSum+trace( conj(YCapTilde.')*EnTilde*WnnTilde));
     end
    
     
  

   
    
    end

end


ThermalLoss==ThermalLossExpression;