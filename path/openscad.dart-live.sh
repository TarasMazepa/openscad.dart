#!/usr/bin/env bash

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

set -x
dart run "$SCRIPT_DIR/../cli/bin/openscad.dart" "$@"
set +x
