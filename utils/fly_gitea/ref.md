# Running Gitea on fly.io

<https://blog.gitea.io/2022/04/running-gitea-on-fly.io/>

/Tue Apr 19, 2022/ by *techknowlogick <https://gitea.com/techknowlogick>*

Gitea is designed to run on many different platforms and has very
minimal requirements for resources. This is great because whatever
computer you have, Gitea can run on it.

Although you might like to self-host your own instance at times, you
might not want to manage all of the moving elements of a server, such as
firewalls, webservers, TLS certificates, and so on. This is where fly.io
enters the picture. Fly.io is a platform with a generous free tier that
allows you to tell them the Docker image you want to run and they’ll
take care of all the tough and time-consuming operational overhead.

To get started, you’ll need to sign up for a fly.io account. Luckily,
they have a nice getting started guide
<https://fly.io/docs/getting-started/log-in-to-fly/#first-time-or-no-fly-account-sign-up-for-fly> that walks you through the process.

Once you have an account you can get started with running Gitea on fly.io.

create a directory to store fly.io application config

`mkdir gitea-on-fly`

enter into the newly created directory

`cd gitea-on-fly`

tell fly.io you wish to create a new application in the amsterdam region (there are many other regions you could pick too)

pick any name for the app that you'd like, in the example we are using `gitea-on-fly`

`flyctl launch --name gitea-on-fly --no-deploy --region ams`

give the newely create application persistant storage, so your data persists between app updates

`flyctl volumes create gitea_data --size 1 --region ams --app gitea-on-fly`

You’ll notice that once you’ve created the app, a new file, named
`fly.toml`, will be created in the directory you just made. This
contains a lot of placeholder information, you’ll want to replace with
the below content. Using the name you picked when you created the
application replace `gitea-on-fly` from the below config in all the
places it occurs.

```toml
app = "gitea-on-fly"

kill_timeout = 5

[build]
  image = "gitea/gitea:latest" # latest is the most recent stable release

[env]
  GITEA__database__DB_TYPE="sqlite3"
  GITEA__database__PATH="/data/gitea/gitea.db"
  GITEA__server__DOMAIN="gitea-on-fly.fly.dev"
  GITEA__server__SSH_DOMAIN="gitea-on-fly.fly.dev"
  GITEA__server__ROOT_URL="https://gitea-on-fly.fly.dev"
  GITEA__security__INSTALL_LOCK="true" # Don't show installer

# GITEA__service__DISABLE_REGISTRATION="true" # TODO: uncomment once you have created your first user

# persist data

[[mounts]]
  destination = "/data"
  source = "gitea_data"

# ssh traffic

[[services]]
  internal_port = 22
  protocol = "tcp"
  [[services.ports]]
    port = 22

# https traffic

[[services]]
  internal_port = 3000
  protocol = "tcp"

  [[services.ports]]
    handlers = ["http"]
    force_https = true
    port = 80

  [[services.ports]]
    handlers = ["tls", "http"]
    port = 443
```

Once you have updated the configuration example with the application
name you chose run `flyctl deploy`, and it will push every up to fly.io
and deploy your gitea instance.

Now you can visit <https://gitea-on-fly.fly.dev>
<https://gitea-on-fly.fly.dev/> (or whichever name you chose), and you
can create an account and use your Gitea instance.

If you wish to be the only one with an account on your instance, after
you’ve registered you account you can close registrations by
uncommenting the environment variable
`GITEA__service__DISABLE_REGISTRATION`, and running `flyctl deploy` again.

Now that you have a Gitea instance up and running on fly.io, you may
wish to look into backups, using your own domain name, scaling up
RAM/CPU using the fly.io cli, or even using fly.io’s hosted postgres as
database instead of sqlite.

Copyright © 2022 The Gitea Authors <https://blog.gitea.io/>. All rights
reserved. Made with // and Hugo <https://gohugo.io/>.

Sponsored by INBlockchain <http://inblockchain.com/>, Equinix Metal
<https://metal.equinix.com/>, Two Sigma <https://www.twosigma.com/>,
SoEBeS <https://soebes.io/>, Allspice <https://www.allspice.io/>, Towhee
<https://towhee.io/>, Hostea <https://hostea.org/blog/>, and all of our
backers on Open Collective <https://opencollective.com/gitea>.

<https://blog.gitea.io/en-us>
