% Τελεστές Sobel για τους άξονες x και y
sobel_x = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
sobel_y = [-1, -2, -1; 0, 0, 0; 1, 2, 1];

image = imread('acropolis.png');
I = rgb2gray(image);
I = double(I)/255;  % Κανονικοποίηση των τιμών φωτεινότητας των
                    % εικονοστοιχείων για ευκολότερες πράξεις

% Κλιμακώνει τα επίπεδα έντασης της εικόνας, έτσι ώστε η απεικόνιση
% λεπτομερειών να είναι ευκολότερη, ενισχύοντας την αντίθεση μεταξύ
% των διαφορετικών περιοχών. Για απλή προβολή της εικόνας: imshow(I)
figure(1);
imagesc(I);
colormap gray;
axis image;
title('Original image (grayscale)');

% Συνέλιξη του τελεστή Sobel κατά τον άξονα x
f_x = conv2(I, sobel_x, 'same');
figure(2);
imagesc(f_x);
colormap gray;
axis image;
title('∂I(x, y) / ∂x');

% Συνέλιξη του τελεστή Sobel κατά τον άξονα y
f_y = conv2(I, sobel_y, 'same');
figure(3);
imagesc(f_y);
colormap gray;
axis image;
title('∂I(x, y) / ∂y');

% Υπολογισμός ισχύς και προσανατοισμού των ακμών
edge_strength = sqrt(f_x.^2 + f_y.^2);
edge_orientation = atan2(f_y, f_x);

figure(4);
imagesc(edge_strength);
colormap gray;
axis image;
title('Edge Strength of image');

figure(5);
imagesc(edge_orientation);
axis image;
title('Edge Orientation of image');

%================ Moravec Corner Detection Algorithm Part ================%

% Καθορισμός του μεγέθους του παραθύρου για τον εντοπισμό γωνιών
w_size_m = 3;

% Αρχικοποίηση των μητρώων της γωνιακής απόκρισης με μηδενικά
response_ssd = zeros(size(I));
response_sad = zeros(size(I));

% Επανάληψη για κάθε εικονοστοιχείο της εικόνας
% SSD -> Sum of Squared Differences
% SAD -> Sum of Absolute Differences
for y = 1:size(I, 1)
    for x = 1:size(I, 2)
        % Υπολογισμός του SSD ή του SAD σε διαφορετικές κατευθύνσεις
        dx_window = f_x(max(1, y-floor(w_size_m/2)) : min(size(I, 1), ...
            y+floor(w_size_m/2)), max(1, x-floor(w_size_m/2)) : ...
            min(size(I, 2), x+floor(w_size_m/2)));
        dy_window = f_y(max(1, y-floor(w_size_m/2)) : min(size(I, 1), ...
            y+floor(w_size_m/2)), max(1, x-floor(w_size_m/2)) : ...
            min(size(I, 2), x+floor(w_size_m/2)));
        ssd_values = sum(dx_window(:).^2 + dy_window(:).^2);
        sad_values = sum(abs(dx_window(:)) + abs(dy_window(:)));

        % Αποθήκευση της απόκρισης γωνίας
        response_ssd(y, x) = ssd_values;
        response_sad(y, x) = sad_values;
    end
end

% Κατώφλι Moravec
m_thresh = 0.5;

% Αρχική εικόνα με τις ανιχνευμένες γωνίες χρησιμοποιώντας Moravec (SSD)
% και τυπωμένες ως κόκκινες τελείες
corners_ssd = response_ssd > m_thresh * max(response_ssd(:));
figure(6);
imshow(I);
title('Moravec Corner Detection (using SSD)');
hold on;
[x2, y2] = find(corners_ssd);
plot(y2, x2, 'r.', 'MarkerSize', 3);
hold off;

% Αρχική εικόνα με τις ανιχνευμένες γωνίες χρησιμοποιώντας Moravec (SAD)
% και τυπωμένες ως κόκκινες τελείες
corners_sad = response_sad > m_thresh * max(response_sad(:));
figure(7);
imshow(I);
title('Moravec Corner Detection (using SAD)');
hold on;
[x2, y2] = find(corners_sad);
plot(y2, x2, 'r.', 'MarkerSize', 3);
hold off;

%====================== Harris Corner Detection Part =====================%

% Καθορισμός του μεγέθους του παραθύρου για τον εντοπισμό γωνιών
w_size_h = 3;

% Αρχικοποίηση του παραθύρου για τη γωνιακή απόκριση
window = ones(w_size_h);

% Υπολογισμός των γινομένων του gradient
Ixx = f_x .* f_x;
Iyy = f_y .* f_y;
Ixy = f_x .* f_y;

% Υπολογισμός του αθροίσματος των τετραγώνων
Sxx = conv2(Ixx, window, 'same');
Syy = conv2(Iyy, window, 'same');
Sxy = conv2(Ixy, window, 'same');

% Ορισμός σταθεράς Harris, ορίζουσας και ίχνους του σχηματιζόμενου τανυστή
k = 0.04;
det_M = Sxx .* Syy - (Sxy).^2;
trace_M = Sxx + Syy;
harris_response = det_M - k * (trace_M).^2;

% Κατώφλι Harris
h_thresh = 0.1;

% Αρχική εικόνα με τις ανιχνευμένες γωνίες χρησιμοποιώντας την
% απόκριση Harris και τυπωμένες ως κόκκινες τελείες
corners_harris = harris_response > h_thresh * max(harris_response(:));
figure(8);
imshow(I);
title('Harris Corner Detection');
hold on;
[x2, y2] = find(corners_harris);
plot(y2, x2, 'r.', 'MarkerSize', 3);
hold off;

%==================== Corner Detection Comparison Part ===================%

% Σύγκριση των Harris και SSD Moravec
figure(9);
imshow(I);
title('Harris (red) vs SSD Moravec (blue) Corner Detections');
hold on;
[x1, y1] = find(corners_harris);
plot(y1, x1, 'r.', 'MarkerSize', 3);
[x2, y2] = find(corners_ssd);
plot(y2, x2, 'b.', 'MarkerSize', 3);

% Εύρεση των κοινών σημείων τα οποία τυπώνονται με πράσινο
overlap_points = intersect([x1, y1], [x2, y2], 'rows');
[x3, y3] = deal(overlap_points(:, 1), overlap_points(:, 2));
plot(y3, x3, 'g.', 'MarkerSize', 3);
hold off;

% Σύγκριση των Harris και SAD Moravec
figure(10);
imshow(I);
title('Harris (red) vs SAD Moravec (blue) Corner Detections');
hold on;
[x1, y1] = find(corners_harris);
plot(y1, x1, 'r.', 'MarkerSize', 3);
[x2, y2] = find(corners_sad);
plot(y2, x2, 'b.', 'MarkerSize', 3);

% Εύρεση των κοινών σημείων τα οποία τυπώνονται με πράσινο
overlap_points = intersect([x1, y1], [x2, y2], 'rows');
[x3, y3] = deal(overlap_points(:, 1), overlap_points(:, 2));
plot(y3, x3, 'g.', 'MarkerSize', 3);
hold off;