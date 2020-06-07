# pompa

Fully-featured spear-phishing toolkit - sample docker setup (Linux-compatible)

**NOTE:** Please read the [wiki](https://github.com/m1nl/pompa/wiki/Getting-Started) in [pompa](https://github.com/m1nl/pompa) repository for better docs.

## Prerequisites

You will need the following things properly installed on your computer:

* [Git](https://git-scm.com/)
* [Docker](https://www.docker.com/)
* [Docker Compose](https://docs.docker.com/compose/)

## Installation

* `git clone https://github.com/m1nl/pompa-docker.git`
* `cd pompa-docker`
* `git submodule init`
* `git submodule update --checkout`
* `./generate_secrets.sh`

## Configuration

Look for config files in the following directories:

* app/config
* facade/config
* facade/nginx
* redis

## Building and running

* `docker-compose build`
* `docker-compose up`
* open http://localhost:8081/ in a modern web browser

## Upgrading submodules

* `git submodule update --remote`
* `docker-compose build`

## Further Reading / Useful Links

* [pompa-api](https://github.com/m1nl/pompa-api)
* [pompa](https://github.com/m1nl/pompa)
* [Docker](https://www.docker.com/)
* [Docker Compose](https://docs.docker.com/compose/)

## License
`pompa` is released under the terms of [lgpl-3.0](LICENSE).

## Author

Mateusz Nalewajski

## Commercial support / professional services

Please contact me directly at mateusz-at-nalewajski-dot-pl
