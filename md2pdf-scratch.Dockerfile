FROM tqxr/md2pdf-build

RUN mkdir -p \
    /newroot/tmp \
    /newroot/bin \
    /newroot/lib64 \
    /newroot/etc \
    /newroot/home/user \
    /newroot/usr/share/pandoc/data/templates \
    /newroot/usr/lib/x86_64-linux-gnu/gconv \
    /newroot/var/lib

RUN cp /usr/share/zoneinfo/Australia/Melbourne /newroot/etc/localtime
RUN cp -r /home/user /newroot/home/user
RUN cp /etc/passwd /newroot/etc/passwd
RUN cp /etc/group /newroot/etc/group

# which pandoc
RUN cp /usr/bin/pandoc /newroot/bin/

# readelf pandoc
RUN cp /lib64/ld-linux-x86-64.so.2 /newroot/lib64/

# ldd pandoc
RUN cp \
/lib/x86_64-linux-gnu/libz.so.1 \
/usr/lib/x86_64-linux-gnu/libyaml-0.so.2 \
/lib/x86_64-linux-gnu/libpcre.so.3 \
/usr/lib/x86_64-linux-gnu/liblua5.1.so.0 \
/usr/lib/x86_64-linux-gnu/libluajit-5.1.so.2 \
/lib/x86_64-linux-gnu/librt.so.1 \
/lib/x86_64-linux-gnu/libutil.so.1 \
/lib/x86_64-linux-gnu/libdl.so.2 \
/lib/x86_64-linux-gnu/libpthread.so.0 \
/usr/lib/x86_64-linux-gnu/libgmp.so.10 \
/lib/x86_64-linux-gnu/libm.so.6 \
/usr/lib/x86_64-linux-gnu/libffi.so.6 \
/lib/x86_64-linux-gnu/libc.so.6 \
/lib/x86_64-linux-gnu/libgcc_s.so.1 \
/newroot/lib64/

# strace `/usr/bin/pandoc tmp.md -o tmp.pdf` 2>&1 | grep -e ^stat
RUN cp /usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache /newroot/usr/lib/x86_64-linux-gnu/gconv/
RUN cp /usr/lib/x86_64-linux-gnu/gconv/UTF-32.so /newroot/usr/lib/x86_64-linux-gnu/gconv/
RUN cp /usr/share/pandoc/data/templates/default.latex /newroot/usr/share/pandoc/data/templates/default.latex

RUN cp /usr/bin/pdftex /newroot/bin/
WORKDIR /newroot/bin
RUN ln -sf pdftex ./pdflatex

# ldd /usr/bin/pdftex | awk '{print $3}'
RUN cp \
/usr/lib/x86_64-linux-gnu/libpng16.so.16 \
/lib/x86_64-linux-gnu/libz.so.1 \
/usr/lib/x86_64-linux-gnu/libpoppler.so.73 \
/usr/lib/x86_64-linux-gnu/libkpathsea.so.6 \
/usr/lib/x86_64-linux-gnu/libstdc++.so.6 \
/lib/x86_64-linux-gnu/libm.so.6 \
/lib/x86_64-linux-gnu/libgcc_s.so.1 \
/lib/x86_64-linux-gnu/libc.so.6 \
/usr/lib/x86_64-linux-gnu/libfreetype.so.6 \
/usr/lib/x86_64-linux-gnu/libfontconfig.so.1 \
/usr/lib/x86_64-linux-gnu/libjpeg.so.8 \
/usr/lib/x86_64-linux-gnu/libnss3.so \
/usr/lib/x86_64-linux-gnu/libsmime3.so \
/usr/lib/x86_64-linux-gnu/libnspr4.so \
/usr/lib/x86_64-linux-gnu/liblcms2.so.2 \
/usr/lib/x86_64-linux-gnu/libtiff.so.5 \
/lib/x86_64-linux-gnu/libpthread.so.0 \
/lib/x86_64-linux-gnu/libexpat.so.1 \
/usr/lib/x86_64-linux-gnu/libnssutil3.so \
/usr/lib/x86_64-linux-gnu/libplc4.so \
/usr/lib/x86_64-linux-gnu/libplds4.so \
/lib/x86_64-linux-gnu/libdl.so.2 \
/lib/x86_64-linux-gnu/librt.so.1 \
/lib/x86_64-linux-gnu/liblzma.so.5 \
/usr/lib/x86_64-linux-gnu/libjbig.so.0 \
/newroot/lib64/

# no mention of fonts etc from
# running it like this....

# so how do we embed fonts into the PDF ??

# Aaand .. no mention of how we need /bin/sh (which is actually dash)
# if you don't use the array notation for entrypoint...
#RUN cp /bin/dash /newroot/bin/sh

# strace et al don't tell you about all the latex format files etc
# that you need to load - only running and failing will show you
# these problems!

# 56kb
RUN cp -r /etc/texmf /newroot/etc/texmf
# 89mb!!
#RUN cp -r /usr/share/texmf /newroot/usr/share/texmf
# 213mb !!!!
#RUN cp -r /usr/share/texlive /newroot/usr/share/texlive
# 9.3mb ...
#RUN cp -r /var/lib/texmf /newroot/var/lib/texmf
# 68k
#RUN cp -r /var/lib/tex-common /newroot/var/lib/tex-common

RUN chmod o+rwx /newroot/tmp

FROM scratch
ENV LD_LIBRARY_PATH /lib64
ENV TERM xterm
COPY --from=0 /newroot/ /
USER user
ENTRYPOINT [ "/bin/pandoc" ]

