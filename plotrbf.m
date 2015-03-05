function y = plotrbf(params, opt, opt2)
%PLOTRBF plot the radial basis functions-based approximated actor and critic function
%
%   y = plotrbf(params, opt, opt2) plot a rbf-based approximated function
%       with options as follows:
%       opt = 'actor' --> plot actor function
%       opt = 'critic' --> plot critic function
%       opt2 = '3d' --> visualized the function as a 3d surface
%       opt2 = '2d' --> visualized the function as 2d scaled color map
%
% Copyright 2015 Yudha Pane

    N       = 50;
    B       = params.B;
    theta   = params.theta;
    phi     = params.phi;
    c       = params.c;

    % generate coordinates for evaluation
    x1  = linspace(-pi, pi, N);   
    x2  = linspace(-params.qdotLim, params.qdotLim, N);

    X1  = repmat(x1, [N,1]);
    X1v = reshape(X1, [1, N*N]);
    X2v = repmat(x2, [1, N]);
    X   = [X1v; X2v];
    
    % for plotting purpose
    Xd      = X1;
    Yd      = repmat(transpose(x2), [1,N]);
    PhiSum  = zeros(N*N,1);
    if strcmp(opt, 'actor')
        for k = 1: size(c,2)        % for each rbf
            center = repmat(c(:,k),[1,N*N]);    

            temp = (X-center)'/B;
            temp2 = temp.*transpose(X-center);
            Phi = exp(-0.5*sum(temp2,2));
            Phi = Phi/sum(Phi)*phi(k);
            PhiSum = PhiSum + Phi;                 
        end
        
        PhiSum = reshape(PhiSum,[N,N]);        
        PhiSum = actSaturate(PhiSum, params);
        
        if (strcmp(opt2, '3d'))
            surf(Xd,Yd,PhiSum);  shading interp;  
        else
            imagesc(x1, x2, PhiSum);
        end
    elseif strcmp(opt, 'critic')
        for k = 1: size(c,2)
            center = repmat(c(:,k),[1,N*N]);

            temp = (X-center)'/B;
            temp2 = temp.*transpose(X-center);
            Phi = exp(-0.5*sum(temp2,2));
            Phi = Phi/sum(Phi)*theta(k);
            PhiSum = PhiSum + Phi;              
        end
        PhiSum = reshape(PhiSum,[N,N]);
        
        if (strcmp(opt2, '3d'))
            surf(Xd,Yd,PhiSum);  shading interp;   
        else
            imagesc(x1, x2, PhiSum);
        end
    else
        error('not a valid option');
    end
    y = 1;
