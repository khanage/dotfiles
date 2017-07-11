;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration."
  (setq-default
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load. If it is the symbol `all' instead
   ;; of a list then all discovered layers will be installed.
   dotspacemacs-configuration-layers
   '(
     csv
     yaml
     ruby
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
     ;; <M-m f e R> (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     auto-completion
     better-defaults
     emacs-lisp
     html
     javascript
     typescript
     (haskell :variables
              haskell-completion-backend 'intero)
     purescript
     idris

     git
     markdown
     org
     themes-megapack
     (shell :variables
            shell-default-height 30
            shell-default-term-shell "/bin/zsh")
     syntax-checking
     version-control
     idris
     python
     windows-scripts
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages then consider to create a layer, you can also put the
   ;; configuration in `dotspacemacs/config'.
   dotspacemacs-additional-packages '(ox-reveal
                                      shakespeare-mode
                                      )
   ;; A list of packages and/or extensions that will not be install and loaded.
   dotspacemacs-excluded-packages '()
   ;; If non-nil spacemacs will delete any orphan packages, i.e. packages that
   ;; are declared in a layer which is not a member of
   ;; the list `dotspacemacs-configuration-layers'
   dotspacemacs-delete-orphan-packages t))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; Either `vim' or `emacs'. Evil is always enabled but if the variable
   ;; is `emacs' then the `holy-mode' is enabled at startup.
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer.
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed.
   dotspacemacs-startup-banner 'official
   ;; List of items to show in the startup buffer. If nil it is disabled.
   ;; Possible values are: `recents' `bookmarks' `projects'."
   dotspacemacs-startup-lists '(recents projects)
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(inkpot)
   ;; If non nil the cursor color matches the state color.
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font. `powerline-scale' allows to quickly tweak the mode-line
   ;; size to make separators look not too crappy.
   dotspacemacs-default-font '("Inconsolata for Powerline"
                               :size 14
                               :weight normal
                               :width expanded
                               :powerline-scale 1.1)
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The leader key accessible in `emacs state' and `insert state'
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it.
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; The command key used for Evil commands (ex-commands) and
   ;; Emacs commands (M-x).
   ;; By default the command key is `:' so ex-commands are executed like in Vim
   ;; with `:' and Emacs commands are executed with `<leader> :'.
   dotspacemacs-command-key ":"
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; Default value is `cache'.
   dotspacemacs-auto-save-file-location 'cache
   ;; If non nil then `ido' replaces `helm' for some commands. For now only
   ;; `find-files' (SPC f f) is replaced.
   dotspacemacs-use-ido nil
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content.
   dotspacemacs-enable-paste-micro-state nil
   ;; Guide-key delay in seconds. The Guide-key is the popup buffer listing
   ;; the commands bound to the current keystrokes.
   dotspacemacs-guide-key-delay 0.4
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil ;; to boost the loading time.
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up.
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX."
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'.
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'.
   dotspacemacs-inactive-transparency 90
   ;; If non nil unicode symbols are displayed in the mode line.
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters the
   ;; point when it reaches the top or bottom of the screen.
   dotspacemacs-smooth-scrolling t
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   dotspacemacs-smartparens-strict-mode nil
   ;; Select a scope to highlight delimiters. Possible value is `all',
   ;; `current' or `nil'. Default is `all'
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil advises quit functions to keep server open when quitting.
   dotspacemacs-persistent-server nil
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now.
   dotspacemacs-default-package-repository nil
   )
  ;; User initialization goes here

  )

(defun dotspacemacs/user-config ()

  (add-to-list 'exec-path "~/.local/bin")

  (setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
  (setq org-mobile-inbox-for-pull "~/Dropbox/org/flagged.org")
  (setq org-directory "~/Dropbox/org")
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (sh . t)
     (haskell . t)
     (sql . t)
     (js . t)))

  (spacemacs/add-to-hook 'org-mode-hook
                         '((defun kt/org-mode-hook ()
                             (progn
                               (load-library 'ox-reveal)
                               (setq org-reveal-root "https://cdn.jsdelivr.net/reveal.js/3.0.0/js/reveal.min.js")
                               (toggle-truncate-lines))
                             )))

  (customize-set-variable 'psc-ide-executable "~/.local/bin/psc-ide")

  (setq-default omnisharp--curl-executable-path "/usr/bin/curl")
  (setq-default omnisharp-server-executable-path "/Users/khan/build/omnisharp-server/OmniSharp/bin/Debug/OmniSharp")

  (dolist (mode '(erc-mode comint-mode shell-mode term-mode eshell-mode inferior-emacs-lisp-mode))
   (setq evil-insert-state-modes (remove mode evil-insert-state-modes)))

  (let ((comint-hooks '(eshell-mode-hook
                        term-mode-hook
                        erc-mode-hook
                        shell-mode-hook
                        messages-buffer-mode-hook
                        inferior-emacs-lisp-mode-hook)))

    (spacemacs/add-to-hooks (defun kt/no-hl-line-mode ()
                    (setq-local global-hl-line-mode nil))
                  comint-hooks)

    (spacemacs/add-to-hooks (defun kt/no-scroll-margin ()
                    (setq-local scroll-margin 0))
                  comint-hooks))
)

(defun dotspacemacs/config ()
  "Configuration function.
 This function is called at the very end of Spacemacs initialization after
layers configuration.")

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (winum unfill solarized-theme madhat2r-theme fuzzy idris-mode prop-menu rvm ruby-tools ruby-test-mode rubocop rspec-mode robe rbenv rake minitest chruby bundler inf-ruby log4e json-mode json-snatcher json-reformat parent-mode gitignore-mode fringe-helper git-gutter+ pos-tip flx web-completion-data peg epl packed pythonic popup autothemer haml-mode org seq bind-map highlight yaml-mode pug-mode hide-comnt yasnippet purescript-mode yapfify ws-butler window-numbering which-key web-mode uuidgen use-package toc-org tide typescript-mode tao-theme spacemacs-theme spaceline py-isort psc-ide planet-theme pip-requirements phpunit persp-mode paradox organic-green-theme org-projectile org-plus-contrib org-download open-junk-file omtose-phellack-theme omnisharp neotree naquadah-theme mwim move-text monokai-theme moe-theme material-theme majapahit-theme magit-gitflow macrostep livid-mode skewer-mode simple-httpd live-py-mode link-hint less-css-mode js2-refactor js2-mode intero indent-guide hlint-refactor hindent help-fns+ helm-themes helm-pydoc helm-projectile helm-make projectile helm-hoogle helm-descbinds helm-c-yasnippet helm-ag haskell-snippets gruvbox-theme grandshell-theme gotham-theme google-translate git-messenger git-link git-gutter-fringe git-gutter eyebrowse exec-path-from-shell evil-visual-mark-mode evil-unimpaired evil-surround evil-search-highlight-persist evil-mc evil-matchit evil-iedit-state iedit evil-exchange evil-ediff eshell-z eshell-prompt-extras ensime sbt-mode scala-mode emmet-mode dumb-jump drupal-mode dracula-theme diff-hl darktooth-theme darkokai-theme cyberpunk-theme csharp-mode company-tern tern company-ghci company-anaconda column-enforce-mode color-theme-sanityinc-tomorrow coffee-mode clojure-snippets clj-refactor hydra cider-eval-sexp-fu cider clojure-mode badwolf-theme auto-yasnippet anaconda-mode ample-theme ace-window ace-link ace-jump-helm-line avy auto-complete ghc anzu smartparens evil undo-tree haskell-mode flycheck company-quickhelp company request helm helm-core markdown-mode alert magit magit-popup git-commit with-editor php-mode f dash s quelpa package-build zenburn-theme zonokai-theme zen-and-art-theme xterm-color web-beautify volatile-highlights vi-tilde-fringe underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme tss tronesque-theme toxi-theme tangotango-theme tango-plus-theme tango-2-theme tagedit sunny-day-theme sublime-themes subatomic256-theme subatomic-theme stekene-theme spinner spacegray-theme soothe-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme smeargle slim-mode shm shell-pop seti-theme scss-mode sass-mode reverse-theme restart-emacs rainbow-delimiters railscasts-theme queue pyvenv pytest pyenv-mode purple-haze-theme psci professional-theme powershell powerline popwin pkg-info phpcbf php-extras php-auto-yasnippets phoenix-dark-pink-theme phoenix-dark-mono-theme pcre2el pastels-on-dark-theme paredit page-break-lines ox-reveal orgit org-repo-todo org-present org-pomodoro org-bullets oldlace-theme occidental-theme obsidian-theme noflet noctilux-theme niflheim-theme mustang-theme multiple-cursors multi-term monochrome-theme molokai-theme mmm-mode minimal-theme markdown-toc lush-theme lorem-ipsum linum-relative light-soap-theme js-doc jbeans-theme jazz-theme jade-mode ir-black-theme inkpot-theme info+ inflections ido-vertical-mode hy-mode hungry-delete htmlize hl-todo highlight-parentheses highlight-numbers highlight-indentation heroku-theme hemisu-theme helm-swoop helm-mode-manager helm-gitignore helm-flx helm-css-scss helm-company hc-zenburn-theme gruber-darker-theme goto-chg golden-ratio gnuplot gntp gitconfig-mode gitattributes-mode git-timemachine git-gutter-fringe+ gh-md gandalf-theme fsharp-mode flycheck-pos-tip flycheck-haskell flx-ido flatui-theme flatland-theme firebelly-theme fill-column-indicator farmhouse-theme fancy-battery expand-region evil-visualstar evil-tutor evil-numbers evil-nerd-commenter evil-magit evil-lisp-state evil-indent-plus evil-escape evil-args evil-anzu eval-sexp-fu espresso-theme esh-help elisp-slime-nav edn dockerfile-mode django-theme diminish define-word dash-functional darkmine-theme darkburn-theme dakrone-theme cython-mode company-web company-statistics company-ghc company-cabal colorsarenice-theme color-theme-sanityinc-solarized cmm-mode clues-theme clean-aindent-mode cherry-blossom-theme busybee-theme buffer-move bubbleberry-theme bracketed-paste birds-of-paradise-plus-theme bind-key auto-highlight-symbol auto-compile async apropospriate-theme anti-zenburn-theme ample-zen-theme alect-themes aggressive-indent afternoon-theme adaptive-wrap ac-ispell)))
 '(safe-local-variable-values
   (quote
    ((haskell-process-use-ghci . t)
     (haskell-indent-spaces . 4))))
 '(send-mail-function (quote mailclient-send-it))
 '(sp-base-key-bindings (quote sp)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(haskell-process-log t))
