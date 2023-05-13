clear, clc, close all;

% Generate a random binary vector
binary_vector = randi([0 1], 1, 10);

% Set the sampling frequency and bit time
fs = 100;
Tb = 10;

% Generate time vector
t = 0:1/fs:Tb-1/fs;
x_axis = 0: 0.001:10-0.001;
% NRZ

nrz = zeros(1, length(binary_vector)*length(t));
for i = 1:length(binary_vector)
    if binary_vector(i) == 0
        nrz((i-1)*length(t)+1:i*length(t)) = [-1*ones(1, length(t)/2), -1*ones(1, length(t)/2)];
    else
        nrz((i-1)*length(t)+1:i*length(t)) = [ones(1, length(t)/2), ones(1, length(t)/2)];
    end
end
nrz_psd = abs(fftshift(fft(nrz))).^2/Tb;
nrz_f = linspace(-fs/2,fs/2,length(nrz_psd));




% NRZ inverted
nrz_inv = -nrz;



nrz_inv_psd = abs(fftshift(fft(nrz_inv))).^2/Tb;
nrz_inv_f = linspace(-fs/2,fs/2,length(nrz_inv_psd));

% RZ
rz = zeros(1, length(binary_vector)*length(t));
for i = 1:length(binary_vector)
    if binary_vector(i) == 0
        rz((i-1)*length(t)+1:i*length(t)) = [-1*ones(1, length(t)/2), zeros(1, length(t)/2)];
    else
        rz((i-1)*length(t)+1:i*length(t)) = [ones(1, length(t)/2), zeros(1, length(t)/2)];
    end
end



rz_psd = abs(fftshift(fft(rz))).^2/Tb;
rz_f = linspace(-fs/2,fs/2,length(rz_psd));

% AMI
ami = zeros(1, length(binary_vector)*length(t));
last_volt = 1;
for i = 1:10
    if binary_vector(i) == 0
        ami((i-1)*length(t)+1:i*length(t)) = zeros(1, length(t));
    else
        ami((i-1)*length(t)+1:i*length(t)) = last_volt * [1*ones(1, length(t)/2), 1*ones(1, length(t)/2)];
        last_volt = -1*ami(i*length(t));
    end
end


ami_psd = abs(fftshift(fft(ami))).^2/Tb;
ami_f = linspace(-fs/2,fs/2,length(ami_psd));

% Manchester coding
manchester = zeros(1, length(binary_vector)*length(t));
for i = 1:length(binary_vector)
    if binary_vector(i) == 0
        manchester((i-1)*length(t)+1:i*length(t) )= [-1*ones(1, length(t)/2) ones(1, length(t)/2)] ;
    else
        manchester((i-1)*length(t)+1:i*length(t)) = [ones(1, length(t)/2)  -1*ones(1, length(t)/2)];
    end
end



manchester_psd = abs(fftshift(fft(manchester))).^2/Tb;
manchester_f = linspace(-fs/2,fs/2,length(manchester_psd));

% Multi level transmission 3
multi_level_3 = zeros(1, length(binary_vector)*length(t));
prev=[ones(1,length(t)), zeros(1,length(t)) ,ones(1,length(t))];
last_value=[1 0 -1 0];
n=1;
for i = 1:length(binary_vector)
     
    if binary_vector(i) == 0
        multi_level_3((i-1)*length(t)+1:i*length(t)) =last_value(n)*ones(1,length(t)) ;
    else
        n=n+1;
		if n==5
			n=1;
		end
        multi_level_3((i-1)*length(t)+1:i*length(t)) =last_value(n)*ones(1,length(t));
    end
    
end

mlt3_psd = abs(fftshift(fft(multi_level_3))).^2/Tb;
mlt3_f = linspace(-fs/2,fs/2,length(mlt3_psd));






N = length(rz); % number of samples in the signal
L = floor(N/2); % length of each segment used in spectral estimation
[Pxx, F] = pwelch(manchester, hamming(L), L/2, [], fs);
% Plot the estimated PSD of the NRZ signal

figure;
plot(F, Pxx, 'LineWidth',2);
xlabel('Frequency (Hz)');
ylabel('PSD');
title('PSD of Manchester signal');

% figure;
% semilogy(F, Pxx, 'LineWidth',2);
% xlabel('Frequency (Hz)');
% ylabel('PSD');
% title('PSD of NRZ signal');