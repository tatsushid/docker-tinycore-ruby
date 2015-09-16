Ruby on Tiny Core Linux
=======================

This provides a small but a fully functional MRI [Ruby](https://www.ruby-lang.org/) runtime environment. This image is based on my [Tiny Core Linux Docker image](https://hub.docker.com/r/tatsushid/tinycore/).

## Supported tags and respective `Dockerfile` links

- [`2.2`, `latest` (2.2/Dockerfile)][Latest Dockerfile]
- [`2.2-onbuild` (2.2/onbuild/Dockerfile)](https://github.com/tatsushid/docker-tinycore-ruby/blob/master/2.2/onbuild/Dockerfile)
- [`2.1` (2.1/Dockerfile)](https://github.com/tatsushid/docker-tinycore-ruby/blob/master/2.1/Dockerfile)
- [`2.1-onbuild` (2.1/onbuild/Dockerfile)](https://github.com/tatsushid/docker-tinycore-ruby/blob/master/2.1/onbuild/Dockerfile)

## How to use this image

This can be used in the same way as [Official Ruby Image](https://hub.docker.com/_/ruby/). Please see "How to use this image" section of it with replacing the image name with this one.

## How to install C extension etc.

This doesn't contain a compiler, a linker and headers etc. so if you'd like to add a something C extension for Ruby, first you need to install them by `tce-load` command. Please refer this image's [Dockerfile][Latest Dockerfile] which is a good example of installing those packages.

[Latest Dockerfile]: https://github.com/tatsushid/docker-tinycore-ruby/blob/master/2.2/Dockerfile
