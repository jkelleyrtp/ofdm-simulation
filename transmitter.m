classdef transmitter

    methods (Static)

        function prepare_samples()
        end

        % ==================
        %   Training
        % ==================
        function data = create_data(num_channels, num_chars)
            t_text = gensupport.dummy_text(num_chars);
            t_samples = gensupport.str_to_binvec(t_text);

            % map the data encode
            data = repmat(t_samples, num_channels, 1);
        end

        function approximate_channel()

        end

        % ==================
        %   Encoding
        % ==================
        function out = encode_block(channel_source, prefix_length)
            % Encode a set of data with a cyclic prefix
            % Expects a list of arrays where each array is the data to be sent on each channel
            %
            % Returns a list of arrays where each array is the data to be sent on each channel
            % Final arrays will be extended by the prefix_length
            A = channel_source;
            row_len = size(A, 2) + prefix_length;
            out = zeros(size(A, 1), row_len);

            for k = 1:size(A, 1)
                out(k, :) = transmitter.cyclic_prefix(A(k, :), prefix_length);
            end

        end

        function out = cyclic_prefix(data, prefix_length)
            % Simply concat the input and the end of the input to create a cyclical data array
            %
            % Approach illustrated in:
            %    https://dspillustrations.com/pages/posts/misc/the-cyclic-prefix-cp-in-ofdm.html
            %    symb1 = hstack([ofdm1[-NCP:], ofdm1])

            % Grab out the last N samples where N = prefix_length
            out = [data(length(data) - prefix_length + 1:end), data];
        end

    end

end
