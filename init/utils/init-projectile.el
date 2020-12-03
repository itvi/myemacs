;;; init-projectile -- projectile
;;; Commentary:
;;; https://github.com/bbatsov/projectile
;;; https://projectile.readthedocs.io/en/latest/installation/
;;; Code:

(use-package projectile
  :ensure t
  :defer 1
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map))
  :config
  (setq projectile-completion-system 'ivy)
  )

(provide 'init-projectile)
;;; init-projectile.el ends here
