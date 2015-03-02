function y = rbf(x, params)
    if ~isvector(x)
        error('the input must be a vector');
    end
    if isrow(x)
        x = x';
    end
    
    % get parameters
    c = params.c;       % mean
    B = params.B;       % inverse of B
    N = params.NrbfX*params.NrbfY;    % no of rbfs
    
    % pre-process input and parameter
    x = repmat(x, [1, N]);
    
    % efficient matrix multiplication of (x-c)'B(x-c)
    temp = (x-c)'*inv(B);
    temp2 = temp.*transpose(x-c);
    y = exp(-0.5*sum(temp2,2));
    