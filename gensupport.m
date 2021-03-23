% General support methods
classdef gensupport

    methods

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

        function estimate_channel()

        end

    end

end
