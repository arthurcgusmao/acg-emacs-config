(require 'smartparens-config)

;; smartparens for all modes
(smartparens-global-mode t)

;; enables smartparens' paren highlighting mode and disables emacs default
(show-smartparens-global-mode t) 
(show-paren-mode nil)


;; removing smartparens' default key-bindings (and setting new ones)
(custom-set-variables
 '(sp-override-key-bindings (quote (
				    ;; unsetting paredit bindings
				    ("M-s")
				    ("M-<up>")
				    ("M-<down>")
				    ("M-r")
				    ("C-)")
				    ("C-}")
				    ("C-(")
				    ("C-{")
				    ("M-S")
				    
				    ;; unsetting smartparens bindings
				    ("C-M-f")
				    ("C-M-b")
				    ("C-M-d")
				    ("C-M-a")
				    ("C-S-d")
				    ("C-S-a")
				    ("C-M-e")
				    ("C-M-u")
				    ("C-M-n")
				    ("C-M-p")
				    ("C-M-k")
				    ("C-M-w")
				    ("M-<delete>")
				    ("M-<backspace>")
				    ("C-<right>")
				    ("C-<left>")
				    ("C-M-<left>")
				    ("C-M-<right>")
				    ("M-D")
				    ("C-M-<delete>")
				    ("C-M-<backspace>")
				    ("C-S-<backspace>")
				    ("C-]")
				    ("C-M-]")
				    ("M-F")
				    ("M-B")
				    ))))

(sp--update-override-key-bindings)