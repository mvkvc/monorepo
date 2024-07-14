# guide

SQLite is used by default, but you can use a Postgres database by changing the environment variables in `fly.toml` that are currrently commented out under `# Postgres` and provisioning a Postgres database.

`flyctl launch --name fly-gitea --no-deploy --region yyz`

`flyctl volumes create fly_gitea_data --size 1 --region yyz --app fly-gitea`

`flyctl deploy`

`fly ips release <shared-ip>`

`fly ips allocate-v4`
