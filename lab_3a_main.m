function lab_3a_main()
    % This simulates the transmission of one resource block between a transmitter and a receiver.
    % The underlying algorithm uses OFDM to multiplex simultaneous streams of data across multiple channels.

    % Theory:
    %
    % A resource block represents the data transmitted along multiple carriers across multiple OFDM symbols.
    % This simulation describes a resource block with 100 channels with 64 symbols per channel.
    %
    % A given channel might look like:
    % ----
    % RE, RE, RE, RE, RE, RE, RE, RE, RE, RE, RE, RE, RE, RE, RE, RE, RE, RE, RE, RE,
    % 1   0   1   0   1   0   1   0   1   0   1   0   1   0   1   0   1   0   1   0

    % =======================================================
    % [0] Setup the Resource Block parameters
    % - Lay out the number of blocks
    % - Lay out the block length
    % - Determine the appropriate prefix length
    % =======================================================
    block_count = 100;
    block_size = 64;
    prefix_size = 16;

    % =======================================================
    % [1] Estimate the channel.
    % - Generate some training data across all channels
    % - Average each channel to estimate H_k
    % =======================================================
    H_k = estimate_channel();

    % =======================================================
    % [2] Generate actual data
    % - Determine the final length and width
    % - Convert some text corpus into binary and lay out onto the respective channels
    % =======================================================
    data_block = transmitter.create_data(...
        block_count, ...
        block_size / 8 ...
        );

    % =======================================================
    % [3] Precode the data
    % - Apply a cyclic prefix to the data stream on each channel
    % =======================================================
    encoded_block = transmitter.encode_block(...
        data_block, ...
        prefix_size ...
        );

    % =======================================================
    % [4] Transmit
    % - Pass the data through the given channel
    % =======================================================
    total_len = num_channels * (num_chars * 8 + prefix_length);
    sent_samples = reshape(encoded_block, total_len, 1);
    received_samples = nonflat_channel(sent_samples);

    % [5] Decode the data
    time_corrected = Receiver.blahblah();

    % [6] Normalize the data from the channel information

    % [7] Compute error rate

end

function H_k = estimate_channel(num_channels, num_chars, prefix_length)
    % generate a training block that's the first 64 bits (8 characters)
    training_block = transmitter.create_data(num_channels, num_chars);

    % encode the samples with a cyclic prefix
    encoded_training_block = transmitter.encode_block(...
        training_block, ...
        prefix_length ...
        );

    % Reshape our block into a single line of data
    total_len = num_channels * (num_chars * 8 + prefix_length);
    training_samples = reshape(encoded_training_block, total_len, 1);

    % Pass it through the channel
    training_received = nonflat_channel(training_samples);

    % Estimate H_k
    H_k = gensupport.estimate_channel(training_samples, training_received);
end
