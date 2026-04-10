#!/usr/bin/env bats

setup() {
    shopt -s expand_aliases
    # shellcheck source=../aliases.sh
    source "${BATS_TEST_DIRNAME}/../aliases.sh"
    TEST_TEMP_DIR="$(mktemp -d)"
}

teardown() {
    rm -rf "${TEST_TEMP_DIR}"
}


# ---------------------------------------------------------------------- #
# cd
# ---------------------------------------------------------------------- #

@test "'..' alias expands to 'cd ..'" {
    run alias ..
    [[ "${output}" == *"cd .."* ]]
}

@test "'...' alias expands to 'cd ../..'" {
    run alias ...
    [[ "${output}" == *"cd ../.."* ]]
}

@test "'....' alias expands to 'cd ../../..'" {
    run alias ....
    [[ "${output}" == *"cd ../../.."* ]]
}

@test "'cd ..' navigates up one directory" {
    mkdir -p "${TEST_TEMP_DIR}/a"
    cd "${TEST_TEMP_DIR}/a"
    cd ..
    [ "$(pwd)" = "${TEST_TEMP_DIR}" ]
}

@test "'cd ../..' navigates up two directories" {
    mkdir -p "${TEST_TEMP_DIR}/a/b"
    cd "${TEST_TEMP_DIR}/a/b"
    cd ../..
    [ "$(pwd)" = "${TEST_TEMP_DIR}" ]
}

@test "'cd ../../..' navigates up three directories" {
    mkdir -p "${TEST_TEMP_DIR}/a/b/c"
    cd "${TEST_TEMP_DIR}/a/b/c"
    cd ../../..
    [ "$(pwd)" = "${TEST_TEMP_DIR}" ]
}


# ---------------------------------------------------------------------- #
# cp
# ---------------------------------------------------------------------- #

@test "'cp' alias includes --interactive and --recursive flags" {
    run alias cp
    [[ "${output}" == *"--interactive"* ]]
    [[ "${output}" == *"--recursive"* ]]
}


# ---------------------------------------------------------------------- #
# clear
# ---------------------------------------------------------------------- #

@test "'cls' alias expands to 'clear'" {
    run alias cls
    [[ "${output}" == *"clear"* ]]
}


# ---------------------------------------------------------------------- #
# docker
# ---------------------------------------------------------------------- #

@test "'dkps' alias expands to 'docker ps'" {
    run alias dkps
    [[ "${output}" == *"docker ps"* ]]
}

@test "'dke' alias expands to 'docker exec -it'" {
    run alias dke
    [[ "${output}" == *"docker exec -it"* ]]
}

@test "'dklf' alias expands to 'docker logs --follow'" {
    run alias dklf
    [[ "${output}" == *"docker logs --follow"* ]]
}

@test "'dkrm' alias expands to 'docker rm'" {
    run alias dkrm
    [[ "${output}" == *"docker rm"* ]]
}

@test "'dkrs' alias expands to 'docker restart'" {
    run alias dkrs
    [[ "${output}" == *"docker restart"* ]]
}

@test "'dks' alias expands to 'docker start'" {
    run alias dks
    [[ "${output}" == *"docker start"* ]]
}

@test "'dkx' alias expands to 'docker stop'" {
    run alias dkx
    [[ "${output}" == *"docker stop"* ]]
}


# ---------------------------------------------------------------------- #
# git
# ---------------------------------------------------------------------- #

@test "'ga' alias expands to 'git add'" {
    run alias ga
    [[ "${output}" == *"git add"* ]]
}

@test "'gbr' alias expands to 'git branch'" {
    run alias gbr
    [[ "${output}" == *"git branch"* ]]
}

@test "'gbrd' alias expands to 'git branch -d'" {
    run alias gbrd
    [[ "${output}" == *"git branch -d"* ]]
}

@test "'gc' alias expands to 'git commit'" {
    run alias gc
    [[ "${output}" == *"git commit"* ]]
}

@test "'gca' alias expands to 'git commit' with --amend" {
    run alias gca
    [[ "${output}" == *"git commit"* ]]
    [[ "${output}" == *"--amend"* ]]
}

@test "'gch' alias expands to 'git checkout'" {
    run alias gch
    [[ "${output}" == *"git checkout"* ]]
}

@test "'gcl' alias expands to 'git clone'" {
    run alias gcl
    [[ "${output}" == *"git clone"* ]]
}

@test "'gclf' alias expands to 'git clone --depth 1'" {
    run alias gclf
    [[ "${output}" == *"git clone --depth 1"* ]]
}

@test "'gcp' alias expands to 'git cherry-pick'" {
    run alias gcp
    [[ "${output}" == *"git cherry-pick"* ]]
}

@test "'gdf' alias expands to 'git diff'" {
    run alias gdf
    [[ "${output}" == *"git diff"* ]]
}

@test "'gdfc' alias expands to 'git diff --cached'" {
    run alias gdfc
    [[ "${output}" == *"git diff --cached"* ]]
}

@test "'gf' alias expands to 'git fetch'" {
    run alias gf
    [[ "${output}" == *"git fetch"* ]]
}

@test "'gl' alias expands to 'git log --pretty=oneline'" {
    run alias gl
    [[ "${output}" == *"git log --pretty=oneline"* ]]
}

@test "'gm' alias expands to 'git merge --no-ff'" {
    run alias gm
    [[ "${output}" == *"git merge --no-ff"* ]]
}

@test "'gmf' alias expands to 'git merge --ff-only'" {
    run alias gmf
    [[ "${output}" == *"git merge --ff-only"* ]]
}

@test "'gp' alias expands to 'git pull'" {
    run alias gp
    [[ "${output}" == *"git pull"* ]]
}

@test "'gpf' alias expands to 'git pull --ff-only'" {
    run alias gpf
    [[ "${output}" == *"git pull --ff-only"* ]]
}

@test "'gre' alias expands to 'git reset'" {
    run alias gre
    [[ "${output}" == *"git reset"* ]]
}

@test "'grem' alias expands to 'git remote'" {
    run alias grem
    [[ "${output}" == *"git remote"* ]]
}

@test "'grm' alias expands to 'git rm'" {
    run alias grm
    [[ "${output}" == *"git rm"* ]]
}

@test "'gs' alias expands to 'git status --short'" {
    run alias gs
    [[ "${output}" == *"git status --short"* ]]
}

@test "'gtl' alias expands to 'git tag --list'" {
    run alias gtl
    [[ "${output}" == *"git tag --list"* ]]
}

@test "'gu' alias expands to 'git push'" {
    run alias gu
    [[ "${output}" == *"git push"* ]]
}

@test "'gz' alias expands to 'git stash save --include-untracked'" {
    run alias gz
    [[ "${output}" == *"git stash save --include-untracked"* ]]
}

@test "'gza' alias expands to 'git stash apply'" {
    run alias gza
    [[ "${output}" == *"git stash apply"* ]]
}

@test "'gzl' alias expands to 'git stash list'" {
    run alias gzl
    [[ "${output}" == *"git stash list"* ]]
}

@test "'gzp' alias expands to 'git stash pop'" {
    run alias gzp
    [[ "${output}" == *"git stash pop"* ]]
}

@test "'FA__git_current_branch' returns the current branch name" {
    local repo="${TEST_TEMP_DIR}/repo"
    git init "${repo}"
    git -C "${repo}" config user.email "test@example.com"
    git -C "${repo}" config user.name "Test User"
    git -C "${repo}" commit --allow-empty -m "init"
    cd "${repo}"
    run FA__git_current_branch
    [ "${status}" -eq 0 ]
    [ -n "${output}" ]
}

@test "'guu' function pushes with --set-upstream" {
    local fake_git="${TEST_TEMP_DIR}/bin/git"
    mkdir -p "${TEST_TEMP_DIR}/bin"
    cat > "${fake_git}" <<'EOF'
#!/usr/bin/env bash
echo "git $*"
EOF
    chmod +x "${fake_git}"
    PATH="${TEST_TEMP_DIR}/bin:${PATH}"
    run FA__guu origin my-branch
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"--set-upstream"* ]]
    [[ "${output}" == *"origin"* ]]
    [[ "${output}" == *"my-branch"* ]]
}

@test "'guf' function pushes with --force" {
    local fake_git="${TEST_TEMP_DIR}/bin/git"
    mkdir -p "${TEST_TEMP_DIR}/bin"
    cat > "${fake_git}" <<'EOF'
#!/usr/bin/env bash
echo "git $*"
EOF
    chmod +x "${fake_git}"
    PATH="${TEST_TEMP_DIR}/bin:${PATH}"
    run FA__guf origin my-branch
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"--force"* ]]
    [[ "${output}" == *"origin"* ]]
    [[ "${output}" == *"my-branch"* ]]
}


# ---------------------------------------------------------------------- #
# less
# ---------------------------------------------------------------------- #

@test "'less' alias includes -R and -N flags" {
    run alias less
    [[ "${output}" == *"-R"* ]]
    [[ "${output}" == *"-N"* ]]
}


# ---------------------------------------------------------------------- #
# ln
# ---------------------------------------------------------------------- #

@test "'lns' creates a symbolic link using absolute paths" {
    local src="${TEST_TEMP_DIR}/source_file"
    local lnk="${TEST_TEMP_DIR}/link_file"
    echo "test content" > "${src}"
    FA__lns "${src}" "${lnk}"
    [ -L "${lnk}" ]
    [ "$(cat "${lnk}")" = "test content" ]
}


# ---------------------------------------------------------------------- #
# ls
# ---------------------------------------------------------------------- #

@test "'ll' alias includes -ahl flags" {
    run alias ll
    [[ "${output}" == *"-ahl"* ]]
}

@test "'la' alias includes -A flag" {
    run alias la
    [[ "${output}" == *"-A"* ]]
}

@test "'l' alias includes -CF flags" {
    run alias l
    [[ "${output}" == *"-CF"* ]]
}


# ---------------------------------------------------------------------- #
# mkdir
# ---------------------------------------------------------------------- #

@test "'mkd' creates a directory and navigates into it" {
    cd "${TEST_TEMP_DIR}"
    FA__mkd "new_dir"
    [ "$(pwd)" = "${TEST_TEMP_DIR}/new_dir" ]
    [ -d "${TEST_TEMP_DIR}/new_dir" ]
}

@test "'mkd' creates nested directories" {
    cd "${TEST_TEMP_DIR}"
    FA__mkd "a/b/c"
    [ "$(pwd)" = "${TEST_TEMP_DIR}/a/b/c" ]
    [ -d "${TEST_TEMP_DIR}/a/b/c" ]
}


# ---------------------------------------------------------------------- #
# mv
# ---------------------------------------------------------------------- #

@test "'mv' alias includes --interactive flag" {
    run alias mv
    [[ "${output}" == *"--interactive"* ]]
}


# ---------------------------------------------------------------------- #
# mvn
# ---------------------------------------------------------------------- #

@test "'mvnp' alias includes 'mvn package' and '-DskipTests'" {
    run alias mvnp
    [[ "${output}" == *"mvn package"* ]]
    [[ "${output}" == *"-DskipTests"* ]]
}

@test "'FA__mvnt' runs 'mvn test' without arguments" {
    local fake_mvn="${TEST_TEMP_DIR}/bin/mvn"
    mkdir -p "${TEST_TEMP_DIR}/bin"
    cat > "${fake_mvn}" <<'EOF'
#!/usr/bin/env bash
echo "mvn $*"
EOF
    chmod +x "${fake_mvn}"
    PATH="${TEST_TEMP_DIR}/bin:${PATH}"
    run FA__mvnt
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"mvn test"* ]]
}

@test "'FA__mvnt' runs 'mvn test -Dtest=<target>' with an argument" {
    local fake_mvn="${TEST_TEMP_DIR}/bin/mvn"
    mkdir -p "${TEST_TEMP_DIR}/bin"
    cat > "${fake_mvn}" <<'EOF'
#!/usr/bin/env bash
echo "mvn $*"
EOF
    chmod +x "${fake_mvn}"
    PATH="${TEST_TEMP_DIR}/bin:${PATH}"
    run FA__mvnt MyTest
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"mvn test"* ]]
    [[ "${output}" == *"-Dtest=MyTest"* ]]
}


# ---------------------------------------------------------------------- #
# npm
# ---------------------------------------------------------------------- #

@test "'npmb' alias expands to 'npm run build'" {
    run alias npmb
    [[ "${output}" == *"npm run build"* ]]
}

@test "'npmc' alias expands to 'npm run clean'" {
    run alias npmc
    [[ "${output}" == *"npm run clean"* ]]
}

@test "'npmd' alias expands to 'npm run doc'" {
    run alias npmd
    [[ "${output}" == *"npm run doc"* ]]
}

@test "'npmf' alias expands to 'npm run format'" {
    run alias npmf
    [[ "${output}" == *"npm run format"* ]]
}

@test "'npmic' alias includes 'npm install --no-save'" {
    run alias npmic
    [[ "${output}" == *"npm install --no-save"* ]]
}

@test "'npmid' alias includes 'npm install --save-dev'" {
    run alias npmid
    [[ "${output}" == *"npm install --save-dev"* ]]
}

@test "'npmo' alias expands to 'npm outdated'" {
    run alias npmo
    [[ "${output}" == *"npm outdated"* ]]
}

@test "'npmp' alias expands to 'npm pack'" {
    run alias npmp
    [[ "${output}" == *"npm pack"* ]]
}

@test "'npmr' alias expands to 'npm run'" {
    run alias npmr
    [[ "${output}" == *"npm run"* ]]
}

@test "'npms' alias expands to 'npm start'" {
    run alias npms
    [[ "${output}" == *"npm start"* ]]
}

@test "'npmt' alias expands to 'npm test'" {
    run alias npmt
    [[ "${output}" == *"npm test"* ]]
}

@test "'npmtb' alias expands to 'npm run test:benchmark'" {
    run alias npmtb
    [[ "${output}" == *"npm run test:benchmark"* ]]
}

@test "'npmte' alias expands to 'npm run test:e2e'" {
    run alias npmte
    [[ "${output}" == *"npm run test:e2e"* ]]
}

@test "'npmtu' alias expands to 'npm run test:unit'" {
    run alias npmtu
    [[ "${output}" == *"npm run test:unit"* ]]
}


# ---------------------------------------------------------------------- #
# pip
# ---------------------------------------------------------------------- #

@test "'pip3g' alias includes 'pip3 install' and '--user'" {
    run alias pip3g
    [[ "${output}" == *"pip3 install"* ]]
    [[ "${output}" == *"--user"* ]]
}

@test "'pipg' alias includes 'pip install' and '--user'" {
    run alias pipg
    [[ "${output}" == *"pip install"* ]]
    [[ "${output}" == *"--user"* ]]
}


# ---------------------------------------------------------------------- #
# rm
# ---------------------------------------------------------------------- #

@test "'rm' alias includes -i flag" {
    run alias rm
    [[ "${output}" == *"-i"* ]]
}


# ---------------------------------------------------------------------- #
# shred
# ---------------------------------------------------------------------- #

@test "'trash' alias includes 'shred' and '--remove'" {
    run alias trash
    [[ "${output}" == *"shred"* ]]
    [[ "${output}" == *"--remove"* ]]
}


# ---------------------------------------------------------------------- #
# uv
# ---------------------------------------------------------------------- #

@test "'uvp' alias expands to 'uv run poe'" {
    run alias uvp
    [[ "${output}" == *"uv run poe"* ]]
}


# ---------------------------------------------------------------------- #
# wget
# ---------------------------------------------------------------------- #

@test "'wget' alias includes --continue flag" {
    run alias wget
    [[ "${output}" == *"--continue"* ]]
}
