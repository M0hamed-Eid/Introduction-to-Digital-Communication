function BER = ComputeBER(bit_seq,rec_bit_seq)
%
% Inputs:
%   bit_seq:     The input bit sequence
%   rec_bit_seq: The output bit sequence
% Outputs:
%   BER:         Computed BER
%
% This function takes the input and output bit sequences and computes the
% BER
% Compute number of bit errors
no_errors = sum(bit_seq ~= rec_bit_seq);
% Compute BER
BER = no_errors/length(bit_seq);