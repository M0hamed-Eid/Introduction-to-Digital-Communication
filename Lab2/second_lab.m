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

% Quantize the signal using fi command
vmax = max(abs(x));         % maximum absolute value of input signal (m_P)
q = 2*vmax/(2^n);           % quantization step size
xq = fi(x,1,m,n);           % quantize signal using fi command
xq = double(xq);            % convert to double precision for further processing

% Convert the quantized samples to binary
x_bin = de2bi((xq + 1)*(2/q), m, 'left-msb');

% Calculate the mean square quantization error
n_values = [3, 4, 5, 10];
mse = zeros(size(n_values));
for i = 1:length(n_values)
    n = n_values(i);
    m = 2*n + 1;
    quantized_signal = double(fi(x,1,m,n));
    quantization_error = x - quantized_signal;
    mse(i) = sum(quantization_error.^2)/length(quantization_error);
    fprintf('n = %d, MSE = %f\n', n, mse(i));
end

% reconstruction from oversampling
t1=0:0.001:1;% time signal
y=2*cos(2*pi*5*t1);
[B,A] = butter(3,1000/100000,'low' ); % butter fly filter
zero_added_signal=zeros(1,length(y)*10);
for i=1:length(y)
          zero_added_signal(i*10)=y(i);
end
zero_added_signal(1:9)=[];
% Adding zeros enhances the signal display and don't change the
% spectrum,it changes sampling freq. only
t2=linspace(0,1,length(zero_added_signal));
filtered_signal = filter(B,A,zero_added_signal);
figure(1),subplot(3,1,1);
plot(t1, y, 'b', t2, filtered_signal, 'r--');
title('Reconstruction from over sampling');
legend('Original signal', 'Reconstructed signal');

s=fft(filtered_signal);
s=fftshift(s);
fs=1000; 
freq=linspace(-fs/2,fs/2,length(s));
figure(2),subplot(311)
plot(freq,abs(s))
xlabel('freq')
ylabel('magnitude of over sampled signals')

% construction from minimum sampling
t1=0:1/(2*5):1; % replace ?? with the suitable number
y=2*cos(2*pi*5*t1);
[B,A] = butter(10,0.1,'low' );
zero_added_signal=zeros(1,length(y)*10);
for i=1:length(y)
          zero_added_signal(i*10)=y(i);
end
zero_added_signal(1:9)=[];
t2=linspace(0,1,length(zero_added_signal));
filtered_signal = filter(B,A,zero_added_signal);
figure(1),subplot(3,1,2);
plot(t1, y, 'b', t2, filtered_signal, 'r--');
title('Reconstruction from over sampling');
legend('Original signal', 'Reconstructed signal');

s=fft(filtered_signal);
s=fftshift(s);
fs=10; % why 100?? Write your comments in the m file
freq=linspace(-fs/2,fs/2,length(s));
figure(2),subplot(312)
plot(freq,abs(s))
xlabel('freq')
ylabel('magnitude of minimum sampled signals')

% construction from undersampling sampling
t1=0:0.2:1;
y=2*cos(2*pi*5*t1);
[B,A] = butter(10,0.2,'low' );
zero_added_signal=zeros(1,length(y)*10);
for i=1:length(y)
          zero_added_signal(i*10)=y(i);
end
zero_added_signal(1:9)=[];
t2=linspace(0,1,length(zero_added_signal));
filtered_signal = filter(B,A,zero_added_signal);
figure(1),subplot(3,1,3);
plot(t1, y, 'b', t2, filtered_signal, 'r--');
title('Reconstruction from under sampling');
legend('Original signal', 'Reconstructed signal');

s=fft(filtered_signal);
s=fftshift(s);
fs=5; 
freq=linspace(-fs/2,fs/2,length(s));
figure(2),subplot(313)
plot(freq,abs(s))
xlabel('freq')
ylabel('magnitude of under sampled signals')
