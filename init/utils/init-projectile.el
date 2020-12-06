 ;;; init-projectile -- projectile
;;; Commentary:
;;; https://github.com/bbatsov/projectile
;;; https://projectile.readthedocs.io/en/latest/installation/
;;; Code:

(use-package projectile
  :ensure t
  :defer t
  :config
  (setq projectile-completion-system 'ivy)
  )

(provide 'init-projectile)
;;; init-projectile.el ends here
