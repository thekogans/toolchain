; setup my color scheme
(set-background-color "black")
(set-foreground-color "lightgray")
(set-border-color "lightgray")
(set-border-color "lightgray")
(set-mouse-color "lightgray")

; force top-and-bottom (vertical) splits
(setq split-width-threshold nil)
;(setq split-height-threshold 0)

; turn off all decorations
(menu-bar-mode nil)
(if window-system
    (tool-bar-mode nil))
;(scroll-bar-mode nil)

(custom-set-variables
 '(show-trailing-whitespace t))

; prompt color
(add-hook 'shell-mode-hook
      (lambda ()
        (face-remap-set-base 'comint-highlight-prompt :inherit nil)))
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

(use-package dape
  :ensure t
  :init
  ;; Pull your Mac's native developer paths directly into Emacs' environment
  (when (eq system-type 'darwin)
    (let ((xcrun-path (string-trim (shell-command-to-string "xcrun -f lldb-dap"))))
      (unless (string-empty-p xcrun-path)
        ;; Add the folder containing lldb-dap to Emacs exec-path
        (add-to-list 'exec-path (file-name-directory xcrun-path))
        ;; Add it to the standard shell PATH for sub-processes
        (setenv "PATH" (concat (getenv "PATH") ":" (file-name-directory xcrun-path)))))))

(with-eval-after-load 'dape
  ;; Bind standard IDE keys for stepping
  (keymap-global-set "<f6>" 'dape-continue)
  (keymap-global-set "<f8>" 'dape-next)        ; Step Over
  (keymap-global-set "<f9>" 'dape-step-in)     ; Step Into
  (keymap-global-set "<f10>" 'dape-step-out)    ; Step Out
  (keymap-global-set "<f11>" 'dape-breakpoint-toggle)    ; Toggle breakpoint

  ;; Configure lldb-dap adapter settings
  (add-to-list 'dape-configs
               `(cpp-mac
                 modes (c-mode c++-mode c-ts-mode c++-ts-mode)
                 ensure dape-ensure-command
                 command "lldb-dap"
                 :request "launch"
                 :type "lldb-dap"
                 ;; Use a comma lambda proxy so Dape evaluates the function at session launch
                 :program ,(lambda () (funcall 'dape-buffer-default))
                 :stopOnEntry t
                 ;; FIX: Replaced string-empty-p with vanilla string= to prevent variable errors
                 :args ,(lambda ()
                          (let ((input (read-string "Arguments (space separated): ")))
                            (if (string= input "")
                                []
                              (vconcat (split-string input " " t))))))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
