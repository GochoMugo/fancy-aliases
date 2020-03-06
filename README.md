
# fancy aliases

> Some fancy Bash aliases
>
> Using [msu][msu], you can move around with them from machine to machine

**Note:** Documenting these aliases is plainly tedious, and **not** worth automating.
Read through the [`aliases.sh`][script] file instead. It is simple!

The aliases wrap around the following CLI apps:

1. **apt-get**
1. **cd**
1. **clear**
1. **docker**
1. **git**
1. **hub**
1. **ln**
1. **ls**
1. **mercurial**
1. **mkdir**
1. **npm**
1. **pip**
1. **supervisord**
1. **xclip**


## installation:

Installation options:

1. Ensure you have [msu][msu] installed:

    ```bash
    $ msu install gh:GochoMugo/fancy-aliases
    ```

    You need to restart your terminal for the aliases to be available, or use
    msu's alias `msu.reload`.

1. You may simply download the [aliases.sh][script] and source it in your `~/.bashrc`


## help information:

Just:

```bash
$ fancy-aliases
```


## license:

**The MIT License (MIT)**

Copyright &copy; 2016 GochoMugo <mugo@forfuture.co.ke>


[msu]:https://github.com/GochoMugo/msu
[script]:https://raw.githubusercontent.com/GochoMugo/fancy-aliases/master/aliases.sh
