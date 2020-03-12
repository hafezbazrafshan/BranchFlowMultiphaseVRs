function Vsol =performZBus( vPr,Branch, Bus,Y,YNS,MaxIt,vS,VMIN,VMAX)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here








err=inf+zeros(MaxIt+1,1);


vIterations=zeros(size(vPr,1),MaxIt+1);
vIterations(:,1)=vPr;
VNew=vPr;

if ~isfield(Bus,'SgVec')
Fv= -fPQ( vPr,Bus.SLoadVec(1:end-3));
else
Fv= -fPQ( vPr,Bus.SLoadVec(1:end-3)-Bus.SgVec(1:end-3));
end



 err(1)=sum(abs(Y*vPr-Fv+YNS*vS));
str=['Iteration No. ', num2str(0),' Error is ', num2str(err(1)), '\n'];
fprintf(str);
 for it=1:MaxIt
     
      if err(it) <1e-8
     itSuccess=it-1;
     fprintf('Convergence \n');
     success=1;
     break;
      end 
      
      
      


VNew=Y\ (Fv-YNS*vS);
% VNew=max([min([abs(VNew),repmat(VMAX,length(VNew),1)],[],2),...
%     repmat(VMIN,length(VNew),1)],[],2).*exp(sqrt(-1)*angle(VNew));
vIterations(:,it+1)=VNew;
 vPr=VNew;
if ~isfield(Bus,'SgVec')
Fv= -fPQ( vPr,Bus.SLoadVec(1:end-3));
else
Fv= -fPQ( vPr,Bus.SLoadVec(1:end-3)-Bus.SgVec(1:end-3));
end
 err(it+1)=sum(abs(Y*VNew-Fv+YNS*vS));
 str=['Iteration No. ', num2str(it),' Error is ', num2str(err(it+1)), '\n'];
 fprintf(str);
 end
 
 
Vsol=VNew;
Vsol=[Vsol;vS];








end

