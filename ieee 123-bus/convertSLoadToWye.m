function [ sloadwye] = convertSLoadToWye( sload )
%CONVERTSLOADTOWYE converts a delta load to wye. 
%   sloadwye=convertSLoadToWye(sLoad) converts the constant-power delta
%   load given by 'sload' to its approximate constant-power wye load
%   'sloadwye'. The method is approximate since the delta-to-wye conversion
%   is approximate and it only is accurate when constant-impedance load
%   model is employed.


% This wye-to-delta conversion is adopted from https://github.com/saveriob/1ACPF/blob/master/ieee13.m
a = exp(-1j*2*pi/3);
aaa = [1; a; a^2];
% Wye to Delta conversion
aba = 1/(1-a);
caa = -1/(a^2-1);
bcb = 1/(1-a);
abb = -a/(1-a);
cac = a^2/(a^2-1);
bcc = -a^2/(a-a^2);


sloadwye= ([aba, 0, caa; abb, bcb,0; 0, bcc, cac]*sload);
% sloadwye=[(sload(1)+sload(3))/2; (sload(1)+sload(2))/2; (sload(2)+sload(3))/2 ];
    



end

