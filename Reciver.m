classdef Reciver

    methods (Static)

        function out = blahblah(S)
            % Convert text to a vector of 1s and -1s
            out = (reshape(dec2bin(S, 8).' - '0', 1, [])') .* 2 - 1;
        end

    end

end
