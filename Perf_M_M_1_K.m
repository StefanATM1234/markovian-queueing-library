function [U, R, Q, X, p0, pK] = Perf_M_M_1_K(lambda, mu, K)


  % Calculul factorului de utilizare
  a = lambda ./ mu;

  % Inițializarea variabilelor de ieșire
  U = zeros(size(lambda));
  R = zeros(size(lambda));
  Q = zeros(size(lambda));
  X = zeros(size(lambda));
  p0 = zeros(size(lambda));
  pK = zeros(size(lambda));

  % Calcul pentru cazurile a != 1
  idx_a_neq_1 = find(a ~= 1);
  if ~isempty(idx_a_neq_1)
    i = idx_a_neq_1;
    p0(i) = (1 - a(i)) ./ (1 - a(i).^(K(i) + 1));
    pK(i) = (1 - a(i)) .* (a(i).^K(i)) ./ (1 - a(i).^(K(i) + 1));
    Q(i) = a(i) ./ (1 - a(i)) - (K(i) + 1) .* (a(i).^(K(i) + 1)) ./ (1 - a(i).^(K(i) + 1));
  end

  % Calcul pentru cazurile a == 1
  idx_a_eq_1 = find(a == 1);
  if ~isempty(idx_a_eq_1)
    i = idx_a_eq_1;
    p0(i) = 1 ./ (K(i) + 1);
    pK(i) = 1 ./ (K(i) + 1);
    Q(i) = K(i) ./ 2;
  end

  % Calculul măsurilor de performanță
  U = 1 - p0;         % Utilizarea centrului de servicii
  X = lambda .* (1 - pK); % Rata de throughput
  R = Q ./ X;         % Timpul de răspuns
end
