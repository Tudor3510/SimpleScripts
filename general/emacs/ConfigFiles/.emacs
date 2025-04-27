;;; -*- lexical-binding: t -*-
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(leuven-dark))
 '(package-selected-packages
   '(auctex company company-auctex company-bibtex powershell vterm)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(prefer-coding-system 'utf-8)
(set-language-environment "UTF-8")
(setq default-buffer-file-coding-system 'utf-8)


(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)


(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))


;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Set tab width to 4 spaces
(setq-default tab-width 4)

;; Set tab width to 4 spaces in LaTeX
(setq LaTeX-indent-level 4)


(setq font-latex-fontify-sectioning 'color)
(setq tex-fontify-script nil)
(setq font-latex-fontify-script nil)
(with-eval-after-load 'font-latex
  (set-face-attribute 'font-latex-bold-face nil :weight 'normal))



;; Enable undo-redo support (Emacs 28+ has built-in undo-redo)
(global-set-key (kbd "C-,") 'undo)
(global-set-key (kbd "C-/") 'undo-redo)


(when (eq system-type 'windows-nt)
  (set-face-attribute 'default nil :height 110))
