clear, clc ,close all;

% Define the parameters
f_s = 4000;         % Sampling frequency (Hz)
f_sig = 2;          % Signal frequency (Hz)
A_sig = 1;          % Signal amplitude (V)

% Generate the time vector
t = 0:1/f_s:1-1/f_s;

% Generate the sinusoidal signal
x = A_sig*sin(2*pi*f_sig*t);

% Define the number of bits for quantization
n_bits = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

% Initialize the mean squared error (MSE) vector
mse = zeros(size(n_bits));

% Loop over each number of bits
for i = 1:length(n_bits)
    n = n_bits(i);              % Number of bits
    L = 2^n;                    % Number of quantization levels
    step_size = (2*A_sig)/L;    % Quantization step size
    partition = [-1:step_size:1];   % Define the partition for the quantization
    start = -A_sig - step_size;      % Define the start of the codebook
    codebook = [start:step_size:1];  % Define the codebook for the quantization
    [index,x_q,distor_linear] = quantiz(x,partition, codebook);  % Quantize the signal
    quantization_error = x - x_q;   % Calculate the quantization error
    mse(i) = sum(quantization_error.^2)/length(quantization_error); % Calculate the MSE
    fprintf('n = %d, MSE = %f\n', n, mse(i));  % Print the results
end

