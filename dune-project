(lang dune 3.17)

(name pageantty)

(generate_opam_files)

(license MIT)

(authors "Mathieu Barbin")

(maintainers "Mathieu Barbin <opensource@mbarbin.org>")

(source
 (github mbarbin/git-pager))

(documentation "https://mbarbin.github.io/git-pager/")

;; The value for the [implicit_transitive_deps] option is set during the CI
;; depending on the OCaml compiler version.
;;
;; This will be set to [false] iif [ocaml-version >= 5.2].
;;
;; For packaging purposes with older ocaml, it is simpler atm if the option is
;; set to [true] in the main branch.
;;
;; See: [.github/workflows/edit_dune_project_dot_ml].

(implicit_transitive_deps true)

(package
 (name pageantty)
 (synopsis "Run a pager to display diffs and other outputs in the terminal")
 (depends
  (ocaml
   (>= 4.14))
  (pp
   (>= 2.0.0))
  (pplumbing-err
   (>= 0.0.16))
  (pplumbing-pp-tty
   (>= 0.0.16))))

(package
 (name pageantty-tests)
 (synopsis "Tests for pageantty")
 (depends
  (ocaml
   (>= 5.2))
  (base
   (>= v0.17))
  (cmdlang
   (>= 0.0.9))
  (cmdlang-cmdliner-err-runner
   (>= 0.0.16))
  (expect_test_helpers_core
   (>= v0.17))
  (fpath
   (>= 0.7.3))
  (fpath-base
   (>= 0.2.2))
  (pageantty
   (= :version))
  (pp
   (>= 2.0.0))
  (pplumbing-err
   (>= 0.0.16))
  (pplumbing-log
   (>= 0.0.16))
  (pplumbing-log-cli
   (>= 0.0.16))
  (pplumbing-pp-tty
   (>= 0.0.16))
  (ppx_compare
   (>= v0.17))
  (ppx_enumerate
   (>= v0.17))
  (ppx_expect
   (>= v0.17))
  (ppx_hash
   (>= v0.17))
  (ppx_here
   (>= v0.17))
  (ppx_js_style
   (and
    :with-dev-setup
    (>= v0.17)))
  (ppx_let
   (>= v0.17))
  (ppx_sexp_conv
   (>= v0.17))
  (ppx_sexp_value
   (>= v0.17))
  (ppxlib
   (>= 0.33))
  (shexp
   (>= v0.17))
  (stdio
   (>= v0.17))
  (volgo
   (>= 0.0.18))
  (volgo-git-unix
   (>= 0.0.18))
  (volgo-vcs
   (>= 0.0.18))
  (sherlodoc
   (and
    :with-doc
    (>= 0.2)))))

(package
 (name pageantty-dev)
 (synopsis
  "Package to regroup dev targets for the project, documentation, and more")
 (allow_empty) ; In case the package is wip or attached to stanzas that dune doesn't see.
 (depends
  (ocaml
   (>= 5.2))
  (ocamlformat
   (and
    :with-dev-setup
    (= 0.27.0)))
  (base
   (>= v0.17))
  (bisect_ppx
   (and
    :with-dev-setup
    (>= 2.8.3)))
  (cmdlang
   (>= 0.0.9))
  (cmdlang-cmdliner-err-runner
   (>= 0.0.16))
  (expect_test_helpers_core
   (>= v0.17))
  (fpath
   (>= 0.7.3))
  (fpath-base
   (>= 0.2.2))
  (pageantty
   (= :version))
  (pageantty-tests
   (= :version))
  (pp
   (>= 2.0.0))
  (pplumbing-err
   (>= 0.0.16))
  (pplumbing-log
   (>= 0.0.16))
  (pplumbing-log-cli
   (>= 0.0.16))
  (pplumbing-pp-tty
   (>= 0.0.16))
  (ppx_compare
   (>= v0.17))
  (ppx_enumerate
   (>= v0.17))
  (ppx_expect
   (>= v0.17))
  (ppx_hash
   (>= v0.17))
  (ppx_here
   (>= v0.17))
  (ppx_js_style
   (and
    :with-dev-setup
    (>= v0.17)))
  (ppx_let
   (>= v0.17))
  (ppx_sexp_conv
   (>= v0.17))
  (ppx_sexp_value
   (>= v0.17))
  (ppxlib
   (>= 0.33))
  (shexp
   (>= v0.17))
  (stdio
   (>= v0.17))
  (volgo
   (>= 0.0.18))
  (volgo-git-unix
   (>= 0.0.18))
  (volgo-vcs
   (>= 0.0.18))
  (sherlodoc
   (and
    :with-doc
    (>= 0.2)))))
