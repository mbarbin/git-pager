(*********************************************************************************)
(*  Git_pager - Run a Git pager to display diffs and other custom outputs        *)
(*  SPDX-FileCopyrightText: 2024-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let () =
  Cmdlang_cmdliner_runner.run Git_pager_cli.main ~name:"git-pager" ~version:"%%VERSION%%"
;;
