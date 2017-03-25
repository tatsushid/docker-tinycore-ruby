FROM tatsushid/tinycore:7.2-x86_64

# Instructions are run with 'tc' user

ENV RUBY_MAJOR 2.1
ENV RUBY_VERSION 2.1.9
ENV RUBY_DOWNLOAD_SHA1 5e89efa5189c3def8ee8de18ce750a7e4a20ac32
ENV RUBYGEMS_VESION 2.6.11

RUN tce-load -wic \
        bash \
        bison \
        flex \
        file \
        gdbm-dev \
        gcc \
        autoconf \
        make \
        m4 \
        linux-4.2.1_api_headers \
        glibc_add_lib \
        glibc_base-dev \
        libffi-dev \
        openssl-dev \
        tcl-dev \
        tk-dev \
        readline-dev \
        zlib_base-dev \
        libX11-dev \
        libXss \
        xorg-proto \
    && cd /tmp \
    && wget -O ruby.tar.xz "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.xz" \
    && echo "$RUBY_DOWNLOAD_SHA1  ruby.tar.xz" | sha1sum -c - \
    && tar -xJf ruby.tar.xz \
    && rm ruby.tar.xz \
    && cd "/tmp/ruby-$RUBY_VERSION" \
    && autoconf \
    && bash -c 'XCFLAGS="-DENABLE_PATH_CHECK=0" ./configure --disable-install-doc' \
    && make \
    && mkdir tmp_install \
    && make install DESTDIR=tmp_install \
    && for F in `find tmp_install | xargs file | grep "executable" | grep ELF | grep "not stripped" | cut -f 1 -d :`; do \
            [ -f $F ] && strip --strip-unneeded $F; \
        done \
    && for F in `find tmp_install | xargs file | grep "shared object" | grep ELF | grep "not stripped" | cut -f 1 -d :`; do \
            [ -f $F ] && strip -g $F; \
        done \
    && for F in `find tmp_install | xargs file | grep "current ar archive" | cut -f 1 -d :`; do \
            [ -f $F ] && strip -g $F; \
        done \
    && $(cd tmp_install; sudo cp -R . /) \
    && rm -rf "/tmp/ruby-$RUBY_VERSION" \
    && cd /tmp/tce/optional \
    && for PKG in `ls *-dev.tcz`; do \
            echo "Removing $PKG files"; \
            for F in `unsquashfs -l $PKG | grep squashfs-root | sed -e 's/squashfs-root//'`; do \
                [ -f $F -o -L $F ] && sudo rm -f $F; \
            done; \
            INSTALLED=$(echo -n $PKG | sed -e s/.tcz//); \
            sudo rm -f /usr/local/tce.installed/$INSTALLED; \
        done \
    && for PKG in autoconf.tcz \
                bash.tcz \
                binutils.tcz \
                bison.tcz \
                cloog.tcz \
                file.tcz \
                flex.tcz \
                gcc.tcz \
                gcc_libs.tcz \
                linux-4.2.1_api_headers.tcz \
                m4.tcz \
                make.tcz \
                perl5.tcz \
                xorg-proto.tcz; do \
            echo "Removing $PKG files"; \
            for F in `unsquashfs -l $PKG | grep squashfs-root | sed -e 's/squashfs-root//'`; do \
                [ -f $F -o -L $F ] && sudo rm -f $F; \
            done; \
            INSTALLED=$(echo -n $PKG | sed -e s/.tcz//); \
            sudo rm -f /usr/local/tce.installed/$INSTALLED; \
        done \
    && sudo rm -rf /usr/local/lib/perl5 \
    && sudo /sbin/ldconfig \
    && rm -rf /tmp/tce/optional/*

# Instructions after here are run with 'root' user
USER root

# skip installing gem documentation
RUN echo -e 'install: --no-document\nupdate: --no-document' >> "/usr/local/etc/gemrc"

# Update gem itself
RUN gem update --system $RUBYGEMS_VERSION

ENV BUNDLER_VERSION 1.14.6

RUN gem install bundler --version "$BUNDLER_VERSION"

# install things globally, for great justice
# and don't create ".bundle" in all our apps
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
    BUNDLE_BIN="$GEM_HOME/bin" \
    BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH
RUN mkdir -p "$GEM_HOME" "$BUNDLE_BIN" \
    && chmod 777 "$GEM_HOME" "$BUNDLE_BIN"

CMD ["irb"]
