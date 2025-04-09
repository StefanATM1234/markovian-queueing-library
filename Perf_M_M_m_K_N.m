function [U, R, Q,Q_queue, X, p0, pK] = Perf_M_M_m_K_N(lambda, mu, m, K, NrPop)
    if nargin ~= 5
        error('Numarul de argumente nu este corect');
    end

    lambda = lambda(:)';
    mu = mu(:)';
    m = m(:)';
    K = K(:)';
    NrPop = NrPop(:)';

    U = zeros(size(lambda));
    R = zeros(size(lambda));
    Q = zeros(size(lambda));
    X = zeros(size(lambda));
    p0 = zeros(size(lambda));
    pK = zeros(size(lambda));
    Q_queue = zeros(size(lambda));
    for i = 1:length(lambda)
        % Verificări
        if K(i) > NrPop(i)
            error('K nu poate fi mai mare decât N.');
        end

        % Inițializăm distribuția π
        pi = zeros(1, K(i) + 1);
        pi(1) = 1;  % π₀ (index 1 în MATLAB)

        % Calculăm recursiv toate valorile π_n până la K
        for n = 1:K(i)
            if n <= m(i)
                mu_n = n * mu(i);
            else
                mu_n = m(i) * mu(i);
            end

            lambda_n = lambda(i) * (NrPop(i) - (n - 1));
            pi(n + 1) = pi(n) * lambda_n / mu_n;
        end

        % Normalizare
        sum_pi = sum(pi);
        pi = pi / sum_pi;
        p0(i) = pi(1);
        pK(i) = pi(end);  % ultima stare = stare blocată

        % Throughput efectiv
        X(i) = 0;
        for n = 0:K(i)-1
            X(i) = X(i) + lambda(i) * (NrPop(i) - n) * pi(n + 1);
        end

        % Număr mediu de clienți în sistem
        Q(i) = sum((0:K(i)) .* pi);
        Q_serv = 0;
        for n = 0:K(i)
            Q_serv = Q_serv + min(n, m(i)) * pi(n + 1);
        end
        Q_queue(i) = Q(i) - Q_serv;
        % Timpul mediu de răspuns
        R(i) = Q(i) / X(i);

        % Utilizarea totală
        U(i) = X(i) / (m(i) * mu(i));
    end
end
