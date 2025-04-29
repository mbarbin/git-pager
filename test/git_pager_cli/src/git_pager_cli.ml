(*********************************************************************************)
(*  Git_pager - Run a Git pager to display diffs and other custom outputs        *)
(*  SPDX-FileCopyrightText: 2024-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let main =
  Command.group
    ~summary:"git-pager"
    [ "diff", Cmd__diff.main
    ; "pager", Cmd__pager.main
    ; "print-settings", Cmd__print_settings.main
    ; "run", Cmd__run.main
    ]
;;
