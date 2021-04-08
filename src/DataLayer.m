classdef DataLayer
    methods (Static)
        function transmission = create_transmission(num_chars)
            contents = dummy_text(num_chars);
            transmission = Utils.str_to_binvec(contents).';
        end

        function recap(...
                data, ...
                transmission, ...
                samples, ...
                received, ...
                normalized ...
                )
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
    corpus= repmat(contents, 1, ceil(num_chars / 32));
    out = corpus(1:num_chars);
end
