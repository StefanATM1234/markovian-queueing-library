function [U, R, Q, X, p0, C] = Perf_M_Er_1(lambda, mu, r)
    % Verificarea argumentelor
    if nargin ~= 3
        error('Usage: Perf_M_Er_1(lambda, mu, r)');
    end

    rho = (lambda * r) / mu;


    % Coeficient de variație pentru distribuția Erlang-r
    cB2 = 1 / r;

    % Timpul de așteptare în coadă
    Wq = (rho^2 / (lambda * (1 - rho))) * ((1 + cB2) / 2);

    % Timpul total în sistem
    R = Wq + r / mu;

    % Lungimea medie a cozii
    Q = lambda * R;

    % Throughput și utilizare
    X = lambda;
    U = rho;

    % p0 este greu de estimat fără distribuție completă – îl setăm ca NaN
    p0 = NaN;

    % Probabilitatea de întârziere C nu este definită clar în M/Er/1
    C = NaN;
end
