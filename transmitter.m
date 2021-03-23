classdef transmitter
    methods (Static)

        function data = create_data(num_channels, num_chars)
            t_text = dummy_text(num_chars);
            t_samples = str_to_binvec(t_text);

            % map the data encode
            data = repmat(t_samples, num_channels, 1);
        end

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
                out(k, :) = cyclic_prefix(A(k, :), prefix_length);
            end

        end

        function [sent, received] = transmit(encoded_block, prefix_length, block_count, num_chars)
            total_len = block_count * (num_chars * 8 + prefix_length);
            sent = reshape(encoded_block, total_len, 1)';
            received = nonflat_channel(sent);
        end
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

function out = dummy_text(num_chars)
    % Generate dummy text for X characters long.
    % Each character is 8 bits
    dummy = {
        'I met a traveller from an antique land, '
        'Who said—“Two vast and trunkless legs of stone '
        'Stand in the desert. . . . Near them, on the sand, '
        'Half sunk a shattered visage lies, whose frown, '
        'And wrinkled lip, and sneer of cold command, '
        'Tell that its sculptor well those passions read '
        'Which yet survive, stamped on these lifeless thing s,'
        'The hand that mocked them, and the heart that fed; '
        'And on the pedestal, these words appear: '
        'My name is Ozymandias, King of Kings; '
        'Look on my Works, ye Mighty, and despair! '
        'Nothing beside remains. Round the decay '
        'Of that colossal Wreck, boundless and bare '
        'The lone and level sands stretch far away. '
        };

    contents = sprintf('%s', dummy{:});

    % return the first N chars from dummy
    out = contents(1:num_chars);
end

function out = str_to_binvec(S)
    % Convert text to a vector of 1s and -1s
    out = (reshape(dec2bin(S, 8).' - '0', 1, [])') .* 2 - 1;
end
