;;; +bindings.el --- description -*- lexical-binding: t; -*-

(map! (:after lsp                                                                
        (:leader
          (:prefix ("l" . "LSP")
            (:after lsp-ui
              :desc "Apply LSP action" :n "a" #'lsp-ui-sideline-apply-code-actions)
            :desc "Rename" :n "r" #'lsp-rename
            :desc "Restart LSP" :n "R" #'lsp-restart-workspace
            )))
      (:after flycheck
        (:leader
          (:prefix ("e", "Flycheck")
            :desc "Next error" :n "e" #'flycheck-next-error))))
