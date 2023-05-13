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

% Quantize the signal using compand command
vmax = max(abs(x));         % maximum absolute value of input signal (m_P)
mu = 255;                   % companding law parameter

% Calculate the mean square quantization error
n_values = [3, 4, 5, 6, 7, 8, 9, 10];
mse = zeros(size(n_values));
for i = 1:length(n_values)
    n = n_values(i);
    m = 2*n + 1;
    xq = compand(x,mu,vmax,'mu/compressor');% quantize signal using compand command
    xq = fi(xq,1,m,n);          % convert to fi object
    xq = double(xq);                   % convert to double precision for further processing
    exband = compand(xq,mu,vmax,'mu/expander');% quantize signal using compand command
    quantization_error = x -exband;
    mse(i) = sum(quantization_error.^2)/length(quantization_error);
    fprintf('n = %d, MSE = %f\n', n, mse(i));
end
