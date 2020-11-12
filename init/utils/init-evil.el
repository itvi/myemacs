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
  :ensure t
  :defer 1)

(use-package evil-org
  :ensure t
  :defer 1
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(provide 'init-evil)
;;; init-evil ends here
