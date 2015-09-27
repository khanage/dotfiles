(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))
(package-initialize)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-startup-message t)
(setq-default indent-tabs-mode nil)
(setq tags-revert-without-query 1)

(desktop-save-mode 1)

(windmove-default-keybindings)

(require 'rainbow-delimiters)
(add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
(add-hook 'nrepl-mode-hook 'rainbow-delimiters-mode)

(require 'color-theme)
(load-theme 'grandshell t)

(require 'paredit)

;; Scala
(require 'scala-mode2)
(require 'ensime)

(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
(add-hook 'scala-mode-hook 'paredit-mode)

(setq ensime-sbt-compile-on-save 't)

;; Elixir

(require 'elixir-mode)
(require 'ruby-end)

(add-to-list 'elixir-mode-hook
             (defun auto-activate-ruby-end-mode-for-elixir-mode ()
               (set (make-variable-buffer-local 'ruby-end-expand-keywords-before-re)
                    "\\(?:^\\|\\s-+\\)\\(?:do\\)")
               (set (make-variable-buffer-local 'ruby-end-check-statement-modifiers) nil)
               (ruby-end-mode +1)))

(defun dont-space-delimit-for-parens-in-paredit-p (endp delimiter)
  "Don't insert a space in paredit for given modes"
  (not 'elixir-mode))

(add-to-list 'paredit-space-for-delimiter-predicates #'dont-space-delimit-for-parens-in-paredit-p)

(add-hook 'elixir-mode-hook 'company-mode)
(add-hook 'elixir-mode-hook 'paredit-mode)
(add-hook 'elixir-mode-hook 'rainbow-delimiters-mode)

;; Clojure
(unless (package-installed-p 'cider)
  (package-install 'cider))
(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'clojure-repl-mode-hook 'paredit-mode)

(add-to-list 'auto-mode-alist '("\\.cljs\\'" . clojure-mode))

;; Paredit
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
(add-hook 'haskell-mode-hook 'paredit-mode)

(global-set-key [f7] 'paredit-mode)

;; web
(require 'sass-mode)
(require 'coffee-mode)

(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-hook 'js2-mode-hook 'paredit-mode)
(add-hook 'js2-mode-hook 'rainbow-delimiters-mode)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(defun all-web-mode-hooks ()
  "Custom hooks for web mode"
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-enable-current-column-highlight t)
  )

(add-hook 'web-mode-hook 'all-web-mode-hooks)

;; haskell

(add-to-list 'exec-path "~/.cabal/bin")
(require 'haskell-mode)
(require 'hamlet-mode)

(eval-after-load "haskell-mode"
  '(progn
    (define-key haskell-mode-map (kbd "C-x C-d") nil)
    (define-key haskell-mode-map (kbd "C-c C-z") 'haskell-interactive-switch)
    (define-key haskell-mode-map (kbd "C-c C-l") 'haskell-process-load-file)
    (define-key haskell-mode-map (kbd "C-c C-b") 'haskell-interactive-switch)
    (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-process-do-type)
    (define-key haskell-mode-map (kbd "C-c C-i") 'haskell-process-do-info)
    (define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile)
    (define-key haskell-mode-map (kbd "M-.") 'haskell-mode-goto-loc)
    (define-key haskell-mode-map (kbd "C-c C-t") 'haskell-mode-show-type-at)
    (define-key haskell-mode-map (kbd "C-?") 'haskell-mode-find-uses)

    (define-key haskell-mode-map (kbd "C-c M-.") nil)
    (define-key haskell-mode-map (kbd "C-c C-d") nil)

    (paredit-mode)))

(eval-after-load "haskell-cabal" 
  '(define-key haskell-cabal-mode-map (kbd "C-c C-c") 'haskell-compile))

(setq haskell-process-type 'stack-ghci)
(setq haskell-process-path-ghci "stack")
(setq haskell-process-args-ghci "ghci")

;; ac

(require 'company)
(require 'company-ghci)

(add-to-list 'company-backends 'company-ghci)

;; Purescript

(setq purescript-program-name "pulp psci")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(haskell-mode-hook
   (quote
    (turn-on-haskell-doc turn-on-haskell-indentation paredit-mode)))
 '(haskell-stylish-on-save t)
 '(haskell-tags-on-save t)
 '(inferior-haskell-wait-and-jump t)
 '(safe-local-variable-values
   (quote
    ((hindent-style . "johan-tibell")
     (hamlet/basic-offset . 4)
     (haskell-process-use-ghci . t)
     (haskell-indent-spaces . 2))))
  '(purescript-mode-hook
   (quote
    (capitalized-words-mode turn-on-eldoc-mode turn-on-purescript-indentation turn-on-purescript-decl-scan inferior-psci-mode))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
