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
            received_len = block_count * channel_length - channel_length + 1;

             for idx = 1:channel_length:received_len
                subblock = samples(...
                    idx + prefix_length ...
                    : ...
                    idx + prefix_length + block_size - 1 ...
                    );

                % Add the block as a new row
                decoded = [decoded fft(subblock)];
             end
        end

        function equalized = equalize_received_samples(decoded_samples, hk, block_count)
            hk_m = repmat(hk, 1, block_count);

            % Elementwise divide
            equalized = decoded_samples ./ hk_m;
        end
        
%         function f_offset = normalize_frequency(samples, block_size)
%                 
%         end

        function [num_errors, error_rate] = estimate_error(sent_samples, received_samples)
            normalized_rx = sign(real(received_samples));
            num_errors = sum(normalized_rx ~= sent_samples);
            error_rate = num_errors / length(sent_samples);
        end
    end
end
