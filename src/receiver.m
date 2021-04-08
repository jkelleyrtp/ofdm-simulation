classdef Receiver
    properties
        block_size % Need to be set to use
        prefix_length = 0;
        training_blocks = 1;        
        preamble_enabled = false;
    end

    methods
        function self = Receiver(block_size)
            self.block_size = block_size;
        end

        function self = with_cyclic_prefix(self, prefix_length)
            self.prefix_length = prefix_length;
        end

        function self = with_preamble(self)
            % Enable the frequency preamble
            self.preamble_enabled = true;
        end

        function samples = receive(self, received)
              locking = Utils.locking_features();
            locking_len = size(locking, 2);
            locking_spaced = [locking ];
            locking = locking_spaced;
%             locking = DataLayer.create_transmission(10) .* 2 - 1;
            
            normalized_rx = real(received);
            [tshift, lags] = xcorr(  real(normalized_rx ), locking);
           
%             hold on 
%             stem(normalized_rx );
%             stem(locking );
%             legend("received", "locking");
%             hold off
%           
%             hold on
%             figure 
%             stem(lags);
%             hold off
% 
%             hold on
%             figure 
%             stem(tshift);
%             hold off

            % Get the index of the greatest xcorr shift
            [~, index] = max(abs(tshift));

            % Resize the received data, removing the locking features
            shiftamount = lags(index)
            corrected = received(shiftamount + 1:end);
%             corrected = received(shiftamount  + 1:end);
            
%             hold on
%             figure
%             stem(corrected)
%             hold off
%             
% 
%             
%             lockingsize = size(locking, 2);
            corrected = corrected(locking_len + 1:end);

%             hold on
%             figure
%             stem(corrected)
%             hold off
            
            % now, we should have a known training signal
            decoded = [];

            % Length of a single received channel block
            channel_length = self.block_size + self.prefix_length;
            received_len = size(corrected, 2);

            for idx = 1:channel_length:(received_len-channel_length + 1)
                subblock = corrected(...
                    idx + self.prefix_length ...
                    : ...
                    idx + self.prefix_length + self.block_size - 1 ...
                    );

                % Add the block as a new row
                decoded = [decoded; fft(subblock)];
            end

            % grab the first n entries and use them to estimate the channel
            estimator = decoded(1, :);
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
