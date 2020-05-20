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




;; ======= UI Stuff =======
;; Remove window fluff
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
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
  (load-theme 'doom-vibrant t))
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

;; (use-package sublimity
;;   :ensure t
;;   :config
;;   (require 'sublimity)
;;   (require 'sublimity-scroll)
;;   ;; (require 'sublimity-map)
;;   (sublimity-mode 1))

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
    :custom-face
    (ivy-posframe-border ((t (:background "#ffffff"))))
    :config
    (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-bottom-left)))
    ;; (setq ivy-posframe-parameters
    ;; 	  '((left-fringe . 8)
    ;; 	    (right-fringe . 8)))
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
  (setq scroll-step 1)
  (setq scroll-margin 5)
  (setq scroll-conservatively 9999)

  :config
  (evil-mode)
  (define-key evil-normal-state-map "J" 'evil-next-line)
  (define-key evil-normal-state-map "C" 'evil-join)
  (define-key evil-normal-state-map "K" 'evil-previous-line)


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
    (evilem-define (kbd "w") 'evil-forward-word-begin :scope 'line)
    (evilem-define (kbd "W") 'evil-backward-word-begin :scope 'line)
    (evilem-define (kbd "e") 'evil-forward-word-end :scope 'line)
    (evilem-define (kbd "E") 'evil-backward-word-end :scope 'line)

    (evilem-define (kbd "j") #'next-line
		   :bind ((goal-column (current-column)))
		   :pre-hook (setq evil-this-type 'line))
    (evilem-define (kbd "k") #'previous-line
		   :bind ((goal-column (current-column)))
		   :pre-hook (setq evil-this-type 'line))
    (evilem-define (kbd "t")
		   #'evil-repeat-find-char
		   :pre-hook (save-excursion
			       (setq evil-this-type 'inclusive)
			       (call-interactively #'evil-find-char-to))
		   :scope 'line
		   :bind ((evil-cross-lines t)))
    (evilem-define (kbd "T")
		   #'evil-repeat-find-char-reverse
		   :pre-hook (save-excursion
			       (setq evil-this-type 'exclusive)
			       (call-interactively #'evil-find-char-to))
		   :scope 'line
		   :bind ((evil-cross-lines t)))
    (evilem-define (kbd "f")
		   #'evil-repeat-find-char
		   :pre-hook (save-excursion
			       (setq evil-this-type 'inclusive)
			       (call-interactively #'evil-find-char))
		   :scope 'line
		   :bind ((evil-cross-lines t)))

    (evilem-define (kbd "F")
		   #'evil-repeat-find-char-reverse
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
  (use-package flycheck-posframe
    :ensure t
    :config
    (add-hook 'flycheck-mode-hook #'flycheck-posframe-mode)
    (setq flycheck-posframe-position 'window-top-right-corner)))

(use-package lsp-mode
  :ensure t
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
	 (haskell-mode . lsp)
	 ;; if you want which-key integration
	 (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setq lsp-diagnostics-modeline-scope :project)
  (add-hook 'lsp-managed-mode-hook 'lsp-diagnostics-modeline-mode)
  :commands lsp)

(use-package lsp-haskell
  :ensure t
  :config
  (setq lsp-haskell-process-path-hie "/home/jack/.local/bin/ghcide")
  (setq lsp-haskell-process-args-hie '())
  ;; (add-hook 'haskell-mode-hook #'lsp)

  ;; Comment/uncomment this line to see interactions between lsp client/server.
  ;; (setq lsp-log-io t)
  )

;; optionally
(use-package lsp-ui :ensure t :commands lsp-ui-mode)
;; if you are helm user
(use-package lsp-ivy :ensure t :commands lsp-ivy-workspace-symbol)
(use-package treemacs
  :ensure t
  :hook (after-init . (lambda () (progn (treemacs) (other-window 1))))
  :config
  (use-package lsp-treemacs :ensure t :commands lsp-treemacs-errors-list)
  (use-package treemacs-evil :ensure t)
  (use-package treemacs-projectile :ensure t)
  (treemacs-resize-icons 44)
  ;; (treemacs)
  )


(add-hook 'text-mode-hook 'auto-fill-mode)
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
 '(dashboard-footer-messages (quote ("Jack's Emacs setup")))
 '(evilem-style (quote at-full))
 '(lsp-ui-doc-position (quote bottom))
 '(lsp-ui-sideline-show-diagnostics nil)
 '(lsp-ui-sideline-show-hover nil)
 '(package-selected-packages
   (quote
    (direnv ivy-posframe sublimity sublimity-scroll company-quickhelp evil-indent-plus dtrt-indent treemacs-projectile treemacs-evil company-mode counsel-projectile projectile counsel lsp-treemacs lsp-ivy lsp-haskell flycheck lsp-ui lsp-mode doom-modeline fira-code-mode general which-key doom-themes evil-nerd-commenter evil-easymotion evil use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
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

(use-package direnv
  :ensure t
  :config
  (direnv-mode))

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
	   "of"  '(counsel-find-file :which-key "find files")
	   ;; Buffers
	   "ob"  '(ivy-switch-buffer :which-key "buffers list")
	   "op"  '(counsel-projectile-switch-project :which-key "project list")
	   ;; Window
	   "lw"  '(windmove-right :which-key "move right")
	   "hw"  '(windmove-left :which-key "move left")
	   "kw"  '(windmove-up :which-key "move up")
	   "jw"  '(windmove-down :which-key "move bottom")
	   "nwl"  '(split-window-right :which-key "split right")
	   "nwj"  '(split-window-below :which-key "split bottom")
	   "dw"  '(delete-window :which-key "delete window")
	   ;; Errors
	   "je" '(next-error :which-key "Next error")
	   "ke" '(next-error :which-key "Previous error")
	   ;; Others
	   "ot"  '(ansi-term :which-key "open terminal")
	   "s" '(:keymap lsp-command-map :which-key "LSP")
	   ))

(provide 'init)
;;; init.el ends here
