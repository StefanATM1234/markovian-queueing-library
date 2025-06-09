% analiza sistem M/M/m/K/N

% system parameters
lam = 2;
miu = 1;
m = 1;
k = 3;
N = 4;

% rate matrix
d1 = lam*[N:(-1):(N-k+1)];
d2 = miu*[1:m  m*ones(1, k-m)];
Q = diag(d1,1) + diag(d2, -1);
d = sum(Q');
Q = Q - diag(d);

% stationary state probability
E = ones(k+1);
e = ones(1,k+1);
pi_stat = e*inv(Q+E)

% states of system, servers, queue
state_X = 0:k;
state_Xs = [0:m m*ones(1,k-m)];
state_Xq = [zeros(1,m) 0:(k-m)];

% states = [state_X; state_Xs; state_Xq]

% mean number of clients in system, in service, waiting in queue
mean_X = sum(state_X .* pi_stat)
mean_Xs = sum(state_Xs .* pi_stat)
mean_Xq = sum(state_Xq .* pi_stat)

% effective arrival rate
lam_eff = sum(d1 .* pi_stat(1:k))

% mean time 
mean_SysTime = mean_X / lam_eff
mean_WaitTime = mean_Xq / lam_eff
mean_ServTime = mean_Xs / lam_eff

