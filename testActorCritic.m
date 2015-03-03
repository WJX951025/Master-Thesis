%testActorCritic run an actor critic RL controller for a 1-DoF inverted pendulum
%
% Copyright 2015 Yudha Pane

clear; clc; close all;
loadParams;

x0  = [pi ;0];  % initial state
e0  = 1;        % initial eligibility trace
k = 1;
Phi(:,k) = params.phi;
Theta(:,k) = params.theta;

for counter = 1: params.Ntrial
    u(k) = 2*rand; urand(k) = 0;      % initialize input and exploration signal
    r(k) = 0;                       % initialize reward/cost
    z_c(:,k) = zeros(params.NrbfX*params.NrbfY,1);
    z_a(:,k) = zeros(params.NrbfX*params.NrbfY,1);
    
    % Memory variabes    
    X(:,k) = x0;

%     E(k) = e0;      % eligibility trace
    counter         % check counter   
    for t = 0: params.ts: params.t_end
        time = [t t+params.ts];
        
        % apply u(k), measure x(k+1), receive r(k+1)
        [clock,x]   = ode45(@(t,x) oneDofRobot(t, x, u(k), params), time, x0);
        x           = transpose(x);
        x(1,:)      = wrapTo2Pi(x(1,:));    % convert the angle to 2pi rad
        X(:,k+1)    = x(:,end);             % get the state measurement
        r(k+1)      = calcCost(X(:,k), u(k), params); % calculate the cost / reward 
        
        % compute next action u(k+1)
        if mod(k,3) == 0
            urand(k+1)  = randn;            % explore only once every three time steps                           
        else
            urand(k+1)  = urand(k);
        end
        u(k+1)      = actor(X(:,k+1), params) + urand(k+1);
        Delta_u     = actSaturate(u(k+1), params) - u(k+1);
        u(k+1)      = actSaturate(u(k+1), params);                  % input saturation
        
        % calculate temporal difference signal 
        V(k)        = critic(X(:,k), params);                       % V(x(k))
        V(k+1)      = critic(X(:,k+1), params);                     % V(x(k+1))
        delta(k)    = r(k+1) + params.gamma*V(k+1) - V(k);
        
        
        %% Formula from [1] section IV A
%         if (k > 1)
%             z_a(:,k) = params.lambda_a*z_a(:,k-1) + (1-params.lambda_a)*u(k)*rbf(X(:,end),params);
%             z_c(:,k) = params.lambda_c*z_c(:,k-1) + (1-params.lambda_c)*rbf(X(:,end),params);
%         end
%         % Update actor and critic
%         % using formula from [1]
%         params.theta    = params.theta + params.alpha_c*delta(k).*z_c(:,k);         % critic
%         params.phi      = params.phi + params.alpha_a*delta(k)*urand(k).*z_a(:,k);   % actor
        
        %% Formula I created on my own
        params.theta    = params.theta + params.alpha_c*delta(k)*rbf(X(:,end), params);         % critic
        params.phi      = params.phi + params.alpha_a*delta(k)*urand(k)*rbf(X(:,end),params);   % actor
        
        Phi(:,k+1)      = params.phi;
        Theta(:,k+1)    = params.theta;
        x0              = x(:,end);
        k               = k+1;
    end
    
    % Plotting purpose
    subplot(2,1,1);
    plotOut = plotrbf(params, 'critic',params.plotopt); title('critic');
    xlabel('theta'); ylabel('theta dot'); colorbar  
    subplot(2,1,2);
    plotOut = plotrbf(params, 'actor',params.plotopt); title('actor'); xlabel('theta'); ylabel('theta dot'); colorbar 
    pause(0.2);
    
end

Q = X(1,:);
spacing = 10;
animateRobot(0, Q(1:spacing:end));


%% References:
% [1] A Survey of Actor-Critic Reinforcement Learning: Standard and Natural Policy Gradients
