;;; init-evil.el --- evil
;;; Commentary:
;;; Code:

(use-package evil
  :ensure t
  :defer 1 
  :config
  (evil-mode)
  )

(use-package evil-magit
  :ensure t)

(provide 'init-evil)
;;; init-evil ends here
