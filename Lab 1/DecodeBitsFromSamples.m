 function rec_bit_seq = DecodeBitsFromSamples(rec_sample_seq,case_type,fs)
% Inputs:
%   rec_sample_seq: The input sample sequence to the channel
%   case_type:      The sampling frequency used to generate the sample sequence
%   fs:             The bit flipping probability
% Outputs:
%   rec_sample_seq: The sequence of sample sequence after passing through the channel
% This function takes the sample sequence after passing through the
% channel, and decodes from it the sequence of bits based on the considered
% case and the sampling frequence
if (nargin <= 2)
    fs = 1;
end
switch case_type
    case 'part_1'
        threshold = 0.5;
        rec_bit_seq = (rec_sample_seq > threshold);
    case 'part_2'
        % Reshape the array into blocks of fs samples
        block_samples = reshape(rec_sample_seq, fs, []);
        % Count the number of ones in each block
        block_counts = sum(block_samples, 1);
        rec_bit_seq = zeros(1,length(block_counts));
        for i = 1:length(block_counts)
            if (block_counts(i)>fs/2)
                rec_bit_seq(i)=1;
            end
        end
    case 'part_3'
        % Reshape the array into blocks of fs samples
        block_samples = reshape(rec_sample_seq, fs, []);
        rec_bit_seq = block_samples(1, :);
end