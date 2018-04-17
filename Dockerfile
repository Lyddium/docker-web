FROM progrium/busybox
EXPOSE 80

RUN wget -O /tmp/os.iso http://cloud.centos.org/centos/7/atomic/images/CentOS-Atomic-Host-7-Installer.iso
RUN mkdir -p /www/iso

RUN opkg-install bsdtar
WORKDIR /www/iso
RUN bsdtar xfp /tmp/os.iso

WORKDIR /
RUN opkg-install uhttpd
RUN printf '#!/bin/sh\nset -e\n\nchmod 755 /www\nexec /usr/sbin/uhttpd $*\n' > /usr/sbin/run_uhttpd && chmod 755 /usr/sbin/run_uhttpd

ENTRYPOINT ["/usr/sbin/run_uhttpd", "-f", "-p", "80", "-h", "/www"]
CMD [""]
