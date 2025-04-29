(*********************************************************************************)
(*  Git_pager - Run a Git pager to display diffs and other custom outputs        *)
(*  SPDX-FileCopyrightText: 2024-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let force_stdout_isatty_test =
  let open Command.Std in
  let+ value = Arg.flag [ "force-stdout-isatty" ] ~doc:"Behave as if stdout was a tty" in
  if value then Git_pager.Private.force_stdout_isatty_test := true
;;
