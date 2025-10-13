function [T, p] = ISA(h)
%ISA Summary of this function goes here
%   Detailed explanation goes here

T_0 = 288.15;
p_0 = 101325;
alpha = 6.5;
R=287;
g=9.81;

T = T_0 - alpha*h/1000;
p = p_0 * (1 - alpha*h/(T_0*1000))^(g/(R*alpha/1000));

end

