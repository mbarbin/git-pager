(*********************************************************************************)
(*  pageantty - Run a pager to display diffs and other outputs in the terminal   *)
(*  SPDX-FileCopyrightText: 2024-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

module Option = struct
  include Option

  let iter t ~f = Option.iter f t
end

module Out_channel = struct
  include Out_channel

  let output_line oc line =
    Out_channel.output_string oc line;
    Out_channel.output_char oc '\n'
  ;;
end

module String = struct
  include StringLabels

  let to_string t = t
end
