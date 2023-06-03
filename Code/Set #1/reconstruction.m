%=========================================================================%
% Part 1: Constructing the graph for the sinc function
%=========================================================================%
t = linspace (-1, 1, 401);
y = my_sinc(2*pi*t);
figure(1);
hold on;
plot (t, y);
title('Plot of sinc(x) where −1 ≤ t ≤ 1');

% Plotting black axis lines for sinc function
plot([-1 1], [0 0], 'Color', [0, 0, 0]);
plot([0 0], [-0.5 1.5], 'Color', [0, 0, 0]);
legend('sinc(x)');
hold off;


%=========================================================================%
% Part 2: Numerical verification of signal reconstruction formula
%=========================================================================%
fs = 6;
Ts = 1/fs;
% Anonymous function definition of function x_a
x_a = @(t) 1 - 2*sin(pi*t) + cos(2*pi*t) + 3*cos(3*pi*t);

% Reconstruct x_a(t) from it samples
prompt = "Enter number of terms p: " ;
p = input(prompt);
t = linspace (-2, 2, 101);
x_p = zeros(size(t));
for i = 1 : length(t)
    for k = -p : p
    x_p(i) = x_p(i) + sum(x_a(k.*Ts) .* sinc(fs .* (t(i) - k.*Ts)));
    end
end
figure(2);
hold on;
plot (t, x_a(t), t, x_p);
title(['Partial Reconstruction using p = ', num2str(p)]);
xlabel('t (sec)');
ylabel('x(t)');
legend('x_a','x_p');
hold off;