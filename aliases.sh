#!/usr/bin/env bash


# metadata
FA__version=0.22.0


# ---------------------------------------------------------------------- #
# cd
# ---------------------------------------------------------------------- #

# DOC: Navigates up one directory.
alias ..='cd ..'

# DOC: Navigates up two directories.
alias ...='cd ../..'

# DOC: Navigates up three directories.
alias ....='cd ../../..'


# ---------------------------------------------------------------------- #
# cp
# ---------------------------------------------------------------------- #

# DOC: Copies directories recursively and prompts before overwriting.
alias cp='cp -i -r'


# ---------------------------------------------------------------------- #
# clear
# ---------------------------------------------------------------------- #

# DOC: Clears the terminal screen.
alias cls="clear"


# ---------------------------------------------------------------------- #
# docker
# ---------------------------------------------------------------------- #

# DOC: Removes all dangling Docker images.
alias dkci='docker rmi $(docker images -f dangling=true -q)'

# DOC: Removes all exited Docker containers.
alias dkcc='docker rm $(docker ps -a -f status=exited -q)'

# DOC: Runs a command in a running Docker container interactively.
alias dke='docker exec -it'

# DOC: Follows the log output of a Docker container.
alias dklf='docker logs --follow'

# DOC: Lists running Docker containers.
alias dkps='docker ps'

# DOC: Removes a Docker container.
alias dkrm='docker rm'

# DOC: Restarts a Docker container.
alias dkrs='docker restart'

# DOC: Starts a Docker container.
alias dks='docker start'

# DOC: Stops a Docker container.
alias dkx='docker stop'


# ---------------------------------------------------------------------- #
# git
# ---------------------------------------------------------------------- #
# HELP: '${FA_git_sign}' as a set variable to have your Git commits and tags PGP-signed
[[ -n "${FA_git_sign:-}" ]] && FA__git_sign="-S"
function FA__git_current_branch() {
    git rev-parse --abbrev-ref HEAD
}

# DOC: Stages files for a commit.
alias ga='git add'

# DOC: Applies a patch from a mailbox file.
alias gam="git am ${FA__git_sign}"

# DOC: Continues applying a mailbox patch after resolving conflicts.
alias gamc='git am --continue'

# DOC: Stages changes interactively, hunk by hunk.
alias gap='git add --patch'

# DOC: Lists all local branches.
alias gbr='git branch'

# DOC: Deletes a local branch.
alias gbrd='git branch -d'

function FA__gbrdd() {
    for branch in "${@}" ; do
        echo "Deleting local ${branch} branch" && git branch -d "${branch}"
        echo "Deleting remote ${branch} branch" && git push origin ":${branch}"
    done
}

# DOC: Deletes a local branch and its remote counterpart.
alias gbrdd='FA__gbrdd'

# DOC: Creates a new commit.
alias gc="git commit ${FA__git_sign}"

# DOC: Amends the most recent commit.
alias gca="git commit ${FA__git_sign} --amend"

# DOC: Removes all merged, local branches,
# except current, master and/or main branches.
alias gcb='git branch --merged | grep --extended-regexp --invert-match "(^\*|master|main)" | xargs git branch --delete'

# DOC: Checks out a branch, tag or file.
alias gch='git checkout'

# DOC: Clones a remote repository.
alias gcl='git clone'

# DOC: Clones a remote repository with only the latest snapshot.
alias gclf='git clone --depth 1'

# DOC: Cherry-picks a commit onto the current branch.
alias gcp='git cherry-pick'

# DOC: Shows changes between commits, the index, and the working tree.
alias gdf='git diff'

# HELP: 'gdfs' requires 'diff-so-fancy' be installed. See https://github.com/so-fancy/diff-so-fancy.
function FA__gdfs() { git diff --color "${@}" | diff-so-fancy | less -RFXS ; }

# DOC: Shows changes using diff-so-fancy for improved readability.
alias gdfs='FA__gdfs'

# DOC: Shows staged changes between the index and the last commit.
alias gdfc='git diff --cached'

# HELP: 'gdfcs' requires 'diff-so-fancy' be installed. See https://github.com/so-fancy/diff-so-fancy.
function FA__gdfcs() { git diff --cached --color "${@}" | diff-so-fancy | less -RFXS ; }

# DOC: Shows staged changes using diff-so-fancy for improved readability.
alias gdfcs='FA__gdfcs'

# DOC: Fetches branches and tags from a remote repository.
alias gf='git fetch'

# DOC: Creates patches from commits for emailing.
alias gfp='git format-patch --binary --output-directory=_patches'

# DOC: Shows the commit log in a compact, one-line format.
alias gl='git log --pretty=oneline'

# DOC: Merges a branch without fast-forwarding.
alias gm="git merge --no-ff ${FA__git_sign}"

# DOC: Merges a branch using fast-forward only.
alias gmf='git merge --ff-only'

# DOC: Pulls changes from a remote repository.
alias gp='git pull'

# DOC: Pulls changes from a remote repository using fast-forward only.
alias gpf='git pull --ff-only'

# DOC: Starts an interactive rebase.
alias grb="git rebase --interactive ${FA__git_sign}"

# DOC: Aborts an in-progress rebase.
alias grba='git rebase --abort'

# DOC: Continues an in-progress rebase after resolving conflicts.
alias grbc='git rebase --continue'

# DOC: Opens the rebase to-do list for editing.
alias grbe='git rebase --edit-todo'

# DOC: Resets the current HEAD to a specified state.
alias gre='git reset'

# DOC: Manages connections to remote repositories.
alias grem='git remote'

# DOC: Removes files from the index.
alias grm='git rm'

# DOC: Reverts a commit by creating a new commit.
alias grv='git revert -S'

# DOC: Shows the working tree status in short format.
alias gs='git status --short'

# DOC: Creates an annotated tag.
alias gt="git tag --annotate ${FA_git_sign:+--sign}"

function FA__gtd() {
    for tag in "${@}" ; do
        git push origin ":${tag}"
        git tag --delete "${tag}"
    done
}

# DOC: Deletes a tag locally and from the remote repository.
alias gtd='FA__gtd'

# DOC: Lists all tags.
alias gtl='git tag --list'

# DOC: Pushes changes to a remote repository.
alias gu='git push'

function FA__guf() {
    local remote="${1:-origin}"
    local branch="${2:-$(FA__git_current_branch)}"
    git push --force "${remote}" "${branch}"
}

# DOC: Force-pushes the current branch to a remote repository.
alias guf='FA__guf'

function FA__guu() {
    local remote="${1:-origin}"
    local branch="${2:-$(FA__git_current_branch)}"
    git push --set-upstream "${remote}" "${branch}"
}

# DOC: Pushes the current branch and sets the upstream tracking.
alias guu='FA__guu'

# DOC: Stashes all changes including untracked files.
alias gz='git stash save --include-untracked'

# DOC: Applies a stash to the working tree.
alias gza='git stash apply'

# DOC: Stashes all changes while keeping the index.
alias gzc='gz --keep-index'

function FA__gzd() {
    msu run console.yes_no "Drop a stash; you will lose un-committed work" || return 1
    git stash drop ${@}
}

# DOC: Drops a stash entry after prompting for confirmation.
alias gzd='FA__gzd'

function FA__gzda() {
    msu run console.yes_no "Drop ALL stashes; you will lose un-committed work" || return 1
    git stash clear
}

# DOC: Drops all stash entries after prompting for confirmation.
alias gzda='FA__gzda'

# DOC: Lists all stash entries.
alias gzl='git stash list'

# DOC: Pops a stash entry, applying it and removing it from the stash.
alias gzp='git stash pop'


# ---------------------------------------------------------------------- #
# less
# ---------------------------------------------------------------------- #

# DOC: Includes line numbers and outputs raw control characters.
alias less='less -R -N'


# ---------------------------------------------------------------------- #
# ln
# ---------------------------------------------------------------------- #
function FA__lns() { ln -sf "$(readlink -f "${1}")" "$(readlink -f "${2}")" ; }

# DOC: Creates a symbolic link using absolute paths.
alias lns="FA__lns"


# ---------------------------------------------------------------------- #
# ls
# ---------------------------------------------------------------------- #

# DOC: Lists all files with detailed information in human-readable format.
alias ll='ls -ahl'

# DOC: Lists all files including hidden ones.
alias la='ls -A'

# DOC: Lists files in a column format.
alias l='ls -CF'


# ---------------------------------------------------------------------- #
# mkdir
# ---------------------------------------------------------------------- #
function FA__mkd() {
  mkdir -p -- ${1}
  cd -- ${1}
}

# DOC: Creates a directory and navigates into it.
alias mkd='FA__mkd'


# ---------------------------------------------------------------------- #
# mv
# ---------------------------------------------------------------------- #

# DOC: Prompts before overwriting.
alias mv='mv -i'


# ---------------------------------------------------------------------- #
# mvn
# ---------------------------------------------------------------------- #

# DOC: Runs package phase while skipping tests.
alias mvnp='mvn package -DskipTests'

# DOC: Runs all tests, or a single test if specified.
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

# DOC: Runs the npm build script.
alias npmb='npm run build'

# DOC: Runs the npm clean script.
alias npmc='npm run clean'

# DOC: Runs the npm doc script.
alias npmd='npm run doc'

# DOC: Runs the npm format script.
alias npmf='npm run format'

# DOC: Installs a package without saving it to package.json.
alias npmic='npm install --no-save' 	# "npm install clean"

# DOC: Installs a package as a development dependency.
alias npmid='npm install --save-dev' 	# "npm install devDep"

# DOC: Checks for outdated npm packages.
alias npmo='npm outdated'

# DOC: Creates a tarball from the npm package.
alias npmp='npm pack'

# DOC: Runs a custom npm script.
alias npmr='npm run'

# DOC: Starts the npm application.
alias npms='npm start'

# DOC: Runs all npm tests.
alias npmt='npm test'

# DOC: Runs npm benchmark tests.
alias npmtb='npm run test:benchmark'

# DOC: Runs npm end-to-end tests.
alias npmte='npm run test:e2e'

# DOC: Runs npm unit tests.
alias npmtu='npm run test:unit'


# ---------------------------------------------------------------------- #
# pip
# ---------------------------------------------------------------------- #

# DOC: Installs a Python 3 package globally for the current user.
alias pip3g='PIP_REQUIRE_VIRTUALENV= pip3 install --user'

# DOC: Installs a Python package globally for the current user.
alias pipg='PIP_REQUIRE_VIRTUALENV= pip install --user'


# ---------------------------------------------------------------------- #
# rm
# ---------------------------------------------------------------------- #

# DOC: Prompts before removal.
alias rm='rm -i'


# ---------------------------------------------------------------------- #
# shred
# ---------------------------------------------------------------------- #

# DOC: Deletes a file securely by overwriting it before removal (uses shred on Linux; falls back to rm on macOS where shred is unavailable).
function FA__trash() {
    if command -v shred >/dev/null 2>&1; then
        shred --remove --zero --verbose "$@"
    else
        rm -f "$@"
    fi
}
alias trash='FA__trash'


# ---------------------------------------------------------------------- #
# tree
# ---------------------------------------------------------------------- #

# DOC: Lists the directory tree with hidden files and color enabled,
# ignoring some directories, such as `.git`, and listing directories first.
# The output gets piped into `less` with options to preserve color and
# line numbers, unless the output is small enough for one screen.
alias tre='FA__tre'
function FA__tre() {
    tree -aC -I '.git|.hg|.venv|node_modules' --dirsfirst "$@" | less -FRNX;
}

# DOC: Shows directories first.
alias tree='tree --dirsfirst'


# ---------------------------------------------------------------------- #
# uv
# ---------------------------------------------------------------------- #

# DOC: Run poe tasks using uv.
alias uvp='uv run poe'


# ---------------------------------------------------------------------- #
# wget
# ---------------------------------------------------------------------- #

# DOC: Resumes partially-downloaded file.
alias wget='wget --continue'


# ---------------------------------------------------------------------- #
# xclip
# ---------------------------------------------------------------------- #

# DOC: Copies stdin to the clipboard and prints the clipboard content.
alias clip='\
    tr --delete \\n | \
    xclip -selection clipboard && \
    echo "$(xclip -selection clipboard -out)"'


# ---------------------------------------------------------------------- #
# misc
# ---------------------------------------------------------------------- #

# DOC: Prints a message indicating the exit status of the
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

# HELP: See https://github.com/GochoMugo/fancy-aliases for more info.
