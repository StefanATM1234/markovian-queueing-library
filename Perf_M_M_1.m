function [U, R, Q, X, p0] = Perf_M_M_1(lambda, mu)
    % Compute utilization, response time, average number of requests, and
    % throughput for an M/M/1 queue.
    %
    % Inputs:
    %   lambda - Arrival rate (lambda >= 0)
    %   mu - Service rate (mu > lambda)
    %
    % Outputs:
    %   U - Server utilization
    %   R - Response time
    %   Q - Average number of requests in the system
    %   X - Server throughput
    %   p0 - Steady-state probability of 0 requests in the system
    
    if nargin ~= 2
        error("Incorrect number of input arguments. Usage: Perf_M_M_1(lambda, mu)");
    end
    
    % Ensure lambda and mu are vectors
    if ~(isvector(lambda) && isvector(mu))
        error("lambda and mu must be vectors.");
    end
    
    % Ensure sizes of lambda and mu are compatible
    if numel(lambda) ~= numel(mu)
        error("lambda and mu must have the same size.");
    end
    
    lambda = lambda(:)'; % Convert to row vector
    mu = mu(:)';         % Convert to row vector
    
    if any(lambda < 0)
        error("lambda must be >= 0");
    end
    
    rho = lambda ./ mu; % Utilization factor
    if any(rho >= 1)
        error("Processing capacity exceeded (rho >= 1).");
    end
    
    % Compute general metrics
    U = rho;                   % Utilization
    p0 = 1 - rho;              % Probability of 0 jobs
    Q = (rho.^2) ./ (1 - rho);      % Average number of requests
    R = 1 ./ (mu .* (1 - rho));% Response time
    X = lambda;                % Throughput
end
