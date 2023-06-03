function y = my_sinc(x)
	y = sin(pi*x) ./ (pi*x);
	% Εύρεση του index της NaN τιμής για την περίπτωση που x = 0
	index = isnan(y);
	y(index)=1;
end