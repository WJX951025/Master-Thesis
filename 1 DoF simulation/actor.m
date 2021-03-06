function action = actor(state, params) 
%ACTOR calculates the actor output at a certain state
%
%   V = actor(state, params) calculates the action at state according to
%       the policy approximated by rbfs. The parameters are defined in params
% 
% Copyright 2015 Yudha Pane

    action = params.phi'*rbf(state,params);     % calculate action
    
    
    

    