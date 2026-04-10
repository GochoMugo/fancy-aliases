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

# Helper: initialise a bare git repo with user identity configured.
_setup_git_repo() {
    local repo="${1}"
    git init "${repo}"
    git -C "${repo}" config user.email "test@example.com"
    git -C "${repo}" config user.name "Test User"
}

# Helper: run a shell command with alias expansion and aliases.sh sourced.
# Use this when the aliased command must be invoked via `run` to capture output.
_run_alias() {
    run bash --norc -O expand_aliases -c "
        source '${BATS_TEST_DIRNAME}/../aliases.sh'
        $*
    "
}


# ---------------------------------------------------------------------- #
# cd
# ---------------------------------------------------------------------- #

@test "'..' navigates up one directory" {
    mkdir -p "${TEST_TEMP_DIR}/a"
    cd "${TEST_TEMP_DIR}/a"
    cd ..
    [ "$(pwd)" = "${TEST_TEMP_DIR}" ]
}

@test "'...' navigates up two directories" {
    mkdir -p "${TEST_TEMP_DIR}/a/b"
    cd "${TEST_TEMP_DIR}/a/b"
    cd ../..
    [ "$(pwd)" = "${TEST_TEMP_DIR}" ]
}

@test "'....' navigates up three directories" {
    mkdir -p "${TEST_TEMP_DIR}/a/b/c"
    cd "${TEST_TEMP_DIR}/a/b/c"
    cd ../../..
    [ "$(pwd)" = "${TEST_TEMP_DIR}" ]
}


# ---------------------------------------------------------------------- #
# cp
# ---------------------------------------------------------------------- #

@test "'cp' copies a file to a new destination" {
    [[ "$(uname)" == "Linux" ]] || skip "requires GNU coreutils"
    local src="${TEST_TEMP_DIR}/src.txt"
    local dst="${TEST_TEMP_DIR}/dst.txt"
    echo "hello" > "${src}"
    # Alias: cp --interactive --recursive
    cp "${src}" "${dst}"
    [ -f "${dst}" ]
    [ "$(cat "${dst}")" = "hello" ]
}

@test "'cp' copies a directory recursively" {
    [[ "$(uname)" == "Linux" ]] || skip "requires GNU coreutils"
    mkdir -p "${TEST_TEMP_DIR}/srcdir/subdir"
    echo "hello" > "${TEST_TEMP_DIR}/srcdir/file.txt"
    echo "world" > "${TEST_TEMP_DIR}/srcdir/subdir/nested.txt"
    # Alias: cp --interactive --recursive
    _run_alias "cp '${TEST_TEMP_DIR}/srcdir' '${TEST_TEMP_DIR}/dstdir'"
    [ -f "${TEST_TEMP_DIR}/dstdir/file.txt" ]
    [ -f "${TEST_TEMP_DIR}/dstdir/subdir/nested.txt" ]
}

@test "'cp' does not overwrite an existing file without confirmation" {
    [[ "$(uname)" == "Linux" ]] || skip "requires GNU coreutils"
    local src="${TEST_TEMP_DIR}/src.txt"
    local dst="${TEST_TEMP_DIR}/dst.txt"
    echo "original" > "${dst}"
    echo "new" > "${src}"
    # Alias: cp --interactive; pipe 'n' to decline. cp exits non-zero when skipping.
    echo "n" | cp --interactive "${src}" "${dst}" || true
    [ "$(cat "${dst}")" = "original" ]
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

@test "'ga' stages a file for commit" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    echo "content" > file.txt
    # Alias: git add
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && ga file.txt"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" status --short
    [[ "${output}" == *"A  file.txt"* ]]
}

@test "'gam' alias expands to 'git am'" {
    run alias gam
    [[ "${output}" == *"git am"* ]]
}

@test "'gamc' alias expands to 'git am --continue'" {
    run alias gamc
    [[ "${output}" == *"git am --continue"* ]]
}

@test "'gap' alias expands to 'git add --patch'" {
    run alias gap
    [[ "${output}" == *"git add --patch"* ]]
}

@test "'gbr' lists local branches" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    git -C "${TEST_TEMP_DIR}/repo" commit --allow-empty -m "init"
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gbr"
    [ "${status}" -eq 0 ]
    [ -n "${output}" ]
}

@test "'gbrd' deletes a local branch" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    git commit --allow-empty -m "init"
    git branch to-delete
    # Alias: git branch -d
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gbrd to-delete"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" branch
    [[ "${output}" != *"to-delete"* ]]
}

@test "'gbrdd' deletes a branch locally and from the remote" {
    local fake_git="${TEST_TEMP_DIR}/bin/git"
    mkdir -p "${TEST_TEMP_DIR}/bin"
    cat > "${fake_git}" <<'EOF'
#!/usr/bin/env bash
echo "git $*"
EOF
    chmod +x "${fake_git}"
    PATH="${TEST_TEMP_DIR}/bin:${PATH}"
    run FA__gbrdd feature
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"branch -d feature"* ]]
    [[ "${output}" == *"push origin :feature"* ]]
}

@test "'gc' creates a commit" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    echo "content" > file.txt
    git add file.txt
    # Alias: git commit
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gc -m 'test commit'"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" log --oneline
    [[ "${output}" == *"test commit"* ]]
}

@test "'gca' amends the most recent commit" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    git commit --allow-empty -m "original message"
    # Alias: git commit --amend
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gca --allow-empty -m 'amended message'"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" log --oneline
    [ "$(echo "${output}" | wc -l)" -eq 1 ]
    [[ "${output}" == *"amended message"* ]]
}

@test "'gcb' alias removes merged branches" {
    run alias gcb
    [[ "${output}" == *"git branch --merged"* ]]
    [[ "${output}" == *"git branch --delete"* ]]
}

@test "'gch' checks out a branch" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    git commit --allow-empty -m "init"
    git branch feature
    # Alias: git checkout
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gch feature"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" rev-parse --abbrev-ref HEAD
    [ "${output}" = "feature" ]
}

@test "'gcl' clones a repository" {
    local origin="${TEST_TEMP_DIR}/origin"
    _setup_git_repo "${origin}"
    git -C "${origin}" commit --allow-empty -m "init"
    # Alias: git clone
    _run_alias "gcl '${origin}' '${TEST_TEMP_DIR}/clone'"
    [ -d "${TEST_TEMP_DIR}/clone/.git" ]
}

@test "'gclf' clones only the latest snapshot of a repository" {
    local origin="${TEST_TEMP_DIR}/origin"
    _setup_git_repo "${origin}"
    git -C "${origin}" commit --allow-empty -m "first"
    git -C "${origin}" commit --allow-empty -m "second"
    # Alias: git clone --depth 1; use file:// so --depth is honoured.
    _run_alias "gclf 'file://${origin}' '${TEST_TEMP_DIR}/shallow'"
    run git -C "${TEST_TEMP_DIR}/shallow" log --oneline
    [ "$(echo "${output}" | wc -l)" -eq 1 ]
}

@test "'gcp' cherry-picks a commit onto the current branch" {
    local repo="${TEST_TEMP_DIR}/repo"
    _setup_git_repo "${repo}"
    cd "${repo}"
    echo "base" > base.txt
    git add base.txt
    git commit -m "init"
    local default_branch
    default_branch="$(git rev-parse --abbrev-ref HEAD)"
    git checkout -b feature
    echo "feature content" > feature.txt
    git add feature.txt
    git commit -m "cherry commit"
    local sha
    sha="$(git rev-parse HEAD)"
    git checkout "${default_branch}"
    # Alias: git cherry-pick
    _run_alias "cd '${repo}' && gcp '${sha}'"
    [ "${status}" -eq 0 ]
    run git -C "${repo}" log --oneline
    [[ "${output}" == *"cherry commit"* ]]
}

@test "'gdf' shows the diff of working-tree changes" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    echo "original" > file.txt
    git add file.txt
    git commit -m "init"
    echo "changed" > file.txt
    # Alias: git diff
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gdf"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"-original"* ]]
    [[ "${output}" == *"+changed"* ]]
}

@test "'gdfc' shows the diff of staged changes" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    echo "original" > file.txt
    git add file.txt
    git commit -m "init"
    echo "changed" > file.txt
    git add file.txt
    # Alias: git diff --cached
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gdfc"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"-original"* ]]
    [[ "${output}" == *"+changed"* ]]
}

@test "'gdfs' alias expands to 'FA__gdfs'" {
    run alias gdfs
    [[ "${output}" == *"FA__gdfs"* ]]
}

@test "'gdfcs' alias expands to 'FA__gdfcs'" {
    run alias gdfcs
    [[ "${output}" == *"FA__gdfcs"* ]]
}

@test "'gf' alias expands to 'git fetch'" {
    run alias gf
    [[ "${output}" == *"git fetch"* ]]
}

@test "'gfp' creates a patch file from a commit" {
    local repo="${TEST_TEMP_DIR}/repo"
    _setup_git_repo "${repo}"
    cd "${repo}"
    git commit --allow-empty -m "initial commit"
    echo "content" > file.txt
    git add file.txt
    git commit -m "add file"
    # Alias: git format-patch --binary --output-directory=_patches
    _run_alias "cd '${repo}' && gfp HEAD~1"
    [ -n "$(ls "${repo}/_patches/"*.patch 2>/dev/null)" ]
}

@test "'gl' shows the commit log in one-line format" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    git commit --allow-empty -m "first commit"
    git commit --allow-empty -m "second commit"
    # Alias: git log --pretty=oneline
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gl"
    [ "${status}" -eq 0 ]
    [ "$(echo "${output}" | wc -l)" -eq 2 ]
    [[ "${output}" == *"first commit"* ]]
    [[ "${output}" == *"second commit"* ]]
}

@test "'gm' merges a branch without fast-forwarding" {
    local repo="${TEST_TEMP_DIR}/repo"
    _setup_git_repo "${repo}"
    cd "${repo}"
    git commit --allow-empty -m "init"
    local default_branch
    default_branch="$(git rev-parse --abbrev-ref HEAD)"
    git checkout -b feature
    git commit --allow-empty -m "feature work"
    git checkout "${default_branch}"
    # Alias: git merge --no-ff
    _run_alias "cd '${repo}' && gm feature -m 'merge feature'"
    [ "${status}" -eq 0 ]
    run git -C "${repo}" log --oneline
    [[ "${output}" == *"merge feature"* ]]
}

@test "'gmf' merges a branch using fast-forward only" {
    local repo="${TEST_TEMP_DIR}/repo"
    _setup_git_repo "${repo}"
    cd "${repo}"
    git commit --allow-empty -m "init"
    local default_branch
    default_branch="$(git rev-parse --abbrev-ref HEAD)"
    git checkout -b feature
    git commit --allow-empty -m "feature work"
    git checkout "${default_branch}"
    # Alias: git merge --ff-only
    _run_alias "cd '${repo}' && gmf feature"
    [ "${status}" -eq 0 ]
    run git -C "${repo}" log --oneline
    [[ "${output}" == *"feature work"* ]]
}

@test "'gp' alias expands to 'git pull'" {
    run alias gp
    [[ "${output}" == *"git pull"* ]]
}

@test "'gpf' alias expands to 'git pull --ff-only'" {
    run alias gpf
    [[ "${output}" == *"git pull --ff-only"* ]]
}

@test "'grb' alias expands to 'git rebase --interactive'" {
    run alias grb
    [[ "${output}" == *"git rebase --interactive"* ]]
}

@test "'grba' alias expands to 'git rebase --abort'" {
    run alias grba
    [[ "${output}" == *"git rebase --abort"* ]]
}

@test "'grbc' alias expands to 'git rebase --continue'" {
    run alias grbc
    [[ "${output}" == *"git rebase --continue"* ]]
}

@test "'grbe' alias expands to 'git rebase --edit-todo'" {
    run alias grbe
    [[ "${output}" == *"git rebase --edit-todo"* ]]
}

@test "'gre' unstages a staged file" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    git commit --allow-empty -m "init"
    echo "new content" > file.txt
    git add file.txt
    # Alias: git reset
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gre HEAD file.txt"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" status --short
    [[ "${output}" == *"??"* ]]
}

@test "'grem' lists remote repositories" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    # Alias: git remote
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && grem"
    [ "${status}" -eq 0 ]
}

@test "'grm' removes a tracked file from the index" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    echo "content" > file.txt
    git add file.txt
    git commit -m "init"
    # Alias: git rm
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && grm file.txt"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" status --short
    [[ "${output}" == *"D  file.txt"* ]]
}

@test "'grv' alias expands to 'git revert'" {
    run alias grv
    [[ "${output}" == *"git revert"* ]]
}

@test "'gs' shows the working-tree status in short format" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    echo "content" > untracked.txt
    # Alias: git status --short
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gs"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"?? untracked.txt"* ]]
}

@test "'gt' creates an annotated tag" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    git commit --allow-empty -m "init"
    # Alias: git tag --annotate
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gt v1.0.0 -m 'version 1.0.0'"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" tag --list
    [[ "${output}" == *"v1.0.0"* ]]
}

@test "'gtd' deletes a tag locally and from the remote" {
    local fake_git="${TEST_TEMP_DIR}/bin/git"
    mkdir -p "${TEST_TEMP_DIR}/bin"
    cat > "${fake_git}" <<'EOF'
#!/usr/bin/env bash
echo "git $*"
EOF
    chmod +x "${fake_git}"
    PATH="${TEST_TEMP_DIR}/bin:${PATH}"
    run FA__gtd v1.0.0
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"push origin :v1.0.0"* ]]
    [[ "${output}" == *"tag --delete v1.0.0"* ]]
}

@test "'gtl' lists all tags" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    git commit --allow-empty -m "init"
    git tag v0.1.0
    git tag v0.2.0
    # Alias: git tag --list
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gtl"
    [[ "${output}" == *"v0.1.0"* ]]
    [[ "${output}" == *"v0.2.0"* ]]
}

@test "'gu' alias expands to 'git push'" {
    run alias gu
    [[ "${output}" == *"git push"* ]]
}

@test "'guf' function force-pushes a branch to a remote" {
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

@test "'guu' function pushes a branch and sets the upstream tracking" {
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

@test "'FA__git_current_branch' returns the current branch name" {
    local repo="${TEST_TEMP_DIR}/repo"
    _setup_git_repo "${repo}"
    git -C "${repo}" commit --allow-empty -m "init"
    cd "${repo}"
    run FA__git_current_branch
    [ "${status}" -eq 0 ]
    [ -n "${output}" ]
}

@test "'gz' stashes working-tree changes" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    echo "original" > file.txt
    git add file.txt
    git commit -m "init"
    echo "modified" > file.txt
    # Alias: git stash save --include-untracked
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gz"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" status --short
    [ "${status}" -eq 0 ]
    [ -z "${output}" ]
}

@test "'gza' applies a stash without removing it" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    echo "original" > file.txt
    git add file.txt
    git commit -m "init"
    echo "modified" > file.txt
    git stash
    # Alias: git stash apply
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gza"
    [ "${status}" -eq 0 ]
    [ "$(cat "${TEST_TEMP_DIR}/repo/file.txt")" = "modified" ]
    run git -C "${TEST_TEMP_DIR}/repo" stash list
    [[ "${output}" == *"stash@{0}"* ]]
}

@test "'gzc' stashes changes but keeps staged files in the index" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    echo "tracked" > tracked.txt
    git add tracked.txt
    git commit -m "init"
    echo "staged" > staged.txt
    git add staged.txt
    echo "unstaged" > unstaged.txt
    # Alias: gz --keep-index  →  git stash save --include-untracked --keep-index
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gzc"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" status --short
    [[ "${output}" == *"staged.txt"* ]]
    [ ! -f "${TEST_TEMP_DIR}/repo/unstaged.txt" ]
}

@test "'gzd' alias expands to 'FA__gzd'" {
    run alias gzd
    [[ "${output}" == *"FA__gzd"* ]]
}

@test "'gzda' alias expands to 'FA__gzda'" {
    run alias gzda
    [[ "${output}" == *"FA__gzda"* ]]
}

@test "'gzl' lists stash entries" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    echo "original" > file.txt
    git add file.txt
    git commit -m "init"
    echo "modified" > file.txt
    git stash
    # Alias: git stash list
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gzl"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"stash@{0}"* ]]
}

@test "'gzp' pops a stash entry and restores changes" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    echo "original" > file.txt
    git add file.txt
    git commit -m "init"
    echo "modified" > file.txt
    git stash
    # Alias: git stash pop
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gzp"
    [ "${status}" -eq 0 ]
    [ "$(cat "${TEST_TEMP_DIR}/repo/file.txt")" = "modified" ]
    run git -C "${TEST_TEMP_DIR}/repo" stash list
    [ -z "${output}" ]
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

@test "'ll' lists files with detailed info including hidden files" {
    touch "${TEST_TEMP_DIR}/.hidden"
    # Alias: ls -ahl
    _run_alias "ll '${TEST_TEMP_DIR}'"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *".hidden"* ]]
    [[ "${output}" == *"total"* ]]
}

@test "'la' lists hidden files" {
    touch "${TEST_TEMP_DIR}/.hidden"
    # Alias: ls -A
    _run_alias "la '${TEST_TEMP_DIR}'"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *".hidden"* ]]
}

@test "'l' lists files" {
    touch "${TEST_TEMP_DIR}/visible.txt"
    # Alias: ls -CF
    _run_alias "l '${TEST_TEMP_DIR}'"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"visible.txt"* ]]
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

@test "'mv' moves a file to a new destination" {
    [[ "$(uname)" == "Linux" ]] || skip "requires GNU coreutils"
    local src="${TEST_TEMP_DIR}/src.txt"
    local dst="${TEST_TEMP_DIR}/dst.txt"
    echo "hello" > "${src}"
    # Alias: mv --interactive
    _run_alias "mv '${src}' '${dst}'"
    [ ! -f "${src}" ]
    [ -f "${dst}" ]
    [ "$(cat "${dst}")" = "hello" ]
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

@test "'rm' removes a file after confirmation" {
    local file="${TEST_TEMP_DIR}/to_delete.txt"
    echo "content" > "${file}"
    # Alias: rm -i; pipe 'y' to confirm removal.
    _run_alias "yes | rm '${file}'"
    [ ! -f "${file}" ]
}


# ---------------------------------------------------------------------- #
# shred
# ---------------------------------------------------------------------- #

@test "'trash' securely deletes a file" {
    [[ "$(uname)" == "Linux" ]] || skip "shred is not available on macOS"
    local file="${TEST_TEMP_DIR}/secret.txt"
    echo "sensitive data" > "${file}"
    # Alias: shred --remove --zero --verbose
    _run_alias "trash '${file}'"
    [ ! -f "${file}" ]
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
