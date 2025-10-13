function p_t = stagnp(p, M, gamma)
%STAGNP Summary of this function goes here
%   Detailed explanation goes here

p_t = p * (1+(gamma-1)*M^2/2)^(gamma/(gamma-1));

end

