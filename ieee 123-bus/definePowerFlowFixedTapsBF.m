%%  implementing power flow equations per node and per phase
ThermalLossExpression=cvx(0);

for n=1:NBuses % project onto three-phase space
    PhaseSet=Bus.Phases{n};
      % allocating correct indices
        VnnTilde=cvx(zeros(3));
        SnTilde=cvx(zeros(3,1));
        YCapTilde=zeros(3);
        if ~isempty(Bus.YCap{n})
        YCapTilde(PhaseSet,PhaseSet)=diag(Bus.YCap{n});
        end
     if length(PhaseSet)==3
            nn=find(Bus.ThreePhaseBusNumbers==n);
            VnnTilde(PhaseSet,PhaseSet)=Vnn3Phi(:,:,nn);
            SnTilde(PhaseSet,1)=Bus.SLoad{n};
        elseif length(PhaseSet)==2
            nn=find(Bus.TwoPhaseBusNumbers==n);
            VnnTilde(PhaseSet,PhaseSet)=Vnn2Phi(:,:,nn);
            SnTilde(PhaseSet,1)=Bus.SLoad{n};
        else
            nn=find(Bus.OnePhaseBusNumbers==n);
            VnnTilde(PhaseSet,PhaseSet)=Vnn1Phi(:,:,nn);
            SnTilde(PhaseSet,1)=Bus.SLoad{n};
     end
        
     
      
      %  To neighbors regular lines or transformers
        ToNeighborsNonRegSum=cvx(zeros(3,1));
        
        for jj=1:length(Bus.ToNeighborsNonRegulatorBranchNumbers{n})
            l=Bus.ToNeighborsNonRegulatorBranchNumbers{n}(jj); % branch number
            SnmTilde=cvx(zeros(3));
            ZNMTilde=zeros(3); 
            ZNMTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.ZNM;

            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm3Phi(:,:,ll);
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm2Phi(:,:,ll);
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                 SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm1Phi(:,:,ll);
            end

            ToNeighborsNonRegSum=ToNeighborsNonRegSum+diag(SnmTilde);
               

        end
  
       % from neighbors regular lines or transformers
        
               FromNeighborsNonRegSum=cvx(zeros(3,1));
        
       for jj=1:length(Bus.FromNeighborsNonRegulatorBranchNumbers{n})
            l=Bus.FromNeighborsNonRegulatorBranchNumbers{n}(jj); % branch number
            SnmTilde=cvx(zeros(3));
            InmTilde=cvx(zeros(3));
           ZNMTilde=zeros(3); 
            ZNMTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.ZNM; 

          
            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm3Phi(:,:,ll);
               InmTilde(Branch.Phases{l},Branch.Phases{l})=Inm3Phi(:,:,ll);
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm2Phi(:,:,ll);
               InmTilde(Branch.Phases{l},Branch.Phases{l})=Inm2Phi(:,:,ll);
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                 SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm1Phi(:,:,ll);
                  InmTilde(Branch.Phases{l},Branch.Phases{l})=Inm1Phi(:,:,ll);
            end
   
            FromNeighborsNonRegSum=FromNeighborsNonRegSum+diag(SnmTilde)-diag(ZNMTilde*InmTilde);
            
           
            
            
            
               
       end
        

        
        
       
        ToNeighborsRegSum=cvx(zeros(3,1)); % here n is the primary (because it's a to bus neighbor)
       
        
        for jj=1:length(Bus.ToNeighborsRegulatorBranchNumbers{n})
            l=Bus.ToNeighborsRegulatorBranchNumbers{n}(jj); % branch number
            SnmTilde=cvx(zeros(3));
            ZNMTilde=zeros(3); 

     

            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm3Phi(:,:,ll);
                 rr=find(Branch.Regs3PhiBranchNumbers==l); 
                 
                 if strcmp(Branch.RegulatorTypes(rr),'Wye') 
                     rrr=find(Branch.Wye3PhiBranchNumbers==l);
                    Av=Branch.Wye3PhiAvs{rrr};
            
                 elseif strcmp(Branch.RegulatorTypes(rr),'ClosedDelta')
                     rrr=find(Branch.ClosedDeltaBranchNumbers==l);
                     Av=Branch.ClosedDeltaAvs{rrr};
                 else
                     rrr=find(Branch.OpenDeltaBranchNumbers==l);
                     Av=Branch.OpenDeltaAvs{rrr};
                 end
                 
   
                 
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm2Phi(:,:,ll);
                 rr=find(Branch.Wye2PhiBranchNumbers==l);
                    Av=Branch.Wye2PhiAvs{rr};
            else 
                  ll=find(Branch.OnePhaseBranchNumbers==l); 
                 SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm1Phi(:,:,ll);
                 rrr=find(Branch.Wye1PhiBranchNumbers==l);
                    Av=Branch.Wye1PhiAvs{rrr};
               
            end
            
            
 ZNMTilde(Branch.Phases{l},Branch.Phases{l})=Av*Branch.Admittance{l}.ZNM*Av.';
                 

            ToNeighborsRegSum=ToNeighborsRegSum+diag(SnmTilde);

        end

           
        FromNeighborsRegSum=cvx(zeros(3,1));
       
    

     
        for jj=1:length(Bus.FromNeighborsRegulatorBranchNumbers{n})
            l=Bus.FromNeighborsRegulatorBranchNumbers{n}(jj); % branch number
            SnmTilde=cvx(zeros(3));
            InmTilde=cvx(zeros(3)); 
           ZNMTilde=zeros(3); 

            
           

            
            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm3Phi(:,:,ll);
                 InmTilde(Branch.Phases{l},Branch.Phases{l})=Inm3Phi(:,:,ll);
                 rr=find(Branch.Regs3PhiBranchNumbers==l); 
                if strcmp(Branch.RegulatorTypes(rr),'Wye')
                     rrr=find(Branch.Wye3PhiBranchNumbers==l);
                     Av=Branch.Wye3PhiAvs{rrr};
                 elseif strcmp(Branch.RegulatorTypes(rr),'ClosedDelta')
                     rrr=find(Branch.ClosedDeltaBranchNumbers==l);
                     Av=Branch.ClosedDeltaAvs{rrr};
                 else
                     rrr=find(Branch.OpenDeltaBranchNumbers==l);
                     Av=Branch.OpenDeltaAvs{rrr};
                end

            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                    SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm2Phi(:,:,ll);
                 InmTilde(Branch.Phases{l},Branch.Phases{l})=Inm2Phi(:,:,ll);                
                 rr=find(Branch.Wye2PhiBranchNumbers==l);
                    Av=Branch.Wye2PhiAvs{rr};
            else 
                  ll=find(Branch.OnePhaseBranchNumbers==l); 
                    SnmTilde(Branch.Phases{l},Branch.Phases{l})=Snm1Phi(:,:,ll);
                 InmTilde(Branch.Phases{l},Branch.Phases{l})=Inm1Phi(:,:,ll);   
                 rrr=find(Branch.Wye1PhiBranchNumbers==l);
                    Av=Branch.Wye1PhiAvs{rrr};
               
            end
            
   
            
            
                 ZNMTilde(Branch.Phases{l},Branch.Phases{l})=Av*Branch.Admittance{l}.ZNM*Av.'; % because we are the recipient
                
            FromNeighborsRegSum=FromNeighborsRegSum+diag(SnmTilde)-diag(ZNMTilde*InmTilde);
       end
        
        
      
     
     if n~=Bus.SubstationNumber
         
         
         FromNeighborsNonRegSum+FromNeighborsRegSum-...
            diag(VnnTilde*conj(YCapTilde.'))-SnTilde-ToNeighborsNonRegSum-ToNeighborsRegSum==0;
         
        
         PowerFlowConstraintsP((n-1)*3+1:3*n)=real(FromNeighborsNonRegSum+FromNeighborsRegSum-...
             diag(VnnTilde*conj(YCapTilde.'))-SnTilde-ToNeighborsNonRegSum-ToNeighborsRegSum);

         
          PowerFlowConstraintsQ((n-1)*3+1:3*n)=imag(FromNeighborsNonRegSum+FromNeighborsRegSum-...
             diag(VnnTilde*conj(YCapTilde.'))-SnTilde-ToNeighborsNonRegSum-ToNeighborsRegSum);
        

     ThermalLossExpression=ThermalLossExpression+ sum(real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
         ToNeighborsRegSum+ FromNeighborsRegSum));
   
     else

SIn+FromNeighborsNonRegSum+FromNeighborsRegSum-...
             diag(VnnTilde*conj(YCapTilde.'))-SnTilde-ToNeighborsNonRegSum-ToNeighborsRegSum==0;


         
         

         PowerFlowConstraintsP((n-1)*3+1:3*n)=real(SIn+FromNeighborsNonRegSum+FromNeighborsRegSum-...
             diag(VnnTilde*conj(YCapTilde.'))-SnTilde-ToNeighborsNonRegSum-ToNeighborsRegSum);

         
          PowerFlowConstraintsQ((n-1)*3+1:3*n)=imag(SIn+FromNeighborsNonRegSum+FromNeighborsRegSum-...
             diag(VnnTilde*conj(YCapTilde.'))-SnTilde-ToNeighborsNonRegSum-ToNeighborsRegSum);

   
   

     ThermalLossExpression=ThermalLossExpression+ sum(real(ToNeighborsNonRegSum+FromNeighborsNonRegSum+...
         ToNeighborsRegSum+ FromNeighborsRegSum));
     end
    
     
  
   
   
   
    
    end





ThermalLoss==ThermalLossExpression;