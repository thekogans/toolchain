; setup my color scheme
(set-background-color "black")
(set-foreground-color "lightgray")
(set-border-color "lightgray")
(set-border-color "lightgray")
(set-mouse-color "lightgray")

; turn off all decorations
(menu-bar-mode nil)
(if window-system
    (tool-bar-mode nil))
;(scroll-bar-mode nil)

(custom-set-variables
 '(show-trailing-whitespace t))

; hide passwords
(add-hook 'comint-output-filter-functions
  'comint-watch-for-password-prompt)

(setq compile-command "build ")

(defun my-compile ()
  "run build and move the point to the end of the output"
  (interactive)
  (save-excursion
    (let ((original-window (selected-window)))
    (command-execute 'compile)
    (switch-to-buffer-other-window '"*compilation*")
    (goto-char (point-max))
    (select-window original-window))))

(cond
 ((string-equal system-type "cygwin") ; Microsoft Windows
  (require 'windows-path)
  (windows-path-activate))
 ((string-equal system-type "darwin") ; Mac OS X
  (setq mac-option-key-is-meta nil
	mac-command-key-is-meta t
	mac-command-modifier 'meta
	mac-option-modifier 'none))
 ((string-equal system-type "gnu/linux") ; linux
  ))

(set-buffer-file-coding-system 'unix)

(require 'redo)
(global-set-key [(hyper z)] 'undo)
(global-set-key [(hyper shift z)] 'redo)

; my global key map
(global-set-key "\C-x\C-u" 'undo)
(global-set-key "\C-x\C-r" 'query-replace)
(global-set-key "\C-x\C-i" 'grep-find)
(global-set-key "\C-x\C-g" 'indent-region)
(global-set-key [f2] 'bookmark-jump)
(global-set-key [f4] 'next-error)
(global-set-key [f5] 'gdb)
(global-set-key [f7] 'my-compile)

(defun my-development-setup ()
  ; cleanup trailing white space before saving
  (add-hook 'write-file-hooks 'delete-trailing-whitespace)

  ; first arg of arglist to functions: tabbed in once
  ; (default was c-lineup-arglist-intro-after-paren)
  (c-set-offset 'arglist-intro '+)

  ; second line of arglist to functions: tabbed in once
  ; (default was c-lineup-arglist)
  (c-set-offset 'arglist-cont-nonempty '+)

  ; switch/case:  make each case line indent from switch
  (c-set-offset 'case-label '+)

  ; make the ENTER key indent next line properly
  (local-set-key "\C-m" 'newline-and-indent)

  ; make DEL take all previous whitespace with it
  (c-toggle-hungry-state 1)

  ; make open-braces after a case: statement indent to 0 (default was '+)
  (c-set-offset 'statement-case-open 0)

  ; make a #define be left-aligned
  (setq c-electric-pound-behavior (quote (alignleft)))

  ; do not impose restriction that all lines not top-level be indented at least
  ; 1 (was imposed by gnu style by default)
  (setq c-label-minimum-indentation 0)

  (global-font-lock-mode t)
  (setq-default tab-width 4)
  (setq-default indent-tabs-mode nil)
  (setq tab-stop-list '(4 8 12 16))
  (setq c-basic-offset 4))
  ;(c-set-style "awk"))

(add-hook 'c++-mode-hook 'my-development-setup)
(add-hook 'c-mode-hook 'my-development-setup)
(add-hook 'asm-mode-hook 'my-development-setup)

(put 'downcase-region 'disabled nil)
