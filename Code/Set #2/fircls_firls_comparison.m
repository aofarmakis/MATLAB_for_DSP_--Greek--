% Κανονικοποιημένες συχνότητες
frequencies = [0, 0.13, 0.27 0.34, 0.46, 0.78, 0.89 1];

% Επιθυμητά πλάτη ανά συχνότητα
amplitude = [1, 1, 0, pi, 0, 1, 0];

% Τάξη φίλτρου και περιορισμοί μέγιστης απόκλισης στα όρια πλάτος και
n = 50;
upper_bound = [1.02, 1.02, 0.01, pi+0.02, 0.01, 1.02, 0.01];
lower_bound = [0.98, 0.98, -0.01, pi-0.02, -0.01, 0.98, -0.01];

% Σχεδίαση των φίλτρων least-squares με και χωρίς περιορισμούς μέσω βρόχου
% και του γραφήματος παραβίασης περιορισμών ανά ζώνη για το fircls()
for filter_type = 1:2
    if filter_type == 1
        filter_name = 'Least-Squares Filter with Constraints';
        filter = fircls(n, frequencies, amplitude, upper_bound, ...
            lower_bound, "both");
        figure(1);
    else
        filter_name = 'Standard Least-Squares Filter';
        filter = firls(n, frequencies, [amplitude, 0]);
    end
    
    % Δημιουργία αντίστοιχα αριθμημένου γραφήματος με βάση τη περίπτωση
    figure(filter_type + 1);
    
    % Σχεδίαση των υπογραφημάτων της κρουστικής απόκρισης και του μέτρου
    % και της φάσης της απόκρισης συχνότητας των φίλτρων fircls() και
    % firls() αντίστοιχα
    [H, w] = freqz(filter, 1, 1024);
    subplot(131);
    impulse_response = impz(filter);
    stem(impulse_response);
    title(['Impulse Response of ' filter_name]);
    xlabel('Sample Index');
    ylabel('Magnitude');
    xlim([0, n+2]);
    subplot(132);
    plot(w/pi, 20*log10(abs(H)))
    title(['Magnitude of Frequency Response of ' filter_name]);
    xlabel('Normalized Frequency (\times\pi rad/sample)');
    ylabel('Magnitude (dB)');
    subplot(133);
    plot(w/pi, angle(H));
    title(['Phase of Frequency Response of ' filter_name]);
    xlabel('Normalized Frequency (\times\pi rad/sample)');
    ylabel('Phase (radians)');
end