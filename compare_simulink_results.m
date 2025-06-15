function compare_simulink_results(modelName)
    % Functia primeste ca parametru numele unui model Simulink (string)
    % si compara valorile teoretice cu cele obtinute prin simulare.
    
    % Ruleaza modelul Simulink si returneaza rezultatele in structura 'simOut'
    simOut = sim(modelName, 'ReturnWorkspaceOutputs', 'on');

    % Extrage media valorilor simulate pentru fiecare indicator de performanta
    util_sim  = mean(simOut.Utilization.Data);           % Grad de utilizare
    resp_sim  = mean(simOut.AverageSystemTime.Data);     % Timp mediu de raspuns
    queue_sim = mean(simOut.QueueLength.Data);           % Lungime medie a cozii
    serv_sim  = mean(simOut.ServiceTime.Data);           % Timp mediu de servire

    % Citeste din workspace-ul de baza valorile teoretice deja calculate
    lambda        = evalin('base', 'lambda');            % Rata de sosire
    mu            = evalin('base', 'mu');                % Rata de servire
    U             = evalin('base', 'U');                 % Utilizarea teoretica
    R             = evalin('base', 'R');                 % Timpul de raspuns teoretic
    Q_queue       = evalin('base', 'Q_queue');           % Lungimea medie a cozii teoretice
    ServerNumbers = evalin('base','ServerNumbers');      % Numar de servere (optional)
    MaxReq        = evalin('base','MaxReq');             % Cerinte maxime (optional)

    % Calculeaza timpul mediu de servire teoretic
    serv_th = 1 / mu;

    % Definește etichetele axei x pentru grafic
    categories = {'Utilization', 'Response Time', 'Queue Length', 'Service Time'};

    % Vector cu valorile teoretice (aplicative)
    app_vals = [U, R, Q_queue, serv_th];

    % Vector cu valorile obtinute din simulare
    sim_vals = [util_sim, resp_sim, queue_sim, serv_sim];

    % Creeaza o fereastra noua pentru grafic, cu dimensiuni si pozitie setata
    figure('Name', 'Grafic Comparatie', 'Position', [300 300 700 400]);

    % Genereaza graficul comparativ cu bare (bar chart)
    b = bar(categorical(categories), [app_vals; sim_vals], 'BarWidth', 0.6);

    % Adauga legenda in partea de sus a graficului, pe orizontala
    legend('Valoare Teoretica', 'Valoare Simulink', ...
           'Location', 'northoutside', 'Orientation', 'horizontal');

    % Seteaza eticheta pentru axa Y si marimea fontului
    ylabel('Valori','FontSize',13);

    % Titlul graficului
    title('Comparatie între valorile teoretice și cele obținute în Simulink');

    % Activeaza liniile grilei pe fundalul graficului
    grid on;

    % Micsoreaza dimensiunea fontului axelor pentru claritate
    set(gca, 'FontSize', 8);

    % Specifica valorile afisate pe axa Y
    yticks(0:0.1:5);
end
