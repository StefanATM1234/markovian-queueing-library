function [U, R, Q, Q_queue, X, p0, C] = Perf_M_Er_1(lambda, mu, r)
% Perf_M_Er_1 Calculează indicatorii de performanță pentru un sistem M/E_r/1
%
% Sistemul are:
% - Sosiri Poisson (rata lambda)
% - Servicii Erlang de ordin r (r faze exponentiale cu rata mu)
% - Un singur server (m = 1 implicit)
%
% Intrări:
%   lambda - rata medie de sosire
%   mu     - rata medie de servire pentru fiecare fază
%   r      - numărul de faze (ordinul distribuției Erlang)
%
% Ieșiri:
%   U        - utilizarea sistemului
%   R        - timpul mediu de răspuns
%   Q        - numărul mediu de cereri în sistem
%   Q_queue  - numărul mediu în coadă
%   X        - throughput-ul (rata efectivă de procesare)
%   p0       - probabilitatea ca sistemul să fie gol (setat NaN)
%   C        - probabilitatea ca o cerere să stea în coadă (setat NaN)

    if nargin ~= 3
        error('Usage: Perf_M_Er_1(lambda, mu, r)');
    end

    % Factor de utilizare
    rho = (lambda * r) / mu;

    if rho >= 1
        error('Sistem instabil: rho ≥ 1');
    end

    % Coeficientul de variație al timpului de servire Erlang-r
    cB2 = 1 / r;

    % Timpul mediu de așteptare în coadă (formula M/G/1)
    Wq = (rho^2 / (lambda * (1 - rho))) * ((1 + cB2) / 2);

    % Timpul mediu total în sistem
    R = Wq + r / mu;

    % Numărul mediu de cereri în sistem și în coadă
    Q = lambda * R;
    Q_queue = lambda * Wq;

    % Throughput și utilizare
    X = lambda;
    U = rho;

    % p0 și C nu se pot calcula ușor în această aproximare
    p0 = NaN;
    C = NaN;
end
