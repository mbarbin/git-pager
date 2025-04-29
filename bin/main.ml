let () =
  Cmdlang_cmdliner_runner.run Git_pager_cli.main ~name:"git-pager" ~version:"%%VERSION%%"
;;
