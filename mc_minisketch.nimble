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
    let gitExe: string = system.findExe("git")
    if gitExe == "":
        echo "Failed to find executable `git`."
        quit(1)

    let makeExe: string = system.findExe("make")
    if makeExe == "":
        echo "Failed to find executable `make`."
        quit(1)

    withDir projectDir():
        exec gitExe & " submodule update --init --recursive"

    withDir projectDir() / "minisketch":
        exec "./autogen.sh"
        exec "./configure"
        exec makeExe