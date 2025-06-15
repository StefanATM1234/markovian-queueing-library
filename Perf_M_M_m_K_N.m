function [U, R, Q, Q_queue, X, p0, pK] = Perf_M_M_m_K_N(lambda, mu, m, K, NrPop)
% Perf_M_M_m_K_N Calculează indicatorii de performanță pentru un sistem M/M/m/K/N
%
% Modelul include:
% - m servere paralele
% - capacitate maximă K (număr maxim de clienți în sistem)
% - populație totală finită N (NrPop), ceea ce implică sosiri limitate
%
% Intrări:
%   lambda - rata medie de sosire per client
%   mu     - rata medie de servire
%   m      - numărul de servere
%   K      - capacitatea maximă a sistemului
%   NrPop  - populația totală N (numărul maxim de clienți existenți)
%
% Ieșiri:
%   U        - utilizarea totală a sistemului
%   R        - timpul mediu de răspuns
%   Q        - numărul mediu de clienți în sistem
%   Q_queue  - numărul mediu de clienți în așteptare (coadă)
%   X        - rata medie de throughput (clienți procesați pe unitate timp)
%   p0       - probabilitatea ca sistemul să fie gol
%   pK       - probabilitatea ca sistemul să fie plin (blocaj)

    if nargin ~= 5
        error('Numarul de argumente nu este corect');
    end

    % Asigurăm format vector linie
    lambda = lambda(:)';
    mu = mu(:)';
    m = m(:)';
    K = K(:)';
    NrPop = NrPop(:)';

    % Inițializare vectori de ieșire
    U = zeros(size(lambda));
    R = zeros(size(lambda));
    Q = zeros(size(lambda));
    X = zeros(size(lambda));
    p0 = zeros(size(lambda));
    pK = zeros(size(lambda));
    Q_queue = zeros(size(lambda));

    for i = 1:length(lambda)
        % Verificări logice
        if K(i) > NrPop(i)
            error('K nu poate fi mai mare decât N.');
        end

        % Inițializare distribuție de probabilitate π_n (pentru n=0..K)
        pi = zeros(1, K(i) + 1);
        pi(1) = 1; % π₀

        % Recursie pentru calculul distribuției π_n
        for n = 1:K(i)
            if n <= m(i)
                mu_n = n * mu(i);          % dacă n servere active
            else
                mu_n = m(i) * mu(i);       % saturație: toți serverii lucrează
            end

            lambda_n = lambda(i) * (NrPop(i) - (n - 1));  % sosiri limitate de N
            pi(n + 1) = pi(n) * lambda_n / mu_n;
        end

        % Normalizare distribuție
        sum_pi = sum(pi);
        pi = pi / sum_pi;

        p0(i) = pi(1);       % probabilitate sistem gol
        pK(i) = pi(end);     % probabilitate sistem plin

        % Calculul throughput-ului efectiv
        X(i) = 0;
        for n = 0:(K(i) - 1)
            X(i) = X(i) + lambda(i) * (NrPop(i) - n) * pi(n + 1);
        end

        % Număr mediu de clienți în sistem
        Q(i) = sum((0:K(i)) .* pi);

        % Număr mediu de clienți în serviciu
        Q_serv = 0;
        for n = 0:K(i)
            Q_serv = Q_serv + min(n, m(i)) * pi(n + 1);
        end

        % Număr mediu în coadă = total - în serviciu
        Q_queue(i) = Q(i) - Q_serv;

        % Timpul mediu de răspuns R = Q / X
        R(i) = Q(i) / X(i);

        % Utilizarea totală U = X / (m * mu)
        U(i) = X(i) / (m(i) * mu(i));
    end
end
