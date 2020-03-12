for n=1:NBuses % project onto three-phase space
    PhaseSet=Bus.Phases{n};
    
      % allocating correct indices
        vnTilde=sdpvar(3,1,'full','complex'); 
        SgTilde=sdpvar(3,1,'full','complex'); 

        SnTilde=zeros(3,1);
        YCapTilde=zeros(3);
        if ~isempty(Bus.YCap{n})
        YCapTilde(PhaseSet,PhaseSet)=diag(Bus.YCap{n});
        end
     if length(PhaseSet)==3
            nn=find(Bus.ThreePhaseBusNumbers==n);
            vnTilde(PhaseSet,1)=vn3Phi(:,nn);
            SnTilde(PhaseSet,1)=Bus.SLoad{n};
            SgTilde(PhaseSet,1)=Sg3Phi(:,nn);

        elseif length(PhaseSet)==2
            nn=find(Bus.TwoPhaseBusNumbers==n);
            vnTilde(PhaseSet,1)=vn2Phi(:,nn);
            SnTilde(PhaseSet,1)=Bus.SLoad{n};
            SgTilde(PhaseSet,1)=Sg2Phi(:,nn);

        else
            nn=find(Bus.OnePhaseBusNumbers==n);
            vnTilde(PhaseSet,1)=vn1Phi(:,nn);
            SnTilde(PhaseSet,1)=Bus.SLoad{n};
            SgTilde(PhaseSet,1)=Sg1Phi(:,nn);

     end
        
     vnTilde(setdiff([1;2;3],PhaseSet),1)=0;
      
      %  To neighbors regular lines or transformers
        ToNeighborsNonRegSum=zeros(3,1);
        
        for jj=1:length(Bus.ToNeighborsNonRegulatorBranchNumbers{n})
            l=Bus.ToNeighborsNonRegulatorBranchNumbers{n}(jj); % branch number
            inmTilde=sdpvar(3,1,'full','complex'); 

            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                inmTilde(Branch.Phases{l},1)=inm3Phi(:,ll);
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                inmTilde(Branch.Phases{l},1)=inm2Phi(:,ll);
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                inmTilde(Branch.Phases{l},1)=inm1Phi(:,ll);
            end
            
            inmTilde(setdiff([1;2;3],Branch.Phases{l}),1)=0;

            ToNeighborsNonRegSum=ToNeighborsNonRegSum+diag(vnTilde*inmTilde');
               

        end
  
       % from neighbors regular lines or transformers
        
               FromNeighborsNonRegSum=zeros(3,1);
        
       for jj=1:length(Bus.FromNeighborsNonRegulatorBranchNumbers{n})
            l=Bus.FromNeighborsNonRegulatorBranchNumbers{n}(jj); % branch number
            inmTilde=sdpvar(3,1,'full','complex');

          
            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
               inmTilde(Branch.Phases{l},1)=inm3Phi(:,ll);
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
               inmTilde(Branch.Phases{l},1)=inm2Phi(:,ll);
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                  inmTilde(Branch.Phases{l},1)=inm1Phi(:,ll);
            end
   
            inmTilde(setdiff([1;2;3],Branch.Phases{l}),1)=0;
            FromNeighborsNonRegSum=FromNeighborsNonRegSum+diag(vnTilde*inmTilde');
            
           
            
            
            
               
       end
        

        
        
       
        ToNeighborsRegSum=zeros(3,1); % here n is the primary (because it's a to bus neighbor)
       
        
        for jj=1:length(Bus.ToNeighborsRegulatorBranchNumbers{n})
            l=Bus.ToNeighborsRegulatorBranchNumbers{n}(jj); % branch number
            inmTilde=sdpvar(3,1,'full','complex');
     

              if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                inmTilde(Branch.Phases{l},1)=inm3Phi(:,ll);
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                inmTilde(Branch.Phases{l},1)=inm2Phi(:,ll);
            else 
                 ll=find(Branch.OnePhaseBranchNumbers==l); 
                inmTilde(Branch.Phases{l},1)=inm1Phi(:,ll);
            end
            
            inmTilde(setdiff([1;2;3],Branch.Phases{l}),1)=0;

            ToNeighborsRegSum=ToNeighborsRegSum+diag(vnTilde*inmTilde');
               
        end

           
        FromNeighborsRegSum=zeros(3,1);
        
       for jj=1:length(Bus.FromNeighborsRegulatorBranchNumbers{n})
            l=Bus.FromNeighborsRegulatorBranchNumbers{n}(jj); % branch number
            inmPrimeTilde=sdpvar(3,1,'full','complex');
%             inmTilde=sdpvar(3,1,'full','complex'); regular line
            if length(Branch.Phases{l})==3
                ll=find(Branch.ThreePhaseBranchNumbers==l); 
                 rr=find(Branch.Regs3PhiBranchNumbers==l); 
               inmPrimeTilde(Branch.Phases{l},1)=inmPrime3Phi(:,rr);
% inmTilde(Branch.Phases{l},1)=inm3Phi(:,ll);  
            elseif length(Branch.Phases{l})==2
                 ll=find(Branch.TwoPhaseBranchNumbers==l); 
                 rr=find(Branch.Wye2PhiBranchNumbers==l); 

               inmPrimeTilde(Branch.Phases{l},1)=inmPrime2Phi(:,rr);
% inmTilde(Branch.Phases{l},1)=inm2Phi(:,ll); 

            else 
%                  ll=find(Branch.OnePhaseBranchNumbers==l); 
                 rr=find(Branch.Wye1PhiBranchNumbers==l); 
                  inmPrimeTilde(Branch.Phases{l},1)=inmPrime1Phi(:,rr);
% inmPrimeTilde(Branch.Phases{l},1)=inm1Phi(:,ll); 

            end
   
            inmPrimeTilde(setdiff([1;2;3],Branch.Phases{l}),1)=0;
            FromNeighborsRegSum=FromNeighborsRegSum+diag(vnTilde*inmPrimeTilde');
            
           
            
            
            
               
       end
        
      
     
     if n~=Bus.SubstationNumber
         
         
         Constraints=[Constraints,FromNeighborsNonRegSum+FromNeighborsRegSum-...
            diag(vnTilde*vnTilde'*conj(YCapTilde.'))-SnTilde-ToNeighborsNonRegSum-ToNeighborsRegSum+SgTilde==0];
         
        
         PowerFlowConstraintsP((n-1)*3+1:3*n)=real(FromNeighborsNonRegSum+FromNeighborsRegSum-...
             diag(vnTilde*vnTilde'*conj(YCapTilde.'))-SnTilde-ToNeighborsNonRegSum-ToNeighborsRegSum);

         
          PowerFlowConstraintsQ((n-1)*3+1:3*n)=imag(FromNeighborsNonRegSum+FromNeighborsRegSum-...
             diag(vnTilde*vnTilde'*conj(YCapTilde.'))-SnTilde-ToNeighborsNonRegSum-ToNeighborsRegSum);
        

   
     else

Constraints=[Constraints,SIn+FromNeighborsNonRegSum+FromNeighborsRegSum-...
             diag(vnTilde*vnTilde'*conj(YCapTilde.'))-SnTilde-ToNeighborsNonRegSum-ToNeighborsRegSum==0];


         
         

         PowerFlowConstraintsP((n-1)*3+1:3*n)=real(SIn+FromNeighborsNonRegSum+FromNeighborsRegSum-...
             diag(vnTilde*vnTilde'*conj(YCapTilde.'))-SnTilde-ToNeighborsNonRegSum-ToNeighborsRegSum);

         
          PowerFlowConstraintsQ((n-1)*3+1:3*n)=imag(SIn+FromNeighborsNonRegSum+FromNeighborsRegSum-...
             diag(vnTilde*vnTilde'*conj(YCapTilde.'))-SnTilde-ToNeighborsNonRegSum-ToNeighborsRegSum);

   
   

     end
    
     
  
   
   
   
    
    end





