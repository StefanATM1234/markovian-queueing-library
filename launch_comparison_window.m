function launch_comparison_window(modelName)
    % Creează o fereastră UI pentru notificarea utilizatorului
    f = uifigure('Name', 'Comparatie Simulink vs Teoretic', ...
        'Position', [500, 400, 320, 100]);  % Dimensiunea și poziția ferestrei

    % Adaugă un mesaj în fereastră care anunță generarea graficului
    lbl = uilabel(f, ...
        'Text', 'Se generează graficul de comparație...', ...
        'Position', [30 40 260 30], ...
        'FontSize', 14);

    drawnow;  % Forțează actualizarea interfeței grafice (afișează mesajul imediat)

    % În funcție de tipul modelului, apelează funcția de comparație corespunzătoare
    if strcmp(modelName, 'M_M_m_K_N')
        compare_simulink_results_MMmKN(modelName);  % Pentru modelul M/M/m/K/N
    elseif strcmp(modelName, 'M_M_m_m')
        compare_simulink_results_MMmm(modelName);   % Pentru modelul M/M/m/m
    else
        compare_simulink_results(modelName);        % Pentru orice alt model standard
    end

    pause(0.3);  % Așteaptă puțin pentru ca figura să rămână vizibilă
    close(f);    % Închide fereastra UI după generarea graficului
end
