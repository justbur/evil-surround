
(require 'ert)
(require 'evil)
(require 'evil-surround)
(require 'evil-test-helpers)

;; interactive test helper (this is the standard configuration)
(evil-add-to-alist
 'evil-surround-pairs-alist
 ?\) '("(" . ")")
 ?\] '("[" . "]")
 ?\} '("{" . "}")
 ?\( '("( " . " )")
 ?\[ '("[ " . " ]")
 ?\{ '("{ " . " }"))

(ert-deftest evil-surround-test ()
  (ert-info ("basic surrounding")
    (evil-test-buffer
      "one [t]wo three"
      (turn-on-evil-surround-mode)
      ("ysiwb")
      "one (two) three"
      ("csb'")
      "one 'two' three"
      ("ds'")
      "one two three"))
  (ert-info ("examples from readme")
    (evil-test-buffer
      :visual-start nil
      :visual-end nil
      "\"Hello world!\""
      (turn-on-evil-surround-mode)
      ("cs\"'")
      "'Hello world!'"
      ("cs'<q>")
      "<q>Hello world!</q>"
      ("cst\"")
      "\"Hello world!\""
      ("ds\"")
      "Hello world!"
      ("ysiw]")
      "[Hello] world!"
      ("cs[{")
      "{ Hello } world!"
      ("yssb")
      "({ Hello } world!)"
      ("lds{ds)") ;; 'l' to move the cursor right, inside brackets
      "Hello world!"
      ("ysiw<em>")
      "<em>Hello</em> world!"))
  (ert-info ("repeat surrounding")
    (evil-test-buffer
      "[o]ne two three"
      (turn-on-evil-surround-mode)
      ;; surround and repeat it
      ("ysiwb")
      "(one) two three"
      ("W.") ;; repeat surround region
      "(one) (two) three"
      ("W.") ;; repeat surround region
      "(one) (two) (three)"

      ;; change surround and repeat it
      ("0csb'")
      "'one' (two) (three)"
      ("W.") ;; repeat change surround
      "'one' 'two' (three)"
      ("W.") ;; repeat change surround
      "'one' 'two' 'three'"

      ;; delete surround and repeat it
      ("0ds'")
      "one 'two' 'three'"
      ("W.") ;; repeat delete surround
      "one two 'three'"
      ("W.") ;; repeat delete surround
      "one two three"))
  (ert-info ("visual surrounding")
    (evil-test-buffer
      "<one two> three\nfour\n"
      (turn-on-evil-surround-mode)
      ("Sb")
      "(one two) three\nfour\n")
    (evil-test-buffer
      "<one two three>\nfour\n"
      (turn-on-evil-surround-mode)
      ("Sb")
      "(one two three)\nfour\n")
    (evil-test-buffer
      "<one two three\nfo>ur\n"
      (turn-on-evil-surround-mode)
      ("Sb")
      "(one two three\nfo)ur\n"))
  (ert-info ("visual line surrounding")
    (evil-test-buffer
      "[o]ne two three\nfour\n"
      (turn-on-evil-surround-mode)
      ("yssb")
      "(one two three)\nfour\n"
      ("dsb")
      "one two three\nfour\n"
      ("VSb")
      "(\none two three\n)\nfour\n")
    (evil-test-buffer
      "111 222 333\n[1]11 222 333\n111 222 333\n111 222 333\n"
      (turn-on-evil-surround-mode)
      ("ysjb")
      "111 222 333\n(\n111 222 333\n111 222 333\n)\n111 222 333\n"))
  (ert-info ("test with evil-want-change-word-to-end")
    (evil-test-buffer
      "[o]ne    two  three"
      (setq evil-want-change-word-to-end nil)
      (turn-on-evil-surround-mode)
      ("yswb")
      "[(]one    )two  three"
      ("dsb")
      "[o]ne    two  three"
      ("ys2wb")
      "[(]one    two  )three"
      ("dsb")
      "[o]ne    two  three"
      ("ys3wb")
      "[(]one    two  three)")
    (evil-test-buffer
      "[o]ne    two  three"
      (setq evil-want-change-word-to-end t)
      (turn-on-evil-surround-mode)
      ("yswb")
      "[(]one)    two  three"
      ("dsb")
      "[o]ne    two  three"
      ("ys2wb")
      "[(]one    two)  three"
      ("dsb")
      "[o]ne    two  three"
      ("ys3wb")
      "[(]one    two  three)"))
  (ert-info ("yS test")
    (evil-test-buffer
      "some_word"
      (turn-on-evil-surround-mode)
      ("ySiW\"")
      "\"\nsome_word\n\""
      ))
  (ert-info ("ensure backquote delimiters work")
    (evil-test-buffer
      "`this_is_a_[b]acktick_surrounded_word`"
      (turn-on-evil-surround-mode)
      ("cs`)")
      "[(]this_is_a_backtick_surrounded_word)"
      )))
