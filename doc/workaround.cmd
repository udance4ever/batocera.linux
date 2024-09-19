arch=x86_64

for x in `cat doc/workaround.$arch.list`; do make bcm2836-build CMD=$x; done
