;; -*- Emacs-Lisp -*-

;; Time-stamp: <2013-11-15 20:05:18 Friday by pein>

(am-add-hooks
 `(c-mode-common-hook lisp-mode-hook emacs-lisp-mode-hook java-mode-hook python-mode-hook)
 'hs-minor-mode)
(defun hs-minor-mode-settings ()
  "settings of `hs-minor-mode'."
  (defvar hs-headline-max-len 30 "*Maximum length of `hs-headline' to display.")

  (setq hs-isearch-open t)

  (defun hs-display-headline ()
    (let* ((len (length hs-headline))
           (headline hs-headline)
           (postfix ""))
      (when (>= len hs-headline-max-len)
        (setq postfix "...")
        (setq headline (substring hs-headline 0 hs-headline-max-len)))
      (if hs-headline (concat headline postfix " ") "")))

  (setq-default mode-line-format
                (append '((:eval (hs-display-headline))) mode-line-format))

  (setq hs-set-up-overlay 'hs-abstract-overlay)

  (defvar hs-overlay-map (make-sparse-keymap) "Keymap for hs minor mode overlay.")

  (eal-define-keys-commonly
   hs-overlay-map
   `(("<mouse-1>" hs-show-block)))

  (defun hs-abstract-overlay (ov)
    (let* ((start (overlay-start ov))
           (end (overlay-end ov))
           (str (format "<%d lines>" (count-lines start end))) text)
      (setq text (propertize str 'face 'hs-block-flag-face 'help-echo (buffer-substring (1+ start) end)))
      (overlay-put ov 'display text)
      (overlay-put ov 'pointer 'hand)
      (overlay-put ov 'keymap hs-overlay-map)))

  (defvar hs-hide-all nil "Current state of hideshow for toggling all.")
  (make-local-variable 'hs-hide-all)
  
  (defun hs-toggle-hiding-all ()
    "Toggle hideshow all."
    (interactive)
    (setq hs-hide-all (not hs-hide-all))
    (if hs-hide-all
        (hs-hide-all)
      (hs-show-all)))

  (defvar fold-all-fun nil "Function to fold all.")
  (make-variable-buffer-local 'fold-all-fun)
  (defvar fold-fun nil "Function to fold.")
  (make-variable-buffer-local 'fold-fun)
  
  (defun toggle-fold-all ()
    "Toggle fold all."
    (interactive)
    (if fold-all-fun
        (call-interactively fold-all-fun)
      (hs-toggle-hiding-all)))

  (defun toggle-fold ()
    "Toggle fold."
    (interactive)
    (if fold-fun
        (call-interactively fold-fun)
      (hs-toggle-hiding)))
  
)

(global-set-key (kbd "C-c e") 'hs-hide-block)
(global-set-key (kbd "C-c E") 'hs-hide-all)
(global-set-key (kbd "C-c s") 'hs-show-block)
;; (global-set-key (kbd "C-c E") 'move-line-down)

(eval-after-load "hideshow"
  '(hs-minor-mode-settings))

(provide 'hs-minor-mode-settings)
