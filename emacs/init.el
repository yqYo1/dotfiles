(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")))
  (package-initialize)
  (use-package leaf :ensure t)

  (leaf leaf-keywords
    :ensure t
    :init
    (leaf blackout :ensure t)
    :config
    (leaf-keywords-init)))

(leaf leaf-convert
  :doc "Convert many format to leaf format"
  :ensure t)

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :global-minor-mode global-auto-revert-mode)
(leaf which-key
  :doc "Display available keybindings in popup"
  :ensure t
  :global-minor-mode t)
(leaf paren
  :doc "highlight matching paren"
  :global-minor-mode show-paren-mode)
(leaf catppuccin-theme
  :doc "color scheme"
  :ensure t)
(load-theme 'catppuccin :no-confirm)
