classdef Receiver

    methods

        function out = blahblah(S)
            % Convert text to a vector of 1s and -1s
            out = (reshape(dec2bin(S, 8).' - '0', 1, [])') .* 2 - 1;
        end

        % function test_str_to_binc()

        %     data = "abc123"
        % end

    end

end
