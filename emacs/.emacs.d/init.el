;;; init.el --- emacs configuration continued
;;; Commentary:
;; config that changes a lot

;;; Code:

(setq inhibit-startup-message t)

;; Disable tool bar, menu bar, scroll bar.
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

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
 '(js-indent-level 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(global-display-line-numbers-mode)

(use-package exec-path-from-shell
  :ensure t)
(exec-path-from-shell-initialize)

;;(server-start)
(use-package typescript-mode
  :ensure t)
(use-package go-mode
  :init
  (add-hook 'go-mode-hook
      (lambda ()
        (setq tab-width 4)))
  :config
  (add-hook 'before-save-hook #'gofmt-before-save)
  :ensure t)

(use-package ripgrep
  :ensure t)
;;TODO use lsp-mode for this
;; This package requires eslint to be installed globally.
(use-package flycheck
  :ensure t
  :config
  (flycheck-add-mode 'javascript-eslint 'js-mode)
  :init
  (global-flycheck-mode))

(add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
              (display-buffer-reuse-window
               display-buffer-in-side-window)
              (side            . bottom)
              (reusable-frames . visible)
              (window-height   . 0.33)))

(use-package company
  :ensure t
  :init
  (setq company-idle-delay nil  ; avoid auto completion popup, use TAB
                                ; to show it
        company-tooltip-align-annotations t)
  :hook (after-init . global-company-mode)
  :bind (:map company-active-map
	 ("<return>" . nil)
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0))

(use-package tide
  :ensure t
  :after typescript-mode
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

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
  :bind ("C-x g" . magit-status)
  :ensure t)
(use-package ivy
  :ensure t)
(use-package swiper
  :ensure t
  :config
  (global-set-key "\C-s" 'swiper)
  (global-set-key "\C-r" 'swiper-backward))
;; use eslint with web-mode for jsx files

(use-package projectile
  :ensure t
  :config
  (setq projectile-completion-system 'ivy)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (global-set-key "\C-x\C-f" 'projectile-find-file)
  (projectile-mode +1))
;;; init.el ends here
