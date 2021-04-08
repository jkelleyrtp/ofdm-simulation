# OFDM simulation in Matlab 


This repository holds the code 


DataLayer
- create data (single stream of characters)

Transmitter
- new(block_count, block_size, prefix_length)
- break data into blocks
- cyclic prefix the blocks
- dynamically create a number of time samples
- prepare a training signal
- prepare a preamble
- prepare pilot tones

Channel
- new(snr_db)




Receiver
- new(block_count, block_size, prefix_length)
