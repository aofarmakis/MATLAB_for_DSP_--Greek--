% Φόρτωση της εικόνας, μετατροπή της σε grayscale και λήψη του μεγέθους της
image = imread('acropolis.png');
I = rgb2gray(image);
imageSize = size(I);

% Αρχικοποίηση των μεταβλητών
N = 5;
numInstances = 200;
varStart = 0.05;
varEnd = 0.55;
varDropStart = numInstances / 2;
varStep = (varEnd - varStart) / varDropStart;

% Προκατανομή μνήμης για τη μεταβλητή noiseInstances
noiseInstances = cell(numInstances, 1);

% Αρχικοποίηση μητρώων για την αποθήκευση της διασποράς και
% των τιμών φιλτραρίσματος
varValues = zeros(numInstances, 1);
filteredValues = zeros(numInstances, 1);
noise_out_values = zeros(numInstances, 1);
mse_values_n = zeros(numInstances, 1);
mse_values_f = zeros(numInstances, 1);

% Βρόχος για το φιλτράρισμα σε κάθε εμφάνιση της εικόνας, αποθήκευση των
% στιγμιοτύπων θορύβου και αναπαραγωγή των εικόνων σειριακά σαν βίντεο
for instance = 1:numInstances
    % Υπολογισμός της διασποράς για το τρέχον στιγμιότυπο
    if instance <= varDropStart
        variance = varStart + (instance - 1) * varStep;
    else
        variance = varEnd - (instance - varDropStart) * varStep;
    end
    
    % Δημιουργία λευκού θορύβου μέσω της imnoise()
    noiseInstance = imnoise(I, 'gaussian', 0, variance);
    
    % Αποθήκευση της διασποράς και του στιγμιότυπου θορύβου
    varValues(instance) = variance;
    noiseInstances{instance} = noiseInstance;
    
    % Αναπαραγωγή των στιγμιοτύπων της θορυβοποιημένης εικόνας
    figure(1);
    imshow(noiseInstance);
    title(sprintf('Noisy Image (Variance = %.3f)', variance));
    axis off;
    drawnow;
    pause(0.001);

    % Υπολογισμός MSE μεταξύ αρχικής με τις θορυβοποιημένες εικόνες
    mse_n = sum(sum((double(I) - double(noiseInstance)).^2)) / ...
    (imageSize(1) * imageSize(2));
    mse_values_n(instance) = mse_n;
end

pause(1);

% Βρόχος για την εφαρμογή του φιλτραρίσματος σε κάθε στιγμιότυπο της
% θορυβοποιημένης εικόνας και αναπαραγωγή των εικόνων σειριακά σαν βίντεο
for instance = 1:numInstances
    % Λήψη του θορυβοποιημένου στιγμιότυπου της εικόνας
    noiseInstance = noiseInstances{instance};
    
    % Εφαρμογή του wiener2()
    [filteredImage, noise_out] = wiener2(noiseInstance, [N N], variance);
    
    % Εμφάνιση των φιλτραρισμένων στιγμιοτύπων της εικόνας
    figure(2);
    imshow(filteredImage);
    title(sprintf('Filtered Image (Variance = %.3f)', varValues(instance)));
    axis off;
    drawnow;
    pause(0.001);
    
    % Αποθήκευση της τιμής φιλτραρίσματος και των τιμών θορύβου
    filteredValues(instance) = filteredImage(1, 1);
    noise_out_values(instance) = noise_out;

    % Υπολογισμός MSE μεταξύ θορυβοποιημένων και φιλτραρισμένων εικόνων
    mse_f = sum(sum((double(I) - double(filteredImage)).^2)) / ...
    (imageSize(1) * imageSize(2));
    mse_values_f(instance) = mse_f;
end

% Σχεδιασμός γραφήματος της σχέσης μεταξύ της εξομάλυνσης και
% των στιγμιοτύπων της εικόνας
figure(3);
plot(filteredValues, 'bo');
xlabel('Instances', 'FontSize', 14);
ylabel('Smoothing', 'FontSize', 14);
title('Smoothing in relation to image instances', 'FontSize', 14);
xlim([0 numInstances]);
set(gcf, 'Color', [1, 1, 1]);

% Σχεδιασμός γραφήματος του μέσου τετράγωνικού σφάλματος (MSE) μεταξύ
% των στιγμιοτύπων της αρχικής εικόνας και της θορυβώδους εικόνας σε σχέση
% με τα στγμιότυπα της αρχικής εικόνας και της φιλτραρισμένης εικόνας
figure(4);
plot(mse_values_n);
hold on
plot(mse_values_f);
hold off
xlabel('Instances', 'FontSize', 14);
ylabel('Mean Squared Error (MSE)', 'FontSize', 14);
title('MSE between Original-Noisy and Original-Filtered Instances', 'FontSize', 14);
legend('Original-Noisy', 'Original-Filtered', 'FontSize', 12);
xlim([0 numInstances]);
set(gcf, 'Color', [1, 1, 1]);

% Σχεδιασμός γραφήματος της σχέσης μεταξύ της πυκνότητας (διασπορά)
% του θορύβου και της εκτιμώμενης ισχύος του υπολειπόμενου θορύβου
figure(5);
plot(varValues, noise_out_values);
xlabel('Variance of Noise', 'FontSize', 14);
ylabel('Estimated Power of Residual Noise', 'FontSize', 14);
title('Residual Noise vs. Variance', 'FontSize', 14);
xlim([varStart varEnd]);
set(gcf, 'Color', [1, 1, 1]);