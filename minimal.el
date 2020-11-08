(require 'package)

(setq package-enable-at-startup nil)
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")))
(package-initialize) ; guess what this one does ?

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

(use-package counsel
  :ensure t
  :config
  (use-package ivy-posframe
    :ensure t
    :config
    (ivy-posframe-mode 1))
  (ivy-mode 1)
  (counsel-mode 1))

(provide 'init)
;;; init.el ends here
