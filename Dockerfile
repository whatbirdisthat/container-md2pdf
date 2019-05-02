FROM ubuntu:latest

# Not a small image
# like - 846mb not small
# TODO: apply smallinizations

# using the internet is slow
# so try to use APT-CACHER-NG if we have one
# (see Makefile)
ARG APT_CACHER_PROXY=
RUN echo "PROXY: $APT_CACHER_PROXY"
RUN if [ "$APT_CACHER_PROXY" != "" ] ; then \
    echo "${APT_CACHER_PROXY}" >/etc/apt/apt.conf.d/01proxy ; \
    fi

# ubuntu wants to update zoneinfo when we apt upgrade
# and will get all interactive and that borks
# so we hack in a zoneinfo to stop that
RUN ln -s /usr/share/zoneinfo/Australia/Melbourne /etc/localtime

# stop those "no terminal defined" type messages
# the debs still want "dialog" though, and will
# continue to complain about that...
# but "dialog" implies interactive so I will live with
# those warnings.
ENV TERM xterm


RUN apt update
RUN apt upgrade -y

# including these on their own layer
# means we can `dive` into the image
# and see what was installed where.
# this is good for smallinating
RUN apt install -y \
    lynx
RUN apt install -y \
    pandoc
RUN apt install -y \
    texlive-latex-recommended texlive-latex-extra

# see ARCH PKGBUILD files for awesomeness:
# https://git.archlinux.org/svntogit/packages.git/tree/trunk/PKGBUILD?h=packages/lynx
# https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/pandoc

# make a user that isn't root
# so we can own the files (if we are 1000 - which is pretty standard)
RUN adduser --disabled-password --gecos "" user
#USER user

