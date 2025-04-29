(*********************************************************************************)
(*  Git_pager - Run a Git pager to display diffs and other custom outputs        *)
(*  SPDX-FileCopyrightText: 2024-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let () =
  Git_pager.run ~f:(fun pager ->
    let write_end = Git_pager.write_end pager in
    Printf.fprintf write_end "Hello, pager!\n")
;;
