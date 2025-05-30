(*********************************************************************************)
(*  pageantty - Run a pager to display diffs and other outputs in the terminal   *)
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
