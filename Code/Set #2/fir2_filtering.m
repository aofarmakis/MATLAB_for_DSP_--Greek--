% Κανονικοποιημένες συχνότητες
frequencies = [0, 0.36, 1];

% Επιθυμητά πλάτη ανά συχνότητα και τάξη φίλτρου
magnitudes = [0, 1, 0];
n = 26;

% Συναρτήσεις Παραθύρου
windows = {'ones(n+1)', 'chebwin(n+1, 42)', ... 
    'blackman(n+1, ''symmetric'')', 'blackman(n+1, ''periodic'')', ...
    'hamming(n+1, ''symmetric'')', 'hamming(n+1, ''periodic'')', ...
    'triang(n+1)', 'rectwin(n+1)'};

% Custom naming scheme for each window function
window_names = containers.Map(windows, {'No', '-42dB Chebyshev', ...
    'Symmetric Blackman', 'Periodic Blackman', ...
    'Symmetric Hamming', 'Periodic Hamming', ...
    'Triangular', 'Rectangular'});

% Βρόχος επανάληψης για τη χάραξη των γραφημάτων της κρουστικής απόκρισης,
% το μέτρο και τη φάση της απόκρισης συχνότητας για κάθε παράθυρο
for i = 1:numel(windows)
    window_function = windows{i};
    if strcmp(window_function, 'ones(n+1)')
        fir2_filter = fir2(n, frequencies, magnitudes); % no window
    else
        fir2_filter = fir2(n, frequencies, magnitudes, ...
            eval(window_function));
    end
    
    [H, w] = freqz(fir2_filter, 1, 1024);
    
    % Εύρεση ονόματος για τη συνάρτηση παραθύρου από λίστα
    window_func_name = window_names(window_function);
    
    figure(i);
    % Υπογράφημα κρουστικής απόκρισης
    subplot(131);
    impulse_response = impz(fir2_filter);
    stem(impulse_response);
    title(['Filter with ', char(window_func_name) ' Window:', ...
        ' Impulse Response']);
    xlabel('Sample Index');
    ylabel('Magnitude');
    xlim([0, n+2]);
    
    % Υπογράφημα μέτρου απόκρισης συχνότητας
    subplot(132);
    plot(w/pi, 20*log10(abs(H)));
    title(['Filter with ', char(window_func_name) ' Window:', ...
        ' Magnitude of Frequency Response']);
    xlabel('Normalized Frequency (\times\pi rad/sample)');
    ylabel('Magnitude (dB)');
    
    % Υπογράφημα φάσης απόκρισης συχνότητας
    subplot(133);
    plot(w/pi, angle(H));
    title(['Filter with ', char(window_func_name) ' Window:', ...
        ' Phase of Frequency Response']);
    xlabel('Normalized Frequency (\times\pi rad/sample)');
    ylabel('Phase (radians)');
end