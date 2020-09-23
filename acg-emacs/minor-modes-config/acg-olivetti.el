(use-package olivetti
  :config
  (setq-default olivetti-body-width 80)

  (define-minor-mode acg/olivetti-mode
    "Toggle buffer-local `olivetti-mode' with additional configs.

Adapted from https://protesilaos.com/codelog/2020-07-16-emacs-focused-editing/"
    :init-value nil
    :global nil
    (if acg/olivetti-mode
        (progn
          (olivetti-mode 1)
          (acg/variable-pitch-mode)
          (set-window-fringes (selected-window) 0 0))
      (olivetti-mode -1)
      (acg/variable-pitch-mode -1)
      (set-window-fringes (selected-window) nil))) ; Use default width
  :bind
  ("<f12>" . acg/olivetti-mode)
  :hook
  (org-mode . acg/olivetti-mode))

(use-package face-remap
  :commands acg/variable-pitch-mode
  :config
  (define-minor-mode acg/variable-pitch-mode
    "Wrapper around `variable-pitch-mode'. Toggle
`variable-pitch-mode', except for `prog-mode'. If `org-mode',
toggle `org-variable-pitch-minor-mode' instead."
    :init-value nil
    :global nil
    (if acg/variable-pitch-mode
        (unless (derived-mode-p 'prog-mode)
            (if (eq major-mode 'org-mode)
                (org-variable-pitch-minor-mode 1)
              (variable-pitch-mode 1)))
      (variable-pitch-mode -1)
      (org-variable-pitch-minor-mode -1)))

  ;; List of possible fonts for variable pitch:
  ;; - Gentium Plus
  ;; - DejaVu Sans, Condensed
  (set-face-attribute 'variable-pitch nil
                      :family "DejaVu Sans"
                      :width 'condensed))

(use-package org-variable-pitch
  :after face-remap)