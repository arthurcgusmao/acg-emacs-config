;; adapatations to use Emacs in WSL within MS Windows

;; configure font. For whatever reason Emacs does not start with XFCE4's
;; default monospace font
(defun acg/wsl-set-custom-frame-font (frame)
  "Set my custom font for the frame."
  (interactive)
  (with-selected-frame frame
    (cond
     ((>= (display-pixel-height) 2160) (set-frame-parameter frame 'font "Hack-15")) ; 4k resolution
     ((>= (display-pixel-height) 1440) (set-frame-parameter frame 'font "Hack-10.5")) ; 2560x1440 resolution
     (t (set-frame-parameter frame 'font "Hack-9")))))

(acg/wsl-set-custom-frame-font (selected-frame)) ; Fontify current frame, if any
(add-to-list 'after-make-frame-functions #'acg/wsl-set-custom-frame-font) ; Fontify any future frames
