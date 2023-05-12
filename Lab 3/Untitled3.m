clear all;

%1- Get the number of samples from user
samples = input("Enter the number of samples ");

%2- Define signal patterns
S1 = ones(1,samples); % high voltage pattern for representing 1
S2 = zeros(1,samples); % low voltage pattern for representing 0

%3- Generate input signal and represent each bit with proper waveform
inputSignal = randi([0 1],1,1e5); % generate a random binary input signal of length 1e6
waveForm =[];
for i = 0:length(inputSignal)-1 
    if inputSignal(i+1) == 1 % if the input bit is 1, the waveform is the high voltage pattern
        waveform = S1;    
    else         
        waveform = S2; % else, the waveform is the low voltage pattern
    end
    waveForm((samples*i)+1:samples*i+length(waveform)) = waveform; % fill in the preallocated waveform with the waveform of the current bit
end

%4- Add noise to samples
bitErrorRate = [];
correlationBitErrorRate = [];
signalToNoiseRatio = 0:2:30;
for snr = 0:2:30
    noisyWaveForm = awgn(waveForm, snr, 'measured'); % add AWGN noise to the waveform
    noisyInputSignal = awgn(inputSignal, snr, 'measured'); % add AWGN noise to the input signal
    
    %5- Apply convolution process in the receiver
    g = S1 - S2;
    matchedFilterResponse = g(end:-1:1); % reflection and shift with t=T
    receivedSignal = zeros(1,length(inputSignal));
    convOutput = zeros(1, (2*samples-1)*length(inputSignal));
    % 6- Sample the output of the Matched filter (i.e. choose the middle sample, you may use indexing tools)
    for i = 0:length(inputSignal)-1
        noisyWaveFormSamples = noisyWaveForm((i*samples)+1:(i+1)*samples); % extract samples
        convResult = conv(noisyWaveFormSamples,matchedFilterResponse);
        % Concatenate the convolution results
        convOutput( (length(matchedFilterResponse)+length(noisyWaveFormSamples)-1)*i+1:(length(matchedFilterResponse)+length(noisyWaveFormSamples)-1)*i+length(convResult) ) = convResult;  
        middleSampleIndex = samples + (length(matchedFilterResponse)+length(noisyWaveFormSamples)-1)*(i); % middle sample index
        receivedSignal(i+1) = convOutput(middleSampleIndex); % concatenate the middle sample to the output   
    end
    
    % Calculate threshold
    threshold = sum(receivedSignal)/length(receivedSignal);
    receivedSignalWithThreshold = zeros(1, 1e5);
    % 7 - Decide whether the Rx_sequence is ‘1’ or ‘0’ by comparing the samples with threshold
    for j = 1:length(receivedSignal)
        if(receivedSignal(j) >= threshold)
            receivedSignalWithThreshold(j) = 1;
        else
            receivedSignalWithThreshold(j) = 0;
        end 
    end
    % 8 - Compare the original bits with the detected bits and calculate number of errors (you can make use of xor or biterr).
    [number, ratio] = biterr(inputSignal, receivedSignalWithThreshold, []); % calculate bit error rate using the received signal with threshold
    bitErrorRate = [bitErrorRate ratio]; 

    % Correlator
    receivedSignalWithNoise = inputSignal.*noisyInputSignal;
    threshold = sum(receivedSignalWithNoise)/length(receivedSignalWithNoise);
    receivedSignalWithNoiseAndThreshold = zeros(1, 1e5);
    for j = 1:length(receivedSignalWithNoise)
        if(receivedSignalWithNoise(j) >= threshold)
            receivedSignalWithNoiseAndThreshold(j) = 1;
        else
            receivedSignalWithNoiseAndThreshold(j) = 0;
        end 
    end
    [number, ratio] = biterr(inputSignal, receivedSignalWithNoiseAndThreshold, []); % calculate bit error rate using the received signal with noise and threshold
   % 9 - Save the probability of error of each SNR in matrix, BER
    correlationBitErrorRate = [correlationBitErrorRate ratio];       
end

% 10 - Plot the BER curve against SNR (use semilogy)
figure; semilogy(signalToNoiseRatio, bitErrorRate); title('Matched Filter');
figure; semilogy(signalToNoiseRatio, correlationBitErrorRate);title('Correlator');
figure; semilogy(signalToNoiseRatio, bitErrorRate,'r');hold on;
semilogy(signalToNoiseRatio, correlationBitErrorRate,'g');
hold off; legend('Matched Filter','Correlator');

% Calculation of transmitted signal power
transmittedPower = (1/1e5) * sum(inputSignal.^2);
display(transmittedPower); % display the transmitted power