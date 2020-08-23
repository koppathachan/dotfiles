;;; .emacs --- my emacs configuration
;;; Commentary:
;;  Just my Emacs setup.

(require 'package)

;;; Code:
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
 
(setq package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes '(misterioso))
 '(inhibit-startup-screen t)
 '(js-indent-level 2)
 '(package-selected-packages
   '(xref-js2 js2-refactor js2-mode js-mode flycheck swiper ivy magit projectile use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;(use-package evil)
(use-package js2-mode
  :ensure t
  :mode "\\.js\\'"
  :config
  (define-key js-mode-map (kbd "M-.") nil)
  (setq-default js2-ignored-warnings '("msg.extra.trailing.comma")))

(use-package js2-refactor
  :ensure t
  :config
  (js2r-add-keybindings-with-prefix "C-c C-r")
  (add-hook 'js2-mode-hook 'js2-refactor-mode))
  ;;(add-hook 'js2-mode-hook (lambda ()
  ;;(add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

(use-package xref-js2
  :ensure t)
(use-package magit
  :ensure t)
(use-package ivy
  :ensure t)
(use-package swiper
  :ensure t
  :config
  (global-set-key "\C-s" 'swiper))
;; This package requires eslint to be installed globally.
(use-package flycheck
  :ensure t
  :config
  (flycheck-add-mode 'javascript-eslint 'js-mode)
  :init
  (global-flycheck-mode))
;; use eslint with web-mode for jsx files


(use-package projectile
  :ensure t
  :config
  (setq projectile-completion-system 'ivy)
  (global-set-key "\C-x\C-f" 'projectile-find-file)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))

(global-display-line-numbers-mode)

(server-start)
;;; .emacs ends here
