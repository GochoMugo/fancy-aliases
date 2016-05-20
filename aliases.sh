#!/usr/bin/env bash

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
# git
# ---------------------------------------------------------------------- #
# HELP: set '${FA_git_sign}' to a string, to have your commits PGP-signed
[[ -n "${FA_git_sign}" ]] && FA__git_sign="-S"
alias ga='git add'
alias gbr='git branch'
alias gc="git commit ${FA__git_sign}"
alias gca="git commit ${FA__git_sign} --amend"
alias gch='git checkout'
alias gcl='git clone'
alias gclf='git clone --depth 1'
alias gdf='git diff'
alias gdfc='git diff --cached'
alias gl='git log --pretty=oneline'
alias gm="git merge --no-ff ${FA__git_sign}"
alias gmf='git merge --ff-only'
alias gp='git pull'
alias grb='git rebase --interactive'
alias gre='git reset'
alias grem='git remote'
alias grm='git rm'
alias gs='git status --short'
alias gu='git push'
alias guf='git push --force'
alias guu='git push --set-upstream'


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
alias npmr='npm run'
alias npms='npm start'
alias npmt='npm test'


# ---------------------------------------------------------------------- #
# supervisord
# ---------------------------------------------------------------------- #
# HELP: set '${FA_supervisord_use_sudo}' to use 'sudo'
[[ -n "${FA_supervisord_use_sudo}" ]] && FA__supervisord_sudo='sudo'
# HELP: set '${FA_supervisord_conf}' to a path to a config file
[[ -n "${FA_supervisord_conf}" ]] && FA__supervisord_conf="-c '${FA_supervisord_conf}'"
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
# HELP: set '${FA_apt_use_sudo}' to use 'sudo'
[[ -n "${FA_apt_no_sudo}" ]] || FA__apt_sudo='sudo'
# HELP: set '${FA_apt_assume_yes}' to have `apt` assume yes
[[ -n "${FA_apt_assume_yes}" ]] && FA__apt_assume_yes='-y'
alias update="${FA__apt_sudo} apt-get update"
alias upgrade="\
    ${FA__apt_sudo} apt-get update && \
    ${FA__apt_sudo} apt-get ${FA__apt_assume_yes} upgrade && \
    ${FA__apt_sudo} apt-get ${FA__apt_assume_yes} dist-upgrade && \
    ${FA__apt_sudo} apt-get ${FA__apt_assume_yes} autoremove"
