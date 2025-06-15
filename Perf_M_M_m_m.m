function [U, R, Q, Q_queue, X, p0, pB] = Perf_M_M_m_m(lambda, mu, m)
% Perf_M_M_m_m Calculează indicatorii de performanță pentru un sistem M/M/m/m
%
% Sistemul are:
% - m servere, fără coadă (Erlang-B)
% - cererile care găsesc toate serverele ocupate sunt pierdute
%
% Intrări:
%   lambda - rata medie de sosire
%   mu     - rata medie de servire per server
%   m      - numărul de servere
%
% Ieșiri:
%   U        - utilizarea serverelor
%   R        - timpul mediu de răspuns (doar pentru cererile acceptate)
%   Q        - numărul mediu de cereri în sistem
%   Q_queue  - întotdeauna 0 (nu există coadă)
%   X        - throughput-ul efectiv
%   p0       - probabilitatea ca sistemul să fie gol
%   pB       - probabilitatea ca o cerere să fie blocată (Erlang-B)

    if nargin ~= 3
        error('Numarul de argumente nu este corect');
    end

    lambda = lambda(:)';
    mu = mu(:)';
    m = m(:)';

    U = zeros(size(lambda));
    R = zeros(size(lambda));
    Q = zeros(size(lambda));
    X = zeros(size(lambda));
    p0 = zeros(size(lambda));
    pB = zeros(size(lambda));
    Q_queue = zeros(size(lambda));  % va fi 0 în toate cazurile

    for i = 1:length(lambda)
        rho = lambda(i) / (mu(i));  % rata de trafic

        % Suma pentru Erlang-B (calculăm pB direct)
        sum_B = 0;
        for k = 0:m(i)
            sum_B = sum_B + (rho^k) / factorial(k);
        end
        pB(i) = (rho^m(i) / factorial(m(i))) / sum_B;

        % Probabilitatea ca sistemul să fie gol
        p0(i) = 1 / sum_B;

        % Throughput efectiv (numai cererile acceptate)
        X(i) = lambda(i) * (1 - pB(i));

        % Utilizare (cereri servite / capacitate totală)
        U(i) = X(i) / (m(i) * mu(i));

        % Timpul mediu în sistem (numai pentru cererile acceptate)
        R(i) = 1 / mu(i);  % Nu se așteaptă, direct în server

        % Numărul mediu de cereri în sistem
        Q(i) = X(i) * R(i);  % ρ * (1 - pB) * m

        % Q_queue este 0 în sistemul fără coadă
        Q_queue(i) = 0;
    end
end
