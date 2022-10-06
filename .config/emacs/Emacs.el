;; Change the user-emacs-directory to keep unwanted things out of ~/.emacs.d
(setq user-emacs-directory (expand-file-name "~/.cache/emacs/")
      url-history-file (expand-file-name "url/history" user-emacs-directory))

;; Use no-littering to automatically set common paths to the new user-emacs-directory
(use-package no-littering)

;; Keep customization settings in a temporary file (thanks Ambrevar!)
(setq custom-file
      (if (boundp 'server-socket-dir)
          (expand-file-name "custom.el" server-socket-dir)
        (expand-file-name (format "emacs-custom-%s.el" (user-uid)) temporary-file-directory)))
(load custom-file t)

(message "Keep .config/emacs/ clean... loaded")

(set-default-coding-systems 'utf-8)

(server-start)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(global-set-key (kbd "C-M-u") 'universal-argument)

(defun dw/evil-hook ()
  (dolist (mode '(custom-mode
                  eshell-mode
                  git-rebase-mode
                  erc-mode
                  circe-server-mode
                  circe-chat-mode
                  circe-query-mode
                  sauron-mode
                  term-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(defun dw/dont-arrow-me-bro ()
  (interactive)
  (message "Arrow keys are bad, you know?"))

(use-package undo-tree
  :init
  (global-undo-tree-mode 1))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-tree)
  :config
  (add-hook 'evil-mode-hook 'dw/evil-hook)
  ;; after saving, force normal mode as if you've typed ESC + : + w.
  (add-hook 'after-save-hook 'evil-normal-state)
  (evil-mode 1)
  ;; (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  ;; (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  ;; Disable arrow keys in normal and visual modes
  (define-key evil-normal-state-map (kbd "<left>") 'dw/dont-arrow-me-bro)
  (define-key evil-normal-state-map (kbd "<right>") 'dw/dont-arrow-me-bro)
  (define-key evil-normal-state-map (kbd "<down>") 'dw/dont-arrow-me-bro)
  (define-key evil-normal-state-map (kbd "<up>") 'dw/dont-arrow-me-bro)
  (evil-global-set-key 'motion (kbd "<left>") 'dw/dont-arrow-me-bro)
  (evil-global-set-key 'motion (kbd "<right>") 'dw/dont-arrow-me-bro)
  (evil-global-set-key 'motion (kbd "<down>") 'dw/dont-arrow-me-bro)
  (evil-global-set-key 'motion (kbd "<up>") 'dw/dont-arrow-me-bro)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))



(use-package evil-collection
  :after evil
  :custom
  (evil-collection-outline-bind-tab-p nil)
  :config
  (setq evil-collection-mode-list
        (remove 'lispy evil-collection-mode-list))
  (evil-collection-init))


(message "Evil mode and whistles... loaded")

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package general
  :config
  (general-evil-setup t)

  (general-create-definer dw/leader-key-def
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (general-create-definer dw/ctrl-c-keys
    :prefix "C-c"))

;; Thanks, but no thanks
(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)       ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

;; show column number
(setq column-number-mode t)

;; toggle display-line-numbers-mode in all buffers.
;; use the function, not the variable!
(global-display-line-numbers-mode)

;; enable relative line numbering everywhere like vim
(setq display-line-numbers-type 'relative)

;; do not display line number for specific modes
(dolist (mode '(pdf-view-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda() (display-line-numbers-mode 0))))

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq use-dialog-box nil) ;; Disable dialog boxes since they weren't working in Mac OSX

(set-frame-parameter (selected-frame) 'alpha '(100 . 100)) ; Make it 90 or 95 to get a material transparency effect!
(add-to-list 'default-frame-alist '(alpha . (100 . 100)))
; (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
; (add-to-list 'default-frame-alist '(fullscreen . maximized))

(message "General configuration - UI... loaded")

(defalias 'yes-or-no-p 'y-or-n-p)

(use-package doom-themes :defer t)
(load-theme 'doom-gruvbox t) ; final 't' loads the theme without asking to confirm
(doom-themes-visual-bell-config) ; Enable flashing on modeline error

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "CMU Bright" :height 140 :weight 'regular)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Monospace" :height 110)

(use-package emojify
  :hook (erc-mode . emojify-mode)
  :commands emojify-mode)

(setq display-time-format "%l:%M %p %b %y"
      display-time-default-load-average nil)

(use-package diminish)

(use-package smart-mode-line
  :config
  (setq sml/no-confirm-load-theme t)
  (sml/setup)
  (sml/apply-theme 'respectful)  ; Respect the theme colors
  (setq sml/mode-width 'right
        sml/name-width 60)

  (setq-default mode-line-format
                `("%e"
                  ,()
                  mode-line-front-space
                  evil-mode-line-tag
                  mode-line-mule-info
                  mode-line-client
                  mode-line-modified
                  mode-line-remote
                  mode-line-frame-identification
                  mode-line-buffer-identification
                  sml/pos-id-separator
                  (vc-mode vc-mode)
                  " "
                                        ;mode-line-position
                  sml/pre-modes-separator
                  mode-line-modes
                  " "
                  mode-line-misc-info))

  (setq rm-excluded-modes
        (mapconcat
         'identity
                                        ; These names must start with a space!
         '(" GitGutter" " MRev" " company"
           " Helm" " Undo-Tree" " Projectile.*" " Z" " Ind"
           " Org-Agenda.*" " ElDoc" " SP/s" " cider.*")
         "\\|")))

;; You must run (all-the-icons-install-fonts) one time after
;; installing this package!
(use-package minions
  :hook (doom-modeline-mode . minions-mode))

(use-package doom-modeline
  ;:hook (after-init . doom-modeline-mode)
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 30)
  (doom-modeline-bar-width 6)
  (doom-modeline-lsp t)
  (doom-modeline-github nil)
  (doom-modeline-mu4e nil)
  (doom-modeline-irc nil)
  (doom-modeline-minor-modes t)
  (doom-modeline-persp-name nil)
  (doom-modeline-buffer-file-name-style 'truncate-except-project)
  (doom-modeline-major-icon t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-major-mode-color-icon t)
  (doom-modeline-modal-icon t))

(message "Doom modeline... loaded")

;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; Revert buffers when the underlying file has changed
(global-auto-revert-mode 1)

;; remember and restore the last cursor location of opened files
(save-place-mode 1)

(dw/leader-key-def
 "t"  '(:ignore t :which-key "toggles")
 "tw" 'whitespace-mode) ; toggle whitespace visualization (whitespace-mode)

;; (use-package paren
;;   :config
;;   (set-face-attribute 'show-paren-match-expression nil :background "#363e4a")
;;   (show-paren-mode 1))

;; there's no global mode because it can create problems.
(use-package rainbow-delimiters
  :hook
  ; (org-mode . rainbow-delimiters-mode)
  ; (text-mode . rainbow-delimiters-mode)
  (prog-mode . rainbow-delimiters-mode))

(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)

(setq-default indent-tabs-mode nil)

(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package ws-butler)
  ;; :hook ((text-mode . ws-butler-mode)
  ;;        (prog-mode . ws-butler-mode)))

(use-package savehist
  :config
  (setq history-length 25)
  (savehist-mode 1))

;; Individual history elements can be configured separately
;;(put 'minibuffer-history 'history-length 25)
;;(put 'evil-ex-history 'history-length 50)
;;(put 'kill-ring 'history-length 25)

(use-package all-the-icons)

(use-package all-the-icons-completion
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
  :init
  (all-the-icons-completion-mode))

(defun dw/minibuffer-backward-kill (arg)
  "When minibuffer is completing a file name delete up to parent
folder, otherwise delete a word"
  (interactive "p")
  (if minibuffer-completing-file-name
      ;; Borrowed from https://github.com/raxod502/selectrum/issues/498#issuecomment-803283608
      (if (string-match-p "/." (minibuffer-contents))
          (zap-up-to-char (- arg) ?/)
        (delete-minibuffer-contents))
    (backward-kill-word arg)))

(use-package vertico
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous)
              ("C-f" . vertico-exit)
              :map minibuffer-local-map
              ("M-h" . dw/minibuffer-backward-kill))
  :custom
  (vertico-cycle t)
  :custom-face
  (vertico-current ((t (:background "#3a3f5a"))))
  :init
  (vertico-mode))

(use-package corfu
  :bind (:map corfu-map
              ("C-j" . corfu-next)
              ("C-k" . corfu-previous)
              ("C-f" . corfu-insert))
  :custom
  (corfu-cycle t) ;; enable cycling for `corfu-next/previous
  (corfu-auto t) ;; enable auto completions
  (corfu-preselect-first t)

  (corfu-min-width 80)
  (corfu-max-width corfu-min-width)       ; Always have the same width

  ;; Works with `indent-for-tab-command'. Make sure tab doesn't indent when you
  ;; want to perform completion
  (tab-always-indent 'complete)
  (completion-cycle-threshold nil)      ; Always show candidates in menu

  (corfu-auto-prefix 2) ; minimum length prefix for auto-completion
  (corfu-auto-delay 0.25) ; time in seconds before suggestion
  :init
  (global-corfu-mode))

;; There are commands like corfu-show-documentation/location which are useful,
;; and can be bounded to M-d and M-l for example.

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-use-icons t)
  (kind-icon-default-face 'corfu-default) ; Have background color be the same as `corfu' face background
  (kind-icon-blend-background nil)  ; Use midpoint color between foreground and background colors ("blended")?
  (kind-icon-blend-frac 0.08)

  ;; other
  (corfu-echo-documentation nil)        ; Already use corfu-doc
  (lsp-completion-provider :none)       ; Use corfu instead for lsp completions

  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter) ; Enable `kind-icon'

  ;; Add hook to reset cache so the icon colors match my theme
  ;; NOTE 2022-02-05: This is a hook which resets the cache whenever I switch
  ;; the theme using my custom defined command for switching themes. If I don't
  ;; do this, then the backgound color will remain the same, meaning it will not
  ;; match the background color corresponding to the current theme. Important
  ;; since I have a light theme and dark theme I switch between. This has no
  ;; function unless you use something similar
  (add-hook 'kb/themes-hooks #'(lambda () (interactive) (kind-icon-reset-cache))))

(use-package corfu-doc
  :after corfu
  :hook
  (corfu-mode . corfu-doc-mode)
  :custom
  (corfu-doc-auto t)
  (corfu-doc-delay 0.5)
  (corfu-doc-max-width 70)
  (corfu-doc-max-height 20)

  ;; NOTE 2022-02-05: I've also set this in the `corfu' use-package to be
  ;; extra-safe that this is set when corfu-doc is loaded. I do not want
  ;; documentation shown in both the echo area and in the `corfu-doc' popup.
  (corfu-echo-documentation nil))

(use-package cape
  :init
  ;; Add `completion-at-point-functions', used by `completion-at-point'.
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file))

(use-package orderless
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion))))))

;; (defun dw/get-project-root ()
;;   (when (fboundp 'projectile-project-root)
;;     (projectile-project-root)))

(use-package consult
  :demand t
  :bind (("C-s" . consult-line) ; it is like a better search with preview
         ("C-M-l" . consult-imenu) ; see how powerful is with org mode!
         ("C-M-j" . persp-switch-to-buffer*)
         :map minibuffer-local-map
         ("C-r" . consult-history))
  :custom
  ;; (consult-project-root-function #'dw/get-project-root)
  (completion-in-region-function #'consult-completion-in-region)
  :config
  (consult-preview-at-point-mode))

(use-package marginalia
  :after vertico
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(message "Completion system... loaded")

(use-package default-text-scale
  :defer 1
  :config
  (default-text-scale-mode))

(use-package ace-window
  :bind (("M-o" . ace-window))
  :custom
  (aw-scope 'frame)
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
  (aw-minibuffer-flag t) ;; shows current window letter in the minibuffer
  :config
  (ace-window-display-mode 1))

(setq display-buffer-base-action
      '(display-buffer-reuse-mode-window
        display-buffer-reuse-window
        display-buffer-same-window))

;; If a popup does happen, don't resize windows to be equal-sized
(setq even-window-sizes nil)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired
  :ensure nil ;; native package, don't search it on melpa, you won't find it
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump)) ;; super useful
                                        ; :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  ;; disable warning when using 'dired-find-alternate-file'.
  (put 'dired-find-alternate-file 'disabled nil)
  ;; in this way I use h/j/k/l vim style for dired. Great!
  (evil-collection-define-key 'normal 'dired-mode-map
    ;; alternate version is useful to avoid opening a lot of buffers
    "l" 'dired-find-alternate-file
  "h" '(lambda () (interactive) (find-alternate-file ".."))))

;; color names of files and folders in dired mode.
(use-package dired-rainbow
  :defer 2
  :config
  (dired-rainbow-define-chmod directory "#6cb2eb" "d.*")
  (dired-rainbow-define html "#eb5286" ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht" "eml" "mustache" "xhtml"))
  (dired-rainbow-define xml "#f2d024" ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg" "pgn" "rss" "yaml" "yml" "rdata"))
  (dired-rainbow-define document "#9561e2" ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx"))
  (dired-rainbow-define markdown "#ffed4a" ("org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst" "tex" "textfile" "txt"))
  (dired-rainbow-define database "#6574cd" ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
  (dired-rainbow-define media "#de751f" ("mp3" "mp4" "mkv" "MP3" "MP4" "avi" "mpeg" "mpg" "flv" "ogg" "mov" "mid" "midi" "wav" "aiff" "flac"))
  (dired-rainbow-define image "#f66d9b" ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png" "psd" "eps" "svg"))
  (dired-rainbow-define log "#c17d11" ("log"))
  (dired-rainbow-define shell "#f6993f" ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
  (dired-rainbow-define interpreted "#38c172" ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql" "sql" "r" "clj" "cljs" "scala" "js"))
  (dired-rainbow-define compiled "#4dc0b5" ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp" "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn" "f90" "f95" "f03" "f08" "s" "rs" "hi" "hs" "pyc" ".java"))
  (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
  (dired-rainbow-define compressed "#51d88a" ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar" "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
  (dired-rainbow-define packaged "#faad63" ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk" "bsp"))
  (dired-rainbow-define encrypted "#ffed4a" ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
  (dired-rainbow-define fonts "#6cb2eb" ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
  (dired-rainbow-define partition "#e3342f" ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak"))
  (dired-rainbow-define vc "#0074d9" ("git" "gitignore" "gitattributes" "gitmodules"))
  (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*"))

(message "File browsing... loaded")

(defun org-syntax-table-modify ()
  "Modify `org-mode-syntax-table' for the current org buffer."
  (modify-syntax-entry ?< "." org-mode-syntax-table)
  (modify-syntax-entry ?> "." org-mode-syntax-table))

(use-package org
  :init
  (setq org-startup-with-inline-images t)
  :custom
  (org-hide-emphasis-markers t)
  (org-ellipsis " ▾")
  (org-confirm-babel-evaluate nil)

  ;; default image size if no other value is provided with #+attr_org: :width N
  (org-image-actual-width '(600))
  :config
  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.3)
                  (org-level-2 . 1.2)
                  (org-level-3 . 1.15)
                  (org-level-4 . 1.1)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "CMU Bright" :weight 'regular :height (cdr face)))

  ;; Set the variable pitch face
 (set-face-attribute 'variable-pitch nil :font "CMU Bright" :height 140 :weight 'regular)

  ;; Set the fixed pitch face
  (set-face-attribute 'fixed-pitch nil :font "Monospace" :height 110)

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch)

  ;; org-babel

  ;; add support for TypeScript
  (use-package ob-typescript)

  ;; load the languages to be supported with org-babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (typescript . t)
     (js . t)))


  ;; use dvipng to preview latex snippets
  (setq org-preview-latex-default-process 'dvipng)
  ;; bigger font
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))

  :hook((org-mode . visual-line-mode)
        (org-mode . variable-pitch-mode)
        (org-mode . org-num-mode)
        (org-mode . org-syntax-table-modify)))

(use-package org-appear
  :hook (org-mode . org-appear-mode))

;; type <el followed by a TAB to create an elisp source block etc
(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("js" . "src js"))
(add-to-list 'org-structure-template-alist '("ts" . "src typescript"))
(add-to-list 'org-structure-template-alist '("html" . "src html"))
(add-to-list 'org-structure-template-alist '("sol" . "src solidity"))
(add-to-list 'org-structure-template-alist '("txt" . "src text"))
(add-to-list 'org-structure-template-alist '("rs" . "src rust"))
(add-to-list 'org-structure-template-alist '("rust" . "src rust"))

;; (use-package org-bullets
;;   :after org
;;   :hook (org-mode . org-bullets-mode))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 120
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(use-package markdown-mode
  :hook ((markdown-mode . auto-fill-mode)
         (markdown-mode . display-fill-column-indicator-mode)
         (markdown-mode . (lambda () (set-fill-column 80)))))

(use-package simple-httpd)

(use-package lsp-mode)

(use-package smartparens
  :hook (prog-mode . smartparens-mode))

;; (use-package affe)

;; (defun lf/fuzzy-find-in-project ()
;;   (interactive)
;;     "combines `project-dired' and `affe-find'"
;;   (project-dired)
;;   (affe-find))

;; (dw/leader-key-def
;;   ;; fuzzy find
;;   "ff" 'lf/fuzzy-find-in-project)

(use-package tree-sitter
  :config
  ;; activate tree-sitter on any buffer containing code for which it has a parser available
  (global-tree-sitter-mode)
  ;; you can easily see the difference tree-sitter-hl-mode makes for python, ts or tsx
  ;; by switching on and off
  ; (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
  :hook
  (tree-sitter-after-on-hook . tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :after tree-sitter)

;; (use-package nvm
;;   :defer t)

(use-package typescript-mode
  :after tree-sitter
  :config
  ;; we choose this instead of tsx-mode so that eglot can automatically figure out language for server
  ;; see https://github.com/joaotavora/eglot/issues/624 and https://github.com/joaotavora/eglot#handling-quirky-servers
  (define-derived-mode typescriptreact-mode typescript-mode
    "TypeScript TSX")

  ;; use our derived mode for tsx files
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescriptreact-mode))
  ;; by default, typescript-mode is mapped to the treesitter typescript parser
  ;; use our derived mode to map both .tsx AND .ts -- typescriptreact-mode -- treesitter tsx
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescriptreact-mode . tsx)))

(defun dw/set-js-indentation ()
  (setq js-indent-level 2)
  (setq evil-shift-width js-indent-level)
  (setq-default tab-width 2))

(use-package js2-mode
  :mode "\\.js\\'"
  :config
  ;; Use js2-mode for Node scripts
  (add-to-list 'magic-mode-alist '("#!/usr/bin/env node" . js2-mode))

  ;; Set up proper indentation in JavaScript and JSON files
  (add-hook 'js2-mode-hook #'dw/set-js-indentation)
  (add-hook 'json-mode-hook #'dw/set-js-indentation))

;; Don't use built-in syntax checking, there already other tools configured
(setq js2-mode-show-strict-warnings nil)

(use-package apheleia
  :config
  (apheleia-global-mode +1))

(use-package prettier
  :hook ((js2-mode . prettier-js-mode)
         (typescript-mode . prettier-js-mode))
  )

(use-package solidity-mode
  :mode "\\.sol\\'")

(use-package rustic)

;; crazy useful
(dw/leader-key-def
  "e"   '(:ignore t :which-key "eval")
  "eb"  '(eval-buffer :which-key "eval buffer"))

(dw/leader-key-def
  :keymaps '(visual)
  "er" '(eval-region :which-key "eval region"))

;; choose 'dvipng' to convert latex snippets into png

(find-file "~/.config/emacs/Emacs.org")
(find-file "~/Documents/org")
