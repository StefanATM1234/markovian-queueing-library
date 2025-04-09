function compare_simulink_results_MMmKN(modelName)
    %simOut = sim('mm1_2023', 'ReturnWorkspaceOutputs', 'on');
    simOut = sim(modelName, 'ReturnWorkspaceOutputs', 'on');

    util_sim = mean(simOut.Utilization.Data);
    queue_sim = mean(simOut.QueueLength.Data);
    serv_sim = mean(simOut.ServiceTime.Data);

    lambda = evalin('base', 'lambda');
    mu     = evalin('base', 'mu');
    U      = evalin('base', 'U');
    R      = evalin('base', 'R');
    Q_queue      = evalin('base', 'Q_queue');
    ServerNumbers     = evalin('base','ServerNumbers');
    MaxReq = evalin('base','MaxReq');
    serv_th = 1 / mu;

    
    categories = {'Utilization','Queue Length', 'Service Time'};
    app_vals = [U, Q_queue, serv_th];
    sim_vals = [util_sim,  queue_sim, serv_sim];

    
    figure('Name', 'Grafic Comparatie', 'Position', [300 300 700 400]);
    b = bar(categorical(categories), [app_vals; sim_vals], 'BarWidth', 0.6);
    legend('Valoare Teoretica', 'Valoare Simulink', 'Location', 'northoutside', 'Orientation', 'horizontal');
    ylabel('Valori','FontSize',13);
    title('Comparatie între valorile teoretice și cele obținute în Simulink');
    grid on; 
    set(gca, 'FontSize', 8);  
    yticks(0:0.1:5);
end
