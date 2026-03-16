#!/usr/bin/env bash
set -euo pipefail

# Upload/copy the latest AGRP files from /mnt/data into a local AGRP git repo,
# commit them, and optionally push to GitHub.
#
# Usage:
#   chmod +x upload_agrp_files.sh
#   ./upload_agrp_files.sh /path/to/agrp-repo
#
# Optional env vars:
#   TARGET_BRANCH=main
#   COMMIT_MESSAGE="Add AGRP RFC v0.3 package"
#   PUSH=1
#   REMOTE_NAME=origin

REPO_PATH="${1:-}"
TARGET_BRANCH="${TARGET_BRANCH:-main}"
REMOTE_NAME="${REMOTE_NAME:-origin}"
PUSH="${PUSH:-0}"
COMMIT_MESSAGE="${COMMIT_MESSAGE:-Add AGRP RFC v0.3 package (spec, strict core schema, conformance schema, examples)}"

if [[ -z "$REPO_PATH" ]]; then
  echo "Usage: $0 /absolute/or/relative/path/to/agrp-repo"
  exit 1
fi

if [[ ! -d "$REPO_PATH/.git" ]]; then
  echo "Error: '$REPO_PATH' is not a git repository."
  exit 1
fi

# Source files generated in this workspace
SRC_SPEC="/mnt/data/AGRP-RFC-v0.3.md"
SRC_SCHEMA_CORE="/mnt/data/agrp-core.strict.v0.3.schema.json"
SRC_SCHEMA_CONF="/mnt/data/agrp-deployment-conformance.v0.3.json"
SRC_EXAMPLES="/mnt/data/agrp-code-examples.json"

for f in "$SRC_SPEC" "$SRC_SCHEMA_CORE" "$SRC_SCHEMA_CONF" "$SRC_EXAMPLES"; do
  if [[ ! -f "$f" ]]; then
    echo "Error: expected file not found: $f"
    exit 1
  fi
done

cd "$REPO_PATH"

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$CURRENT_BRANCH" != "$TARGET_BRANCH" ]]; then
  echo "Switching from branch '$CURRENT_BRANCH' to '$TARGET_BRANCH'..."
  git checkout "$TARGET_BRANCH"
fi

mkdir -p docs/rfc schemas/core schemas/conformance examples

install -m 0644 "$SRC_SPEC" docs/rfc/AGRP-RFC-v0.3.md
install -m 0644 "$SRC_SCHEMA_CORE" schemas/core/agrp-core.strict.v0.3.schema.json
install -m 0644 "$SRC_SCHEMA_CONF" schemas/conformance/agrp-deployment-conformance.v0.3.json
install -m 0644 "$SRC_EXAMPLES" examples/agrp-code-examples.json

# Optional convenience aliases / latest pointers
cp docs/rfc/AGRP-RFC-v0.3.md docs/rfc/AGRP-RFC-latest.md
cp schemas/core/agrp-core.strict.v0.3.schema.json schemas/core/agrp-core.strict.latest.schema.json
cp schemas/conformance/agrp-deployment-conformance.v0.3.json schemas/conformance/agrp-deployment-conformance.latest.json

# Generate a simple manifest for traceability
cat > docs/rfc/manifest.v0.3.txt <<MANIFEST
AGRP RFC package v0.3

Files:
- docs/rfc/AGRP-RFC-v0.3.md
- docs/rfc/AGRP-RFC-latest.md
- docs/rfc/manifest.v0.3.txt
- schemas/core/agrp-core.strict.v0.3.schema.json
- schemas/core/agrp-core.strict.latest.schema.json
- schemas/conformance/agrp-deployment-conformance.v0.3.json
- schemas/conformance/agrp-deployment-conformance.latest.json
- examples/agrp-code-examples.json
MANIFEST

# Stage only the intended files
git add \
  docs/rfc/AGRP-RFC-v0.3.md \
  docs/rfc/AGRP-RFC-latest.md \
  docs/rfc/manifest.v0.3.txt \
  schemas/core/agrp-core.strict.v0.3.schema.json \
  schemas/core/agrp-core.strict.latest.schema.json \
  schemas/conformance/agrp-deployment-conformance.v0.3.json \
  schemas/conformance/agrp-deployment-conformance.latest.json \
  examples/agrp-code-examples.json

if git diff --cached --quiet; then
  echo "No changes staged. Repository already matches these files."
  exit 0
fi

git commit -m "$COMMIT_MESSAGE"

echo
echo "Committed successfully on branch '$TARGET_BRANCH'."

git --no-pager log -1 --stat

if [[ "$PUSH" == "1" ]]; then
  echo
  echo "Pushing to $REMOTE_NAME/$TARGET_BRANCH ..."
  git push "$REMOTE_NAME" "$TARGET_BRANCH"
  echo "Push complete."
else
  echo
  echo "Push skipped. To push now, run:"
  echo "  PUSH=1 $0 '$REPO_PATH'"
fi
