version     = "0.8.4"
author      = "Luke Parker"
description = "A Nim Wrapper for the Minisketch library."
license     = "MIT"

installFiles = @[
    ".gitmodules",
    "LICENSE.md",
    "README.md",
    "mc_minisketch.nim"
]

installDirs = @[
    ".git"
]

requires "nim >= 0.20.2"
