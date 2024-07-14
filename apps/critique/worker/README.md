# worker

**CURRENTLY DISABLED, UNCLEAR HOW TO DO CLIENT SIDE**

Intercepts request to the R2 bucket containing all images and only allows authorized requests. Requests are checked for a `X-Auth-PSK` header matching the secret (header key can be changed in `wrangler.toml`).

Set auth key:

```bash
doppler run -- \
echo "$R2_WORKER_KEY" | wrangler secret put AUTH_PSK
```

Deploy:

```bash
wrangler deploy
```

To test behavior is correct use the below code with the different keys, it should return a 403 if the key is incorrect otherwise grant access.

```bash
doppler run -- \
curl -f -O \
    -H "X-Auth-PSK: $R2_WORKER_KEY" \
    -X GET "https://cdn.critique.pics/critique/running.jpg"
```
