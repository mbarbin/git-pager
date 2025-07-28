(*********************************************************************************)
(*  pageantty - Run a pager to display diffs and other outputs in the terminal   *)
(*  SPDX-FileCopyrightText: 2024-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let main =
  Command.make
    ~summary:"Simulate a pager that quits after reading some number of lines."
    (let open Command.Std in
     let+ quit_after_n_lines =
       Arg.named_opt
         [ "quit-after-n-lines" ]
         Param.int
         ~docv:"N"
         ~doc:
           "To be able to simulate what happens with a pager that quits after having \
            read some number of lines, this argument can be set to a positive integer. \
            The process will then exit after having read N lines."
     and+ exit_code =
       Arg.named_with_default
         [ "exit-code" ]
         Param.int
         ~doc:
           "Specify an exit code for the process. This is to simulate failures of the \
            pager."
         ~default:0
     in
     (* We output a welcome line as a clue that this pager is indeed running. *)
     print_endline "Hello from the test pager!";
     With_return.with_return (fun { return } ->
       let index = ref 0 in
       while true do
         Int.incr index;
         (match In_channel.input_line In_channel.stdin with
          | None ->
            (* This line is covered but off due to unvisitable out-edge point. *)
            return () [@coverage off]
          | Some line -> Out_channel.output_line Out_channel.stdout line);
         Option.iter quit_after_n_lines ~f:(fun max -> if !index >= max then return ())
       done);
     Err.exit exit_code)
;;
