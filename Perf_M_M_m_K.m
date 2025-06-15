function [U, R, Q, Q_queue, X, p0, pK] = Perf_M_M_m_K(lambda, mu, m, K)
% Perf_M_M_m_K Calculează indicatorii de performanță pentru un sistem M/M/m/K (m servere, capacitate finită).
%
% Intrări:
%   lambda - rata medie de sosire 
%   mu     - rata medie de servire 
%   m      - numărul de servere 
%   K      - capacitatea totală a sistemului 
%
% Ieșiri:
%   U        - gradul de utilizare al serverului
%   R        - timpul mediu de răspuns în sistem
%   Q        - numărul mediu total de cereri în sistem
%   Q_queue  - numărul mediu de cereri în coadă (peste servere)
%   X        - rata de throughput efectiv (ieșiri/secundă)
%   p0       - probabilitatea ca sistemul să fie gol
%   pK       - probabilitatea ca sistemul să fie plin (cerere respinsă)

    if nargin ~= 4
        error('Numărul de argumente nu este corect');
    end

    % Conversie la vectori linie
    lambda = lambda(:)'; 
    mu = mu(:)'; 
    m = m(:)'; 
    K = K(:)'; 

    % Inițializare vectori de ieșire
    U = zeros(size(lambda));
    R = zeros(size(lambda));
    Q = zeros(size(lambda));
    X = zeros(size(lambda));
    p0 = zeros(size(lambda));
    pK = zeros(size(lambda));
    Q_queue = zeros(size(lambda));

    % Bucla pentru fiecare set de parametri
    for i = 1:length(lambda)
        rho = lambda(i) / mu(i);  % Rată efectivă de încărcare per server (atenție: nu clasic ρ = λ / (mμ))

        % Calcul pentru p0 (probabilitatea ca sistemul e gol)
        sum1 = 0;
        for k = 0:m(i)-1
            sum1 = sum1 + (rho^k) / factorial(k);
        end

        sum2 = 0;
        for k = m(i):K(i)
            sum2 = sum2 + ((rho^m(i)) / factorial(m(i))) * ((rho/m(i))^(k - m(i)));
        end

        p0(i) = 1 / (sum1 + sum2);  % Probabilitatea ca sistemul să fie gol

        % Probabilitatea ca sistemul să fie plin
        pK(i) = p0(i) * ((rho^m(i)) / factorial(m(i))) * ((rho/m(i))^(K(i) - m(i)));

        % Calculul mediei numărului de cereri în sistem și în coadă
        Q(i) = 0;
        for k = 0:K(i)
            if k <= m(i)
                Q(i) = Q(i) + k * ((rho^k) / factorial(k)) * p0(i);
            else
                term = ((rho^m(i)) / factorial(m(i))) * ((rho/m(i))^(k - m(i))) * p0(i);
                Q(i) = Q(i) + k * term;
                Q_queue(i) = Q_queue(i) + (k - m(i)) * term;
            end
        end

        % Throughput-ul efectiv (nu toate cererile intră)
        X(i) = lambda(i) * (1 - pK(i));

        % Utilizarea efectivă a serverelor
        U(i) = X(i) / (m(i) * mu(i));

        % Timpul mediu de răspuns
        R(i) = Q(i) / X(i);
    end
end
