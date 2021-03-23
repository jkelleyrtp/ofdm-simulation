classdef receiver
    methods (Static)
        function corrected_samples = time_correction(sent_samples, received_samples)
            % Determine how much y1 is lagging
            [fits, lags] = xcorr(received_samples, sent_samples);

            % Get the index of the greatest xcorr shift
            [~, index] = max(abs(fits));

            % Resize the time array
            corrected_samples = received_samples(lags(index) + 1:end);
        end

        function decoded = decode(samples, block_count, block_size, prefix_length)
            decoded = [];

            % Length of a single received channel block
            channel_length = block_size + prefix_length;

            for i = 1:channel_length:block_count * channel_length - (channel_length -1)
                subblock = samples(...
                    i + prefix_length ...
                    : ...
                    i + channel_length - 1 ...
                    );

                % Add the block as a new row
                decoded = [decoded fft(subblock)];
            end
        end

        function equalized = equalize_received_samples(decoded_samples, hk, block_count)
            equalized = decoded_samples ./ repmat(hk, 1, block_count);
        end

    end
end
