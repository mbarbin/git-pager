let main =
  Command.make
    ~summary:"Send an incrementing counter to the git pager"
    (let open Command.Std in
     let+ sleep =
       Arg.named_with_default
         [ "sleep" ]
         Param.float
         ~docv:"VAL"
         ~doc:"Set a delay for the sleep happening between prints."
         ~default:0.05
     in
     Git_pager.run ~f:(fun git_pager ->
       let write_end = Git_pager.write_end git_pager in
       With_return.with_return (fun { return = _ } ->
         let index = ref 0 in
         while true do
           Unix.sleepf sleep;
           Int.incr index;
           Out_channel.output_line write_end (Int.to_string_hum !index);
           Out_channel.flush write_end
         done;
         ())))
;;
