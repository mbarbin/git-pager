let () =
  Git_pager.run ~f:(fun pager ->
    let write_end = Git_pager.write_end pager in
    Printf.fprintf write_end "Hello, pager!\n")
;;
