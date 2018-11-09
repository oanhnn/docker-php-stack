# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased] - YYYY-MM-DD

### BC Changed



## [1.0.0] - 2018-11-09

### BC Changed

- Base from alpine:3.8
- PHP 7.2
- Default project root mount to `/var/www/html`
- Default webroot is `/var/www/html/public`



## 0.1.0

First release

- Base from alpine:3.7
- PHP 7.1
- Default project root mount to `/app`
- Default webroot is `/app/public`
- Include service `supervisor`, `nginx`, `php-fpm`



[1.0.0]: https://github.com/oanhnn/docker-php-stack/compare/0.1.0...1.0.0
[Unreleased]: https://github.com/oanhnn/docker-php-stack/compare/1.0.0...develop
