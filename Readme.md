
# fancy aliases

> Some fancy Bash aliases
>
> Using [msu][msu], you can move around with them from machine to machine

**Note:** This documentation may get outdated at times, so I suggest you read through
the [`aliases.sh`][script] file instead. It is simple!

**cd**:

1. `..`: move one directory up
1. `...`: move two directories up
1. `....`: move three directories up

**git**:

1. `ga`: `git add`
1. `gbr`: `git branch`
1. `gc`: `git commit`
1. `gca`: `git commit --amend`
1. `gch`: `git checkout`
1. `gcl`: `git clone`
1. `gclf`: `git clone --depth 1`
1. `gdf`: `git diff`
1. `gdfc`: `git diff --cached`
1. `gl`: `git log --pretty=oneline`
1. `gm`: `git merge --no-ff`
1. `gmf`: `git merge --ff-only`
1. `gp`: `git pull`
1. `grb`: `git rebase --interactive`
1. `gre`: `git reset`
1. `grem`: `git remote`
1. `grm`: `git rm`
1. `gs`: `git status`
1. `gu`: `git push`
1. `guf`: `git push --force`
1. `guu`: `git push --set-upstream`

**ls**:

1. `ll`: `ls -l`
1. `la`: `ls -A`
1. `l`: `ls -CF`

**mercurial**:

1. `hga`: `hg add`
1. `hgc`: `hg commit`
1. `hgdf`: `hg diff | less`
1. `hgf`: `hg forget`
1. `hgl`: `hg log --limit 10 --template '{rev}: {desc|firstline}\n'`
1. `hgp`: `hg pull && hg update`
1. `hgrm`: `hg remove`
1. `hgs`: `hg status`
1. `hgu`: `hg push`
1. `hguu`: `hg push --new-branch`

**npm**:

1. `npmb`: `npm run build`
1. `npmc`: `npm run clean`
1. `npmr`: `npm run`
1. `npms`: `npm start`
1. `npmt`: `npm test`

**supervisord**:

1. `ssv`: `sudo supervisorctl`
1. `ssv.i`: `sudo /etc/init.d/supervisor start`
1. `ssv.r`: `sudo supervisorctl reload`
1. `ssv.s`: `sudo supervisorctl start`
1. `ssv.t`: `sudo supervisorctl status`

**system updates**:

1. `update`: `sudo apt-get update`
1. `upgrade`: *too long to write here :)*
    * installs updates and removes outdated packages
    * currently works for systems with `apt-get`.


## installation:

Installation options:

1. Ensure you have [msu][msu] installed:

    ```bash
    $ msu install gh:GochoMugo/fancy-aliases
    ```

    You need to restart your terminal for the aliases to be available, or use
    msu's alias `msu.reload`.

1. You may simply download the [aliases.sh][script] and source it in your `~/.bashrc`


## license:

**The MIT License (MIT)**

Copyright &copy; 2016 GochoMugo <mugo@forfuture.co.ke>


[msu]:https://github.com/GochoMugo/msu
[script]:https://raw.githubusercontent.com/GochoMugo/fancy-aliases/master/aliases.sh
