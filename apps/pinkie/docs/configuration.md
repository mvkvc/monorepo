# Configuration

<https://github.com/quic-go/quic-go/wiki/UDP-Receive-Buffer-Size>

non-BSD
It is recommended to increase the maximum buffer size by running:

sysctl -w net.core.rmem_max=2500000
This command would increase the maximum receive buffer size to roughly 2.5 MB.
