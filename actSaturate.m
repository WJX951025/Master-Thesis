function usat = actSaturate(u, params)
%actSaturate calculate the saturated input value
%
%   usat =  actSaturate(u, params) calculate the saturated value for input
%           u. If u is within saturation region, usat is the same as u. If not, then 
%           usat is equal to the saturation value defined in params.
% 
% Copyright 2015 Yudha Pane
    if u > params.uSat
        usat = params.uSat;
    elseif u < -params.uSat
        usat = -params.uSat;
    else
        usat = u;
    end
    