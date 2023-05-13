function sample_seq = GenerateSamples(bit_seq,fs)
%
% Inputs:
%   bit_seq:    Input bit sequence
%   fs:         Number of samples per bit
% Outputs:
%   sample_seq: The resultant sequence of samples
%
% This function takes a sequence of bits and generates a sequence of
% samples as per the input number of samples per bit

sample_seq = zeros(size(bit_seq*fs));
% Define the pulse shape
pulse_shape = ones(1,fs);
% Map each bit to a specific amplitude level and generate the waveform
for i = 1:length(bit_seq)
    if bit_seq(i) == 0
        sample_seq((i-1)*fs+1:i*fs) = 0;
    else
        sample_seq((i-1)*fs+1:i*fs) = pulse_shape;
    end
end
