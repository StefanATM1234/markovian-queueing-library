function [U, R, Q,Q_queue, X, p0, pB] = Perf_M_M_m_m(lambda, mu, m)
    % Verifică argumentele de intrare
    if nargin ~= 3
        error('Numarul de argumente nu este corect');
    end

    lambda = lambda(:)';  % Transformă vectorii de intrare într-o linie
    mu = mu(:)';
    m = m(:)';

    U = zeros(size(lambda));
    R = zeros(size(lambda));
    Q = zeros(size(lambda));
    X = zeros(size(lambda));
    p0 = zeros(size(lambda));
    pB = zeros(size(lambda));
    Q_queue = zeros(size(lambda));
    for i = 1:length(lambda)
        rho = lambda(i) / (m(i) * mu(i));  % Utilizarea serverelor

        % Calcularea lui p0 (probabilitatea că sistemul este gol)
        sum1 = 0;
        for k = 0:m(i)-1
            sum1 = sum1 + (rho(i)^k) / factorial(k);
        end

        p0(i) = 1 / (sum1 + (rho(i)^m(i)) / factorial(m(i)));  % Probabilitatea că sistemul este gol

        % Calcularea probabilității de blocare pB (Erlang B)
        sum_B = 0;
        for k = 0:m(i)
            sum_B = sum_B + (rho(i)^k) / factorial(k);
        end
        pB(i) = (rho(i)^m(i) / factorial(m(i))) / sum_B;  % Probabilitatea de blocare

        % Calcularea numărului mediu de cereri în sistem (Q)
        Q(i) = m(i) * rho(i);  % Numărul mediu de cereri în sistem
        % Calcularea Throughput-ului (X), Utilizării (U) și Timpului de răspuns (R)
        X(i) = lambda(i) * (1 - pB(i));  % Throughput-ul efectiv
        U(i) = X(i) / (m(i) * mu(i));    % Utilizarea serverului
        R(i) = Q(i) / X(i);              % Timpul de răspuns
    end
end
