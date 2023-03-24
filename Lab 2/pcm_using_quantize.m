clear, clc ,close all;

% Parameters
A = 1;                      % amplitude of sinusoidal wave
f = 2;                      % frequency of sinusoidal wave
Fs = 4000;                  % sampling frequency
m = 7;                      % total number of bits, including the sign bit
n = floor((m-1)/2);         % number of bits for integer value and fraction part

% Generate the signal
t1 = 0:1/Fs:1/f;             % time vector
x = A*sin(2*pi*f*t1);        % sinusoidal wave

% Quantize the signal using quantize command
vmax = max(abs(x));         % maximum absolute value of input signal (m_P)
q = 2*vmax/(2^n);           % quantization step size
% Apply quantize function to the scaled input
xq = quantize(x, fi([], true, 16, 0));

% Convert the quantized samples to binary
x_bin = dec2bin(xq);

% Calculate the mean square quantization error
n_values = [3, 4, 5, 6, 7, 8, 9, 10];
mse = zeros(size(n_values));
for i = 1:length(n_values)
    n = n_values(i);
    m = 2*n + 1;
    quantized_signal = quantize(x, fi([], true, 16, 0));
    quantization_error = x - quantized_signal;
    mse(i) = sum(quantization_error.^2)/length(quantization_error);
    fprintf('n = %d, MSE = %f\n', n, mse(i));
end
