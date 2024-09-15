build helper scripts
- buildMonitor - loop wrapper around compileRemain.sh and activeBuildTasks.py
- compileRemain.sh - show remaining pkgs to build & count (from batocera wiki)
- activeBuildTasks.py - show build tasks started and not completed
- makepkg - pretty much an alias for `make %-build CMD=<pkg>` w logging
- linkpkg - parallel build patch script when package dependencies are missed
