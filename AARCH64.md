This is the beginnings of building Batocera Linux on top of the Asahi kernel!

NOTE: There is no `aarch64` target for building Batocea Linux on Apple Silicon. Current progress is getting system running on top of Fedora Asahi Remix

### SUMMARY
- prerequisite: [batocera-emuluationstation](https://github.com/batocera-linux/batocera-emulationstation) built in Fedora Asahi Remix
- working
	1. all RetroArch cores avail in Fedora RetroArch package (launches roms, playable, retroachievements, saves)
		* systems (15): atari2600, atari7800, nes, fds, gb, gbc, lynx, ngpc, pcengine, pcenginecd, psx, snes, virtualboy, gw, wswanc
		* not tested (2): ngp, wswan
	2. Dolphin (gamecube has great performance on M1)
	3. MAME with hiscore plugin and softList working
		1. personal computers (2): apple2, coco
		2. "standard" arcade titles (tested with dkong and marble (to test BIOS resolution))
		3. gnw_* Game & Watch (MAME (not gw))

### TODO
- `batocera-settings-get` compiled for aarch64 so preferences are applied while launching emulators
- sort out gamepad configuration (testing w DualSense)
	- MAME: gamepad on gnw_* and coco work (but not arcade titles)
	- Dolphin: gamepad only works **outside** of ES (you can control ES but when you launch a gamecube/wii title, control is not passed)
- Dolphin & MAME exit via hotkey combo
- talk to creators of [alternative Asahi distros](https://github.com/AsahiLinux/docs/wiki/SW%3AAlternative-Distros) and get an overview of distro porting process

### Future system support
- 3ds - Lime3DS avail via flatpak (poor performance)
- psp - PPSSPP avail via flatpak (poor performance)
- standalone emulators haven't tried: zxspectrum, Melon DS (nds), DeSmuNE (nds)
- standalone emulators built for aarch64 - emulators boot but do not launch titles: Ryujinx (switch), Flycast (dreamcast), Play! (ps2), simple64 (n64)
- default config of RetroArch disables core downloader.  There is a workaround but I don't think other RetroArch cores are available for download (outside of 11 cores emulating 16 systems listed above)

### DETAILS
- standalone [batocera-emulationstation](https://github.com/batocera-linux/batocera-emulationstation) builds out of the box (just remember to build & install SDL_mixer as it is not part of the build scripts yet)
- installed python 3.11 (Asahi Fedora Remix default 3.12) for maximum compatibility
	- minimum python packages installed to get bootstrapped (4): pyudev, evdev, pyyaml, pillow
	- installed but not used: ruamel.yaml (vita3KGenerator)
	- deferred (will install as python throws errors)
		- have .info (51): aiodns, aiohttp, aiosignal, async_timeout, attrs, bauh, bottle, brotli, certifi, cffi, chardet, chardet_normalizer, colorama, configobj, Cryptodome, cryptography, evmapy, ffmpeg, frozenlist, future, hidapi, httplib2, idna, multidict, packaging, protobuf, proxy_tools, psutil, pycares, pycparser, pygame, PyGObject, pyOpenSSL, pyparsing, pyQt5, pyserial, python_dateutil, pyxel, requests, setuptools, sip, six, smbus, talloc, tdb, tevent, toml, typing_extensions, urllib3, websockets, yarl
		- no .info (24):   attr, avahi, cv2, dbus, distutils, drv_libxml2.py, gi, google, gpiod.so, _ldb_text.py, libfuturize, libmount, libpasteurize, libxml2, lirc, numpy, past, pkg_resourcees, pygtkcompat, samba, serial, validate, webview, xcbgen
- using v40-dev configgen
- running ES inside virtual env (venv) as a **non-admin** user
	- occasional permissions issues resolved on a case-by-case basis (it will be nice for everything to work without root)
- copied in /usr/lib/batocera and /usr/lib/emulationstation manually
- copied in /usr/bin/batocera-vulcan (to get Dolphin to launch)
- init /userdata/system/batocera.conf
- patched `batocera-resolution` currentResolution (differences in xrandr)
- created `configgen-defaults-aarch64.yml`
- copied in /usr/bin/mame/hash to `/userdata/bios/mame/hash` (Fedora RetroArch pkg doesn't include them?)
- patched `mameGenerator.py`
	- difference in mame prefix (and /usr/bin/mame is not in prefix!)
	- /var/run not writable as non-admin (use /tmp)
    - allow resolution to user softList dir: /userdata/bios/mame/hash
    - temp patch to get system `coco` running
- patched `util/wheelUtils.py` to avoid throwing error if `dev` is None
