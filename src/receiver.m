classdef Receiver
    properties
        block_size = 64;
        prefix_length = 0;
        training_blocks = 1;
        estimation_blocks = 1;
        preamble_blocks = 0;
    end

    methods
        function self = Receiver()
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

        function samples = receive(self, received)
            locking_features = Utils.locking_features();
            [tshift, lags] = xcorr(real(received), locking_features);

            % Get the index of the greatest xcorr shift
            [~, index] = max(abs(tshift));

            % Resize the received data, removing the locking features
            timing_correction = lags(index) + 1;
            locking_offset = size(locking_features, 2) + 1;
            corrected = received((timing_correction + locking_offset):end);

            % Create an output buffer to push the data into
            channel_length = self.block_size + self.prefix_length;
            decoded = [];

            % Length of a single received channel block
            for idx = 1:channel_length:(size(corrected, 2) - channel_length + 1)
                offset = idx + self.prefix_length;
                subblock = corrected(offset:(offset + self.block_size - 1));

                % Add the block as a new row
                decoded = [decoded; fft(subblock)];
            end

            % grab the first signal estimation entries and use them to estimate the channel
            % TODO: enable multi-sample channel estimation
            estimator = decoded(self.estimation_blocks, :);
            training = Utils.training_signals(self.block_size);
            hk = estimator ./ training;

            % prune the decoded samples to remove the training signals
            decoded = decoded(2:end, :);

            % Equalize the channel with the channel estimate
            decoded = decoded ./ hk;

            % Flatten down to a bit stream
            samples = reshape(transpose(decoded), 1, []);
        end
    end
end
