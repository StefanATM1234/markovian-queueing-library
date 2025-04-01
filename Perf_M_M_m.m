function [U, R, Q, X, p0, C] = Perf_M_M_m(lambda, mu, m)
  % Validate input arguments
  if nargin < 2 || nargin > 3
    error('Usage: Perf_M_M_m(lambda, mu, m)');
  end
  
  if nargin == 2
    m = 1;  % Set m to 1 if not provided
  else
    if ~(isnumeric(lambda) && isnumeric(mu) && isnumeric(m))
        error('The parameters must be numeric vectors');
    end
  end
  
  lambda = lambda(:)';  % Convert to row vector
  mu = mu(:)';          % Convert to row vector
  m = m(:)';            % Convert to row vector
  
  if any(m <= 0)
    error('m must be > 0');
  end
  if any(lambda <= 0)
    error('lambda must be > 0');
  end
  
  % Calculate utilization (rho)
  rho = lambda ./ (m .* mu);
  if any(rho >= 1)
    error('Processing capacity exceeded');
  end
  
  % Calculate p0 (probability of 0 requests in the system)
  p0 = zeros(size(lambda));
  for i = 1:length(lambda)
    sum_terms = 0;
    % Calculating the sum part of p0
    for k = 0:(m(i)-1)
        sum_terms = sum_terms + (m(i) * rho(i))^k / factorial(k);
    end
    % Calculating the second part of p0
    p0(i) = 1 / (sum_terms + (m(i) * rho(i))^m(i) / (factorial(m(i)) * (1 - rho(i))));
  end
  
  % Calculate Erlang-C probability (probability of delay)
  C = zeros(size(lambda));
  for i = 1:length(lambda)
    C(i) = ((m(i) * rho(i))^m(i) / factorial(m(i))) * (1 / (1 - rho(i))) * p0(i);
  end
    
  % Calculate average number of requests in the queue
  Q_queue = C .* ((rho.^2) ./ (1 - rho));
  
  % Calculate system parameters
  X = lambda;                        % Throughput
  U = rho;                           % Server utilization
  Q = Q_queue + (lambda ./ mu);      % Average number of requests in the system
  R = Q ./ lambda;                   % Response time
  
end
