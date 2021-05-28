;; (use-package ivy
;;   :config
;;   ;; (setq ivy-use-virtual-buffers t)

;;   ;; max size the minibuffer can grow up to
;;   (setq ivy-height 16)
;;   ;; configure regular expression of the search
;;   (setq ivy-re-builders-alist
;;         '((swiper-isearch . regexp-quote)
;;           (t . ivy--regex-ignore-order)))
;;   ;; remove initial ^ from search
;;   (setq ivy-initial-inputs-alist nil)
;;   ;; do not quit the minibuffer when deletion error happens
;;   (setq ivy-on-del-error-function #'ignore)

;;   ;; "IVY HERE" set of functions
;;   ;; ---------------------------
;;   ;; Set of functions that run external commands on the directory of the file
;;   ;; the user was browsing on.

;;   (defun acg/ivy-get-browsing-location ()
;;     "Returns the directory path of the last ivy selection. Meant
;; to be called indirectly during an ivy minibuffer search."
;;     (expand-file-name
;;      (file-name-directory
;;       (concat (ivy-state-directory ivy-last)
;;               (ivy-state-current ivy-last)))))

;;   (defun acg/ivy-here--magit-status ()
;;     "Opens a magit-status buffer where the minibuffer was
;; browsing on and quits the minibuffer."
;;     (interactive)
;;     (ivy-quit-and-run
;;       (magit-status-setup-buffer (acg/ivy-get-browsing-location))))

;;   (defun acg/ivy-here--dired ()
;;     "Opens a dired buffer where the minibuffer was browsing on
;; and quits the minibuffer."
;;     (interactive)
;;     (ivy-quit-and-run (dired (acg/ivy-get-browsing-location))))

;;   (defun acg/ivy-here--grep-vc-or-dir ()
;;     "Performs an RG search on the project (or directory, if not a
;; project) where the minibuffer was browsing on and quits the
;; minibuffer."
;;     (interactive)
;;     (ivy-quit-and-run
;;       (let ((default-directory (acg/ivy-get-browsing-location)))
;;         (call-interactively 'prot/grep-vc-or-dir))))

;;   (defun acg/ivy-here--counsel-rg ()
;;     "Performs an RG search on the project (or directory, if not a
;; project) where the minibuffer was browsing on and quits the
;; minibuffer."
;;     (interactive)
;;     (ivy-quit-and-run
;;       (let ((default-directory (acg/ivy-get-browsing-location)))
;;         (call-interactively 'counsel-rg))))

;;   (defun acg/ivy-alt-done-all ()
;;     ""
;;     (interactive)
;;     (let ((compls (all-completions "" (ivy-state-collection ivy-last))))
;;       (mapc #'find-file-noselect (cdr compls))
;;       (find-file (car compls)))

;;     (let (alt-done-fn)
;;       (cond ((or arg (ivy--prompt-selected-p))
;;              (ivy-immediate-done))
;;             ((setq alt-done-fn (ivy-alist-setting ivy-alt-done-functions-alist))
;;              (funcall alt-done-fn))
;;             (t
;;              (ivy-done))))
;;     )


;;   :bind
;;   (:map ivy-minibuffer-map
;;    ("S-SPC" . nil)
;;    ("<S-return>" . ivy-immediate-done)
;;    ("<C-return>" . ivy-restrict-to-matches)
;;    ("<return>" . ivy-alt-done)
;;    ("TAB" . ivy-partial)
;;    ("C-x g" . acg/ivy-here--magit-status)
;;    ("C-M-g" . acg/ivy-here--magit-status)
;;    ("C-x d" . acg/ivy-here--dired)
;;    ("C-M-d" . acg/ivy-here--dired)
;;    ("M-s g" . acg/ivy-here--grep-vc-or-dir)
;;    ("M-f" . acg/ivy-here--counsel-rg))
;;   :hook (after-init . ivy-mode))




;; isearch keybindings
;; (define-key overriding-terminal-local-map (kbd "S-SPC") nil) ; unbind S-SPC in isearch

;; ;; @todo: use variable `isearch-repeat-on-direction-change' in Emacs >= 28.1

;; old isearch keybindings
;; (define-key isearch-mode-map "\C-f" 'isearch-forward)
;; (define-key isearch-mode-map "\C-g" 'isearch-repeat-forward)
;; (define-key isearch-mode-map (kbd "C-S-G") 'isearch-repeat-backward)
;; (define-key isearch-mode-map (kbd "C-S-V") 'isearch-yank-kill)




;; General completion configs
(use-package emacs
  :straight nil
  :config
  (setq completion-ignore-case t)
  (setq read-file-name-completion-ignore-case t)
  (setq read-buffer-completion-ignore-case t))

(use-package minibuffer
  :straight nil
  :config
  (defun acg/minibuffer-smart-backspace ()
    "Same as <backspace> but acts differently when finding files."
    (interactive)
    (if (and minibuffer-completing-file-name
             (= (char-before) ?/))
        (acg/backward-kill-word)
      (call-interactively 'delete-backward-char)))

  :bind
  (:map minibuffer-local-map
        ("<backspace>" . acg/minibuffer-smart-backspace)))

;; Vertico is a more minimalistic completion than Ivy
(use-package vertico
  :init
  (vertico-mode 1)
  :config
  ;; Disable features that don't go well w/ Vertico
  (advice-add #'vertico--setup :after
              (lambda (&rest _)
                (setq-local completion-auto-help nil
                            completion-show-inline-help nil)))

  (defun acg/vertico-smart-exit ()
    "Same as `vertico-exit' but enters directory when finding files."
    (interactive)
    (if (and minibuffer-completing-file-name
             (string= (substring (vertico--candidate) -1) "/"))
        (vertico-insert)
      (call-interactively 'vertico-exit)))

  :bind
  (:map vertico-map
        ("<S-return>" . vertico-exit-input)
        ("<return>" . acg/vertico-smart-exit)
        ;; ("<C-return>" . vert) ; @todo: see how to narrow selection in vertico -- dual of ivy-restrict-to-matches
        ))



;; Marginalia = Ivy-rich for Vertico
(use-package marginalia
  :after vertico
  :init
  (marginalia-mode)
  ;; @todo: replace ivy-yasnippet
  )



(use-package consult
  :config
  (setq consult-line-start-from-top nil)
  (setq consult-line-point-placement 'match-end)

  ;; @todo: Use `vertico--goto' to make vertico selected candidate start from
  ;; the current line!

;;  ;; Try and fix consult line 'wrapped around' behavior

  ;; (defun consult--line-candidates (top)
  ;; "Return list of line candidates; start from top if TOP non-nil."
  ;; (consult--forbid-minibuffer)
  ;; (consult--fontify-all)
  ;; (let* ((default-cand)
  ;;        (candidates)
  ;;        (line (line-number-at-pos (point-min) consult-line-numbers-widen))
  ;;        (curr-line (line-number-at-pos (point) consult-line-numbers-widen)))
  ;;   (consult--each-line beg end
  ;;     (let ((str (consult--buffer-substring beg end)))
  ;;       (unless (string-blank-p str)
  ;;         (push (consult--location-candidate str (point-marker) line) candidates)
  ;;         (when (and (not default-cand) (>= line curr-line))
  ;;           (setq default-cand candidates)))
  ;;       (setq line (1+ line))))
  ;;   (unless candidates
  ;;     (user-error "No lines"))
  ;;   (setq acg/consult-line--offset (length (cdr default-cand)))
  ;;   (nreverse
  ;;    (if top
  ;;        candidates
  ;;      (let ((before (cdr default-cand)))
  ;;        (setcdr default-cand nil)
  ;;        (nconc before candidates))))))

;;   (defun consult-line (&optional initial start)
;;   "Search for a matching line and jump to the line beginning.

;; The default candidate is a non-empty line closest to point.
;; This command obeys narrowing. Optional INITIAL input can be provided.
;; The search starting point is changed if the START prefix argument is set.
;; The symbol at point and the last `isearch-string' is added to the future history."
;;   (interactive (list nil (not (not current-prefix-arg))))
;;   (let ((candidates (consult--with-increased-gc
;;                      (consult--line-candidates
;;                       (not (eq start consult-line-start-from-top))))))
;;     (consult--read
;;      (cdr candidates)
;;      :prompt "Go to line: "
;;      :annotate (consult--line-prefix)
;;      :category 'consult-location
;;      :sort nil
;;      :require-match t
;;      ;; Always add last isearch string to future history
;;      :add-history (list (thing-at-point 'symbol) isearch-string)
;;      :history '(:input consult--line-history)
;;      :lookup #'consult--line-match
;;      ;; :default (car candidates)
;;      :default nil
;;      ;; Add isearch-string as initial input if starting from isearch
;;      :initial (or initial
;;                   (and isearch-mode (prog1 isearch-string (isearch-done))))
;;      :state (consult--jump-state)))
;;   (vertico--goto 3))

  (defun acg/consult-line ()
    (interactive)
    (let ((vertico-cycle t))
      (call-interactively 'consult-line)))


  ;;; Make completion-at-point work in the minibuffer

  (defun acg/consult-completion-in-region (start end collection &optional predicate)
    "Prompt for completion of region in the minibuffer if non-unique.
Use as a value for `completion-in-region-function'."
    (let* ((initial (buffer-substring-no-properties start end))
           (limit (car (completion-boundaries initial collection predicate "")))
           (metadata (completion-metadata initial collection predicate))
           (category (completion-metadata-get metadata 'category))
           (all (completion-all-completions initial collection predicate
                                            (length initial)))
           (exit-status 'finished)
           (completion
            (cond
             ((atom all) nil)
             ((and (consp all) (atom (cdr all)))
              (setq exit-status 'sole)
              (concat (substring initial 0 limit) (car all)))
             (t (let ((enable-recursive-minibuffers t))
                  (if (eq category 'file)
                      (read-file-name "Completion: "
                                      (file-name-directory initial)
                                      initial t
                                      (file-name-nondirectory initial)
                                      predicate)
                    (completing-read
                     ;; @acg: I have modified the line below to add a space after
                     ;; the original text, so that typing the selection of choice
                     ;; works better with orderless
                     "Completion: " collection predicate t (concat initial " "))))))))
      (if (null completion)
          (progn (message "No completion") nil)
        (delete-region start end)
        (insert (substring-no-properties completion))
        (when-let ((exit (plist-get completion-extra-properties :exit-function)))
          (funcall exit completion exit-status))
        t)))

  (defun acg/consult-completion-at-point ()
    (interactive)
    (let ((completion-in-region-function #'acg/consult-completion-in-region))
      (completion-at-point)))


  ;;; Improve isearch, grep, search by line commands

  (defun acg/consult-ripgrep-project (&optional initial)
    "Same as `consult-ripgrep' but defaults to project
directory."
    (interactive)
    (consult--grep
     "rg"
     "rg --null --line-buffered --color=ansi --max-columns=1000 --smart-case --no-heading --line-number . -e ARG OPTS"
     (rg-project-root default-directory) initial))

  ;; Preselect input
  (advice-add 'consult-line :around #'acg/with-thing-at-point)
  (advice-add 'consult-line :before #'acg/with-marked-input)
  ;; (advice-remove 'consult-line 'acg/with-thing-at-point)
  ;; (advice-remove 'consult-line 'acg/with-marked-input)
  (advice-add 'acg/consult-ripgrep-project :around #'acg/with-thing-at-point)
  (advice-add 'acg/consult-ripgrep-project :before #'acg/with-marked-input)

  :bind
  ;; ("C-M-i" . acg/corfu-orderless-completion-at-point)
  (("C-f" . acg/consult-line)
   ("C-S-F" . consult-multi-occur) ;; @todo: default to all buffers, do not ask
   ("M-f" . acg/consult-ripgrep-project)
   ;; @todo: set C-f to restart search when in consult-line & others
   ("C-M-S-i" . acg/consult-completion-at-point)
   ("C-S-O" . consult-recent-file) ; @todo: disable preview of files
   ("M-g g" . consult-goto-line)
   (:map minibuffer-local-map
         ("C-r" . consult-history))))

;; (use-package orderless
;;   :ensure t
;;   :custom (completion-styles '(orderless))
;;   :config
;;   ;; (setq orderless-style-dispatchers '())
;;   )
(use-package orderless
  :init
  (setq completion-styles '(orderless))
  (setq completion-category-defaults nil)
  (setq completion-category-overrides '((file (styles . (partial-completion))))))



;; Corfu does completion-at-point

(use-package corfu
  :init
  (corfu-global-mode)
  :config
  ;;; Completion with orderless and ability to type text for selection

  ;; This section implements functions to make the functionality described
  ;; above work.

  ;; (defun acg/corfu-complete ()
  ;;   (interactive)
  ;;   (if (corfu-complete)
  ;;       (message "yes")
  ;;     (message "no")))
  ;; (define-key corfu-map (kbd "TAB") 'acg/corfu-complete)

  ;; (defun acg/corfu-complete--insert-space (&rest args)
  ;;   (insert " "))
  ;; (advice-add 'corfu-complete :after #'acg/corfu-complete--insert-space)

  (defun acg/corfu-complete ()
    "Adds a space after calling `completion-at-point' so
orderless can do its magic."
    (interactive)
    (when (completion-at-point) (insert " ")))

  (defvar acg/completion-in-region--original-input nil
    "Store START, END, and BUFFER-SUBSTRING information of the
last call to `completion-in-region'.")

  (defun acg/completion--in-region--save-input (start end collection &optional predicate)
    "Updates the value of `acg/completion-in-region--original-input'.
To be used as advice after `completion--in-region'."
    (setq acg/completion-in-region--original-input
          `(,start ,end ,(buffer-substring start end))))

  (advice-add 'completion--in-region :after #'acg/completion--in-region--save-input)
  ;; (advice-remove 'completion--in-region 'acg/completion--in-region--advice)

  (defun acg/corfu-abort ()
    (interactive)
    ;; Replace region with original text
    (let ((beg (nth 0 acg/completion-in-region--original-input))
          (end (nth 1 acg/completion-in-region--original-input))
          (txt (nth 2 acg/completion-in-region--original-input)))
      (when (> (point) end)
        (setq end (point)))
      (delete-region beg end)
      (insert txt))
    ;; Call regular abort function
    (corfu-abort))

  :bind
  (:map corfu-map
        ("<tab>" . acg/corfu-complete)
        ("<escape>" . acg/corfu-abort)))




;; Test and debug
;; (compl)


;; (setq acg/anticipate-deactivate-mark-flag t)

;; ;; (defun acg/maybe-anticipate-deselection (&rest args)
;; ;;   (when (and delete-selection-mode
;; ;;              (region-active-p)
;; ;;              acg/anticipate-deselection-flag)
;; ;;       (setq deactivate-mark t)
;; ;;     (funcall orig-fun args)))

;; (defun acg/maybe-anticipate-deactivate-mark ()
;;   (when (and delete-selection-mode
;;              (region-active-p)
;;              acg/anticipate-deactivate-mark-flag)
;;     (deactivate-mark)
;;     (setq acg/anticipate-deactivate-mark-flag nil)
;;     (message this-command)))

;; (advice-add 'minibuffer-keyboard-quit :before #'acg/maybe-anticipate-deactivate-mark)
