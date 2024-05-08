#!/usr/bin/env bash


# metadata
FA__version=0.18.0


# ---------------------------------------------------------------------- #
# Showing help information
# ---------------------------------------------------------------------- #
fancy-aliases() {
    echo
    echo " fancy-aliases v${FA__version}"
    echo
    echo " Available aliases:"
    echo
    grep -Eo 'alias (\w+)' "${BASH_SOURCE[0]}" | sed s/alias\ /\ \ / | column
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
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'


# ---------------------------------------------------------------------- #
# clear
# ---------------------------------------------------------------------- #
alias cls="clear"


# ---------------------------------------------------------------------- #
# docker
# ---------------------------------------------------------------------- #
alias dkci='docker rmi $(docker images -f dangling=true -q)'
alias dkcc='docker rm $(docker ps -a -f status=exited -q)'
alias dke='docker exec -it'
alias dklf='docker logs --follow'
alias dkps='docker ps'
alias dkrs='docker restart'
alias dks='docker start'
alias dkx='docker stop'


# ---------------------------------------------------------------------- #
# git
# ---------------------------------------------------------------------- #
# HELP: '${FA_git_sign}' as a set variable to have your Git commits and tags PGP-signed
[[ -n "${FA_git_sign:-}" ]] && FA__git_sign="-S"
function FA__git_current_branch() {
    git rev-parse --abbrev-ref HEAD
}
alias ga='git add'
alias gam="git am ${FA__git_sign}"
alias gamc='git am --continue'
alias gap='git add --patch'
alias gbr='git branch'
alias gbrd='git branch -d'
function FA__gbrdd() {
    for branch in "${@}" ; do
        echo "Deleting local ${branch} branch" && git branch -d "${branch}"
        echo "Deleting remote ${branch} branch" && git push origin ":${branch}"
    done
}
alias gbrdd='FA__gbrdd'
alias gc="git commit ${FA__git_sign}"
alias gca="git commit ${FA__git_sign} --amend"
alias gch='git checkout'
alias gcl='git clone'
alias gclf='git clone --depth 1'
alias gcp='git cherry-pick'
alias gdf='git diff'
# HELP: 'gdfs' requires 'diff-so-fancy' be installed. See https://github.com/so-fancy/diff-so-fancy.
function FA__gdfs() { git diff --color "${@}" | diff-so-fancy | less -RFXS ; }
alias gdfs='FA__gdfs'
alias gdfc='git diff --cached'
# HELP: 'gdfcs' requires 'diff-so-fancy' be installed. See https://github.com/so-fancy/diff-so-fancy.
function FA__gdfcs() { git diff --cached --color "${@}" | diff-so-fancy | less -RFXS ; }
alias gdfcs='FA__gdfcs'
alias gf='git fetch'
alias gfp='git format-patch --binary --output-directory=_patches'
alias gl='git log --pretty=oneline'
alias gm="git merge --no-ff ${FA__git_sign}"
alias gmf='git merge --ff-only'
alias gp='git pull'
alias grb="git rebase --interactive ${FA__git_sign}"
alias grbc='git rebase --continue'
alias grbe='git rebase --edit-todo'
alias gre='git reset'
alias grem='git remote'
alias grm='git rm'
alias gs='git status --short'
alias gt="git tag --annotate ${FA_git_sign:+--sign}"
function FA__gtd() {
    for tag in "${@}" ; do
        git push origin ":${tag}"
        git tag --delete "${tag}"
    done
}
alias gtd='FA__gtd'
alias gtl='git tag --list'
alias gu='git push'
function FA__guf() {
    local remote="${1:-origin}"
    local branch="${2:-$(FA__git_current_branch)}"
    git push --force "${remote}" "${branch}"
}
alias guf='FA__guf'
function FA__guu() {
    local remote="${1:-origin}"
    local branch="${2:-$(FA__git_current_branch)}"
    git push --set-upstream "${remote}" "${branch}"
}
alias guu='FA__guu'
alias gz='git stash save --include-untracked'
alias gza='git stash apply'
alias gzc='gz --keep-index'
function FA__gzd() {
    msu run console.yes_no "Drop a stash; you will lose un-committed work" || return 1
    git stash drop ${@}
}
alias gzd='FA__gzd'
alias gzl='git stash list'
alias gzp='git stash pop'


# ---------------------------------------------------------------------- #
# ln
# ---------------------------------------------------------------------- #
function FA__lns() { ln -sf "$(readlink -f "${1}")" "$(readlink -f "${2}")" ; }
alias lns="FA__lns"


# ---------------------------------------------------------------------- #
# ls
# ---------------------------------------------------------------------- #
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'


# ---------------------------------------------------------------------- #
# mkdir
# ---------------------------------------------------------------------- #
function FA__mkd() {
  mkdir -p -- ${1}
  cd -- ${1}
}
alias mkd='FA__mkd'


# ---------------------------------------------------------------------- #
# npm
# ---------------------------------------------------------------------- #
alias npmb='npm run build'
alias npmc='npm run clean'
alias npmd='npm run doc'
alias npmic='npm install --no-save' 	# "npm install clean"
alias npmid='npm install --save-dev' 	# "npm install devDep"
alias npmp='npm pack'
alias npmr='npm run'
alias npms='npm start'
alias npmt='npm test'
alias npmtb='npm run test:benchmark'
alias npmte='npm run test:e2e'
alias npmtu='npm run test:unit'


# ---------------------------------------------------------------------- #
# pip
# ---------------------------------------------------------------------- #
alias pip3g='PIP_REQUIRE_VIRTUALENV= pip3 install --user'
alias pipg='PIP_REQUIRE_VIRTUALENV= pip install --user'


# ---------------------------------------------------------------------- #
# system updates
# ---------------------------------------------------------------------- #
# HELP: '${FA_apt_no_sudo}' as a set variable to not use `sudo` with `apt-get`
[[ -n "${FA_apt_no_sudo:-}" ]] || FA__apt_sudo='sudo'
# HELP: '${FA_apt_assume_yes}' as a set variable to `apt` assume yes
[[ -n "${FA_apt_assume_yes:-}" ]] && FA__apt_assume_yes='-y'
# HELP: '${FA_apt_purge}' as a set variable to purge during cleanup
[[ -n "${FA_apt_purge:-}" ]] && FA__apt_purge='--purge'
alias upgrade="\
    ${FA__apt_sudo} apt-get update && \
    ${FA__apt_sudo} apt-get ${FA__apt_assume_yes} upgrade && \
    ${FA__apt_sudo} apt-get ${FA__apt_assume_yes} dist-upgrade && \
    ${FA__apt_sudo} apt-get ${FA__apt_assume_yes} ${FA__apt_purge} autoremove"


# ---------------------------------------------------------------------- #
# xclip
# ---------------------------------------------------------------------- #
alias clip='\
    tr --delete \\n | \
    xclip -selection clipboard | \
    echo "$(xclip -selection clipboard -out)"'
