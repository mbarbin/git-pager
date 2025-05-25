In a cram test like this one, the default settings are as follows:

  $ git-pager print-settings 2>&1 | grep -v fatal
  Error: Failed to get the value of [GIT_PAGER].
  [Exited 128]

This is due to the way that there is no git repository in the context by which
the test is run.

It is possible to get around this by disabling the pager via the GIT_PAGER
variable.

  $ GIT_PAGER=cat git-pager print-settings
  ((git_color_mode Auto) (should_enable_color false) (output_kind Other))

Let's now initiate a Git repo.

  $ volgo-vcs init -q .
  $ volgo-vcs set-user-config --user.name "Test User" --user.email "test@example.com"

Let's try again:

  $ git-pager print-settings
  ((git_color_mode Auto) (should_enable_color false) (output_kind Other))

So, as we see here, [output_kind=Other]. This means that in the context of a
cram test, stdout is not a tty. Having access to a tty is a precondition for
using an actual pager, so the extend of the tests that we can run automatically
here would be limited without a workaround.

So, to allow exercising more of the code, we added a flag that makes the library
behaves as if stdout was a tty.

  $ git-pager print-settings --force-stdout-isatty
  ((git_color_mode Always) (should_enable_color true) (output_kind Pager))

We monitor here the impact of the color mode on the settings:

  $ git-pager print-settings --color=never
  ((git_color_mode Never) (should_enable_color false) (output_kind Other))

  $ git-pager print-settings --color=never --force-stdout-isatty
  ((git_color_mode Never) (should_enable_color false) (output_kind Pager))

  $ git-pager print-settings --color=auto
  ((git_color_mode Auto) (should_enable_color false) (output_kind Other))

The case below is an interesting case covered by the library. When the output is
a tty and the color mode is auto, the library forces [Always] so git commands
are correctly colored.

  $ git-pager print-settings --color=auto --force-stdout-isatty
  ((git_color_mode Always) (should_enable_color true) (output_kind Pager))

  $ GIT_PAGER=cat git-pager print-settings --color=auto --force-stdout-isatty
  ((git_color_mode Auto) (should_enable_color true) (output_kind Tty))

  $ git-pager print-settings --color=always
  ((git_color_mode Always) (should_enable_color true) (output_kind Other))

  $ git-pager print-settings --color=always --force-stdout-isatty
  ((git_color_mode Always) (should_enable_color true) (output_kind Pager))

The setting of the [color.ui] is also meant to affect the settings, when it is
not overridden via the command line. However, this would only be visible if
stdout was a tty, and the pager enabled, so we are not going to be able to see
that in this test.

  $ git config --local color.ui never

  $ git-pager print-settings --force-stdout-isatty
  ((git_color_mode Never) (should_enable_color false) (output_kind Pager))

  $ git-pager print-settings --force-stdout-isatty --color=always
  ((git_color_mode Always) (should_enable_color true) (output_kind Pager))

  $ git config --local color.ui always

  $ git-pager print-settings --force-stdout-isatty
  ((git_color_mode Always) (should_enable_color true) (output_kind Pager))

  $ git-pager print-settings --force-stdout-isatty --color=never
  ((git_color_mode Never) (should_enable_color false) (output_kind Pager))

  $ git config --local color.ui auto

  $ git-pager print-settings --force-stdout-isatty
  ((git_color_mode Always) (should_enable_color true) (output_kind Pager))

Visualizing actual ansi colors produced by Git is done in the [diff.t] test.
