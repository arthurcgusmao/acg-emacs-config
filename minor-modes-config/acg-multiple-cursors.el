(require 'multiple-cursors)

(global-set-key (kbd "C-c m m") 'mc/edit-lines)
(global-set-key (kbd "C-c m n") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c m p") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c m a") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c m r") 'mc/mark-all-in-region)
(global-set-key (kbd "C-c m i l") 'mc/insert-letters)
(global-set-key (kbd "C-c m i n") 'mc/insert-numbers)
(global-set-key (kbd "C-c m v") 'yank)

(define-key mc/keymap (kbd "<escape>") 'mc/keyboard-quit)
(global-set-key (kbd "C-d") 'mc/mark-next-like-this)

;; This file is automatically generated by the multiple-cursors extension.
;; It keeps track of your preferences for running commands with multiple cursors.

(setq mc/cmds-to-run-for-all
      '(
        acg-clipboard-paste-replace-selection
        acg-kill-line-or-region-backwards
        clipboard-kill-region
        clipboard-kill-ring-save
        clipboard-paste-replace-selection
        crux-kill-line-backwards
        crux-smart-open-line-above
        helm-mini
        indent-for-tab-command
        keyboard-escape-quit
        keyboard-quit
        kill-line-or-region
        kill-line-or-region-backwards
        kill-sexp
        mc/mark-all-in-region
        my-super-keyboard-quit
        org-self-insert-command
        prelude-move-beginning-of-line
        sp-kill-hybrid-sexp
        subword-left
        subword-right
        web-mode-attribute-insert
        x-clipboard-yank
        yas-expand
        ))

(setq mc/cmds-to-run-once
      '(
        crux-switch-to-previous-buffer
        helm-M-x
        helm-find-files
        kmacro-end-or-call-macro
        kmacro-start-macro-or-insert-counter
        mouse-set-region
        repeat
        web-mode-mark-and-expand
        ))
