function [U, R, Q,Q_queue, X, p0, pK] = Perf_M_M_m_K(lambda, mu, m, K)
    if nargin ~= 4
        error('Numarul de argumente nu este corect');
    end

    lambda = lambda(:)'; 
    mu = mu(:)'; 
    m = m(:)'; 
    K = K(:)'; 

    U = zeros(size(lambda));
    R = zeros(size(lambda));
    Q = zeros(size(lambda));
    X = zeros(size(lambda));
    p0 = zeros(size(lambda));
    pK = zeros(size(lambda));
    Q_queue = zeros(size(lambda));
    for i = 1:length(lambda)
        rho = lambda(i) / mu(i);  % Request rate / service rate

        sum1 = 0;
        for k = 0:m(i)-1
            sum1 = sum1 + (rho(i)^k) / factorial(k);
        end

        sum2 = 0;
        for k = m(i):K(i)
            sum2 = sum2 + (rho(i)^m(i)) / factorial(m(i)) * (rho(i)/m(i))^(k-m(i));
        end

        p0(i) = 1 / (sum1 + sum2);  % The probability that the system is empty.

        % The probability pK (the system is full).
        pK(i) = p0(i) * (rho(i)^m(i)) / factorial(m(i)) * (rho(i)/m(i))^(K(i)-m(i));

        % The calculation of the average number of requests in the system (Q).
        Q(i) = 0;
        for k = 0:K(i)
            if k <= m(i)
                Q(i) = Q(i) + k * (rho(i)^k) / factorial(k) * p0(i);
            else
                Q(i) = Q(i) + k * (rho(i)^m(i)) / factorial(m(i)) * (rho(i)/m(i))^(k-m(i)) * p0(i);
                Q_queue(i) = Q_queue(i) + (k-m(i)) * (rho(i)^m(i)) / factorial(m(i)) * (rho(i)/m(i))^(k-m(i)) * p0(i);
            end
        end

        X(i) = lambda(i) * (1 - pK(i));  % Throughput
        U(i) = X(i) / (m(i) * mu(i));   % Utilization   
        R(i) = Q(i) / X(i);              % Resposne Time
    end
end
