(*********************************************************************************)
(*  pageantty - Run a pager to display diffs and other outputs in the terminal   *)
(*  SPDX-FileCopyrightText: 2024-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

open! Import

module Settings = struct
  type t =
    { git_color_mode : [ `Auto | `Always | `Never ]
    ; should_enable_color : bool
    ; output_kind : [ `Tty | `Pager | `Other ]
    }

  let to_dyn { git_color_mode; should_enable_color; output_kind } =
    Dyn.record
      [ ( "git_color_mode"
        , match git_color_mode with
          | `Auto -> Dyn.Variant ("Auto", [])
          | `Always -> Dyn.Variant ("Always", [])
          | `Never -> Dyn.Variant ("Never", []) )
      ; "should_enable_color", Dyn.bool should_enable_color
      ; ( "output_kind"
        , match output_kind with
          | `Tty -> Dyn.Variant ("Tty", [])
          | `Pager -> Dyn.Variant ("Pager", [])
          | `Other -> Dyn.Variant ("Other", []) )
      ]
  ;;
end

let main =
  Command.make
    ~summary:"Run a pager and print its settings to stdout."
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
         (Dyn.to_string
            (Settings.to_dyn { git_color_mode; should_enable_color; output_kind }))))
;;
