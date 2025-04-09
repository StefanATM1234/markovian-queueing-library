function launch_comparison_window(modelName)
    f = uifigure('Name', 'Comparatie Simulink vs Teoretic', ...
        'Position', [500, 400, 320, 100]);

    lbl = uilabel(f, ...
        'Text', 'Se generează graficul de comparație...', ...
        'Position', [30 40 260 30], ...
        'FontSize', 14);

    drawnow; 

    if strcmp(modelName, 'M_M_m_K_N')
        compare_simulink_results_MMmKN(modelName);  
    elseif strcmp(modelName, 'M_M_m_m')
        compare_simulink_results_MMmm(modelName);  
    else
        compare_simulink_results(modelName);
    end

    pause(0.3); 
    close(f);
end
