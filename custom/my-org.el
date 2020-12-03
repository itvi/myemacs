;;; my-org.el --- custom org configuration
;;; Commentary:
;; http://doc.norang.ca/org-mode.html#HowToUseThisDocument
;;; Code:

(use-package org-superstar
  :ensure t
  :defer 1
  :config
  (add-hook 'org-mode-hook (lambda()(org-superstar-mode 1)))
  (setq org-hide-leading-stars nil)
  ;; This line is necessary.
  (setq org-superstar-leading-bullet ?\s)
  )

(use-package org
  ;; :pin manual
  :ensure t
  :commands (org-agenda org-capture)
  :bind(("C-c a" . org-agenda)
        ("C-c c" . org-capture)
        :map org-mode-map
        ("C-c i" . org-clock-in)
        ("C-c o" . org-clock-out)
        ("C-'" . nil)
        )
  :config
  (add-hook 'org-agenda-mode-hook 'org-agenda-to-appt)
  (setq org-agenda-files (list
                          "~/org"
                          "~/org/archive"
                          ))

  ;; TODO keyword
  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!/!)")
                (sequencep "SOMEDAY(s)" "DELAY(l@/!)")
                (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "MEETING"))))

  (setq org-todo-keyword-faces
        (quote (("TODO" :foreground "red" :weight bold)
                ("NEXT" :foreground "cyan" :weight bold)
                ("DONE" :foreground "chartreuse3" :weight bold)
                ("SOMEDAY" :foreground "chartreuse3" :weight bold)
                ("DELAY" :foreground "gold" :weight bold)
                ("WAITING" :foreground "yellow" :weight bold)
                ("HOLD" :foreground "orange" :weight bold)
                ("CANCELLED" :foreground "gray" :weight bold)
                ("MEETING" :foreground "forest green" :weight bold))))

  ;; Tag tasks with GTD-ish contexts
  (setq org-tag-alist '(("@office" . ?o)
                        ("@home" . ?h)
                        ("@project" . ?p)
                        ("@reading" . ?r)
                        ("@bug" . ?b)))
  (setq org-tag-faces
        (quote (("@office" :foreground "red" :background "yellow")
                ("@home" :foreground "black" :background "red")
                ("@project" :foreground "white" :background "blue")
                ("@bug" :foreground "yellow" :background "red")

                )))

  (setq org-capture-templates
        (quote (("i" "inbox" entry (file "~/org/refile.org")
                 "* TODO %?\n%U\n%a\n")
                ("t" "todo" entry (file+datetree "~/org/todo.org")
                 "* TODO %?\n  %U\n  %a\n")
                ("p" "pause" entry (file "~/org/refile.org")
                 "* %? :PAUSE:\n%U\n%a\n" :clock-in t :clock-resume t)
                ("r" "reference" entry (file "~/org/reference.org")
                 "* %? \n%U\n%a\n")
                ;; ("n" "note" entry (file "~/org/refile.org")
                ;;  "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
                ("d" "Diary" entry (file+datetree "~/org/diary.org")
                 "* %?\n%U\n" :clock-in t :clock-resume t)
                ("w" "Work Log" entry (file+datetree "~/org/worklog.org")
                 "* %?\n%U\n" :clock-in t :clock-resume t)
                ("m" "Meeting" entry (file "~/org/refile.org")
                 "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
                ("h" "Habit" entry (file "~/org/refile.org")
                 "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")
                )
               )
        )
  )

(provide 'my-org)
