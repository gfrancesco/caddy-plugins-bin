# What's this?

Dockerfile source for multi platform linux [Caddy](https://caddyserver.com/) docker images published at [gfrancesco11/caddy-plugins](https://hub.docker.com/r/gfrancesco11/caddy-plugins).
The images include the [Cloudflare DNS Caddy module](https://caddyserver.com/docs/modules/dns.providers.cloudflare).

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

Do not expect any support, in particular I won't add any additional Caddy plugin outside the one(s) already included.
Don't expect regular builds following the Caddy releases, however feel free to open an issue and tag me if you need a version bump, I'll do my best to follow up.