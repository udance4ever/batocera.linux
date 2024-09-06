# Sept 6, 2024
#
# patches required (bcm2836 batocera-40)
# 
# tested build hosts (2020 M1 MacBookPro 16GB):
# 1. Ubuntu Server arm64 in VMWare VM (DIRECT_BUILD := y) (macOS Sonoma)
# 2. Ubuntu Server arm64 in docker (DIRECT_BUILD := n) (Asahi Linux (Fedora Asahi Remix))

arch=bcm2836

if [ -d /$arch ]; then
	# inside Docker shell
	project=/build
	output=/output
else
	project=$(realpath `pwd`)
	output=$project/output
fi

# applewin
$project/scripts/linux/linkpkg libyaml applewin

# fheroes2
$project/scripts/linux/linkpkg sdl2_mixer fheroes2

# gpicase
# phase: install
mkdir -p $output/$arch/per-package/gpicase/target/etc/udev/rules.d/

# grim
for pkg in libpng libjpeg-bato jpeg-turbo pixman wayland wayland-protocols; do scripts/linux/linkpkg $pkg grim; done
# kodi20-pvr-freebox
$project/scripts/linux/linkpkg json-for-modern-cpp kodi20-pvr-freebox

# libretro-flycastvl
# $$$ for some reason you can't prebuild gl4es up front so wait until package errs and then:
#     make bcm2836-build CMD=gl4es
$project/scripts/linux/linkpkg gl4es libretro-flycastvl
# phase: install
mkdir -p $output/$arch/per-package/libretro-flycastvl/target/usr/share/libretro/info/

# mame
$project/scripts/linux/linkpkg pulseaudio mame

# mangohud
$project/scripts/linux/linkpkg libxkbcommon mangohud
$project/scripts/linux/linkpkg json-for-modern-cpp mangohud


# deselected
# ----------
echo
echo "NOTE: deselected: syncthing - dependency on host-go. workaround: import prebuilt binaries from x86 build"
echo "NOTE: deselected: kodi - in DIRECT_BUILD due to unresolved build error related to host/python3 (works fine in DOCKER build)"
echo "NOTE: deselected: python_adafruit_circuitpython_ws2801 - dependency on pip"
echo "NOTE: deselected: solarus-engine - dependency on mono"
echo "NOTE: deselected: sinden-guns - dependency on mono (package builds independently though)"
