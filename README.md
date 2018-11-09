# oanhnn/docker-php-stack

[![Build Status](https://travis-ci.org/oanhnn/docker-php-stack.svg?branch=master)](https://travis-ci.org/oanhnn/docker-php-stack)

Repository of `oanhnn/php-stack` Docker image.

> Version 1.0.0 is released and includes some BC changes.
> Please update your project or using tag `0.1.0`. 
> See detail in [CHANGLOG.md](./CHANGLOG.md)

## Features

- [x] Base from `alpine:3.8` image
- [x] Install supervisor
- [x] Install php-fpm 7.2
- [x] Install nginx
- [x] Install curl

## Requirement
- Docker Engine & Docker Compose

## Usage

Example for a Laravel application

1. Copy all file in `example-laravel` folder to your project root folder

2. Build and run

```bash
$ docker-compose build app
$ docker-compose up -d
```

## Contributing

All code contributions must go through a pull request and approved by
a core developer before being merged. This is to ensure proper review of all the code.

Fork the project, create a feature branch, and send a pull request.

If you would like to help take a look at the [list of issues](https://github.com/oanhnn/docker-php-stack/issues).

## License

This project is released under the MIT License.   
Copyright © 2018 [Oanh Nguyen](https://github.com/oanhnn)   
Please see [License File](https://github.com/oanhnn/docker-php-stack/blob/master/LICENSE) for more information.
