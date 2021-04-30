import os

version     = "1.0.0"
author      = "Luke Parker"
description = "A Nim Wrapper for the Minisketch library."
license     = "MIT"

installFiles = @[
  "mc_minisketch.nim"
]

installDirs = @[
  "minisketch"
]

requires "nim >= 1.2.0"

before install:
  let makeExe: string = system.findExe("make")
  if makeExe == "":
    echo "Failed to find executable `make`."
    quit(1)

  withDir thisDir() / "minisketch":
    exec "./autogen.sh"
    exec "./configure"
    exec makeExe
