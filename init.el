;;; init --- My init thing
;;; Commentary:

;;; Code:
(require 'package)

(setq package-enable-at-startup nil) ; tells emacs not to load any packages before starting up
;; the following lines tell emacs where on the internet to look up
;; for new packages.
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")))
(package-initialize) ; guess what this one does ?

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package) ; unless it is already installed
  (package-refresh-contents) ; updage packages archive
  (package-install 'use-package)) ; and install the most recent version of use-package

(require 'use-package) ; guess what this one does too ?
(use-package posframe
  :load-path "~/sources/posframe/"
  )

(use-package magit
  :ensure t
  )
(use-package tex-mode
  :ensure auctex)
(use-package latex-preview-pane
  :ensure t
  )

;; Default behavior changes
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")) )
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) )
(setq coding-system-for-read 'utf-8 )
(setq coding-system-for-write 'utf-8 )
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(setq sentence-end-double-space nil)
(setq default-fill-column 80)
(global-display-line-numbers-mode)
(show-paren-mode t)

(setq default-frame-alist '((font . "Fira Code-12")))
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq ns-pop-up-frames nil)



;; ======= UI Stuff =======
;; Remove window fluff
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
;; (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq initial-scratch-message nil)
(setq ring-bell-function 'ignore )
(defun display-startup-echo-area-message ()
  (message ""))
;; Theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-peacock t))
(use-package all-the-icons :ensure t)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-modal-icon t))

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package highlight-indent-guides
  :ensure t
  :config
  (setq highlight-indent-guides-method 'bitmap)
  )

(use-package slime
  :ensure t
  :config
  (setq inferior-lisp-program "sbcl")
  )

(use-package auto-package-update
   :ensure t
   :config
   (setq auto-package-update-delete-old-versions t
         auto-package-update-interval 4)
   (auto-package-update-maybe))

;; (use-package smooth-scrolling
;;   :ensure t
;;   :init
;;   :config
;;   (smooth-scrolling-mode 1)
;;   )
(use-package sublimity
  :ensure t
  :config
  (require 'sublimity)
  (require 'sublimity-scroll)
  ;; (require 'sublimity-map)
  (sublimity-mode 1))

;; UI tweaks
;; (use-package ivy
;;   :ensure t
;;   :init
;;   (setq ivy-use-virtual-buffers t)
;;   (setq enable-recursive-minibuffers t)
;;   :config
;;   (ivy-mode 1))
;; (use-package ivy
;;   :ensure t
;;   :config

(use-package counsel
  :ensure t
  :config
  (use-package ivy-posframe
    :ensure t
    :init
    ;; (setq focus-follows-mouse t
    ;; 	  mouse-autoselect-window t
    ;; 	  )
    (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-bottom-left)))
    :custom-face
    (ivy-posframe-border ((t (:background "#ffffff"))))
    :config
    (ivy-posframe-mode 1))
  (ivy-mode 1)
  (counsel-mode 1)
  (setq ivy-use-virtual-buffers t)
  (define-key ivy-minibuffer-map [escape] 'minibuffer-keyboard-quit)
  (setq enable-recursive-minibuffers t))
(use-package counsel-projectile
  :ensure t
  :config (counsel-projectile-mode 1))

;; (use-package counsel
;;   :ensure t
;;   :hook ((after-init . ivy-mode)
;; 	 (ivy-mode . counsel-mode))
;;   )

(use-package which-key
  :ensure t
  :init
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "+")
  :config
  (which-key-mode))
(setq select-enable-clipboard nil)

(use-package projectile
  :ensure t
  :config
  (projectile-mode +1))

(use-package dtrt-indent
  :ensure t
  :config (dtrt-indent-global-mode))
;; Vim stuff
(use-package evil
  :ensure t
  :init
  (setq evil-want-keybinding nil)
  (setq scroll-step 1
	;scroll-margin 10)
	scroll-conservatively 1000)

  :config
  (evil-mode)
  ;; (define-key evil-normal-state-map "J" 'evil-next-line)
  (define-key evil-normal-state-map "C" 'evil-join)
  (define-key evil-normal-state-map "K" 'evil-previous-line)


  (use-package evil-magit
    :ensure t)
  (use-package evil-indent-plus
    :ensure t
    :config (evil-indent-plus-default-bindings))
  ;; Rest of the evil ecosystem
  (use-package evil-collection
    :after evil
    :ensure t
    :config
    (evil-collection-init))

  (use-package evil-goggles
    :ensure t
    :config
    (evil-goggles-use-diff-faces)
    (setq evil-goggles-enable-delete nil)
    (setq evil-goggles-enable-change nil)
    (evil-goggles-mode))

  (use-package gdscript-mode
    :ensure t
    :config
    (defun lsp--gdscript-ignore-errors (original-function &rest args)
      "Ignore the error message resulting from Godot not replying to the `JSONRPC' request."
      (if (string-equal major-mode "gdscript-mode")
	  (let ((json-data (nth 0 args)))
	    (if (and (string= (gethash "jsonrpc" json-data "") "2.0")
		     (not (gethash "id" json-data nil))
		     (not (gethash "method" json-data nil)))
		nil ; (message "Method not found")
	      (apply original-function args)))
	(apply original-function args)))
    ;; Runs the function `lsp--gdscript-ignore-errors` around `lsp--get-message-type` to suppress unknown notification errors.
    (advice-add #'lsp--get-message-type :around #'lsp--gdscript-ignore-errors))

  (use-package evil-surround
    :ensure t
    :commands
    (evil-surround-edit
     evil-Surround-edit
     evil-surround-region
     evil-Surround-region)
    :init
    (evil-define-key 'operator global-map "s" 'evil-surround-edit)
    (evil-define-key 'operator global-map "S" 'evil-Surround-edit)
    (evil-define-key 'visual global-map "S" 'evil-surround-region)
    (evil-define-key 'visual global-map "gS" 'evil-Surround-region))

  (use-package evil-easymotion
    :ensure t
    :config
    (define-key evil-normal-state-map "J" 'nil)
    (define-key evil-normal-state-map "s" 'nil)
    (evilem-define (kbd "w") 'evil-forward-word-begin :scope 'line)
    (evilem-define (kbd "W") 'evil-backward-word-begin :scope 'line)
    (evilem-define (kbd "e") 'evil-forward-word-end :scope 'line)
    (evilem-define (kbd "E") 'evil-backward-word-end :scope 'line)

    (evilem-define (kbd "s") #'evil-repeat-find-char
		   :name 'move-to-both
		   :pre-hook (save-excursion
			       (move-to-window-line 0)
			       (move-beginning-of-line nil)
			       (setq evil-this-type 'inclusive)
			       (call-interactively #'evil-find-char))
		   :initial-point
		   (lambda ()
		     (move-to-window-line 0)
		     (move-beginning-of-line nil))
		   :bind ((evil-cross-lines t)))
    (evilem-define (kbd "j") #'next-line
		   :bind ((goal-column (current-column)))
		   :pre-hook (setq evil-this-type 'line))
    (evilem-define (kbd "J") #'previous-line
		   :bind ((goal-column (current-column)))
		   :pre-hook (setq evil-this-type 'line))
    (evilem-define (kbd "t")
		   #'evil-repeat-find-char
		   :name 'move-to
		   :pre-hook (save-excursion
			       (setq evil-this-type 'inclusive)
			       (call-interactively #'evil-find-char-to))
		   :scope 'line
		   :bind ((evil-cross-lines t)))
    (evilem-define (kbd "T")
		   #'evil-repeat-find-char-reverse
		   :name 'move-to-reverse
		   :pre-hook (save-excursion
			       (setq evil-this-type 'exclusive)
			       (call-interactively #'evil-find-char-to))
		   :scope 'line
		   :bind ((evil-cross-lines t)))
    (evilem-define (kbd "f")
		   #'evil-repeat-find-char
		   :name 'move-at
		   :pre-hook (save-excursion
			       (setq evil-this-type 'inclusive)
			       (call-interactively #'evil-find-char))
		   :scope 'line
		   :bind ((evil-cross-lines t)))

    (evilem-define (kbd "F")
		   #'evil-repeat-find-char-reverse
		   :name 'move-at-reverse
		   :pre-hook (save-excursion
			       (setq evil-this-type 'exclusive)
			       (call-interactively #'evil-find-char))
		   :scope 'line
		   :bind ((evil-cross-lines t))))
    
  ;; (evilem-define (kbd "t") 'evil-find-char-to :scope 'line)
  ;; (evilem-define (kbd "T") 'evil-find-char-to-backward :scope 'line)
  ;; (evilem-define (kbd "f") 'evil-find-char :scope 'line)
  ;; (evilem-define (kbd "F") 'evil-find-char-backward :scope 'line))

  (use-package evil-nerd-commenter
    :ensure t
    :bind (:map evil-normal-state-map
		("gc" . evilnc-comment-operator))))

;; Keybindings

(use-package company
  :ensure t
  :config
  (use-package company-quickhelp
    :ensure t
    :config
    (company-quickhelp-mode))
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-minimum-prefix-length 1
	company-idle-delay 0.0))

(use-package flycheck
  :ensure t
  :config
  ;; (defun flycheck-display-error-at-point-soon ()
  ;; "No-op placeholder")

  ;;   (defun init-flycheck-hook ()
  ;;     (remove-hook 'post-command-hook 'flycheck-display-error-at-point-soon 'local)
  ;;     (remove-hook 'focus-in-hook 'flycheck-display-error-at-point-soon 'local))

;; (add-hook 'flycheck-mode-hook 'init-flycheck-hook)
  ;; (setq flycheck-display-errors-delay 10)
  (use-package flycheck-posframe
    :load-path "~/sources/flycheck-posframe/"
    :config
    (add-hook 'flycheck-mode-hook #'flycheck-posframe-mode)
    (flycheck-posframe-configure-pretty-defaults)
    (setq posframe-mouse-banish nil)
    (setq flycheck-posframe-position 'window-top-right-corner)))

(use-package lsp-mode
  :ensure t
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
	 (haskell-mode . lsp)
	 ;; (haskell-mode . (lambda () (message "Calling Direnv") (direnv-update-directory-environment (direnv--directory)) (message "Called Direnv") (message "Calling lsp") (lsp) (message "Called lsp")))
	 ;; (change-major-mode-after-body-hook . (lambda () ))
	 ;; (haskell-mode . direnv--maybe-update-environment)
	 ;; if you want which-key integration
	 (lsp-mode . lsp-enable-which-key-integration))
  :init
  :config
  (use-package lsp-ui :ensure t :commands lsp-ui-mode
    :config
    (add-to-list 'lsp-ui-doc-frame-parameters '(no-accept-focus . t))
    (setq lsp-ui-doc-position 'bottom
	  ;; focus-follows-mouse t
	  lsp-ui-sideline-show-diagnostics nil
	  lsp-ui-sideline-show-hover nil))
  (setq lsp-completion-provider :capf)
  ;; (setq lsp-log-io t)
  (setq inhibit-eol-conversion t)
  (setq lsp-diagnostics-modeline-scope :project)
  (add-hook 'lsp-managed-mode-hook 'lsp-diagnostics-modeline-mode)
  ;; :commands lsp)
  )

(use-package lsp-haskell
  :ensure t
  ;; :defer
  :config
  ;; (setq lsp-haskell-process-path-hie "ghcide")
  ;; (setq lsp-haskell-process-args-hie '())
  ;; (add-hook 'haskell-mode-hook #'lsp)

  ;; Comment/uncomment this line to see interactions between lsp client/server.
  ;; (setq lsp-log-io t)
  )

;; optionally
;; if you are helm user
(use-package lsp-ivy :ensure t :commands lsp-ivy-workspace-symbol)
;; (use-package treemacs
;;   :ensure t
;;   :hook (after-init . (lambda () (progn (treemacs) (other-window 1))))
;;   :config
;;   (use-package lsp-treemacs :ensure t :commands lsp-treemacs-errors-list)
;;   (use-package treemacs-evil :ensure t)
;;   (use-package treemacs-projectile :ensure t)
;;   (treemacs-resize-icons 22)
;;   ;; (treemacs)
;;   )
;; (use-package ayu-theme
;;   :ensure t
;;   :config (load-theme 'ayu-grey t))


(add-hook 'text-mode-hook 'auto-fill-mode)
;; (defun spaces ()
;;   (interactive)
;;   (insert-char ?\s standard-indent))
;; (add-hook 'text-mode-hook (define-key text-mode-map (kbd "TAB") 'spaces))
(add-hook 'text-mode-hook 'flyspell-mode)
(setq-default fill-column 80)

;; optionally if you want to use debugger
;; (use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#1d1f21" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#c9b4cf" "#8abeb7" "#c5c8c6"])
 '(avy-keys
   '(97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116))
 '(avy-style 'at-full)
 '(custom-safe-themes
   '("79278310dd6cacf2d2f491063c4ab8b129fee2a498e4c25912ddaa6c3c5b621e" "e1ef2d5b8091f4953fe17b4ca3dd143d476c106e221d92ded38614266cea3c8b" "c83c095dd01cde64b631fb0fe5980587deec3834dc55144a6e78ff91ebc80b19" "730a87ed3dc2bf318f3ea3626ce21fb054cd3a1471dcd59c81a4071df02cb601" "2cdc13ef8c76a22daa0f46370011f54e79bae00d5736340a5ddfe656a767fddf" "2f1518e906a8b60fac943d02ad415f1d8b3933a5a7f75e307e6e9a26ef5bf570" "4f01c1df1d203787560a67c1b295423174fd49934deb5e6789abd1e61dba9552" "bf387180109d222aee6bb089db48ed38403a1e330c9ec69fe1f52460a8936b66" "dde8c620311ea241c0b490af8e6f570fdd3b941d7bc209e55cd87884eb733b0e" "5b809c3eae60da2af8a8cfba4e9e04b4d608cb49584cb5998f6e4a1c87c057c4" "d74c5485d42ca4b7f3092e50db687600d0e16006d8fa335c69cf4f379dbd0eee" "71e5acf6053215f553036482f3340a5445aee364fb2e292c70d9175fb0cc8af7" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "9efb2d10bfb38fe7cd4586afb3e644d082cbcdb7435f3d1e8dd9413cbe5e61fc" "c4bdbbd52c8e07112d1bfd00fee22bf0f25e727e95623ecb20c4fa098b74c1bd" "5036346b7b232c57f76e8fb72a9c0558174f87760113546d3a9838130f1cdb74" "74ba9ed7161a26bfe04580279b8cad163c00b802f54c574bfa5d924b99daa4b9" "8d7684de9abb5a770fbfd72a14506d6b4add9a7d30942c6285f020d41d76e0fa" "3df5335c36b40e417fec0392532c1b82b79114a05d5ade62cfe3de63a59bc5c6" "76bfa9318742342233d8b0b42e824130b3a50dcc732866ff8e47366aed69de11" "4bca89c1004e24981c840d3a32755bf859a6910c65b829d9441814000cf6c3d0" "990e24b406787568c592db2b853aa65ecc2dcd08146c0d22293259d400174e37" default))
 '(dashboard-footer-messages '("Jack's Emacs setup"))
 '(evilem-style nil)
 '(fci-rule-color "#5c5e5e")
 '(jdee-db-active-breakpoint-face-colors (cons "#0d0d0d" "#81a2be"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#0d0d0d" "#b5bd68"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#0d0d0d" "#5a5b5a"))
 '(lsp-before-initialize-hook '(doom-modeline-update-lsp direnv-update-environment))
 '(lsp-before-open-hook '(doom-modeline-update-lsp direnv-update-environment))
 '(objed-cursor-color "#cc6666")
 '(package-selected-packages
   '(auto-package-update slime direnv ivy-posframe sublimity sublimity-scroll company-quickhelp evil-indent-plus dtrt-indent treemacs-projectile treemacs-evil company-mode counsel-projectile projectile counsel lsp-treemacs lsp-ivy lsp-haskell flycheck lsp-ui lsp-mode doom-modeline fira-code-mode general which-key doom-themes evil-nerd-commenter evil-easymotion evil use-package))
 '(pdf-view-midnight-colors (cons "#c5c8c6" "#1d1f21"))
 '(rustic-ansi-faces
   ["#1d1f21" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#c9b4cf" "#8abeb7" "#c5c8c6"])
 '(vc-annotate-background "#1d1f21")
 '(vc-annotate-color-map
   (list
    (cons 20 "#b5bd68")
    (cons 40 "#c8c06c")
    (cons 60 "#dcc370")
    (cons 80 "#f0c674")
    (cons 100 "#eab56d")
    (cons 120 "#e3a366")
    (cons 140 "#de935f")
    (cons 160 "#d79e84")
    (cons 180 "#d0a9a9")
    (cons 200 "#c9b4cf")
    (cons 220 "#ca9aac")
    (cons 240 "#cb8089")
    (cons 260 "#cc6666")
    (cons 280 "#af6363")
    (cons 300 "#936060")
    (cons 320 "#765d5d")
    (cons 340 "#5c5e5e")
    (cons 360 "#5c5e5e")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(avy-lead-face ((t nil)))
 '(avy-lead-face-0 ((t nil)))
 '(avy-lead-face-1 ((t nil)))
 '(evil-goggles-change-face ((t (:inherit diff-removed))))
 '(evil-goggles-delete-face ((t (:inherit diff-removed))))
 '(evil-goggles-paste-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-add-face ((t (:inherit diff-added))))
 '(evil-goggles-undo-redo-change-face ((t (:inherit diff-changed))))
 '(evil-goggles-undo-redo-remove-face ((t (:inherit diff-removed))))
 '(evil-goggles-yank-face ((t (:inherit diff-changed))))
 '(ivy-posframe-border ((t (:background "#ffffff")))))

;; (use-package haskell-mode :ensure t)
(add-hook 'after-change-major-mode-hook
	  (function (lambda ()
		      (setq evil-shift-width standard-indent))))

(with-eval-after-load "haskell-mode"
  ;; This changes the evil "O" and "o" keys for haskell-mode to make sure that
  ;; indentation is done correctly. See
  ;; https://github.com/haskell/haskell-mode/issues/1265#issuecomment-252492026.
  (defun haskell-evil-open-above ()
    (interactive)
    (evil-digit-argument-or-evil-beginning-of-line)
    (haskell-indentation-newline-and-indent)
    (evil-previous-line)
    (haskell-indentation-indent-line)
    (evil-append-line nil))

  (defun haskell-evil-open-below ()
    (interactive)
    (evil-append-line nil)
    (haskell-indentation-newline-and-indent))

  (evil-define-key 'normal haskell-mode-map
    "o" 'haskell-evil-open-below
    "O" 'haskell-evil-open-above)
  )


(use-package general
  :ensure t
  :config (general-define-key
	   :states 'normal
	   :keymaps 'override
	   :prefix "SPC"
	   :non-normal-prefix "M-SPC"
	   "" nil
	   ;; "/"   '(counsel-rg :which-key "ripgrep") ; You'll need counsel package for this
	   "TAB" '(switch-to-prev-buffer :which-key "previous buffer")
	   "SPC" '(counsel-M-x :which-key "M-x")
	   "w" '(save-buffer :which-key "save")
	   "q" '(evil-quit :which-key "exit")
	   ; Open
	   "od"  '(counsel-find-file :which-key "find files in directory")
	   "ob"  '(ivy-switch-buffer :which-key "buffers list")
	   "op"  '(counsel-projectile-switch-project :which-key "project list")
	   "of"  '(counsel-projectile-find-file :which-key "find files in project")
	   "os"  '(counsel-projectile-rg :which-key "Find file by search")
	   "ot"  '(ansi-term :which-key "open terminal")
	   ;; right
	   "lw"  '(windmove-right :which-key "move right")
	   ;; left
	   "hw"  '(windmove-left :which-key "move left")
	   ;; up
	   "Jw"  '(windmove-up :which-key "move up")
	   "Je" '(next-error :which-key "Previous error")
	   ;; down
	   "jw"  '(windmove-down :which-key "move bottom")
	   "je" '(next-error :which-key "Next error")
	   ;; New window (right|down)
	   "nwl"  '(split-window-right :which-key "split right")
	   "nwj"  '(split-window-below :which-key "split bottom")
	   ;; Delete
	   "dw"  '(delete-window :which-key "delete window")
	   ;; Others
	   "s" '(:keymap lsp-command-map :package lsp-mode :which-key "LSP")
	   ))

(use-package direnv
  :ensure t
  :config
  (direnv-mode)
  (advice-add 'lsp :before (lambda (&optional x) (message "Calling Direnv") (direnv-update-environment) (message "Called Direnv"))))

(provide 'init)
;;; init.el ends here
