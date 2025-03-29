function launch_comparison_window()
    f = uifigure('Name', 'Comparatie Simulink vs Teoretic', ...
        'Position', [500, 400, 320, 100]);

    lbl = uilabel(f, ...
        'Text', 'Se generează graficul de comparație...', ...
        'Position', [30 40 260 30], ...
        'FontSize', 14);

    drawnow; 

    compare_simulink_results('mm1_2023');

    pause(0.3); 
    close(f);
end
