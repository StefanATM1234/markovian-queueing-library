function compare_simulink_results_MMmKN(modelName)
    % compare_simulink_results_MMmKN - Compară valorile teoretice cu cele
    % simulate în Simulink pentru modelul M/M/m/K/N (m servere, capacitate totală K, N surse).
    %
    % Parametru de intrare:
    %   modelName - numele modelului Simulink care se simulează (ex. 'M_M_m_K_N')
    %
    % Funcția:
    %   - Rulează modelul Simulink specificat
    %   - Extrage valorile medii pentru utilizare, lungimea cozii și timpul de servire
    %   - Recuperează valorile teoretice din workspace-ul MATLAB
    %   - Construiește un grafic comparativ cu bare pentru cele trei valori

    % Rulează simularea modelului Simulink și returnează rezultatele în simOut
    simOut = sim(modelName, 'ReturnWorkspaceOutputs', 'on');

    % Extrage valorile medii obținute din Simulink
    util_sim = mean(simOut.Utilization.Data);       % Utilizarea serverelor
    queue_sim = mean(simOut.QueueLength.Data);      % Lungimea medie a cozii
    serv_sim = mean(simOut.ServiceTime.Data);       % Timpul mediu de servire

    % Recuperează valorile teoretice din workspace-ul MATLAB
    lambda = evalin('base', 'lambda');              % Rata de sosire
    mu     = evalin('base', 'mu');                  % Rata de servire
    U      = evalin('base', 'U');                   % Utilizarea teoretică
    R      = evalin('base', 'R');                   % Timpul de răspuns teoretic (neutilizat aici)
    Q_queue = evalin('base', 'Q_queue');            % Lungimea medie a cozii teoretică

    % (Variabile suplimentare – neutilizate dar încărcate pentru eventuale comparații extinse)
    ServerNumbers = evalin('base','ServerNumbers');
    MaxReq = evalin('base','MaxReq');               
    % Calculează timpul de servire teoretic
    serv_th = 1 / mu;

    % Definirea categoriilor comparate
    categories = {'Utilization','Queue Length', 'Service Time'};
    app_vals = [U, Q_queue, serv_th];               % Valorile teoretice
    sim_vals = [util_sim, queue_sim, serv_sim];     % Valorile din Simulink

    % Creează graficul comparativ
    figure('Name', 'Grafic Comparatie', 'Position', [300 300 700 400]);
    bar(categorical(categories), [app_vals; sim_vals], 'BarWidth', 0.6);

    % Setări grafice
    legend('Valoare Teoretica', 'Valoare Simulink', ...
           'Location', 'northoutside', 'Orientation', 'horizontal');
    ylabel('Valori','FontSize',13);
    title('Comparatie între valorile teoretice și cele obținute în Simulink');
    grid on;
    set(gca, 'FontSize', 8);
    yticks(0:0.1:5);  % Ajustabil în funcție de magnitudinea valorilor
end
