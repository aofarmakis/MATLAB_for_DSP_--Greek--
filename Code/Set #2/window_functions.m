% Μήκος παραθύρου και συντελεστής απόσβεσης
L = 64;
m = 42;

% Συναρτήσεις Παραθύρου
windows = {'sym_hamm', 'per_hamm', 'cheb', 'rect'};

% Custom naming scheme για κάθε συνάρτηση παραθύρου
window_names = containers.Map(windows, {'Symmetric Hamming', ...
    'Periodic Hamming', '-42dB Chebyshev', 'Rectangular'});

% Αρχικοποίηση των handle για τη δημιουργία των κατάλληλων γραφημάτων
figure_handles = zeros(4, 1);

% Δέσμευση μνήμης για τα legend των γραφημάτων
legend_names = cell(2, numel(windows));

% Βρόχος για τη σχεδίαση των γραφημάτων των παραθύρων στο χώρο
% του χρόνου και της συχνότητας
for i = 1:numel(windows)
    window_function = windows{i};
    if strcmp(window_function, 'sym_hamm')
        chosen_window = hamming(L, 'symmetric');
        x_axis = 0:L-1;
    elseif strcmp(window_function, 'per_hamm')
        chosen_window = hamming(L-1, 'periodic');
        x_axis = 0:L-2;
    elseif strcmp(window_function, 'rect')
        chosen_window = rectwin(L);
        x_axis = 0:L-1;
    else
        chosen_window = chebwin(L, m);
        x_axis = 0:L-1;
    end
    
    [H, w] = freqz(chosen_window, 1, 1024);
    
    % Εύρεση του ονόματος της συνάρτησης παραθύρου από λίστα
    window_func_name = window_names(window_function);
    
    % Σχεδίαση γραφήματος του παραθύρου στο χώρο του χρόνου
    if i <= 3
        figure_handles(1) = figure(1);
        plot(x_axis, chosen_window, 'LineWidth', 2);
        grid on;
        hold on;
    else
        figure_handles(3) = figure(3);
        plot(x_axis, chosen_window, 'LineWidth', 2);
        grid on;
        hold on;
    end
    
    % Σχεδίαση γραφήματος του παραθύρου στο χώρο της συχνότητας
    if i <= 3
        figure_handles(2) = figure(2);
        plot(w/pi, 20*log10(abs(H)), 'LineWidth', 2);
        grid on;
        hold on;
    else
        figure_handles(4) = figure(4);
        plot(w/pi, 20*log10(abs(H)), 'LineWidth', 2);
        grid on;
        hold on;
    end
    
    % Αποθήκευση των ονομάτων των legend για κάθε συνάρτηση παραθύρου
    legend_names{1,i} = window_func_name;
    legend_names{2,i} = window_func_name;
end

% Set figure background color to white
set(figure_handles, 'Color', [1, 1, 1]);

% Προσθήκη legend στα γραφήματα των παραθύρων Hamming και Chebyshev
% στο χώρο του χρόνου
figure(1);
legend(legend_names{1, 1:3});
xlim([0 63]);
title('Time Domain of Hamming Windows');
xlabel('Window Length');
ylabel('Amplitude');
hold off;

% Προσθήκη legend στα γραφήματα των παραθύρων Hamming και Chebyshev
% στο χώρο της συχνότητας
figure(2);
legend(legend_names{2, 1:3});
title('Frequency Domain of Hamming Windows');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (dB)');
hold off;

% Προσθήκη legend στα γραφήματος του τετραγωνικού παραθύρου
% στο χώρο του χρόνου
figure(3);
legend(legend_names{1, 4});
xlim([0 63]);
ylim([0 2]);
line([0 0], [0 1], 'Color', [0 0.4470 0.7410], 'LineWidth', 2, ...
    'HandleVisibility','off');
line([63 63] , [0 1], 'Color', [0 0.4470 0.7410], 'LineWidth', 2, ...
    'HandleVisibility','off');
title('Time Domain of Rectangular Window');
xlabel('Window Length');
ylabel('Amplitude');
hold off;

% Προσθήκη legend στα γραφήματος του τετραγωνικού παραθύρου
% στο χώρο της συχνότητας
figure(4);
legend(legend_names{2, 4});
title('Frequency Domain of Rectangular Window');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (dB)');
hold off;