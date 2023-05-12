% Parameters
num_bits = 10000;    % number of bits in data sequence
bit_rate = 1e6;      % bit rate in bits/sec
sampling_freq = 10*bit_rate;  % sampling frequency in Hz

% Generate binary data sequence
data = randi([0 1], 1, num_bits);

% Modulate binary data to obtain NRZ signal
nrz = 2*data - 1;

% Upsample NRZ signal to match sampling frequency
t = 0:1/bit_rate:(num_bits-1)/bit_rate;
upsample_factor = sampling_freq/bit_rate;
t_upsampled = 0:1/sampling_freq:(num_bits-1)/bit_rate;
nrz_upsampled = interp1(t, nrz, t_upsampled, 'previous');

% Compute PSD of NRZ signal using Welch's method
window_size = round(length(nrz_upsampled)/10);
[psd, f] = pwelch(nrz_upsampled, window_size, [], [], sampling_freq);

% Plot PSD
plot(f, 10*log10(psd));
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density of NRZ Signal');
