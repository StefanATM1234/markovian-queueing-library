function [U, R, Q, Q_queue, X, p0, C] = Perf_M_M_m(lambda, mu, m)
% Perf_M_M_m Calculează indicatorii de performanță pentru un sistem M/M/m.
%
% Sistemul presupune m servere identice care deservesc cererile sosite
% conform unui proces Poisson și durate de servire exponentiale.
%
% Intrări:
%   lambda - vector al ratelor de sosire (λ)
%   mu     - vector al ratelor de servire (μ)
%   m      - vector al numărului de servere
%
% Ieșiri:
%   U        - utilizarea fiecărui server (ρ)
%   R        - timpul mediu de răspuns în sistem
%   Q        - numărul mediu total de cereri în sistem
%   Q_queue  - numărul mediu de cereri în așteptare (coadă)
%   X        - rata medie de procesare (throughput)
%   p0       - probabilitatea ca sistemul să fie gol
%   C        - probabilitatea ca o cerere să aștepte în coadă (Erlang-C)

    % Verificarea numărului de argumente
    if nargin < 2 || nargin > 3
        error('Apel corect: Perf_M_M_m(lambda, mu, m)');
    end

    % Dacă m nu e dat, se consideră m = 1 (M/M/1)
    if nargin == 2
        m = 1;
    end

    % Verificăm că toate valorile sunt numerice
    if ~(isnumeric(lambda) && isnumeric(mu) && isnumeric(m))
        error('Toți parametrii trebuie să fie vectori numerici');
    end

    % Convertim toate valorile în vectori-linie
    lambda = lambda(:)';
    mu = mu(:)';
    m = m(:)';

    % Verificări de validitate
    if any(m <= 0)
        error('Numărul de servere m trebuie să fie > 0');
    end
    if any(lambda <= 0)
        error('Rata lambda trebuie să fie > 0');
    end

    % Calculul utilizării ρ = λ / (m * μ)
    rho = lambda ./ (m .* mu);
    if any(rho >= 1)
        error('Capacitatea de procesare este depășită (rho ≥ 1)');
    end

    % Calculul probabilității ca sistemul să fie gol (p₀)
    p0 = zeros(size(lambda));
    for i = 1:length(lambda)
        suma = 0;
        for k = 0:(m(i)-1)
            suma = suma + (m(i) * rho(i))^k / factorial(k);
        end
        p0(i) = 1 / (suma + (m(i) * rho(i))^m(i) / (factorial(m(i)) * (1 - rho(i))));
    end

    % Probabilitatea ca o cerere să fie nevoită să aștepte (Erlang-C)
    C = zeros(size(lambda));
    for i = 1:length(lambda)
        C(i) = ((m(i) * rho(i))^m(i) / factorial(m(i))) * (1 / (1 - rho(i))) * p0(i);
    end

    % Numărul mediu de cereri în coadă
    Q_queue = C .* (rho ./ (1 - rho));

    % Throughput = λ (nu se pierd cereri)
    X = lambda;

    % Utilizarea serverului
    U = rho;

    % Numărul total mediu de cereri în sistem
    Q = Q_queue + lambda ./ mu;

    % Timpul mediu de răspuns
    R = Q ./ lambda;
end
