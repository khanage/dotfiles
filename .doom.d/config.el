;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(setq exec-path (append '("~/go/bin" "~/.local/bin" "~/.nvm/versions/node/v10.15.1/bin") exec-path))
(setq lsp-auto-guess-root t)
(setq lsp-print-io t)
(setq lsp-ui-doc-max-width 150)
(setq lsp-ui-doc-max-height 30)
(setq doom-localleader-key ",")

(load! "+bindings")
