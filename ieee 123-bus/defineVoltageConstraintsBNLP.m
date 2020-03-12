

% SlackVoltage constraint
Constraints=[Constraints,vn3Phi(:,Bus.ThreePhaseBusNumbers==Bus.SubstationNumber)==vS];





for n=1:NBuses3Phi
    if Bus.ThreePhaseBusNumbers(n)~=Bus.SubstationNumber
        % voltage bounds constraint
   Constraints=[Constraints,  abs(vn3Phi(:,n)) <=VMAX];
%    Constraints=[Constraints,  sqrtm(real((vn3Phi(:,n)).^2+imag(vn3Phi(:,n)).^2)) >=VMIN];

Constraints=[Constraints, real(vn3Phi(:,n)).^2+imag(vn3Phi(:,n)).^2>=VMIN.^2];

BusNumber=Network.Bus.ThreePhaseBusNumbers(n);
assign(vn3Phi(:,n),Network.Solution.v3Phase(BusNumber,Bus.Phases{BusNumber}).');
    end
end
for n=1:NBuses2Phi
            % voltage bounds constraint
    Constraints=[Constraints, abs(vn2Phi(:,n)) <=VMAX];
%          Constraints=[Constraints,  sqrtm(real((vn2Phi(:,n)).^2+imag(vn2Phi(:,n)).^2)) >=VMIN];
Constraints=[Constraints, real(vn2Phi(:,n)).^2+imag(vn2Phi(:,n)).^2>=VMIN.^2];

BusNumber=Network.Bus.TwoPhaseBusNumbers(n);
assign(vn2Phi(:,n),Network.Solution.v3Phase(BusNumber,Bus.Phases{BusNumber}).');
end

for n=1:NBuses1Phi
    % voltage bounds constraint
   Constraints=[Constraints,  abs(vn1Phi(:,n)) <=VMAX];
%    Constraints=[Constraints,  sqrtm(real((vn1Phi(:,n)).^2+imag(vn1Phi(:,n)).^2)) >=VMIN];
Constraints=[Constraints, real(vn1Phi(:,n)).^2+imag(vn1Phi(:,n)).^2>=VMIN.^2];

BusNumber=Network.Bus.OnePhaseBusNumbers(n);
assign(vn1Phi(:,n),Network.Solution.v3Phase(BusNumber,Bus.Phases{BusNumber}).');

end



for l=1:NBranches
    
    
     n=Branch.BusFromNumbers(l); 
    m=Branch.BusToNumbers(l);
   
   
    vnTilde=sdpvar(3,1,'full','complex');
    vmTilde=sdpvar(3,1,'full','complex'); 
    
    
       if length(Bus.Phases{n})==3
        kk=find(Bus.ThreePhaseBusNumbers==n);
        vnTilde(Bus.Phases{n})=vn3Phi(:,kk); 
        
    elseif length(Bus.Phases{n})==2
        kk=find(Bus.TwoPhaseBusNumbers==n);
        vnTilde(Bus.Phases{n})=vn2Phi(:,kk); 
    else 
        kk=find(Bus.OnePhaseBusNumbers==n); 
        vnTilde(Bus.Phases{n})=vn1Phi(:,kk); 
       end
    
               vnTilde(setdiff([1;2;3],Bus.Phases{n}),1)=0;

   
          if length(Bus.Phases{m})==3
        kk=find(Bus.ThreePhaseBusNumbers==m);
        vmTilde(Bus.Phases{m}, 1)=vn3Phi(:,kk); 
        
    elseif length(Bus.Phases{m})==2
        kk=find(Bus.TwoPhaseBusNumbers==m);
        vmTilde(Bus.Phases{m},1)=vn2Phi(:,kk); 
    else 
        kk=find(Bus.OnePhaseBusNumbers==m); 
        vmTilde(Bus.Phases{m}, 1)=vn1Phi(:,kk); 
          end
                  vmTilde(setdiff([1;2;3],Bus.Phases{m}),1)=0;

    
          
    if ~strcmp(Branch.Device{l},'Reg')
         
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
    
    ZNMTilde=zeros(3);
        
    
     ZNMTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.ZNM;
       Constraints=[Constraints, vmTilde(Branch.Phases{l},1)==vnTilde(Branch.Phases{l},1)-...
        ZNMTilde(Branch.Phases{l},Branch.Phases{l})*inmTilde(Branch.Phases{l},1)];
         
    else
        
        inmTilde=sdpvar(3,1,'full','complex'); 
        vnmPrimeTilde=sdpvar(3,1,'full','complex'); 
        inmPrimeTilde=sdpvar(3,1,'full','complex'); 
%             
          if length(Branch.Phases{l})==3
                      rr=find(Branch.Regs3PhiBranchNumbers==l);
        ll=find(Branch.ThreePhaseBranchNumbers==l); 
         inmTilde(Branch.Phases{l},1)=inm3Phi(:,ll);      
        vnmPrimeTilde(Branch.Phases{l},1)=vnmPrime3Phi(:,rr);
        inmPrimeTilde(Branch.Phases{l},1)=inmPrime3Phi(:,rr); 
      
            
         

    elseif length(Branch.Phases{l})==2
            rr=find(Branch.Wye2PhiBranchNumbers==l);
     ll=find(Branch.TwoPhaseBranchNumbers==l); 
            inmTilde(Branch.Phases{l},1)=inm2Phi(:,ll);
            vnmPrimeTilde(Branch.Phases{l},1)=vnmPrime2Phi(:,rr);
            inmPrimeTilde(Branch.Phases{l},1)=inmPrime2Phi(:,rr);

          else
           rr=find(Branch.Wye1PhiBranchNumbers==l);
         ll=find(Branch.OnePhaseBranchNumbers==l); 
        inmTilde(Branch.Phases{l},1)=inm1Phi(:,ll);
          
         
         
              vnmPrimeTilde(Branch.Phases{l},1)=vnmPrime1Phi(:,rr);
       inmPrimeTilde(Branch.Phases{l},1)=inmPrime1Phi(:,rr);
          
        
          end
    
          inmTilde(setdiff([1;2;3],Branch.Phases{l}),1)=0; 
          vnmPrimeTilde(setdiff([1;2;3],Branch.Phases{l}),1)=0; 
          inmPrimeTilde(setdiff([1;2;3],Branch.Phases{l}),1)=0; 

    
    ZNMTilde=zeros(3);
        
    
     ZNMTilde(Branch.Phases{l},Branch.Phases{l})=Branch.Admittance{l}.ZNM;
      Constraints=[Constraints,  vmTilde(Branch.Phases{l},1)==vnmPrimeTilde(Branch.Phases{l},1)-...
        ZNMTilde(Branch.Phases{l},Branch.Phases{l})*inmPrimeTilde(Branch.Phases{l},1)];    
  

    end
    
    
   
    

     
    
    
    
     
    
 
    
    
    

        
    end
    





    
