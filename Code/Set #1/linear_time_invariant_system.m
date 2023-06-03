% Η κρουστική απόκριση του συστήματος
h = [-1/12, 1/3, 1, -1/4, -2/9, -1/15];

% Ορισμός χιλίων δειγμάτων για τη συνάρτηση
[H, w] = freqz(h, 1, 1000);

% Κανονικοποιημένο γράφημα μέτρου απόκρισης συχνότητας
figure(1);
plot(w/pi, abs(H))
title('Μέτρο απόκρισης συχνότητας');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude');

% Κανονικοποιημένο γράφημα φάσης απόκρισης συχνότητας
figure(2);
plot(w/pi, angle(H));
title('Φάση απόκρισης συχνότητας');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Phase');

n = 0:10000;
x = sin((pi/3)*n) - cos((pi/4)*n) + (2/3).^n + (-1/4).^n;
y = filter(h, 1, x);

figure(3);
plot(x(1:100));
hold on;
plot(y(1:100));
title('Πρώτα 100 δείγματα εξόδου συστήματος');
xlabel('Samples');
ylabel('System Output');
legend('Input x', 'filter()');
hold off;

figure (4);
plot(x);
hold on;
plot(y);
title('Τελευταία 100 δείγματα εξόδου συστήματος');
xlabel('Samples');
ylabel('System Output');
legend('Input x', 'filter()');
% Θέτουμε τον άξονα x μεταξύ 9900 και 10000. Πρέπει να γίνει plot()
% ολόκληρου του σήματος για να εμφανιστεί σωστά το γράφημα
xlim([9900, 10000]);
% Θέτουμε το tick του άξονα x στις τιμές 9900 ως 10000 με βήμα 10
xticks(9900:10:10000);
hold off;