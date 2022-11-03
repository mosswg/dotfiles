;;; mycelium/mycelium.el -*- lexical-binding: t; -*-

(defconst mycelium-mode-syntax-table
  (with-syntax-table (copy-syntax-table)
    ;; C/C++ style comments
	(modify-syntax-entry ?/ ". 124b")
	(modify-syntax-entry ?* ". 23")
	(modify-syntax-entry ?\n "> b")
    ;; Chars are the same as strings
    (modify-syntax-entry ?' "\"")
    (syntax-table))
  "Syntax table for `mycelium-mode'.")

(eval-and-compile
  (defconst mycelium-keywords
    '("int" "string" "func" "oper" "cond")))

(defconst mycelium-highlights
  `((,(regexp-opt mycelium-keywords 'symbols) . font-lock-keyword-face)))

;;;###autoload
(define-derived-mode mycelium-mode prog-mode "mycelium"
  "Major Mode for editing Mycelium source code."
  :syntax-table mycelium-mode-syntax-table
  (setq font-lock-defaults '(mycelium-highlights))
  (setq-local comment-start "// "))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.myc\\'" . mycelium-mode))

(provide 'mycelium-mode)

;;; mycelium.el ends here
