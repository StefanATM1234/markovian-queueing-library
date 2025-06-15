function compare_simulink_results_MMmm(modelName)
    % compare_simulink_results_MMmm - Compară valorile teoretice cu cele simulate
    % în Simulink pentru modelul M/M/m/m (sistem cu m servere și capacitate limitată).
    %
    % Parametru de intrare:
    %   modelName - numele modelului Simulink care se simulează (ex. 'M_M_m_m')
    %
    % Funcția:
    %   - Rulează modelul Simulink specificat
    %   - Extrage valorile medii pentru utilizare, timp de răspuns și timp de servire
    %   - Recuperează valorile teoretice din workspace-ul MATLAB
    %   - Construiește un grafic comparativ cu bare pentru cele trei valori

    % Rulează simularea modelului specificat și returnează rezultatele în simOut
    simOut = sim(modelName, 'ReturnWorkspaceOutputs', 'on');

    % Extrage valorile medii obținute din Simulink
    util_sim = mean(simOut.Utilization.Data);          % Utilizarea serverului
    resp_sim = mean(simOut.AverageSystemTime.Data);    % Timpul de răspuns
    serv_sim = mean(simOut.ServiceTime.Data);          % Timpul de servire

    % Recuperează variabilele teoretice din workspace-ul de bază
    lambda = evalin('base', 'lambda');  % Rata de sosire
    mu     = evalin('base', 'mu');      % Rata de servire
    U      = evalin('base', 'U');       % Utilizarea teoretică
    R      = evalin('base', 'R');       % Timpul de răspuns teoretic

    % (Opțional - momentan neutilizat)
    ServerNumbers = evalin('base','ServerNumbers');  
    MaxReq = evalin('base','MaxReq');               

    % Calculează timpul de servire teoretic
    serv_th = 1 / mu;

    % Definește categoriile pentru grafic
    categories = {'Utilization', 'Response Time', 'Service Time'};
    app_vals = [U, R, serv_th];             % Valorile teoretice
    sim_vals = [util_sim, resp_sim, serv_sim];  % Valorile simulate

    % Creează figura și graficul comparativ
    figure('Name', 'Grafic Comparatie', 'Position', [300 300 700 400]);
    bar(categorical(categories), [app_vals; sim_vals], 'BarWidth', 0.6);

    % Setări pentru grafic
    legend('Valoare Teoretica', 'Valoare Simulink', ...
           'Location', 'northoutside', 'Orientation', 'horizontal');
    ylabel('Valori','FontSize',13);
    title('Comparatie între valorile teoretice și cele obținute în Simulink');
    grid on;
    set(gca, 'FontSize', 8);
    yticks(0:0.1:5);  % Intervalele de pe axa Y 
end
