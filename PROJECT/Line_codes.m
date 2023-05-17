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


% NRZ inverted
nrz_inv = -nrz;



% RZ
rz = zeros(1, length(binary_vector)*length(t));
for i = 1:length(binary_vector)
    if binary_vector(i) == 0
        rz((i-1)*length(t)+1:i*length(t)) = [-1*ones(1, length(t)/2), zeros(1, length(t)/2)];
    else
        rz((i-1)*length(t)+1:i*length(t)) = [ones(1, length(t)/2), zeros(1, length(t)/2)];
    end
end



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


% Manchester coding
manchester = zeros(1, length(binary_vector)*length(t));
for i = 1:length(binary_vector)
    if binary_vector(i) == 0
        manchester((i-1)*length(t)+1:i*length(t) )= [-1*ones(1, length(t)/2) ones(1, length(t)/2)] ;
    else
        manchester((i-1)*length(t)+1:i*length(t)) = [ones(1, length(t)/2)  -1*ones(1, length(t)/2)];
    end
end


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








N = length(nrz); % number of samples in the signal
L = floor(N/2); % length of each segment used in spectral estimation
[Pxx1, F1] = pwelch(nrz, hamming(L), L/2, [], fs);
[Pxx2, F2] = pwelch(nrz_inv, hamming(L), L/2, [], fs);
[Pxx3, F3] = pwelch(rz, hamming(L), L/2, [], fs);
[Pxx4, F4] = pwelch(ami, hamming(L), L/2, [], fs);
[Pxx5, F5] = pwelch(manchester, hamming(L), L/2, [], fs);
[Pxx6, F6] = pwelch(multi_level_3, hamming(L), L/2, [], fs);
f = 0:10/length(Pxx1):10- (10/length(Pxx1));

figure;
subplot(711)
plot(x_axis,repelem(binary_vector,1000))
ylim([-2 2])
title('Generated Data');
xlabel('Time (s)');
ylabel('Amplitude');
subplot(712);
plot(x_axis,nrz);
ylim([-2 2])
title('NRZ');
xlabel('Time (s)');
ylabel('Amplitude');
subplot(713);
plot(x_axis, nrz_inv);
ylim([-2 2])
title('NRZ Inverted');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(714);
plot(x_axis, rz);
ylim([-2 2])
title('RZ');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(715);
plot(x_axis, ami);
ylim([-2 2])
title('AMI');
xlabel('Time (s)');
ylabel('Amplitude');


subplot(7,1,6);
plot(x_axis, manchester);
ylim([-2 2])
title('Manchester');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(7,1,7);
plot(x_axis, multi_level_3);
ylim([-2 2])
title('Multi Level Transmission 3');
xlabel('Time (s)');
ylabel('Amplitude');









% Plot the estimated PSD of the NRZ signal
figure;
subplot(321);
plot(F1*7.5, Pxx1, 'LineWidth',2);
grid on
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Power Spectral Density (PSD) - NRZ');

subplot(322);
plot(F2*7.5, Pxx2, 'LineWidth',2);
grid on
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Power Spectral Density (PSD) - NRZI');

subplot(323);
plot(F3*7.5, Pxx3, 'LineWidth',2);
grid on
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Power Spectral Density (PSD) - RZ');

subplot(324);
plot(F4*7.5, Pxx4, 'LineWidth',2);
grid on
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Power Spectral Density (PSD) - AMI');

subplot(325);
plot(F5*7.5, Pxx5, 'LineWidth',2);
grid on
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Power Spectral Density (PSD) - Manchester');

subplot(326);
plot(F6*7.5, Pxx6, 'LineWidth',2);
grid on
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Power Spectral Density (PSD) - MLT-3');
