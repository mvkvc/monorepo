defmodule Protohackers.MeansTest do
	use ExUnit.Case, async: true

	# In this example, "-->" denotes messages from the server to the client, and "<--" denotes messages from the client to the server.

	#     Hexadecimal:                 Decoded:
	# <-- 49 00 00 30 39 00 00 00 65   I 12345 101
	# <-- 49 00 00 30 3a 00 00 00 66   I 12346 102
	# <-- 49 00 00 30 3b 00 00 00 64   I 12347 100
	# <-- 49 00 00 a0 00 00 00 00 05   I 40960 5
	# <-- 51 00 00 30 00 00 00 40 00   Q 12288 16384
	# --> 00 00 00 65                  101

	# The client inserts (timestamp,price) values: (12345,101), (12346,102), (12347
	# ,100), and (40960,5). The client then queries between T=12288 and T=16384. 
	# The server computes the mean price during this period, which is 101, and 
	# sends back 101.

	test "insert then query" do
		
	end
end