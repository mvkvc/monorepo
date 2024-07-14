# dns_in_a_weekend_ex

<https://implement-dns.wizardzines.com/>

Elixir implementation of the `DNS In A Weekend` tutorial.

- [x] Tutorial part 1: build a DNS query
- [ ] Tutorial part 2: parse the response
- [ ] Tutorial part 3: implement our resolver

## Notes

To view DNS traffic on the local network:

```sh
sudo tcpdump -ni any port 53
```

To query a DNS server:

```sh
dig URL @DNS_SERVER
```
