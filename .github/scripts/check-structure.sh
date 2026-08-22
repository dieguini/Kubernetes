#!/usr/bin/env bash
# Guards the layout convention documented in README.md:
#
#   - top-level folders are numbered sections, read in order
#   - any numbered folder is NN_snake_case
#   - two sibling folders never share the same number
#   - no path needs shell escaping (this repo used to have a `&` in a folder name)
set -uo pipefail

cd "$(git rev-parse --show-toplevel)" || exit 1

fail=0
err() {
    # ::error:: makes it show up as an annotation in the Actions UI.
    printf '::error::%s\n' "$*"
    fail=1
}

# All directories that contain tracked files, one per line.
dirs=$(git ls-files | awk -F/ '{
    path = ""
    for (i = 1; i < NF; i++) {
        path = path $i
        print path
        path = path "/"
    }
}' | sort -u)

# 1. Characters a shell would need escaping for: spaces, &, quotes...
while IFS= read -r path; do
    [ -n "$path" ] && err "path needs shell escaping: $path"
done < <(git ls-files | grep -vE '^[A-Za-z0-9._/-]+$')

# 2. Top-level folders are numbered sections.
while IFS= read -r dir; do
    [ -n "$dir" ] || continue
    [[ $dir =~ ^[0-9]{2}_[a-z0-9_]+$ ]] || err "top-level folder is not NN_snake_case: $dir/"
done < <(printf '%s\n' "$dirs" | grep -v '/' | grep -v '^\.')

# 3. A folder that starts with a number follows the same shape everywhere.
while IFS= read -r dir; do
    [ -n "$dir" ] || continue
    base=${dir##*/}
    case $base in
        [0-9]*)
            [[ $base =~ ^[0-9]{2}_[a-z0-9_]+$ ]] || err "numbered folder is not NN_snake_case: $dir/"
            ;;
    esac
done < <(printf '%s\n' "$dirs")

# 4. Two sibling folders must not claim the same number.
while IFS= read -r clash; do
    [ -n "$clash" ] && err "two folders share the same number: $clash"
done < <(printf '%s\n' "$dirs" | awk -F/ '
    {
        base = $NF
        if (base !~ /^[0-9][0-9]_/) next
        parent = ""
        for (i = 1; i < NF; i++) parent = parent $i "/"
        key = parent substr(base, 1, 2)
        count[key]++
        seen[key] = seen[key] " " $0
    }
    END { for (k in count) if (count[k] > 1) print seen[k] }')

if [ "$fail" -eq 0 ]; then
    echo "Layout OK: $(printf '%s\n' "$dirs" | wc -l) folders checked."
fi
exit "$fail"
