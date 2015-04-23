FROM tatsushid/tinycore:6.1-x86_64

# Instructions are run with 'tc' user

ENV RUBY_MAJOR 2.1
ENV RUBY_VERSION 2.1.6

RUN tce-load -wic \
        bison \
        flex \
        file \
        gdbm-dev \
        gcc \
        autoconf \
        make \
        m4 \
        linux-3.16.2_api_headers \
        glibc_base-dev \
        libffi-dev \
        openssl-1.0.0-dev \
        tcl-dev \
        tk-dev \
        readline-dev \
        zlib_base-dev \
        libX11-dev \
        libXss \
        xorg-proto \
    && wget -O - "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.xz" \
        | tar -xJf - -C /tmp \
    && cd "/tmp/ruby-$RUBY_VERSION" \
    && autoconf \
    && ./configure --disable-install-doc \
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
                binutils.tcz \
                bison.tcz \
                cloog.tcz \
                file.tcz \
                flex.tcz \
                gcc.tcz \
                gcc_libs.tcz \
                linux-3.16.2_api_headers.tcz \
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
RUN echo 'gem: --no-rdoc --no-ri' >> "$HOME/.gemrc"

# install things globally, for great justice
RUN mkdir /usr/local/bundle
ENV GEM_HOME /usr/local/bundle
ENV PATH $GEM_HOME/bin:$PATH
RUN gem install bundler \
    && bundle config --global path "$GEM_HOME" \
    && bundle config --global bin "$GEM_HOME/bin"

# don't create ".bundle" in all our apps
ENV BUNDLE_APP_CONFIG $GEM_HOME

CMD ["irb"]
