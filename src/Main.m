classdef Main
    methods (Static)
        function lab3a()
            packet_size = 8; % generate characters (bytes) of text
            block_size = 64; % Reserve channels for data
            prefix_length = 16; % Reserve channels for the cyclic prefix
            SNR_dB = 100;

            % Create the data from the data layer
            data = DataLayer ...
                .create_transmission(packet_size);

            % Package that data with the transmitter
            transmission = Transmitter(block_size) ...
                .with_cyclic_prefix(prefix_length) ...
                .transmit(data);

            % Pass the transmission through the channel
            samples = Channel(SNR_dB) ...
                .send_nonflat(transmission);

            % Send
            received = Receiver(block_size) ...
                .with_cyclic_prefix(prefix_length) ...
                .receive(samples);            
            
            % Normalize
            normalized = Utils.normalize_received_samples(received);
            
            [err, rate] = Utils.estimate_error(data, normalized);
            
            % Display the data
            DataLayer.recap(...
                data, ...
                transmission, ...
                samples, ...
                received, ...
                normalized ...
                );
        end

        function lab3b()
            data_size_bytes = 1024; % generate 1024 characters (bytes) of text
            block_size = 64; % Preserve 64 channels for data
            prefix_length = 16; % Preserve 16 channels for the cyclic prefix
            SNR_dB = 30;

            % Create the data from the data layer
            data = DataLayer ...
                .createTransmission(data_size_bytes);

            % Package that data with the transmitter
            transmission = Transmitter(block_size) ...
                .with_cyclic_prefix(prefix_length) ...
                .transmit(data);

            % Pass the transmission through the channel
            samples = Channel(SNR_dB) ...
                .send_nonflat(transmission);

            % Send
            received = Receiver(block_size) ...
                .with_cyclic_prefix(prefix_length) ...
                .with_preamble() ...
                .receive(samples);

            % Display the data
            DataLayer.display(...
                data, ...
                transmission, ...
                samples, ...
                received ...
                )
        end

        function lab3c_send()
            data_size_bytes = 1024; % generate 1024 characters (bytes) of text
            block_size = 64; % Preserve 64 channels for data
            prefix_length = 16; % Preserve 16 channels for the cyclic prefix
            SNR_dB = 30;

            % Create the data from the data layer
            data = DataLayer ...
                .createTransmission(data_size_bytes);

            % Package that data with the transmitter
            transmission = Transmitter(block_size) ...
                .with_cyclic_prefix(prefix_length) ...
                .transmit(data);

            % Write the samples to a file
        end

        function lab3c_receive()
            data_size_bytes = 1024; % generate 1024 characters (bytes) of text
            block_size = 64; % Preserve 64 channels for data
            prefix_length = 16; % Preserve 16 channels for the cyclic prefix
            SNR_dB = 30;

            % Send
            received = Receiver(block_size) ...
                .with_cyclic_prefix(prefix_length) ...
                .with_preamble() ...
                .receive(samples);

            % Display the data
            DataLayer.display(...
                data, ...
                transmission, ...
                samples, ...
                received ...
                )
        end

        function tests()
        end
    end
end
