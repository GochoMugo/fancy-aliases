#!/usr/bin/env bash


# metadata
FA__version=0.14.0


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
alias dklf='docker logs --follow'


# ---------------------------------------------------------------------- #
# git
# ---------------------------------------------------------------------- #
# HELP: '${FA_git_sign}' as a set variable to have your Git commits and tags PGP-signed
[[ -n "${FA_git_sign:-}" ]] && FA__git_sign="-S"
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
alias gdf='git diff'
# HELP: 'gdfs' requires 'diff-so-fancy' be installed. See https://github.com/so-fancy/diff-so-fancy.
function FA__gdfs() { git diff --color "${@}" | diff-so-fancy | less -RFXS ; }
alias gdfs='FA__gdfs'
alias gdfc='git diff --cached'
# HELP: 'gdfcs' requires 'diff-so-fancy' be installed. See https://github.com/so-fancy/diff-so-fancy.
function FA__gdfcs() { git diff --cached --color "${@}" | diff-so-fancy | less -RFXS ; }
alias gdfcs='FA__gdfcs'
alias gfp='git format-patch --binary --output-directory=_patches'
alias gl='git log --pretty=oneline'
alias gm="git merge --no-ff ${FA__git_sign}"
alias gmf='git merge --ff-only'
alias gp='git pull'
alias grb="git rebase --interactive ${FA__git_sign}"
alias grbc='git rebase --continue'
alias gre='git reset'
alias grem='git remote'
alias grm='git rm'
alias gs='git status --short'
alias gt="git tag --annotate ${FA_git_sign:+--sign}"
alias gtl='git tag --list'
alias gu='git push'
alias guf='git push --force'
alias guu='git push --set-upstream'
alias gz='git stash save --include-untracked'
function FA__gz() {
    local args=($@)
    if [[ "${@: -1}" =~ ^-?[0-9]+$ ]] ; then
        args[-1]="stash@{${args[-1]}}"
    fi
    git stash ${args[@]}
}
alias gza='FA__gz apply' # git stash apply
alias gzc='gz --keep-index'
function FA__gzd() {
    msu run console.yes_no "Drop a stash; you will lose un-committed work" || return 1
    FA__gz drop ${@}
}
alias gzd='FA__gzd'
alias gzl='git stash list'
alias gzp='FA__gz pop' # git stash pop


# ---------------------------------------------------------------------- #
# hub
# ---------------------------------------------------------------------- #
alias ghcr='hub create'
alias ghf='hub fork'
alias ghi='hub issue'
alias ghpr='hub pull-request'
alias ghr='hub release'
alias ghrc='hub release create'
alias ghs='hub ci-status'
alias ghv='hub browse'


# ---------------------------------------------------------------------- #
# mkdir 
# ---------------------------------------------------------------------- #
function FA__mkd() {
  mkdir -p ${1}
  cd ${1}
}
alias mkd='FA__mkd'


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
# mercurial
# ---------------------------------------------------------------------- #
alias hga='hg add'
alias hgbr='hg heads'
alias hgc='hg commit'
alias hgch='hg update'
alias hgdf='hg diff | less'
alias hgf='hg forget'
alias hgl="hg log --limit 10 --template '{rev}: {desc|firstline}\n'"
alias hgp='hg pull && hg update'
alias hgrm='hg remove'
alias hgs='hg status'
alias hgu='hg push'
alias hguu='hg push --new-branch'
alias hgx='hg commit --close-branch'


# ---------------------------------------------------------------------- #
# npm
# ---------------------------------------------------------------------- #
alias npmb='npm run build'
alias npmc='npm run clean'
alias npmd='npm run doc'
alias npmh='npm home'
alias npmic='npm install --no-save' 	# "npm install clean"
alias npmid='npm install --save-dev' 	# "npm install devDep"
alias npmp='npm pack'
alias npmr='npm run'
alias npms='npm start'
alias npmt='npm test'


# ---------------------------------------------------------------------- #
# supervisord
# ---------------------------------------------------------------------- #
# HELP: '${FA_supervisord_use_sudo}' as a set variable to use `sudo` with `supervisord`
[[ -n "${FA_supervisord_use_sudo:-}" ]] && FA__supervisord_sudo='sudo'
# HELP: '${FA_supervisord_conf}' as a path to a config file for `supervisord` and `supervisorctl`
[[ -n "${FA_supervisord_conf:-}" ]] && FA__supervisord_conf="-c '${FA_supervisord_conf}'"
alias ssv="${FA__supervisord_sudo} supervisorctl ${FA__supervisord_conf}"
alias ssv.i="${FA__supervisord_sudo} supervisord ${FA__supervisord_conf}"
alias ssv.r="${FA__supervisord_sudo} supervisorctl ${FA__supervisord_conf} reload"
alias ssv.s="${FA__supervisord_sudo} supervisorctl ${FA__supervisord_conf} start"
alias ssv.t="${FA__supervisord_sudo} supervisorctl ${FA__supervisord_conf} status"
alias ssv.x="${FA__supervisord_sudo} supervisorctl ${FA__supervisord_conf} stop"
alias ssv.initd="${FA__supervisord_sudo} /etc/init.d/supervisor start"


# ---------------------------------------------------------------------- #
# system updates
# ---------------------------------------------------------------------- #
# HELP: '${FA_apt_no_sudo}' as a set variable to not use `sudo` with `apt-get`
[[ -n "${FA_apt_no_sudo:-}" ]] || FA__apt_sudo='sudo'
# HELP: '${FA_apt_assume_yes}' as a set variable to `apt` assume yes
[[ -n "${FA_apt_assume_yes:-}" ]] && FA__apt_assume_yes='-y'
# HELP: '${FA_apt_purge}' as a set variable to purge during cleanup
[[ -n "${FA_apt_purge:-}" ]] && FA__apt_purge='--purge'
alias update="${FA__apt_sudo} apt-get update"
alias upgrade="\
    ${FA__apt_sudo} apt-get update && \
    ${FA__apt_sudo} apt-get ${FA__apt_assume_yes} upgrade && \
    ${FA__apt_sudo} apt-get ${FA__apt_assume_yes} dist-upgrade && \
    ${FA__apt_sudo} apt-get ${FA__apt_assume_yes} ${FA__apt_purge} autoremove"


# ---------------------------------------------------------------------- #
# xclip
# ---------------------------------------------------------------------- #
alias clip='xclip -selection clipboard'
