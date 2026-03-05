#!/usr/bin/env bash


# metadata
FA__version=0.20.0


# ---------------------------------------------------------------------- #
# Showing help information
# ---------------------------------------------------------------------- #
fancy-aliases() {
    echo
    echo " fancy-aliases v${FA__version}"
    echo
    echo " Available aliases:"
    echo
    awk '
        BEGIN { blank=1; doc=""; in_doc=0 }
        /^[[:space:]]*$/ { blank=1; doc=""; in_doc=0; next }
        /^# DOC: / {
            if (blank) {
                doc = substr($0, 8)
                in_doc = 1
            }
            blank = 0
            next
        }
        /^# / {
            if (in_doc) { doc = doc " " substr($0, 3) }
            blank = 0
            next
        }
        /^alias / || /^function [[:alnum:]]/ {
            if (doc != "") {
                name = $2
                sub(/[=(].*$/, "", name)
                if (name !~ /^FA__/) {
                    printf "  %-12s %s\n", name, doc
                }
            }
            doc = ""
            in_doc = 0
            blank = 0
            next
        }
        { blank = 0; doc = ""; in_doc = 0 }
    ' "${BASH_SOURCE[0]}"
    echo
    echo " Available options:"
    echo
    grep -E '^# HELP: ' "${BASH_SOURCE[0]}" | sed s/\#\ HELP:/\ \ /
    echo
    echo " See https://github.com/GochoMugo/fancy-aliases for more info."
    echo
}


# ---------------------------------------------------------------------- #
# cd
# ---------------------------------------------------------------------- #

# DOC: `..` navigates up one directory.
alias ..='cd ..'

# DOC: `...` navigates up two directories.
alias ...='cd ../..'

# DOC: `....` navigates up three directories.
alias ....='cd ../../..'


# ---------------------------------------------------------------------- #
# cp
# ---------------------------------------------------------------------- #

# DOC: `cp` copies directories recursively and prompts before overwriting.
alias cp='cp --interactive --recursive'


# ---------------------------------------------------------------------- #
# clear
# ---------------------------------------------------------------------- #

# DOC: `cls` clears the terminal screen.
alias cls="clear"


# ---------------------------------------------------------------------- #
# docker
# ---------------------------------------------------------------------- #

# DOC: `dkci` (docker clean images) removes all dangling Docker images.
alias dkci='docker rmi $(docker images -f dangling=true -q)'

# DOC: `dkcc` (docker clean containers) removes all exited Docker containers.
alias dkcc='docker rm $(docker ps -a -f status=exited -q)'

# DOC: `dke` (docker exec) runs a command in a running Docker container interactively.
alias dke='docker exec -it'

# DOC: `dklf` (docker logs follow) follows the log output of a Docker container.
alias dklf='docker logs --follow'

# DOC: `dkps` lists running Docker containers.
alias dkps='docker ps'

# DOC: `dkrm` removes a Docker container.
alias dkrm='docker rm'

# DOC: `dkrs` restarts a Docker container.
alias dkrs='docker restart'

# DOC: `dks` starts a Docker container.
alias dks='docker start'

# DOC: `dkx` stops a Docker container.
alias dkx='docker stop'


# ---------------------------------------------------------------------- #
# git
# ---------------------------------------------------------------------- #
# HELP: '${FA_git_sign}' as a set variable to have your Git commits and tags PGP-signed
[[ -n "${FA_git_sign:-}" ]] && FA__git_sign="-S"
function FA__git_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

# DOC: `ga` stages files for a commit.
alias ga='git add'

# DOC: `gam` applies a patch from a mailbox file.
alias gam="git am ${FA__git_sign}"

# DOC: `gamc` continues applying a mailbox patch after resolving conflicts.
alias gamc='git am --continue'

# DOC: `gap` stages changes interactively, hunk by hunk.
alias gap='git add --patch'

# DOC: `gbr` lists all local branches.
alias gbr='git branch'

# DOC: `gbrd` deletes a local branch.
alias gbrd='git branch -d'

function FA__gbrdd() {
    for branch in "${@}" ; do
        echo "Deleting local ${branch} branch" && git branch -d "${branch}"
        echo "Deleting remote ${branch} branch" && git push origin ":${branch}"
    done
}

# DOC: `gbrdd` deletes a local branch and its remote counterpart.
alias gbrdd='FA__gbrdd'

# DOC: `gc` creates a new commit.
alias gc="git commit ${FA__git_sign}"

# DOC: `gca` amends the most recent commit.
alias gca="git commit ${FA__git_sign} --amend"

# DOC: `gcb` (git clean branches) removes all merged, local branches,
# except current, master and/or main branches.
alias gcb='git branch --merged | grep --extended-regexp --invert-match "(^\*|master|main)" | xargs git branch --delete'

# DOC: `gch` checks out a branch, tag or file.
alias gch='git checkout'

# DOC: `gcl` clones a remote repository.
alias gcl='git clone'

# DOC: `gclf` clones a remote repository with only the latest snapshot.
alias gclf='git clone --depth 1'

# DOC: `gcp` cherry-picks a commit onto the current branch.
alias gcp='git cherry-pick'

# DOC: `gdf` shows changes between commits, the index, and the working tree.
alias gdf='git diff'

# HELP: 'gdfs' requires 'diff-so-fancy' be installed. See https://github.com/so-fancy/diff-so-fancy.
function FA__gdfs() { git diff --color "${@}" | diff-so-fancy | less -RFXS ; }

# DOC: `gdfs` shows changes using diff-so-fancy for improved readability.
alias gdfs='FA__gdfs'

# DOC: `gdfc` shows staged changes between the index and the last commit.
alias gdfc='git diff --cached'

# HELP: 'gdfcs' requires 'diff-so-fancy' be installed. See https://github.com/so-fancy/diff-so-fancy.
function FA__gdfcs() { git diff --cached --color "${@}" | diff-so-fancy | less -RFXS ; }

# DOC: `gdfcs` shows staged changes using diff-so-fancy for improved readability.
alias gdfcs='FA__gdfcs'

# DOC: `gf` fetches branches and tags from a remote repository.
alias gf='git fetch'

# DOC: `gfp` creates patches from commits for emailing.
alias gfp='git format-patch --binary --output-directory=_patches'

# DOC: `gl` shows the commit log in a compact, one-line format.
alias gl='git log --pretty=oneline'

# DOC: `gm` merges a branch without fast-forwarding.
alias gm="git merge --no-ff ${FA__git_sign}"

# DOC: `gmf` merges a branch using fast-forward only.
alias gmf='git merge --ff-only'

# DOC: `gp` pulls changes from a remote repository.
alias gp='git pull'

# DOC: `gpf` pulls changes from a remote repository using fast-forward only.
alias gpf='git pull --ff-only'

# DOC: `grb` starts an interactive rebase.
alias grb="git rebase --interactive ${FA__git_sign}"

# DOC: `grba` aborts an in-progress rebase.
alias grba='git rebase --abort'

# DOC: `grbc` continues an in-progress rebase after resolving conflicts.
alias grbc='git rebase --continue'

# DOC: `grbe` opens the rebase to-do list for editing.
alias grbe='git rebase --edit-todo'

# DOC: `gre` resets the current HEAD to a specified state.
alias gre='git reset'

# DOC: `grem` manages connections to remote repositories.
alias grem='git remote'

# DOC: `grm` removes files from the index.
alias grm='git rm'

# DOC: `grv` reverts a commit by creating a new commit.
alias grv='git revert -S'

# DOC: `gs` shows the working tree status in short format.
alias gs='git status --short'

# DOC: `gt` creates an annotated tag.
alias gt="git tag --annotate ${FA_git_sign:+--sign}"

function FA__gtd() {
    for tag in "${@}" ; do
        git push origin ":${tag}"
        git tag --delete "${tag}"
    done
}

# DOC: `gtd` deletes a tag locally and from the remote repository.
alias gtd='FA__gtd'

# DOC: `gtl` lists all tags.
alias gtl='git tag --list'

# DOC: `gu` pushes changes to a remote repository.
alias gu='git push'

function FA__guf() {
    local remote="${1:-origin}"
    local branch="${2:-$(FA__git_current_branch)}"
    git push --force "${remote}" "${branch}"
}

# DOC: `guf` force-pushes the current branch to a remote repository.
alias guf='FA__guf'

function FA__guu() {
    local remote="${1:-origin}"
    local branch="${2:-$(FA__git_current_branch)}"
    git push --set-upstream "${remote}" "${branch}"
}

# DOC: `guu` pushes the current branch and sets the upstream tracking.
alias guu='FA__guu'

# DOC: `gz` stashes all changes including untracked files.
alias gz='git stash save --include-untracked'

# DOC: `gza` applies a stash to the working tree.
alias gza='git stash apply'

# DOC: `gzc` stashes all changes while keeping the index.
alias gzc='gz --keep-index'

function FA__gzd() {
    msu run console.yes_no "Drop a stash; you will lose un-committed work" || return 1
    git stash drop ${@}
}

# DOC: `gzd` drops a stash entry after prompting for confirmation.
alias gzd='FA__gzd'

function FA__gzda() {
    msu run console.yes_no "Drop ALL stashes; you will lose un-committed work" || return 1
    git stash clear
}

# DOC: `gzda` drops all stash entries after prompting for confirmation.
alias gzda='FA__gzda'

# DOC: `gzl` lists all stash entries.
alias gzl='git stash list'

# DOC: `gzp` pops a stash entry, applying it and removing it from the stash.
alias gzp='git stash pop'


# ---------------------------------------------------------------------- #
# less
# ---------------------------------------------------------------------- #

# DOC: `less` includes line numbers and outputs raw control characters.
alias less='less -R -N'


# ---------------------------------------------------------------------- #
# ln
# ---------------------------------------------------------------------- #
function FA__lns() { ln -sf "$(readlink -f "${1}")" "$(readlink -f "${2}")" ; }

# DOC: `lns` creates a symbolic link using absolute paths.
alias lns="FA__lns"


# ---------------------------------------------------------------------- #
# ls
# ---------------------------------------------------------------------- #

# DOC: `ll` lists all files with detailed information in human-readable format.
alias ll='ls -ahl'

# DOC: `la` lists all files including hidden ones.
alias la='ls -A'

# DOC: `l` lists files in a column format.
alias l='ls -CF'


# ---------------------------------------------------------------------- #
# mkdir
# ---------------------------------------------------------------------- #
function FA__mkd() {
  mkdir -p -- ${1}
  cd -- ${1}
}

# DOC: `mkd` creates a directory and navigates into it.
alias mkd='FA__mkd'


# ---------------------------------------------------------------------- #
# mv
# ---------------------------------------------------------------------- #

# DOC: `mv` prompts before overwriting.
alias mv='mv --interactive'


# ---------------------------------------------------------------------- #
# mvn
# ---------------------------------------------------------------------- #

# DOC: `mvnp` (maven package) runs package phase while skipping tests.
alias mvnp='mvn package -DskipTests'

# DOC: `mvnt` (maven test) runs all tests, or a single test if specified.
alias mvnt='FA__mvnt'
function FA__mvnt() {
  local target
  target="${1}"
  if [ -n "${target}" ] ; then
    mvn test -Dtest="${target}"
  else
    mvn test
  fi
}


# ---------------------------------------------------------------------- #
# npm
# ---------------------------------------------------------------------- #

# DOC: `npmb` runs the npm build script.
alias npmb='npm run build'

# DOC: `npmc` runs the npm clean script.
alias npmc='npm run clean'

# DOC: `npmd` runs the npm doc script.
alias npmd='npm run doc'

# DOC: `npmf` runs the npm format script.
alias npmf='npm run format'

# DOC: `npmic` (npm install clean) installs a package without saving it to package.json.
alias npmic='npm install --no-save' 	# "npm install clean"

# DOC: `npmid` (npm install dev) installs a package as a development dependency.
alias npmid='npm install --save-dev' 	# "npm install devDep"

# DOC: `npmo` checks for outdated npm packages.
alias npmo='npm outdated'

# DOC: `npmp` creates a tarball from the npm package.
alias npmp='npm pack'

# DOC: `npmr` runs a custom npm script.
alias npmr='npm run'

# DOC: `npms` starts the npm application.
alias npms='npm start'

# DOC: `npmt` runs all npm tests.
alias npmt='npm test'

# DOC: `npmtb` runs npm benchmark tests.
alias npmtb='npm run test:benchmark'

# DOC: `npmte` runs npm end-to-end tests.
alias npmte='npm run test:e2e'

# DOC: `npmtu` runs npm unit tests.
alias npmtu='npm run test:unit'


# ---------------------------------------------------------------------- #
# pip
# ---------------------------------------------------------------------- #

# DOC: `pip3g` installs a Python 3 package globally for the current user.
alias pip3g='PIP_REQUIRE_VIRTUALENV= pip3 install --user'

# DOC: `pipg` installs a Python package globally for the current user.
alias pipg='PIP_REQUIRE_VIRTUALENV= pip install --user'


# ---------------------------------------------------------------------- #
# rm
# ---------------------------------------------------------------------- #

# DOC: `rm` prompts before removal.
alias rm='rm -i'


# ---------------------------------------------------------------------- #
# shred
# ---------------------------------------------------------------------- #

# DOC: `trash` overwrites and zeroes the file before deleting it.
alias trash='shred --remove --zero --verbose'


# ---------------------------------------------------------------------- #
# tree
# ---------------------------------------------------------------------- #

# DOC: `tre` is a shorthand for `tree` with hidden files and color enabled,
# ignoring some directories, such as `.git`, and listing directories first.
# The output gets piped into `less` with options to preserve color and
# line numbers, unless the output is small enough for one screen.
alias tre='FA__tre'
function FA__tre() {
    tree -aC -I '.git|.hg|.venv|node_modules' --dirsfirst "$@" | less -FRNX;
}

# DOC: `tree` shows directories first.
alias tree='tree --dirsfirst'


# ---------------------------------------------------------------------- #
# wget
# ---------------------------------------------------------------------- #

# DOC: `wget` resumes partially-downloaded file.
alias wget='wget --continue'


# ---------------------------------------------------------------------- #
# xclip
# ---------------------------------------------------------------------- #

# DOC: `clip` copies stdin to the clipboard and prints the clipboard content.
alias clip='\
    tr --delete \\n | \
    xclip -selection clipboard && \
    echo "$(xclip -selection clipboard -out)"'


# ---------------------------------------------------------------------- #
# misc
# ---------------------------------------------------------------------- #

# DOC: `ok` prints a message indicating the exit status of the
# last ran command.
function ok() {
    local ret_code=$?
    if [ ${ret_code} -eq 0 ] ; then
        echo -e "${clr_green}Last command was successful${clr_reset}"
    else
        echo -e "${clr_red}Last command failed with exit code ${ret_code}${clr_reset}"
    fi
    return ${ret_code}
}
