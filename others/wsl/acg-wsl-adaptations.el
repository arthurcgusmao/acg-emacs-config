;; adapatations to use Emacs in WSL within MS Windows

;; configure font. For whatever reason Emacs does not start with XFCE4's
;; default monospace font
(defun fontify-frame-wsl (frame)
  (set-frame-parameter frame 'font "Hack-9"))

(fontify-frame-wsl nil) ;; Fontify current frame
(push 'fontify-frame-wsl after-make-frame-functions) ;; Fontify any future frames
