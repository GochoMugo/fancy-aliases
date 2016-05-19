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
# HELP: set '${FA_git_sign}' to a string, to have your commits signed
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
alias ssv='sudo supervisorctl'
alias ssv.i='sudo /etc/init.d/supervisor start'
alias ssv.r='sudo supervisorctl reload'
alias ssv.s='sudo supervisorctl start'
alias ssv.t='sudo supervisorctl status'
alias ssv.x='sudo supervisorctl stop'


# ---------------------------------------------------------------------- #
# system updates
# ---------------------------------------------------------------------- #
alias update='sudo apt-get update'
alias upgrade='sudo apt-get update && \
    sudo apt-get -y upgrade && \
    sudo apt-get -y dist-upgrade && \
    sudo apt-get -y autoremove'
