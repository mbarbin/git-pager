# git-pager

[![CI Status](https://github.com/mbarbin/git-pager/workflows/ci/badge.svg)](https://github.com/mbarbin/git-pager/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/mbarbin/git-pager/badge.svg?branch=main)](https://coveralls.io/github/mbarbin/git-pager?branch=main)

Welcome to **git-pager**, a small one-module OCaml library for running a Git pager to display diffs and other custom outputs in the terminal.

It is particularly useful for tools that integrate with Git and need to display output exceeding one screen, while respecting user color preferences and Git's configuration.

## Hello Pager

```ocaml
let () =
  Git_pager.run ~f:(fun pager ->
    let write_end = Git_pager.write_end pager in
    Printf.fprintf write_end "Hello, pager!\n")
;;
```

## Published named

To publish this project to opam we're using a packaging naming scheme where `pageantty` is a namespacing prefix.

`pageantty` (pronounced: "pageant-T-Y", like "pageant" + the letters "T" and "Y", IPA: /ˈpædʒənt ti waɪ/).

The current `Git_pager` module is available as the main library of the `pageantty.git-pager` sub-package.
