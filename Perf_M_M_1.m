function [U, R, Q, Q_queue, X, p0] = Perf_M_M_1(lambda, mu)
% Perf_M_M_1 Calculează indicatorii de performanță pentru un sistem de așteptare M/M/1.
%
% Intrări:
%   lambda - rata medie de sosire 
%   mu     - rata medie de servire 
%
% Ieșiri:
%   U        - gradul de utilizare al serverului
%   R        - timpul mediu de răspuns în sistem
%   Q        - numărul mediu total de cereri în sistem
%   Q_queue  - numărul mediu de cereri în coadă
%   X        - rata de throughput (ieșiri/secundă)
%   p0       - probabilitatea ca sistemul să fie gol

    % Verificarea numărului de argumente
    if nargin ~= 2
        error("Număr incorect de argumente. Usage: Perf_M_M_1(lambda, mu)");
    end
    % Verificare că lambda și mu sunt vectori
    if ~(isvector(lambda) && isvector(mu))
        error("lambda și mu trebuie să fie vectori.");
    end
    % Verificare că au aceeași dimensiune
    if numel(lambda) ~= numel(mu)
        error("lambda și mu trebuie să fie de aceeași dimensiune.");
    end
    % Conversia în vectori linie
    lambda = lambda(:)';
    mu = mu(:)';
    % Verificare valori pozitive pentru lambda
    if any(lambda < 0)
        error("lambda trebuie să fie >= 0");
    end
    % Calculul factorului de utilizare
    rho = lambda ./ mu;
    % Verificare ca rho să fie sub 1 (condiție de stabilitate)
    if any(rho >= 1)
        error("Capacitatea de procesare a fost depășită (rho >= 1).");
    end
    % Calculul indicatorilor de performanță
    U = rho;                                 % Utilizarea serverului
    p0 = 1 - rho;                            % Probabilitatea ca sistemul să fie gol
    Q_queue = (rho.^2) ./ (1 - rho);         % Numărul mediu de cereri în coadă
    Q = (rho) ./ (1 - rho);                  % Numărul mediu total de cereri în sistem
    R = 1 ./ (mu .* (1 - rho));              % Timpul mediu de răspuns
    X = lambda;                              % Rata de throughput (ieșiri/secundă)
end
