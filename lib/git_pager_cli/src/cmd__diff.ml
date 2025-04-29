(*********************************************************************************)
(*  Git_pager - Run a Git pager to display diffs and other custom outputs        *)
(*  SPDX-FileCopyrightText: 2024-2025 Mathieu Barbin <mathieu.barbin@gmail.com>  *)
(*  SPDX-License-Identifier: MIT                                                 *)
(*********************************************************************************)

let git_diff ~repo_root ~(git_pager : Git_pager.t) ~base ~tip ?(paths = []) () =
  let process =
    Shexp_process.call_exit_status
      (List.concat
         [ [ "git"; "diff" ]
         ; (match Git_pager.git_color_mode git_pager with
            | `Auto -> []
            | `Always -> [ "--color=always" ]
            | `Never -> [ "--color=never" ])
         ; [ Printf.sprintf "%s..%s" (Vcs.Rev.to_string base) (Vcs.Rev.to_string tip) ]
         ; (match paths with
            | [] -> []
            | _ :: _ -> "--" :: List.map ~f:Vcs.Path_in_repo.to_string paths)
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
      if i <> Stdlib.Sys.sigpipe then failwith (Printf.sprintf "Signaled %d" i) else `Quit
  with
  | exn ->
    Err.raise
      Pp.O.
        [ Pp.text "Running process "
          ++ Pp_tty.kwd (module String) "git diff"
          ++ Pp.text " failed."
        ; Pp.text (Exn.to_string exn)
        ]
;;

let main =
  let open Command.Std in
  let rev name =
    Arg.named
      [ name ]
      (Param.validated_string (module Vcs.Rev))
      ~docv:"REV"
      ~doc:(Printf.sprintf "The %s revision for the diff" name)
  in
  Command.make
    ~summary:"Send the output of git diff to the git pager"
    (let+ () = Log_cli.set_config ()
     and+ base = rev "base"
     and+ tip = rev "tip" in
     let cwd = Unix.getcwd () |> Absolute_path.v in
     let vcs = Vcs_git_blocking.create () in
     let repo_root =
       match Vcs.find_enclosing_git_repo_root vcs ~from:cwd with
       | Some repo_root -> repo_root
       | None ->
         Err.raise
           [ Pp.text "This command requires to be run from within a Git repository." ]
     in
     Git_pager.run ~f:(fun git_pager ->
       With_return.with_return (fun { return } ->
         while true do
           Unix.sleepf 0.5;
           match git_diff ~repo_root ~git_pager ~base ~tip () with
           | `Ok -> ()
           | `Quit -> return ()
         done)))
;;
