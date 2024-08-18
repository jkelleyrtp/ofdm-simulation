classdef Transmitter
    properties
        block_size = 64;
        prefix_length = 0;
        training_blocks = 1;
        estimation_blocks = 1;
        preamble_blocks = 0;
    end

    methods
        function self = Transmitter()
        end

        function self = with_block_size(self, block_size)
            self.block_size = block_size;
        end

        function self = with_cyclic_prefix(self, prefix_length)
            self.prefix_length = prefix_length;
        end

        function self = with_preamble(self, preamble_blocks)
            self.preamble_blocks = preamble_blocks;
        end

        function self = with_training_blocks(self, training_blocks)
            self.training_blocks = training_blocks;
        end

        function samples = transmit(self, bin_stream)
            % Take in a datastream of 1s and 0s and convert it to 1s and -1s
            %             bpsk_stream = bin_stream;
            bpsk_stream = (bin_stream .* 2) - 1;

            % Reshape the stream into an abitrary # of columns with a fixed size
            % The number of blocks automatically expands to fit the input data
            block_data = reshape(bpsk_stream, [], self.block_size);

            training_signals = Utils.training_signals(self.block_size);
            training_signals = repmat(training_signals, 1, self.training_blocks);

            block_data = [training_signals; block_data];
            block_data = prefix_block(block_data, self.prefix_length);

            % Preamble the data
            if self.preamble_enabled
                % todo
                preamble = zeros(self.block_size, 1);
                block_data = [preamble block_data];
            end

            % Flatten the block structure down into a single stream
            %             transpose is very important, for whatever erason
            samples = reshape(transpose(block_data), 1, []);

            % Add features to lock onto the signal easier
            locking = Utils.locking_features();
            samples = [locking samples];
        end

    end
end

function block_data = prefix_block(blockstream, prefix_length)
    % Rehsape the data into the appropraite block sizes
    block_data = zeros(...
        size(blockstream, 1), ... % Column length (with prefix if prefixenabled)
        size(blockstream, 2) + prefix_length ... % Number of rows
        );

    % Encode the data with a prefix
    stop = size(blockstream, 1);
    for k = 1:stop
        iffted = ifft(blockstream(k, :));
        block_data(k, :) = cyclic_prefix(iffted, prefix_length);
    end
end

function out = cyclic_prefix(data, prefix_length)
    % Simply concat the input and the end of the input to create a cyclical data array
    %
    % Approach illustrated in:
    %    https://dspillustrations.com/pages/posts/misc/the-cyclic-prefix-cp-in-ofdm.html
    %    symb1 = hstack([ofdm1[-NCP:], ofdm1])

    % Grab out the last N samples where N = prefix_length
    pref = data(length(data) - prefix_length + 1:end);
    out = transpose([pref data]);
end

function preamble = create_preamble(preamble_size)
    preamble = 1:1:preamble_size;
end
