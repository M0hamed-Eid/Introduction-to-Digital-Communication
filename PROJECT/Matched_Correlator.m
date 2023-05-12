clear, clc, close all;
tic;  % start timer

%% Simulation parameters
num_bits = 1e5;                         % Number of bits
SNR = 0:2:30;                           % SNR range in dB
% Prompt user for input of m or set default value to 20
default_m = 20;													% Number of samples representing waveform
prompt = sprintf('Enter the number of samples representing waveform (default is %d): ', default_m);
user_m = input(prompt);

% If user enters a value, use it, otherwise use the default value
if ~isempty(user_m)
    m = user_m;
else
    m = default_m;
end
n = num_bits*m;                         % Total number of samples
T = 1;                                  % Symbol duration
t = linspace(0,T,m);                    % Time vector

% Generate rectangular pulse s1(t)
prompt = 'Enter s1(t) as an amplitude number (default = 1 ): ';
s = input(prompt);
if isempty(s)
    s1 = ones(1,m);	
else
		s1 = s * ones(1,m);
end

% Generate zero signal s2(t)
prompt = 'Enter s2(t) as an amplitude number (default = 0 ): ';
s = input(prompt);
if isempty(s)
    s2 = zeros(1,m);
else
		s2 = s * ones(1,m);
end                  

%% Generate random binary data vector
data = randi([0 1],1,num_bits);

%% Modulate data with waveform
waveform = repelem(data,m);

%% Add noise to samples
berMF = zeros(1,length(SNR));
berCorr = zeros(1,length(SNR));

for iSNR = 1:length(SNR)
    snr = SNR(iSNR);
    
    % Calculate transmitted signal power and display it
    TxPower = sum(abs(waveform).^2)/length(waveform);
		if snr == 0
			fprintf('Transmitted Power = %.3f Watts(W)\n',TxPower);
		end
		
    % Add white Gaussian noise to waveform
    noisyWF = awgn(waveform, snr, 'measured');
    % Add noise to data bits
    xNoisy = awgn(data, snr, 'measured');

    % Apply convolution process in the receiver
    % Response of matched filter
    diff = s1 - s2;
    g = diff(end:-1:1);                  % reflection and shift with t=T

    received = zeros(1,length(data));
    convOP = zeros(1, (2*m-1)*length(data));

    for i = 0:length(data)-1
        noisyWF_20 = noisyWF((i*m)+1:(i+1)*m);       % Extracting 20 samples
        c = conv(noisyWF_20,g);
        % Concatenating the conv results
        convOP( (length(g)+length(noisyWF_20)-1)*i+1:(length(g)+length(noisyWF_20)-1)*i+length(c) ) = c;
        k = m + (length(g)+length(noisyWF_20)-1)*(i);        % middle sample index
        received(i+1) = convOP(k);                           % concatenating the middle sample to the o/p
    end

    % Calculating threshold
    TH = sum(received)/length(received);
    received_TH = received >= TH;

    [~, ratio] = biterr(data, received_TH);
    berMF(iSNR) = ratio;

    % Correlator
    xReceived = data.*xNoisy;
    TH = sum(xReceived)/length(xReceived);
    xReceived_TH = xReceived >= TH;

    [~, ratio] = biterr(data, xReceived_TH);
    berCorr(iSNR) = ratio;
end

% Plot BER vs SNR curves for matched filter and correlator
figure;
subplot(311)
semilogy(2*SNR, berMF, 'LineWidth', 1.5);
xlim([0 30])
xlabel('SNR (dB)'),ylabel('Bit Error Rate');
set(gca,'FontWeight','bold')
set(gca,'TitleFontSizeMultiplier',1.2)
title('Matched filter');
subplot(312)
semilogy(2*SNR, berCorr, 'LineWidth', 1.5);
xlim([0 30])
xlabel('SNR (dB)'),ylabel('Bit Error Rate');
set(gca,'FontWeight','bold')
set(gca,'TitleFontSizeMultiplier',1.2)
title('Correlator');
subplot(313)
semilogy(2*SNR, berMF, '^-', 'LineWidth', 2, 'MarkerSize', 8);
hold on;
xlabel('SNR (dB)'),ylabel('Bit Error Rate');
semilogy(2*SNR, berCorr, 'o-', 'LineWidth', 2, 'MarkerSize', 8);
hold off;
set(gca,'FontWeight','bold')
set(gca,'TitleFontSizeMultiplier',1.2)
xlim([0 30])
legend('matched filter','correlator');
disp(['Elapsed time: ', num2str(toc), ' seconds']);  % display elapsed time