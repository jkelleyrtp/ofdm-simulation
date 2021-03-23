classdef transmitter

    methods

        function prepare_samples()
        end

        % ==================
        %   Training
        % ==================
        function data = create_data(num_channels, num_chars)
            t_text = gensupport.dummy_text(num_chars);
            t_samples = gensupport.str_to_binvec(t_text);

            % block_data = arrayfun(@(x) encode_data(t_samples, prefix_length), zeros(num_channels));

            % map the data encode
            data = repmat(t_samples, num_channels, 1);

            % data = repmat(encode_data(t_samples, prefix_length), num_channels, 1);
        end

        function approximate_channel()

        end

        % ==================
        %   Encoding
        % ==================
        function create_real_data(num_channels, length)
            % data = arrayfun(@(x))

        end

        function out = encode_block(channel_source, prefix_length)
            % Encode a set of data with a cyclic prefix
            % Expects a list of arrays where each array is the data to be sent on each channel
            %
            % Returns a list of arrays where each array is the data to be sent on each channel
            % Final arrays will be extended by the prefix_length

            out = arrayfun(@(x) cyclic_prefix(x, prefix_length), channel_source);
        end

        function out = cyclic_prefix(data, prefix_length)
            % Simply concat the input and the end of the input to create a cyclical data array
            %
            % Approach illustrated in:
            %    https://dspillustrations.com/pages/posts/misc/the-cyclic-prefix-cp-in-ofdm.html
            %    symb1 = hstack([ofdm1[-NCP:], ofdm1])

            % Grab out the last N samples where N = prefix_length
            final = data(length(data) - prefix_length + 1:end);

            % Combine them
            out = [final, data];
        end

    end

end

% ensure the training data is right
function test_training_data()
end

% ensure the training data is right
function channel_approx()
end
