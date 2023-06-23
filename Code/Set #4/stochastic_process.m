% Δημιουργία ημιτονοειδούς σήματος συχνότητας πλάτους Α = [-1, 1],
% με 500 δείγματα ανά περίοδο και δημιουργία του αντίστοιχου γραφήματος
samples = 500;
Ts = 1/samples;
n = -2*(1/Ts):2*(1/Ts);
y = sin(2*pi*n*Ts);

figure(1);
plot(n, y);
hold on;
plot([min(n) max(n)], [0 0], 'black');
plot([0 0], [(1.1*min(y)) (1.1*max(y))], 'black');
hold off;
xlabel('Samples');
ylabel('Amplitude');
title('Ημιτονοειδές Σήμα');
ylim([(1.1*min(y)) (1.1*max(y))]);

% Δημιουργία Κ υλοποιήσεων του στοχαστικού σήματος φορτώνοντας τη
% κατανομή Γάμμα από το αντίστοιχο .mat αρχείο
K = 1000;
load('gamma_distribution.mat', 'pd');
A = random(pd, K, 1);
X = A + y;
X1 = 1 + y;     % Ξεχωριστή υλοποίηση με τη μέση τιμή της κατανομής

% Υπολογισμός τιμών μέσης τιμής, διασποράς, αυτοσυσχέτισης και
% πυκνότητας φάσματος
arithmetic_mean = mean(mean(X));
variance = mean(var(X));
autocorrelation_p = xcorr(y);
autocorrelation_m = X' * X / K;
spectral_density_p = 20*log10(fftshift(abs(fft(autocorrelation_p))));
spectral_density_m = 20*log10(fftshift(abs(fft2(autocorrelation_m))));
expected_acorr = (X1)' * (X1);
expected_sd = 20*log10(fftshift(abs(fft2(expected_acorr))));

max_exp_acorr = max(expected_acorr(:));
max_acorr = max(autocorrelation_m(:));
max_exp_sd = max(expected_sd(:));
max_sd = max(spectral_density_m(:));

% Εκτύπωση τιμών μέσης τιμής, διασποράς και μclear allέγιστης παρατήρησης
fprintf('\nArithmetic Mean of stochastic signal = %f\n', arithmetic_mean);
fprintf('Variance of stochastic signal = %f\n\n', variance);
fprintf('Largest number expected in autocorrelation = %f\n', max_exp_acorr);
fprintf('Largest number observed in autocorrelation = %f\n\n', max_acorr);
fprintf('Largest number expected in SD = %f\n', max_exp_sd);
fprintf('Largest number observed in SD = %f\n', max_sd);

% Δημιουργία γραφημάτων
figure(2);
plot(pd);
grid on;
title('Κατανομή Γάμμα');

figure(3);
plot(n, X);
xlabel('Time');
ylabel('Amplitude');
title('Υλοποιήσεις της στοχαστικής διαδικασίας');

figure(4);
f = linspace(-0.5, 0.5, length(autocorrelation_p));
plot(f, autocorrelation_p);
grid on;
title('Αυτοσυσχέτιση του τριγωνικού κύματος');
xlabel('Sample Lag');
ylabel('Autocorrelation');

figure(5);
imagesc(n, n, autocorrelation_m);
axis image;
title('Αυτοσυσχέτιση του τριγωνικού κύματος (σε μορφή μητρώου)');

figure(6);
f = linspace(-0.5, 0.5, length(spectral_density_p));
plot(f, spectral_density_p);
grid on;
title('Πυκνότητα Φάσματος');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Power (dB)');

figure(7);
imagesc(spectral_density_m);
title('Πυκνότητα Φάσματος (σε μορφή μητρώου)');
axis image;
