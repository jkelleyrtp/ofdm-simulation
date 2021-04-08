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
            % Estimate the channel
            training_text = sprintf('%s', ....
                "He who shall not be named return");
            corpus = repmat(training_text, 1, ceil(len / 32));
            binvec = Utils.str_to_binvec(corpus);
            data = binvec .* 2 - 1;
            data = data(1:len)';
        end

        function data = locking_features()
            % Consistent locking features
%             locking_text = sprintf('%s',...
%                 "I solemnly swear I am up to no good");
%             data = Utils.str_to_binvec(locking_text) .* 2 - 1;
%             data = transpose(data);

%               data = [1 1 1 1 1 1 -1 -1 -1 -1 -1 -1 1 1 1 1 1 1 -1 -1 -1 -1 -1 -1];
              
                data = ones(1, 100);
        end

        function out = str_to_binvec(S)
            % Convert text to a vector of 1s and 0s
            out = reshape(dec2bin(S, 8).' - '0', 1, [])';
        end
    end
end
