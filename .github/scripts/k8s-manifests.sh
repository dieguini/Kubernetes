#!/usr/bin/env bash
# Prints the tracked YAML files that are actual Kubernetes API objects.
#
# The repo also holds YAML that is *not* a Kubernetes manifest: k3d cluster configs
# (k3d.io/*), the eksctl config (eksctl.io/*) and Helm values files. kubeconform has no
# schema for those, so validating them would only produce false positives.
set -euo pipefail

cd "$(git rev-parse --show-toplevel)" || exit 1

git ls-files -z '*.yaml' '*.yml' | while IFS= read -r -d '' file; do
    case "$file" in
        .github/* | .yamllint.yml) continue ;;
    esac

    # No `kind:` means it is not an API object at all (Helm values, plain config).
    grep -qE '^kind:' "$file" || continue

    api_version=$(grep -m1 -E '^apiVersion:' "$file" | awk '{print $2}' | tr -d '\r')
    case "$api_version" in
        k3d.io/* | eksctl.io/*) continue ;;
    esac

    printf '%s\n' "$file"
done
