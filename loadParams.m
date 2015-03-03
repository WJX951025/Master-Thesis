%LOADPARAMS define all necessary parameters before running the actor critic
%           algorithm
%
% Copyright 2015 Yudha Pane

params.Ntrial   = 600;                                  % no of trials
params.NrbfX    = 10;                                   % no of rbfs in q dimension
params.NrbfY    = 10;                                   % no of rbfs in qdot dimension

params.phi      = ones(params.NrbfX*params.NrbfY,1);    % actor parameters
params.theta    = ones(params.NrbfX*params.NrbfY,1);	% critic parameters
params.ref      = [0; 0];                               % desired position (state) 

% generate center of rbf (2xN matrix)
qc          = linspace(-pi, pi, params.NrbfX);   
qc          = repmat(qc, [params.NrbfY,1]);
qc          = reshape(qc, [1, params.NrbfX*params.NrbfY]);
qdotc       = linspace(-10, 10, params.NrbfY);
qdotc       = repmat(qdotc, [1, params.NrbfX]);
params.c    = [qc; qdotc];                          % center coordinate of all rbfs

params.t_end    = 3;                                % final time    [s]
params.ts       = 1/125;                            % sampling time [s]

% RL parameters
params.B        = [0.06 0; 0 0.6];          % the rbf's variance
params.R        = 1;                        % the input cost function penalty
params.Q        = [5 0; 0 .1];              % the error cost function penalty
params.alpha_a  = 0.005;                    % actor learning rate
params.alpha_c  = 0.01;                     % critic learning rate
params.gamma    = 0.9;                      % discount term
params.lambda   = 0.65;                     %  
params.lambda_a   = 0.55;                   % eligibility trace for actor
params.lambda_c   = 0.85;                   % eligibility trace for critic


% Robot Parameters
params.J    = 1.91e-4;      % pendulum inertia [kgm^2]
params.m    = 5.50e-2;      % mass [kg]
params.g    = 9.81;         % gravity [m/s^2]
params.l    = 4.2e-2;       % link's length [m]
params.b    = 3e-6;         % damping [Nms]
params.K    = 5.36e-2;      % torque constant [Nm/A]
params.R    = 9.5;          % rotor resistance (ohm)
params.uSat = 3;            % voltage saturation value

% Various paramaters
% params.plotopt = '3d';      % the plot option, uncomment for use
params.plotopt = '2d';      % plot as 2d 
