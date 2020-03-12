function [ y] = getCodesInString(x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

y=x;
if isequal(class(x),'double')
    y=num2str(x);
end

end

