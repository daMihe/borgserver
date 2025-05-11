# borgserver

Sets up a `borg serve` instance over SSH for one user. Useful, if just wanting to use some modern NAS systems as target or self host it without opening a whole system for borg. See [borgbackup](https://www.borgbackup.org/) what this is actually about. SSH is based on OpenSSH, the configuration is a bit restricted to reduce attack surface.

## Running this image

### Environment variables

| Variable        | required | Description                                                                              |
|-----------------|----------|------------------------------------------------------------------------------------------|
| `CLIENT_PUBKEY` | yes      | The clients SSH public key in OpenSSH's oneline format.                                  |
| `HOSTKEY_FILE`  | no       | The servers host key path inside the container. See recommended volumes for more detail. |

### recommended volumes and ports

There are some volumes which you most likely want to set.

| Volume | Description |
|---------|--------------------------------------|
| `/repo` | The path for the repository. This contains your backup so you should make sure to really make it persistent. |
| `/home/borg/ssh_host_ed5519_key` | Actually this is defined through environment variable `HOSTKEY_FILE` and should be your host key for this container. This should be a file, not a directory, just read access is fine. The key will be treid to generate, if not found. So if not having the tools available on your system, just spin up the image once and you get a nice key in that location. |
| `/home/borg/ssh_host_ed5519_key.pub` | The public part of the host key. The path is also defined by `HOSTKEY_FILE` but `.pub` is expected additionally. |

As usual OpenSSH uses Port 22 (TCP) which is also exposed. However this port is most likely already in use by your host system so you might want to map it to any different port.

### Usage on client

Enter as repository address of your borg(matic) client `borg@<server-host>:<server-mapped-port>/repo`. As this is a regular `borg serve` repository it should behave as usual.

## Building

### Build arguments

| Argument | default | Description                                               |
|----------|---------|-----------------------------------------------------------|
| `PGID`   | `1000`  | The gid the service will use and also save the repository |
| `PUID`   | `1000`  | The uid the service will use and also save the repository |

### License

My scripts are licensed under Apache 2.0 and so you can use them in many cases. You can find the text in the `LICENSE` file. If contributing, please be aware your changes will also be published using that license.