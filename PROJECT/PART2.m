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

figure;
subplot(721)
plot(x_axis,repelem(binary_vector,1000))
ylim([-2 2])
title('Generated Data');
xlabel('Time (s)');
ylabel('Amplitude');
subplot(723);
plot(x_axis,nrz);
ylim([-2 2])
title('NRZ');
xlabel('Time (s)');
ylabel('Amplitude');

% NRZ inverted
nrz_inv = -nrz;

subplot(725);
plot(x_axis, nrz_inv);
ylim([-2 2])
title('NRZ Inverted');
xlabel('Time (s)');
ylabel('Amplitude');

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

subplot(727);
plot(x_axis, rz);
ylim([-2 2])
title('RZ');
xlabel('Time (s)');
ylabel('Amplitude');

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

subplot(729);
plot(x_axis, ami);
ylim([-2 2])
title('AMI');
xlabel('Time (s)');
ylabel('Amplitude');

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

subplot(7,2,11);
plot(x_axis, manchester);
ylim([-2 2])
title('Manchester');
xlabel('Time (s)');
ylabel('Amplitude');

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

% Plot the modulated signals
subplot(7,2,13);
plot(x_axis, multi_level_3);
ylim([-2 2])
title('Multi Level Transmission 3');
xlabel('Time (s)');
ylabel('Amplitude');

mlt3_psd = abs(fftshift(fft(multi_level_3))).^2/Tb;
mlt3_f = linspace(-fs/2,fs/2,length(mlt3_psd));


subplot(724);
plot(nrz_f, nrz_psd);
title('NRZ');
xlabel('Frequency (Hz)');
ylabel('Power');

subplot(726);
plot(nrz_inv_f, nrz_inv_psd);
title('NRZ Inverted');
xlabel('Frequency (Hz)');
ylabel('Power');

subplot(728);
plot(rz_f, rz_psd);
title('RZ');
xlabel('Frequency (Hz)');
ylabel('Power');

subplot(7,2,10);
plot(ami_f, ami_psd);
title('AMI');
xlabel('Frequency (Hz)');
ylabel('Power');

subplot(7,2,12);
plot(manchester_f, manchester_psd);
title('Manchester');
xlabel('Frequency (Hz)');
ylabel('Power');

subplot(7,2,14);
plot(mlt3_f, mlt3_psd);
title('MLT-3');
xlabel('Frequency (Hz)');
ylabel('Power');