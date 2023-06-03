function Hd = Butterworth_Bandstop
% BUTTERWORTH_BANDSTOP Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.13 and Signal Processing Toolbox 9.1.
% Butterworth Bandstop filter designed using FDESIGN.BANDSTOP.

% All frequency values are in Hz.
Fs = 44100;  % Sampling Frequency

N   = 10;   % Order
Fc1 = 895;  % First Cutoff Frequency
Fc2 = 905;  % Second Cutoff Frequency

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandstop('N,F3dB1,F3dB2', N, Fc1, Fc2, Fs);
Hd = design(h, 'butter');

% [EOF]