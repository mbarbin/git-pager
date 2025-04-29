(*********************************************************************************)
(*  Git_pager - Run a Git pager to display diffs and other custom outputs        *)
(*  SPDX-FileCopyrightText: 2024-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let main =
  Command.make
    ~summary:"Send an incrementing counter to the git pager"
    (let open Command.Std in
     let+ () = Log_cli.set_config ()
     and+ () = Common_helpers.force_stdout_isatty_test
     and+ raise_after_n_steps =
       Arg.named_opt
         [ "raise-after-n-steps" ]
         Param.int
         ~docv:"N"
         ~doc:
           "To simulate a failure in the writer side of the pager, use this flag to \
            raise an exception after N steps."
     and+ sleep =
       Arg.named_with_default
         [ "sleep" ]
         Param.float
         ~docv:"VAL"
         ~doc:"Set a delay for the sleep happening between prints."
         ~default:0.01
     and+ steps =
       Arg.named_with_default
         [ "steps" ]
         Param.int
         ~default:5
         ~docv:"N"
         ~doc:
           "The number of incremental steps the counter should be sent to the pager. \
            This argument is meant to test what happens when a pager is closed, with \
            pending writers that are not done writing to it."
     and+ loop = Arg.flag [ "loop" ] ~doc:"Supersedes --steps and loop forever" in
     Git_pager.run ~f:(fun git_pager ->
       let write_end = Git_pager.write_end git_pager in
       With_return.with_return (fun { return } ->
         let index = ref 0 in
         while true do
           Unix.sleepf sleep;
           Int.incr index;
           Out_channel.output_line write_end (Int.to_string_hum !index);
           Out_channel.flush write_end;
           let index = !index in
           Option.iter raise_after_n_steps ~f:(fun n ->
             if index >= n then failwith (Printf.sprintf "Raised after %d steps!" index));
           if (not loop) && index >= steps
           then
             return () [@coverage off]
             (* coverage off is due to undesirable out-edge detection. *);
           ()
         done;
         ())))
;;
