;; Handler for MacOS
(when (string-equal system-type "darwin")
  (defun x-clipboard-yank ()
    "Alternative version of `clipboard-yank' for MacOS since the
original mixes the clipboard content with the kill ring."
    (interactive)
    (insert (shell-command-to-string "pbpaste"))))


(defun acg/clipboard-paste-replace-selection-indent ()
  "Paste text from clipboard overwriting the current selection"
  (interactive)
  (if (use-region-p)
      (let ((clipboard-paste-region-beginning (region-beginning)))
        (delete-region (region-beginning) (region-end))
        (x-clipboard-yank)
        (indent-region clipboard-paste-region-beginning (region-end))
        )
    (let ((clipboard-paste-point-start (point)))
      (x-clipboard-yank)
      (indent-region clipboard-paste-point-start (point))
      )))


(defun acg/clipboard-paste-replace-selection ()
  "Paste text from clipboard overwriting the current selection"
  (interactive)
  (if (use-region-p)
      (let ((clipboard-paste-region-beginning (region-beginning)))
        (delete-region (region-beginning) (region-end))
        (x-clipboard-yank)
        ;; (indent-region clipboard-paste-region-beginning (region-end))
        )
    (let ((clipboard-paste-point-start (point)))
      (x-clipboard-yank)
      ;; (indent-region clipboard-paste-point-start (point))
      )))


(defun acg/clipboard-kill-ring-save ()
  "Copies to the clipboard the current active region. If no region is selected,
copies the content of the current line (stripping starting and ending
whitespace)"
  (interactive)
  (if (use-region-p)
      (clipboard-kill-ring-save (region-beginning) (region-end))
    (save-excursion
      (clipboard-kill-ring-save
       (progn (back-to-indentation) (point))
       (progn (end-of-line) (skip-chars-backward " \t") (point))))))

;; (advice-add 'acg/clipboard-kill-ring-save :after #'acg/with-mark-active)
;; (advice-remove 'acg/clipboard-kill-ring-save 'acg/with-mark-active)


(defun acg/clipboard-kill-region-or-line ()
  "Cuts the current selected region (or line content, in the same fashion as
`acg/clipboard-kill-ring-save') to the clipboard."
  (interactive)
  (if (use-region-p)
      (clipboard-kill-region (region-beginning) (region-end))
    (save-excursion
      (clipboard-kill-ring-save
       (progn (back-to-indentation) (point))
       (progn (end-of-line) (skip-chars-backward " \t") (point)))
      (kill-whole-line))))


;;keybindings
(global-set-key (kbd "C-S-C") 'acg/clipboard-kill-ring-save)
(global-set-key (kbd "C-S-X") 'acg/clipboard-kill-region-or-line)
(global-set-key (kbd "C-S-V") 'acg/clipboard-paste-replace-selection)
(global-set-key (kbd "C-v") 'acg/clipboard-paste-replace-selection)
(global-set-key (kbd "<S-insert>") 'acg/clipboard-paste-replace-selection) ;; compatibility with CopyQ (OS clipboard history software)
