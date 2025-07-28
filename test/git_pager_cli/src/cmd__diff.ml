(*********************************************************************************)
(*  pageantty - Run a pager to display diffs and other outputs in the terminal   *)
(*  SPDX-FileCopyrightText: 2024-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let git_diff ~repo_root ~(git_pager : Git_pager.t) ~base ~tip ~exit_code =
  let process =
    Shexp_process.call_exit_status
      (List.concat
         [ [ "git"; "diff" ]
         ; (if exit_code then [ "--exit-code" ] else [])
         ; (match Git_pager.git_color_mode git_pager with
            | `Auto -> []
            | `Always -> [ "--color=always" ]
            | `Never -> [ "--color=never" ])
         ; [ Printf.sprintf "%s..%s" base tip ]
         ])
  in
  try
    let context =
      Shexp_process.Context.create
        ~stdout:(Git_pager.write_end git_pager |> Unix.descr_of_out_channel)
        ~cwd:(Path (Vcs.Repo_root.to_string repo_root))
        ()
    in
    let result = Shexp_process.eval ~context process in
    Shexp_process.Context.dispose context;
    match result with
    | Exited i -> if i <> 0 then failwith (Printf.sprintf "Exited %d" i) else `Ok
    | Signaled i ->
      if i <> Stdlib.Sys.sigpipe
      then failwith (Printf.sprintf "Signaled %d" i) [@coverage off]
      else `Quit
  with
  | exn ->
    Err.raise
      Pp.O.
        [ Pp.text "Running process "
          ++ Pp_tty.kwd (module String) "git diff"
          ++ Pp.text " failed."
        ; Err.exn exn
        ]
;;

let main =
  let open Command.Std in
  let rev name =
    Arg.named
      [ name ]
      Param.string
      ~docv:"REV"
      ~doc:(Printf.sprintf "The %s revision for the diff." name)
  in
  Command.make
    ~summary:"Send the output of git diff to the git pager."
    (let+ () = Log_cli.set_config ()
     and+ () = Common_helpers.force_stdout_isatty_test
     and+ exit_code =
       Arg.flag [ "exit-code" ] ~doc:"Supply the flag $(b,--exit-code) to git diff."
     and+ base = rev "base"
     and+ tip = rev "tip"
     and+ loop =
       Arg.flag [ "loop" ] ~doc:"Loop and keep on writing the diff to the pager."
     in
     let cwd = Unix.getcwd () |> Absolute_path.v in
     let vcs = Volgo_git_unix.create () in
     let repo_root =
       match Vcs.find_enclosing_git_repo_root vcs ~from:cwd with
       | Some repo_root -> repo_root
       | None ->
         Err.raise
           [ Pp.text "This command requires to be run from within a Git repository." ]
         [@coverage off]
     in
     Git_pager.run ~f:(fun git_pager ->
       With_return.with_return (fun { return } ->
         while true do
           (match git_diff ~repo_root ~git_pager ~base ~tip ~exit_code with
            | `Ok -> ()
            | `Quit ->
              (* This line is covered but off due to unvisitable out-edge point. *)
              return () [@coverage off]);
           if loop
           then Unix.sleepf 0.5
           else
             (* This line is covered but off due to unvisitable out-edge point. *)
             return () [@coverage off]
         done)))
;;
