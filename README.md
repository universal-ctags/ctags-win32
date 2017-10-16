[![Build status](https://ci.appveyor.com/api/projects/status/uo4k9ug54ngexai8/branch/master?svg=true)](https://ci.appveyor.com/project/universalctags/ctags-win32/branch/master)

# Universal Ctags Win32/64 daily builds

This project provides daily builds of [universal-ctags](https://ctags.io) for Win32/64.

You can download the zip packages from the [releases](https://github.com/universal-ctags/ctags-win32/releases) page.

Four types of packages are provided:

* `ctags-YYYY-MM-DD_{CommitID}-x64.zip`: x64 release build
* `ctags-YYYY-MM-DD_{CommitID}-x64.debug.zip`: x64 debug build
* `ctags-YYYY-MM-DD_{CommitID}-x86.zip`: x86 release build
* `ctags-YYYY-MM-DD_{CommitID}-x86.debug.zip`: x86 debug build

`{CommitID}` is a commit ID or a tag name of the [ctags repository](https://github.com/universal-ctags/ctags).
Normally you may want to use the release builds. If you need unstripped binaries for debugging, use the debug builds.

# Note

Starting from the build [2017-10-14/d9944ef9](https://github.com/universal-ctags/ctags-win32/releases/tag/2017-10-14%2Fd9944ef9), Universal Ctags doesn't load `~/.ctags` and other exuberant-ctags compatible configuration files.
See `man/ctags.1.html` and `man/ctags-incompatibilities.7.html` in the zip packages. Also refer to [#1519](https://github.com/universal-ctags/ctags/pull/1519).

# License

Universal Ctags itself (which is in the ctags subdirectory) is licensed under GPL 2 (or later).

The build scripts in this repository are based on the [vim-win32-installer](https://github.com/vim/vim-win32-installer) project, and [the Vim license](http://vimhelp.appspot.com/uganda.txt.html#license) applies to them.
