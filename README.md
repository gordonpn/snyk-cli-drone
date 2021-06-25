# snyk-cli-drone

[![Docker Image](https://badgen.net/badge/icon/docker?icon=docker&label)](https://hub.docker.com/r/gordonpn/snyk-cli-drone)
[![Build Status](https://drone.gordon-pn.com/api/badges/gordonpn/snyk-cli-drone/status.svg)](https://drone.gordon-pn.com/gordonpn/snyk-cli-drone)
[![License](https://badgen.net/github/license/gordonpn/snyk-cli-drone)](./LICENSE)
[![Project Status: Inactive – The project has reached a stable, usable state but is no longer being actively developed; support/maintenance will be provided as time allows.](https://www.repostatus.org/badges/latest/inactive.svg)](https://www.repostatus.org/#inactive)

[![Buy Me A Coffee](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/gordonpn)

## Deprecated

Now that the Snyk engine has been integrated into Docker Engine, we can get the same scanning features by using `docker scan <image>`.

<https://docs.docker.com/engine/scan/>

## Motivation

The main issue I had with the official Snyk-cli image is that it expects the user to mount their project to `/project` to be scanned.

My continuous integration and continuous delivery (CI/CD) platform of choice is [Drone](https://drone.io/). What is particular about this platform is that every step of the pipeline is executed inside an isolated docker container.

At runtime, Drone sets the working directory and clones your project to `/drone/src`. Due to this, I found it much easier to use `snyk test` directly in the working directory set up by Drone rather than making sure to mount the project to `/project` like the snyk-cli image expects you to.

The other reason is that a cached image reduces build times significantly.

## Description

This image is based on Node.js 14 on Buster Slim, includes an installation of Docker and snyk-cli.

## Example

Here is an example of a pipeline for Drone.

For more information on snyk-cli usage, refer to the official documentation: <https://support.snyk.io/hc/en-us/articles/360003812578-CLI-reference>

```yaml
---
kind: pipeline
type: docker
name: security

trigger:
  event: [ push, pull_request ]
  branch:
    exclude:
      - master

steps:
  - name: snyk scan
    image: gordonpn/snyk-cli-drone
    environment:
      SNYK_TOKEN:
        from_secret: SNYK_TOKEN
    volumes:
      - name: dockersock
        path: /var/run/docker.sock
    commands:
      - snyk test --severity-threshold=high
      - snyk test --docker yourUsername/yourRepo:yourTag --file=Dockerfile

volumes:
  - name: dockersock
    host:
      path: /var/run/docker.sock
```

## Authors

[@gordonpn](https://github.com/gordonpn)

## License

[MIT License](./LICENSE)
