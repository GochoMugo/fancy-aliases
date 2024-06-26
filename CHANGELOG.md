# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).


## [Unreleased][unreleased]


## [0.19.0][0.19.0] - 2024-05-08

Changed:

1. **git**: `guf` and `guu` will use a default remote and branch.

Fixed:

1. **xclip**: Fix incorrect output of copied selection from `clip`.

Removed:

1. **angular**: all aliases.
1. **apt-get**: `update`
1. **docker**: `dkl`
1. **hub**: all aliases.
1. **mercurial**: all aliases.
1. **npm**: `npmh`
1. **react-native**: all aliases.
1. **supervisord**: all aliases.


## [0.18.0][0.18.0] - 2024-04-03

Added:

1. **docker**: `dke`, `dkl`, `dkps`, `dkrs`, `dks`, `dkx`
1. **git**: `gcp`, `gf`, `grbe`, `gtd`
1. **npm**: `npmtb`, `npmte`, `npmtu`

Fixed:

1. **git**: Fixed `gzd` throwing error due to unsupported negative array index.


## [0.17.0][0.17.0] - 2020-03-09

Added:

1. **angular**: `ngt`
1. **pip**: `pip3g`
1. **react-native**: `rn`

Changed:

1. **mkdir**: `mkd` allows passing paths prefixed with a hypen (`-`).


## [0.16.0][0.16.0] - 2019-02-11

Changed:

1. **xclip**: `clip` prints to stdout the copied selection


## [0.15.0][0.15.0] - 2019-01-14

Added:

1. **pip**: `pipg`

Changed:

1. **xclip**: `clip` removes newlines before copying to clipboard.


## [0.14.0][0.14.0] - 2018-11-18

Changed:

1. **git**: Allow passing a stash index to `gzd`
1. **git**: Sign commits in `grb` (`git rebase`)


## [0.13.0][0.13.0] - 2018-07-13

Added:

1. **git**: `gam`, `gamc`, `gfp`, `gtl`, `gza`


## [0.12.0][0.12.0] - 2018-06-22

Added:

1. **npm**: `npmid`


## [0.11.0][0.11.0] - 2018-06-15

Added:

1. **xclip**: `clip`
1. **npm**: `npmic`, `npmp`
1. **git**: `gz`, `gzc`, `gzd`, `gzl`, `gzp`
1. **mkdir**: `mkd`


## [0.10.0][0.10.0] - 2017-12-21

Added:

1. **docker**: `dklf`
1. **git**: `gt`
1. **npm**: `npmd`


[0.10.0]:https://github.com/GochoMugo/fancy-aliases/releases/tag/v0.10.0
[0.11.0]:https://github.com/GochoMugo/fancy-aliases/releases/tag/v0.11.0
[0.12.0]:https://github.com/GochoMugo/fancy-aliases/releases/tag/v0.12.0
[0.13.0]:https://github.com/GochoMugo/fancy-aliases/releases/tag/v0.13.0
[0.14.0]:https://github.com/GochoMugo/fancy-aliases/releases/tag/v0.14.0
[0.15.0]:https://github.com/GochoMugo/fancy-aliases/releases/tag/v0.15.0
[0.16.0]:https://github.com/GochoMugo/fancy-aliases/releases/tag/v0.16.0
[0.17.0]:https://github.com/GochoMugo/fancy-aliases/releases/tag/v0.17.0
[0.18.0]:https://github.com/GochoMugo/fancy-aliases/releases/tag/v0.18.0
[0.19.0]:https://github.com/GochoMugo/fancy-aliases/releases/tag/v0.19.0
[unreleased]:https://github.com/GochoMugo/fancy-aliases/compare/v0.19.0...master
