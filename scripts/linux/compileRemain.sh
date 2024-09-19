#!/bin/sh

# https://phoenixnap.com/kb/bash-case-statement
case "$PWD" in
  *x86_64*)
	arch=x86_64;;
  *bcm2836*)
	arch=bcm2836;;
  *)
	arch=x86_64 #default
	echo "defaulting to $arch"
	;;
esac

if [ ! -d ./buildroot ]; then
	echo "this doesn't seem to be the root"
	exit 1
fi

# https://wiki.batocera.org/compile_batocera.linux#tips

for i in output/$arch/build/*; do test -d "$i" && test -e "$i"/.stamp_built || echo "$i"; done | \
        grep -v build-time.log | \
        grep -v ,deselected | \
        grep -v buildroot-config | \
        grep -v buildroot-fs | \
        grep -v genimage.tmp | \
        grep -v locales.nopurge | \
        grep -v packages-file-list | \
	grep -v ca-certificates.crt | \
	grep -v \.d$ | \
	grep -v \.o$ | \
	grep -v static$ | \
	grep -v dynamic$ | \
	grep -v release-linux | \
        cut -d'/' -f4 | rev | cut -d'-' -f2- | rev | \
                tee /dev/tty | \
                tee output/compileRemain.$arch.list | \
                        wc -l
