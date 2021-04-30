import os

version     = "0.8.5"
author      = "Luke Parker"
description = "A Nim Wrapper for the Minisketch library."
license     = "MIT"

installFiles = @[
    "mc_minisketch.nim"
]

installDirs = @[
    "minisketch"
]

requires "nim >= 0.20.2"

before install:
    let makeExe: string = system.findExe("make")
    if makeExe == "":
        echo "Failed to find executable `make`."
        quit(1)

    withDir thisDir() / "minisketch":
        exec "./autogen.sh"
        exec "./configure"
        exec makeExe
