function [U, R, Q, Q_queue, X, p0, pK] = Perf_M_M_1_K(lambda, mu, K)
% Perf_M_M_1_K Calculează indicatorii de performanță pentru un sistem M/M/1/K.
%
% Intrări:
%   lambda - rata medie de sosire
%   mu     - rata medie de servire 
%   K      - capacitatea totală a sistemului 
%
% Ieșiri:
%   U        - gradul de utilizare al serverului
%   R        - timpul mediu de răspuns în sistem
%   Q        - numărul mediu total de cereri în sistem
%   Q_queue  - numărul mediu de cereri în coadă
%   X        - throughput (rata efectivă de servire)
%   p0       - probabilitatea ca sistemul să fie gol
%   pK       - probabilitatea ca sistemul să fie plin

    % Calculul factorului de utilizare a = λ / μ
    a = lambda ./ mu;

    % Inițializarea vectorilor de ieșire
    U = zeros(size(lambda));
    R = zeros(size(lambda));
    Q = zeros(size(lambda));
    X = zeros(size(lambda));
    p0 = zeros(size(lambda));
    pK = zeros(size(lambda));
    Q_queue = zeros(size(lambda));

    % Cazul a ≠ 1 (general)
    idx_a_neq_1 = find(a ~= 1);
    if ~isempty(idx_a_neq_1)
        i = idx_a_neq_1;
        p0(i) = (1 - a(i)) ./ (1 - a(i).^(K(i) + 1));
        pK(i) = (1 - a(i)) .* (a(i).^K(i)) ./ (1 - a(i).^(K(i) + 1));
        Q(i) = a(i) ./ (1 - a(i)) - (K(i) + 1) .* (a(i).^(K(i) + 1)) ./ (1 - a(i).^(K(i) + 1));
        Q_queue(i) = Q(i) - lambda(i) .* (1 - pK(i)) ./ mu(i); 
    end

    % Cazul a = 1 (formule limită)
    idx_a_eq_1 = find(a == 1);
    if ~isempty(idx_a_eq_1)
        i = idx_a_eq_1;
        p0(i) = 1 ./ (K(i) + 1);
        pK(i) = 1 ./ (K(i) + 1);
        Q(i) = K(i) ./ 2;
        Q_queue(i) = K(i) .* (K(i) - 1) ./ (2 .* (K(i)+1));
    end

    % Calculul metodelor de performanță
    U = 1 - p0;                   % Utilizarea
    X = lambda .* (1 - pK);       % Throughput efectiv
    R = Q ./ X;                   % Timpul mediu de răspuns
end
