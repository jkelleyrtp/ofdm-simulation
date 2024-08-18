classdef Utils
    methods (Static)
        function [num_errors, error_rate] = estimate_error(sent_samples, received_samples)
            % estimate the data
            num_errors = sum(received_samples ~= sent_samples);
            error_rate = num_errors / length(sent_samples);
        end

        function binary_rx = normalize_received_samples(received_samples)
            normalized_rx = sign(real(received_samples));
            binary_rx = (normalized_rx + 1) ./ 2;
        end

        function data = training_signals(len)
            training_text = sprintf('%s', "He who shall not be named return");
            corpus = repmat(training_text, 1, ceil(len / 32));
            binvec = Utils.str_to_binvec(corpus);
            data = binvec .* 2 - 1;
            data = transpose(data(1:len));
        end

        function data = locking_features()
            % Consistent locking features
            data = ones(1, 100);
            % TODO: see if a hardcoded pseudorandom pattern is better than a block of ones
            % locking_text = sprintf('%s', "I solemnly swear I am up to no good");
            % data = Utils.str_to_binvec(locking_text) .* 2 - 1;
            % data = transpose(data);
        end

        function out = str_to_binvec(S)
            % Convert text to a vector of 1s and 0s
            % This code was taken from somewhere on the internet
            out = reshape(dec2bin(S, 8).' - '0', 1, [])';
        end

        function transmission = create_transmission(num_chars)
            contents = dummy_text(num_chars);
            transmission = Utils.str_to_binvec(contents).';
        end

        function recap(...
                data, ...
                transmission, ...
                samples, ...
                received, ...
                normalized, ...
                num_errs, ...
                err_rate ...
                )

            % Provide a recap of the experimentation

            figure
            stem(data);
            title "data"

            figure
            stem(transmission);
            title "transmission"

            figure
            stem(samples);
            title "sampels"

            figure
            stem(received);
            title "received"

            figure
            stem(normalized);
            title "received"

        end
    end
end

function out = dummy_text(num_chars)
    % Generate dummy text for X characters long.
    % Each character is 8 bits
    dummy = {
        'I met a traveller from an antique land, '
        'Who said Two vast and trunkless legs of stone '
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

    % return the first N chars from dummy
    contents = sprintf('%s', dummy{:});
    corpus = repmat(contents, 1, ceil(num_chars / 32));
    out = corpus(1:num_chars);
end
