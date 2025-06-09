function [U, R, Q, Q_queue,X, p0] = Perf_M_M_1(lambda, mu)

    if nargin ~= 2
        error("Număr incorect de argumente. Usage: Perf_M_M_1(lambda, mu)");
    end

    % Verificare că lambda și mu sunt vectori.
    if ~(isvector(lambda) && isvector(mu))
        error("lambda și mu trebuie sa fie vectori.");
    end
    
    % Se verifică dimensiunile
    if numel(lambda) ~= numel(mu)
        error("lambda și mu trebuie sa aibă aceeași dimensiune.");
    end
    
    lambda = lambda(:)';
    mu = mu(:)';

    if any(lambda < 0)
        error("lambda trebuie să fie >= 0");
    end
    
    rho = lambda ./ mu; % Factorul de utilizare
    if any(rho >= 1)
        error("Capacitatea de procesare a fost depășită(rho >= 1).");
    end
    
    % Calculam performanțele
    U = rho;                   % Utilizarea
    p0 = 1 - rho;              % Probabilitatea ca sistemul să fie gol
    Q_queue = (rho.^2) ./ (1 - rho);      % numărul mediu de cereri în sistem
    Q = (rho) ./ (1 - rho);
    R = 1 ./ (mu .* (1 - rho));% Timpul de răspuns
    X = lambda;                % Throughput
end
