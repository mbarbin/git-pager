In a cram test like this one, the default settings are as follows:

  $ git-pager run 2>&1 | grep -v fatal
  Error: Failed to get the value of [GIT_PAGER].
  [Exited 128]

This is due to the way that there is no git repository in the context by which
the test is run.

It is possible to get around this by disabling the pager via the GIT_PAGER
variable.

  $ GIT_PAGER=cat git-pager run
  1
  2
  3
  4
  5

Let's now initiate a Git repo.

  $ ocaml-vcs init -q .
  $ ocaml-vcs set-user-config --user.name "Test User" --user.email "test@example.com"

Let's try again:

  $ git-pager run
  1
  2
  3
  4
  5

  $ git-pager run --force-stdout-isatty
  1
  2
  3
  4
  5

OK. Now we are now going to use a custom pager.

  $ export GIT_PAGER='git-pager pager'

  $ git-pager run --force-stdout-isatty
  Hello from the test pager!
  1
  2
  3
  4
  5

If the writer raises, this results in an internal error. The pager is closed
properly.

  $ git-pager run --force-stdout-isatty --raise-after-n-steps=2 2>&1 | head -n 4
  Hello from the test pager!
  1
  2
  Internal Error: Failure("Raised after 2 steps!")

Here we simulate a pager that exits with a non zero code.

  $ export GIT_PAGER='git-pager pager --exit-code=42'

  $ git-pager run --force-stdout-isatty
  Hello from the test pager!
  1
  2
  3
  4
  5
  Error: Call to [GIT_PAGER] failed.
  Writer Status: Ok.
  Pager Exit Status: [Exited 42].
  [123]

  $ git-pager run --force-stdout-isatty --raise-after-n-steps=2
  Hello from the test pager!
  1
  2
  Error: Call to [GIT_PAGER] failed.
  Writer Status: Raised [Failure("Raised after 2 steps!")].
  Pager Exit Status: [Exited 42].
  [123]

Now we simulate exit condition of the pager, while the writer hasn't finished
writing its output.

Exit code 141 typically corresponds to the signal SIGPIPE (signal number 13) on
Unix-like systems. This signal is sent to a process when it attempts to write to
a pipe or socket that has been closed on the other end.

  $ export GIT_PAGER='git-pager pager --quit-after-n-lines=3 --exit-code=42'

  $ git-pager run --force-stdout-isatty
  Hello from the test pager!
  1
  2
  3
  [141]

  $ git-pager run --force-stdout-isatty --loop
  Hello from the test pager!
  1
  2
  3
  [141]

  $ export GIT_PAGER='git-pager pager --quit-after-n-lines=3 --exit-code=0'

  $ git-pager run --force-stdout-isatty
  Hello from the test pager!
  1
  2
  3
  [141]

  $ git-pager run --force-stdout-isatty --loop
  Hello from the test pager!
  1
  2
  3
  [141]
