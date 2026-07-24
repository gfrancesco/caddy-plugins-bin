# What's this?

Dockerfile source for multi platform linux [Caddy](https://caddyserver.com/) docker images published on Docker HUB at [gfrancesco11/caddy-plugins](https://hub.docker.com/r/gfrancesco11/caddy-plugins).
For each build, Caddy binaries are published under releases. Binaries can be used to add plugin funcionalities to existing installs, e.g. when Caddy is installed on [Home Assistant as an App](https://github.com/einschmidt/app-caddy-2).
The images include the following plugins:

- [Cloudflare DNS](https://caddyserver.com/docs/modules/dns.providers.cloudflare)
- [Layer-4](https://github.com/mholt/caddy-l4)

# Architectures

The images are [Alpine linux](https://www.alpinelinux.org/) only, based on the Caddy official ones, and built for the following platforms:

- `linux/amd64`
- `linux/arm64/v8`
- `linux/arm/v7`
- `linux/arm/v6`
- `linux/ppc64le`
- `linux/riscv64`
- `linux/s390x`

# Scope

The final images are optimized for size. I use them to test network configurations on embedded devices and Mikrotik routers like the [RB5009](https://mikrotik.com/product/rb5009ug_s_in) family, which supports containers.

# Support

Do not expect any support, in particular I won't add any additional Caddy plugin outside the one(s) already included, see forking for additional customizations.
Don't expect regular builds following the Caddy releases, however feel free to open an issue and tag me if you need a version bump, I'll do my best to follow up.

# Forking

To build the containers and artifacts after updates to the actions, dockerfile or to bump caddy's version:

- commit and push any change: `git commit -am "UPD: dockerfile"`, `git push`
- to trigger a rebuild via github actions you need to create a tag in the `vN.N.N*` format and push it, e.g.: `git tag v2.11.4`, `git push --tags`