# architecture

How are we going to structure the application?

Principles:

- Scale to zero
- Serverless

Services used:

- Code hosting: GitHub
- Task tracking: Github Issues
- CI: Github Actions
- Domain: Namecheap
- DNS: Cloudflare
- App hosting: Fly.io
- Database: Neon
- Blob storage: Cloudflare
- CDN: Cloudflare
- ML inference: Runpod
- ML training: Lambda (make it work with Genesis)
- Secret manager: Doppler
- Email: PostMark
- Analytics: Plausible

Notes:

Images are in an R2 bucket under a custom domain, default is publicly available but deployed a Cloudflare Worker to restrict based on auth header.

Using the S3 API to upload to R2 using examples.

https://hexdocs.pm/phoenix_live_view/uploads.html
https://hexdocs.pm/phoenix_live_view/uploads-external.html
