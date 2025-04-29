(*********************************************************************************)
(*  Git_pager - Run a Git pager to display diffs and other custom outputs        *)
(*  SPDX-FileCopyrightText: 2024-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let main =
  Command.make
    ~summary:"Run a pager and print its settings to stdout"
    (let open Command.Std in
     let+ () = Log_cli.set_config ()
     and+ () = Common_helpers.force_stdout_isatty_test in
     Git_pager.run ~f:(fun git_pager ->
       let write_end = Git_pager.write_end git_pager in
       let git_color_mode = Git_pager.git_color_mode git_pager in
       let should_enable_color = Git_pager.should_enable_color git_pager in
       let output_kind = Git_pager.output_kind git_pager in
       Out_channel.output_line
         write_end
         (Sexp.to_string_hum
            [%sexp
              { git_color_mode : [ `Auto | `Always | `Never ]
              ; should_enable_color : bool
              ; output_kind : [ `Tty | `Pager | `Other ]
              }])))
;;
