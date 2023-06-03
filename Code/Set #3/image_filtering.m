I = imread('acropolis.png');

% Δημιουργία θορυβοποιημένης εικόνας με μέσο 0 και τυπική απόκλιση 0,05
noisy = imnoise(I, 'gaussian', 0, 0.05);

% Δημιουργία ενός Gaussian φίλτρου μέσω της fspecial()
sigma = 1.0;        % Τυπική απόκλιση της Gaussian κατανομής του φίλτρου
kernel_size = 3;    % Μέγεθος του πυρήνα συσχέτισης του φίλτρου
kernel = fspecial('gaussian', kernel_size, sigma);

%======================== Original Image Filtered ========================%

figure(1);
imshow(I);
title('Original Image');

% Εφαρμογή του Gaussian φίλτρου μέσω της imfilter()
% Η επιλογή 'replicate' χρησιμοποείται για την αποφυγή
% παραμορφώσεων στα όρια της εικόνας
imfiltered_o = imfilter(I, kernel, 'replicate');
figure(2);
imshow(imfiltered_o);
title('Filtered Original Image using imfilter()');

% Εναλλακτικά γίνεται και με προσθήκη της παραμέτρου 'DegreeOfSmoothing'
nlmfiltered_o = imnlmfilt(I);
figure(3);
imshow(nlmfiltered_o);
title('Filtered Original Image using imnlmfilt()');

%========================== Noisy Image Filtered =========================%

figure(4);
imshow(noisy);
title('Noisy Image');

% Εφαρμογή του Gaussian φίλτρου μέσω της imfilter()
% Η επιλογή 'replicate' χρησιμοποείται για την αποφυγή
% παραμορφώσεων στα όρια της εικόνας
imfiltered_n = imfilter(noisy, kernel, 'replicate');
figure(5);
imshow(imfiltered_n);
title('Filtered Noisy Image using imfilter()', 'FontSize', 14);
set(gcf, 'Color', [1, 1, 1]);
% Εναλλακτικά γίνεται και με προσθήκη της παραμέτρου 'DegreeOfSmoothing'
nlmfiltered_n = imnlmfilt(noisy);
figure(6);
imshow(nlmfiltered_n);
title('Filtered Noisy Image using imnlmfilt()', 'FontSize', 14);
set(gcf, 'Color', [1, 1, 1]);