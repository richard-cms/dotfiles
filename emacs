(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(inhibit-startup-screen t)
 '(initial-scratch-message "")
 '(mouse-scroll-delay 0.5)
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount (quote (3 ((shift) . 1) ((control))))))

;; delete trailing whitespace in C and python on save
(add-hook 'c-mode-hook (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))
(add-hook 'python-mode-hook (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

;;auxtex settings, for writing LaTex with emacs
;;(eval-after-load "tex-mode" '(progn
;;			       (load "auctex.el" nil nil t)
;;			       (load "preview-latex.el" nil nil t)))

;;(add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
;;(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
;;(add-hook 'LaTeX-mode-hook 'flyspell-mode)
;;(setq TeX-view-program-list '(("Okular" ("okular --unique %o" (mode-io-correlate "#src:%n%b")))))
;;(setq TeX-view-program-selection
;;      '((output-pdf "Okular") (output-dvi "Okular")))

;; make kill/yank behave like copy/paste, using the clipboard
(global-set-key "\C-w" 'clipboard-kill-region)
(global-set-key "\M-w" 'clipboard-kill-ring-save)
(global-set-key "\C-y" 'clipboard-yank)

;; do not make backup files ending with ~ or #
(setq make-backup-files nil)
(setq auto-save-default nil)

;; put the filename in the windowmanager titlebar, or use buffer name
;; otherwise
(setq frame-title-format "%b - emacs")

;; Two real spaces for offsets in c code
(setq c-default-style "bsd"
      c-basic-offset 2)
;; assume .h files are C++, not C
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; In text mode use visual line mode (good wrapping)
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)
(add-hook 'text-mode-hook 'flyspell-mode)

;;newline and indent when hitting return in c mode
(require 'cc-mode)
(define-key c-mode-base-map (kbd "RET") 'newline-and-indent)

;;default to ssh alone for tramp mode
(setq tramp-default-method "ssh")

(let ((default-directory "~/.dotfiles/emacs.d/"))
  (normal-top-level-add-subdirs-to-load-path))

(require 'smart-tab)
(global-smart-tab-mode 1)

;; open with mouse in dired
(add-hook 'dired-mode-hook 'my-dired-mode-hook)
(defun my-dired-mode-hook ()
  (local-set-key (kbd "<mouse-2>") 'dired-mouse-find-file))

(defun dired-mouse-find-file (event)
  "In Dired, visit the file or directory name you click on."
  (interactive "e")
  (require 'cl)
  (flet ((find-file-other-window
          (filename &optional wildcards)
          (find-file filename wildcards)))
	(dired-mouse-find-file-other-window event)))

;; turn on paren match highlighting
(show-paren-mode 1)
;; highlight entire bracket expression
;;(setq show-paren-style 'expression)

;; delete seleted text when typing
(delete-selection-mode 1)

;; show buffer list when completing things
(iswitchb-mode 1)

;; use the CUA undo key. Disables suspend in terminal however...
(global-set-key (kbd "C-z") 'undo)

;; unfill functions, mostly for latex text
(defun unfill-paragraph ()
  "Replace newline chars in current paragraph by single spaces.
This command does the inverse of `fill-paragraph'."
  (interactive)
  (let ((fill-column 90002000)) ; 90002000 is just random. you can use `most-positive-fixnum'
    (fill-paragraph nil)))

(defun unfill-region (start end)
  "Replace newline chars in region by single spaces.
This command does the inverse of `fill-region'."
  (interactive "r")
  (let ((fill-column 90002000))
    (fill-region start end)))

(global-set-key (kbd "C-M-q") 'unfill-region)

;; file shortcuts instead of using bash aliases
;; use C-x r j <register> to get to each one
(set-register ?c (cons 'file "/ssh:luck@cgate.mit.edu|hidsk0002:~/"))
(set-register ?l (cons 'file "/ssh:richard@lxplus.cern.ch:~/"))
(set-register ?o (cons 'file "/ssh:richard@lxplus.cern.ch|cmsusr0.cern.ch|cms-kvm-31:~/"))
(set-register ?m (cons 'file "/ssh:alex@ikandros.com:~/"))

;; rust mode for fun
(add-to-list 'load-path "~/.emacs.d/rust-mode")
(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
