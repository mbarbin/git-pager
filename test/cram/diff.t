First we need to setup a repo in a way that satisfies the test environment. This
includes specifics required by the GitHub Actions environment.

  $ ocaml-vcs init -q .
  $ ocaml-vcs set-user-config --user.name "Test User" --user.email "test@example.com"

Let's add some files to the tree.

  $ cat > hello << EOF
  > Hello World!
  > EOF

  $ ocaml-vcs add hello
  $ rev0=$(ocaml-vcs commit -m "Initial commit")

  $ cat > hello << EOF
  > Hello World!
  > Nice to see you.
  > EOF

  $ ocaml-vcs add hello
  $ rev1=$(ocaml-vcs commit -m "Greetings")

The library works when stdout it piped to another process.

  $ git-pager diff --base=${rev0} --tip=${rev1} | cat -v
  diff --git a/hello b/hello
  index 980a0d5..845ae1b 100644
  --- a/hello
  +++ b/hello
  @@ -1 +1,2 @@
   Hello World!
  +Nice to see you.

In the cram test, the output is not a tty, so the pager is disabled.

  $ git-pager diff --base=${rev0} --tip=${rev1}
  diff --git a/hello b/hello
  index 980a0d5..845ae1b 100644
  --- a/hello
  +++ b/hello
  @@ -1 +1,2 @@
   Hello World!
  +Nice to see you.

However we can fake it.

  $ git-pager diff --base=${rev0} --tip=${rev1} --force-stdout-isatty
  diff --git a/hello b/hello
  index 980a0d5..845ae1b 100644
  --- a/hello
  +++ b/hello
  @@ -1 +1,2 @@
   Hello World!
  +Nice to see you.

But, there's something in the way the test are run that makes the ansi char
invisible! To actually see them, we'll use `cat -v`.

  $ git-pager diff --base=${rev0} --tip=${rev1} --force-stdout-isatty | cat -v
  ^[[1mdiff --git a/hello b/hello^[[m
  ^[[1mindex 980a0d5..845ae1b 100644^[[m
  ^[[1m--- a/hello^[[m
  ^[[1m+++ b/hello^[[m
  ^[[36m@@ -1 +1,2 @@^[[m
   Hello World!^[[m
  ^[[32m+^[[m^[[32mNice to see you.^[[m

Note however that we have to supply `--force-stdout-isatty` otherwise, the fact
that the process is redirected will make it disable the pager, and thus the
colors!

The local [color.ui] is meant to be used by git command writing to the pager,
unless their color mode is overridden from the command line, in which case the
command line setting takes precedence.

  $ git config --local color.ui always

  $ git-pager diff --base=${rev0} --tip=${rev1} | cat -v
  ^[[1mdiff --git a/hello b/hello^[[m
  ^[[1mindex 980a0d5..845ae1b 100644^[[m
  ^[[1m--- a/hello^[[m
  ^[[1m+++ b/hello^[[m
  ^[[36m@@ -1 +1,2 @@^[[m
   Hello World!^[[m
  ^[[32m+^[[m^[[32mNice to see you.^[[m

  $ git-pager diff --base=${rev0} --tip=${rev1} --color=never | cat -v
  diff --git a/hello b/hello
  index 980a0d5..845ae1b 100644
  --- a/hello
  +++ b/hello
  @@ -1 +1,2 @@
   Hello World!
  +Nice to see you.

  $ git-pager diff --base=${rev0} --tip=${rev1} --color=auto | cat -v
  ^[[1mdiff --git a/hello b/hello^[[m
  ^[[1mindex 980a0d5..845ae1b 100644^[[m
  ^[[1m--- a/hello^[[m
  ^[[1m+++ b/hello^[[m
  ^[[36m@@ -1 +1,2 @@^[[m
   Hello World!^[[m
  ^[[32m+^[[m^[[32mNice to see you.^[[m

  $ git config --local color.ui never

  $ git-pager diff --base=${rev0} --tip=${rev1} | cat -v
  diff --git a/hello b/hello
  index 980a0d5..845ae1b 100644
  --- a/hello
  +++ b/hello
  @@ -1 +1,2 @@
   Hello World!
  +Nice to see you.

  $ git-pager diff --base=${rev0} --tip=${rev1} --color=always | cat -v
  ^[[1mdiff --git a/hello b/hello^[[m
  ^[[1mindex 980a0d5..845ae1b 100644^[[m
  ^[[1m--- a/hello^[[m
  ^[[1m+++ b/hello^[[m
  ^[[36m@@ -1 +1,2 @@^[[m
   Hello World!^[[m
  ^[[32m+^[[m^[[32mNice to see you.^[[m

By the way, here we check that we can use a custom pager to print diffs too.

  $ export GIT_PAGER='git-pager pager'

  $ git-pager diff --base=${rev0} --tip=${rev1} --force-stdout-isatty
  Hello from the test pager!
  diff --git a/hello b/hello
  index 980a0d5..845ae1b 100644
  --- a/hello
  +++ b/hello
  @@ -1 +1,2 @@
   Hello World!
  +Nice to see you.

In the [diff] command we've illustrated how to avoid crashing on SIGPIPE when
attempting to write a pager that has already closed.

  $ export GIT_PAGER='git-pager pager --quit-after-n-lines=10'

  $ git-pager diff --base=${rev0} --tip=${rev1} --force-stdout-isatty --loop
  Hello from the test pager!
  diff --git a/hello b/hello
  index 980a0d5..845ae1b 100644
  --- a/hello
  +++ b/hello
  @@ -1 +1,2 @@
   Hello World!
  +Nice to see you.
  diff --git a/hello b/hello
  index 980a0d5..845ae1b 100644
  --- a/hello

Let's monitor the behavior when the git process exit with non zero.

  $ export GIT_PAGER=cat

  $ git-pager diff --base=${rev0} --tip=${rev1} --force-stdout-isatty --exit-code
  diff --git a/hello b/hello
  index 980a0d5..845ae1b 100644
  --- a/hello
  +++ b/hello
  @@ -1 +1,2 @@
   Hello World!
  +Nice to see you.
  Error: Running process [git diff] failed.
  (Failure "Exited 1")
  [123]
