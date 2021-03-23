function H_k = estimate_channel(num_channels, num_chars, prefix_length)
    % generate a training block that's the first 64 bits (8 characters)
    training_block = transmitter.create_data(num_channels, num_chars);

    training_block
    
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
