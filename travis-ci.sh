#!/bin/bash

set -e -x -o pipefail

# test for successful release build
dub build -b release --compiler=$DC -c $CONFIG

# test for successful 32-bit build
if [ "$DC" == "dmd" ]; then
	dub build --arch=x86 -c $CONFIG
fi

dub test --compiler=$DC -c $CONFIG

if [ ${BUILD_EXAMPLE=1} -eq 1 ]; then
    for ex in $(\ls -1 examples/); do
        echo "[INFO] Building example $ex"
        # --override-config vibe-core/$CONFIG
        (cd examples/$ex && dub build --compiler=$DC && dub clean)
    done
fi
if [ ${RUN_TEST=1} -eq 1 ]; then
    for ex in `\ls -1 tests/*.d`; do
        echo "[INFO] Running test $ex"
        dub --temp-build --compiler=$DC --single $ex # --override-config vibe-core/$CONFIG
    done
fi
