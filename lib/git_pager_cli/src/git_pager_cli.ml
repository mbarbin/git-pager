let main =
  Command.group ~summary:"git-pager" [ "diff", Cmd__diff.main; "run", Cmd__run.main ]
;;
