(*_********************************************************************************)
(*_  pageantty - Run a pager to display diffs and other outputs in the terminal   *)
(*_  SPDX-FileCopyrightText: 2024-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*_  SPDX-License-Identifier: MIT                                                 *)
(*_********************************************************************************)

module Option : sig
  include module type of struct
    include Option
  end

  val iter : 'a t -> f:('a -> unit) -> unit
end

module Out_channel : sig
  include module type of struct
    include Out_channel
  end

  val output_line : t -> string -> unit
end

module String : sig
  include module type of struct
    include StringLabels
  end

  val to_string : t -> t
end
