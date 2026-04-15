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
    _run_alias "cd '${TEST_TEMP_DIR}/a' && .. && pwd"
    [ "${status}" -eq 0 ]
    [ "${output}" = "${TEST_TEMP_DIR}" ]
}

@test "'...' navigates up two directories" {
    mkdir -p "${TEST_TEMP_DIR}/a/b"
    _run_alias "cd '${TEST_TEMP_DIR}/a/b' && ... && pwd"
    [ "${status}" -eq 0 ]
    [ "${output}" = "${TEST_TEMP_DIR}" ]
}

@test "'....' navigates up three directories" {
    mkdir -p "${TEST_TEMP_DIR}/a/b/c"
    _run_alias "cd '${TEST_TEMP_DIR}/a/b/c' && .... && pwd"
    [ "${status}" -eq 0 ]
    [ "${output}" = "${TEST_TEMP_DIR}" ]
}


# ---------------------------------------------------------------------- #
# cp
# ---------------------------------------------------------------------- #

@test "'cp' copies a file to a new destination" {
    local src="${TEST_TEMP_DIR}/src.txt"
    local dst="${TEST_TEMP_DIR}/dst.txt"
    echo "hello" > "${src}"
    cp "${src}" "${dst}"
    [ -f "${dst}" ]
    [ "$(cat "${dst}")" = "hello" ]
}

@test "'cp' copies a directory recursively" {
    mkdir -p "${TEST_TEMP_DIR}/srcdir/subdir"
    echo "hello" > "${TEST_TEMP_DIR}/srcdir/file.txt"
    echo "world" > "${TEST_TEMP_DIR}/srcdir/subdir/nested.txt"
    _run_alias "cp '${TEST_TEMP_DIR}/srcdir' '${TEST_TEMP_DIR}/dstdir'"
    [ -f "${TEST_TEMP_DIR}/dstdir/file.txt" ]
    [ -f "${TEST_TEMP_DIR}/dstdir/subdir/nested.txt" ]
}


# ---------------------------------------------------------------------- #
# git
# ---------------------------------------------------------------------- #

@test "'ga' stages a file for commit" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    echo "content" > file.txt
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && ga file.txt"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" status --short
    [[ "${output}" == *"A  file.txt"* ]]
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
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gc -m 'test commit'"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" log --oneline
    [[ "${output}" == *"test commit"* ]]
}

@test "'gca' amends the most recent commit" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    git commit --allow-empty -m "original message"
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gca --allow-empty -m 'amended message'"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" log --oneline
    [ "$(echo "${output}" | wc -l)" -eq 1 ]
    [[ "${output}" == *"amended message"* ]]
}

@test "'gcb' deletes all merged local branches" {
    local repo="${TEST_TEMP_DIR}/repo"
    _setup_git_repo "${repo}"
    cd "${repo}"
    git commit --allow-empty -m "init"
    local default_branch
    default_branch="$(git rev-parse --abbrev-ref HEAD)"
    git checkout -b merged-branch
    git checkout "${default_branch}"
    git merge merged-branch
    _run_alias "cd '${repo}' && gcb"
    [ "${status}" -eq 0 ]
    run git -C "${repo}" branch
    [[ "${output}" != *"merged-branch"* ]]
}

@test "'gch' checks out a branch" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    git commit --allow-empty -m "init"
    git branch feature
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gch feature"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" rev-parse --abbrev-ref HEAD
    [ "${output}" = "feature" ]
}

@test "'gcl' clones a repository" {
    local origin="${TEST_TEMP_DIR}/origin"
    _setup_git_repo "${origin}"
    git -C "${origin}" commit --allow-empty -m "init"
    _run_alias "gcl '${origin}' '${TEST_TEMP_DIR}/clone'"
    [ -d "${TEST_TEMP_DIR}/clone/.git" ]
}

@test "'gclf' clones only the latest snapshot of a repository" {
    local origin="${TEST_TEMP_DIR}/origin"
    _setup_git_repo "${origin}"
    git -C "${origin}" commit --allow-empty -m "first"
    git -C "${origin}" commit --allow-empty -m "second"
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
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gdfc"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"-original"* ]]
    [[ "${output}" == *"+changed"* ]]
}

@test "'gf' fetches changes from a remote repository" {
    local origin="${TEST_TEMP_DIR}/origin"
    local clone="${TEST_TEMP_DIR}/clone"
    _setup_git_repo "${origin}"
    git -C "${origin}" commit --allow-empty -m "init"
    git clone "${origin}" "${clone}"
    git -C "${clone}" config user.email "test@example.com"
    git -C "${clone}" config user.name "Test User"
    git -C "${origin}" commit --allow-empty -m "new commit"
    local branch
    branch="$(git -C "${origin}" rev-parse --abbrev-ref HEAD)"
    _run_alias "cd '${clone}' && gf"
    [ "${status}" -eq 0 ]
    run git -C "${clone}" log --oneline "origin/${branch}"
    [[ "${output}" == *"new commit"* ]]
}

@test "'gfp' creates a patch file from a commit" {
    local repo="${TEST_TEMP_DIR}/repo"
    _setup_git_repo "${repo}"
    cd "${repo}"
    git commit --allow-empty -m "initial commit"
    echo "content" > file.txt
    git add file.txt
    git commit -m "add file"
    _run_alias "cd '${repo}' && gfp HEAD~1"
    [ -n "$(ls "${repo}/_patches/"*.patch 2>/dev/null)" ]
}

@test "'gl' shows the commit log in one-line format" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    git commit --allow-empty -m "first commit"
    git commit --allow-empty -m "second commit"
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
    _run_alias "cd '${repo}' && gmf feature"
    [ "${status}" -eq 0 ]
    run git -C "${repo}" log --oneline
    [[ "${output}" == *"feature work"* ]]
}

@test "'gp' pulls changes from a remote repository" {
    local origin="${TEST_TEMP_DIR}/origin"
    local clone="${TEST_TEMP_DIR}/clone"
    _setup_git_repo "${origin}"
    git -C "${origin}" commit --allow-empty -m "init"
    git clone "${origin}" "${clone}"
    git -C "${clone}" config user.email "test@example.com"
    git -C "${clone}" config user.name "Test User"
    git -C "${origin}" commit --allow-empty -m "new commit"
    _run_alias "cd '${clone}' && gp"
    [ "${status}" -eq 0 ]
    run git -C "${clone}" log --oneline
    [[ "${output}" == *"new commit"* ]]
}

@test "'gpf' pulls changes using fast-forward only" {
    local origin="${TEST_TEMP_DIR}/origin"
    local clone="${TEST_TEMP_DIR}/clone"
    _setup_git_repo "${origin}"
    git -C "${origin}" commit --allow-empty -m "init"
    git clone "${origin}" "${clone}"
    git -C "${clone}" config user.email "test@example.com"
    git -C "${clone}" config user.name "Test User"
    git -C "${origin}" commit --allow-empty -m "new commit"
    _run_alias "cd '${clone}' && gpf"
    [ "${status}" -eq 0 ]
    run git -C "${clone}" log --oneline
    [[ "${output}" == *"new commit"* ]]
}

@test "'grba' aborts an in-progress rebase" {
    local repo="${TEST_TEMP_DIR}/repo"
    _setup_git_repo "${repo}"
    cd "${repo}"
    echo "base" > file.txt
    git add file.txt
    git commit -m "base"
    local default_branch
    default_branch="$(git rev-parse --abbrev-ref HEAD)"
    git checkout -b feature
    echo "feature" > file.txt
    git commit -am "feature change"
    git checkout "${default_branch}"
    echo "main" > file.txt
    git commit -am "main change"
    git checkout feature
    git rebase "${default_branch}" || true
    [ -d "${repo}/.git/rebase-merge" ]
    _run_alias "cd '${repo}' && grba"
    [ "${status}" -eq 0 ]
    [ ! -d "${repo}/.git/rebase-merge" ]
}

@test "'grbc' continues a rebase after resolving conflicts" {
    local repo="${TEST_TEMP_DIR}/repo"
    _setup_git_repo "${repo}"
    git -C "${repo}" config core.editor true
    cd "${repo}"
    echo "base" > file.txt
    git add file.txt
    git commit -m "base"
    local default_branch
    default_branch="$(git rev-parse --abbrev-ref HEAD)"
    git checkout -b feature
    echo "feature" > file.txt
    git commit -am "feature change"
    git checkout "${default_branch}"
    echo "main" > file.txt
    git commit -am "main change"
    git checkout feature
    git rebase "${default_branch}" || true
    [ -d "${repo}/.git/rebase-merge" ]
    echo "resolved" > "${repo}/file.txt"
    git -C "${repo}" add file.txt
    _run_alias "cd '${repo}' && grbc"
    [ "${status}" -eq 0 ]
    [ ! -d "${repo}/.git/rebase-merge" ]
    run git -C "${repo}" log --oneline
    [[ "${output}" == *"feature change"* ]]
}

@test "'gre' unstages a staged file" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    git commit --allow-empty -m "init"
    echo "new content" > file.txt
    git add file.txt
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gre HEAD file.txt"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" status --short
    [[ "${output}" == *"??"* ]]
}

@test "'grem' lists remote repositories" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && grem"
    [ "${status}" -eq 0 ]
}

@test "'grm' removes a tracked file from the index" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    echo "content" > file.txt
    git add file.txt
    git commit -m "init"
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && grm file.txt"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" status --short
    [[ "${output}" == *"D  file.txt"* ]]
}

@test "'gs' shows the working-tree status in short format" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    echo "content" > untracked.txt
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gs"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"?? untracked.txt"* ]]
}

@test "'gt' creates an annotated tag" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    git commit --allow-empty -m "init"
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
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gtl"
    [[ "${output}" == *"v0.1.0"* ]]
    [[ "${output}" == *"v0.2.0"* ]]
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
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gzc"
    [ "${status}" -eq 0 ]
    run git -C "${TEST_TEMP_DIR}/repo" status --short
    [[ "${output}" == *"staged.txt"* ]]
    [ ! -f "${TEST_TEMP_DIR}/repo/unstaged.txt" ]
}

@test "'gzl' lists stash entries" {
    _setup_git_repo "${TEST_TEMP_DIR}/repo"
    cd "${TEST_TEMP_DIR}/repo"
    echo "original" > file.txt
    git add file.txt
    git commit -m "init"
    echo "modified" > file.txt
    git stash
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
    _run_alias "cd '${TEST_TEMP_DIR}/repo' && gzp"
    [ "${status}" -eq 0 ]
    [ "$(cat "${TEST_TEMP_DIR}/repo/file.txt")" = "modified" ]
    run git -C "${TEST_TEMP_DIR}/repo" stash list
    [ -z "${output}" ]
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
    _run_alias "ll '${TEST_TEMP_DIR}'"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *".hidden"* ]]
    [[ "${output}" == *"total"* ]]
}

@test "'la' lists hidden files" {
    touch "${TEST_TEMP_DIR}/.hidden"
    _run_alias "la '${TEST_TEMP_DIR}'"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *".hidden"* ]]
}

@test "'l' lists files" {
    touch "${TEST_TEMP_DIR}/visible.txt"
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
    local src="${TEST_TEMP_DIR}/src.txt"
    local dst="${TEST_TEMP_DIR}/dst.txt"
    echo "hello" > "${src}"
    _run_alias "mv '${src}' '${dst}'"
    [ ! -f "${src}" ]
    [ -f "${dst}" ]
    [ "$(cat "${dst}")" = "hello" ]
}


# ---------------------------------------------------------------------- #
# mvn
# ---------------------------------------------------------------------- #

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
# rm
# ---------------------------------------------------------------------- #

@test "'rm' removes a file after confirmation" {
    local file="${TEST_TEMP_DIR}/to_delete.txt"
    echo "content" > "${file}"
    _run_alias "yes | rm '${file}'"
    [ ! -f "${file}" ]
}


# ---------------------------------------------------------------------- #
# shred
# ---------------------------------------------------------------------- #

@test "'trash' securely deletes a file" {
    command -v shred >/dev/null 2>&1 || skip "shred is not available on this system"
    local file="${TEST_TEMP_DIR}/secret.txt"
    echo "sensitive data" > "${file}"
    _run_alias "trash '${file}'"
    [ ! -f "${file}" ]
}


# ---------------------------------------------------------------------- #
# uv
# ---------------------------------------------------------------------- #

@test "'uvp' runs a poe task via uv" {
    local fake_uv="${TEST_TEMP_DIR}/bin/uv"
    mkdir -p "${TEST_TEMP_DIR}/bin"
    cat > "${fake_uv}" <<'EOF'
#!/usr/bin/env bash
echo "uv $*"
EOF
    chmod +x "${fake_uv}"
    _run_alias "PATH='${TEST_TEMP_DIR}/bin:${PATH}' uvp my-task"
    [ "${status}" -eq 0 ]
    [[ "${output}" == *"uv run poe my-task"* ]]
}
