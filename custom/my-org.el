;;; my-org.el --- custom org configuration
;;; Commentary:
;; http://doc.norang.ca/org-mode.html#HowToUseThisDocument
;;; Code:
;;; https://hugocisneros.com/org-config/
;;; https://www.rousette.org.uk/archives/doom-emacs-tweaks-org-journal-and-org-super-agenda/
;;; http://www.i3s.unice.fr/~malapert/emacs_orgmode.html

(use-package org-superstar
  :ensure t
  :defer 1
  :config
  (add-hook 'org-mode-hook (lambda()(org-superstar-mode 1)))
  (setq org-hide-leading-stars nil)
  ;; This line is necessary.
  (setq org-superstar-leading-bullet ?\s)
  )

(use-package org-super-agenda
  :ensure t
  :defer t
  :init
  ;; (setq org-agenda-skip-scheduled-if-done t
  ;;       org-agenda-skip-deadline-if-done t
  ;;       org-agenda-include-deadlines t
  ;;       org-agenda-block-separator nil
  ;;       org-agenda-compact-blocks t
  ;;       org-agenda-start-day nil ;; i.e. today
  ;;       org-agenda-span 1
  ;;       org-agenda-start-on-weekday nil)
  (setq org-agenda-custom-commands
        '(("z" "Super view"
           (
            (agenda "" ((org-agenda-span 'day)
                        (org-super-agenda-groups
                         '((:name "Today"
                                  :time-grid t
                                  :date today
                                  :todo "TODO"
                                  :scheduled today
                                  :order 1)
                           (:discard (:anything))))))
            (alltodo "" ((org-agenda-overriding-header "")
                         (org-super-agenda-groups
                          '(;; Each group has an implicit boolean OR operator between its selectors.
                            (:name "Passed deadline"
                                   :and (:deadline past :todo ("TODO" "WAITING" "HOLD" "NEXT"))
                                   :face (:background "#7f1b19")
                                   :order 0)
                            (:name "Due Soon"
                                   :deadline future
                                   :order 5)
                            (:name "Passed scheduled"
                                   :and (:scheduled past :todo("TODO"))
                                   :order 2)
                            ;; (:name "Work important"
                            ;;        :and (:priority "A" :category "Work" :todo "TODO"))
                            ;; (:name "Work other"
                            ;;        :and (:category "Work" :todo "TODO"))
                            (:name "Important"
                                   :transformer(--> it
                                                    (upcase it)
                                                    (propertize it 'face '(
                                                                           :background "orange"
                                                                           :foreground "red")))
                                   :priority "A")
                            (:priority<= "B"
                                         ;; Show this section after "Today" and "Important", because
                                         ;; their order is unspecified, defaulting to 0. Sections
                                         ;; are displayed lowest-number-first.
                                         :order 7)
                            
                            (:name "Waiting"
                                   :todo "WAITING"
                                   :order 9)
                            (:name "Inbox"
                                   :tag "Inbox")
                            (:name "Trivial"
                                   :todo "SOMEDAY"
                                   :order 100)
                            (:name "Next to do"
                                   :todo "NEXT"
                                   :order 3)
                            ;;(:name "Cancelled"
                            ;;      :todo "CANCELLED")
                            ;;(:discard (:anything))
                            ))))))))
  (setq org-super-agenda-header-map nil) ;; evil working
  
  ;; (custom-set-variables
  ;;  '(org-super-agenda-header-separator 45) ;; show sth.(--) between each headers
  ;;  )
  
  (custom-set-faces
   '(org-super-agenda-header ((t (:box (:line-width 1 :color "grey") :slant italic :weight bold))))
   )
  ;;:config
  ;;(org-super-agenda-mode)
  )

(use-package org
  ;; :pin manual ;; :pin org
  :ensure  org-plus-contrib
  :defer t
  :commands (org-agenda org-capture)
  :bind(("C-c a" . org-agenda)
        ("C-c c" . org-capture)
        :map org-mode-map
        ("C-c i" . org-clock-in)
        ("C-c o" . org-clock-out)
        ("C-'" . nil)
        )
  :config
  (setq system-time "C")
  ;; (setq org-fast-tag-selection-single-key t)
  ;; (setq org-use-fast-todo-selection t)
  ;; (setq org-use-speed-commands t)
  ;; (setq org-src-fontify-natively t)
  ;; (setq org-src-tab-acts-natively t)
  ;; (setq org-agenda-dim-blocked-tasks nil)
  ;; (setq org-agenda-inhibit-startup t)
  ;; (setq org-agenda-use-tag-inheritance nil)
  (setq org-startup-folded 'content)

  (add-hook 'org-mode-hook 'org-super-agenda-mode)
  (add-hook 'org-agenda-mode-hook 'org-agenda-to-appt)
  (setq org-agenda-files (list
                          "~/org"
                          "~/org/archive"
                          ))
  ;; Compact the block agenda view
  (setq org-agenda-compact-blocks t)

  ;; ;; color file name in agenda view
  ;; (add-hook 'org-agenda-finalize-hook
  ;;           (lambda ()
  ;;             (org-agenda-color-category "todo:" "#CC0000" "#EFCABE")
  ;;             (org-agenda-color-category "project:" "#4285F4" "gray")
  ;;             (org-agenda-color-category "refile:" "#2BBBAD" "white")
  ;;             ))

  (defun org-agenda-color-category (category backcolor forecolor)
    "color agenda header."
    (let ((re (rx-to-string `(seq bol (0+ space) ,category (1+ space)))))
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward re nil t)
          (add-text-properties (match-beginning 0) (match-end 0)
                               (list 'face (list :background backcolor :foreground forecolor)))))))
  

  
  ;; TODO keyword
  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!/!)")
                (sequencep "SOMEDAY(s)" "DELAY(l@/!)")
                (sequence "WAITING(w@/!)" "CANCELLED(c@/!)" "MEETING(m)")
                )))

  (setq org-todo-keyword-faces
        (quote (("TODO" :foreground "red" :weight bold)
                ("NEXT" :foreground "cyan" :weight bold)
                ("DONE" :foreground "chartreuse3" :weight bold)
                ("SOMEDAY" :foreground "chartreuse3" :weight bold)
                ("DELAY" :foreground "gold" :weight bold)
                ("WAITING" :foreground "yellow" :weight bold)
                ("CANCELLED" :foreground "gray" :weight bold)
                )))

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
        (quote (("i" "inbox" entry (file "~/org/inbox.org")
                 "* TODO %?\n%U\n%a\n")
                ("t" "todo" entry (file+datetree "~/org/todo.org")
                 "* TODO %?\n  %U\n  %a\n")
                ("p" "pause" entry (file "~/org/refile.org")
                 "* %? :PAUSE:\n%U\n%a\n" :clock-in t :clock-resume t)
                ("r" "reference" entry (file "~/org/reference.org")
                 "* %? \n%U\n%a\n")
                ("d" "diary" entry (file+datetree "~/org/diary.org")
                 "* %?\n%U\n" :clock-in t :clock-resume t)
                ("w" "Work Log" entry (file+datetree "~/org/worklog.org")
                 "* %?\n%U\n" :clock-in t :clock-resume t)
                ("h" "habit" entry (file "~/org/habit.org")
                 "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n")
                )
               )
        )

  ;; ===================================================================
  ;; refile
  ;; ===================================================================
  ;; Targets include this file and any file contributing to the agenda - up to 9 levels deep
  (setq org-refile-targets (quote ((nil :maxlevel . 9)
                                   (org-agenda-files :maxlevel . 9))))

  ;; Use full outline paths for refile targets
  (setq org-refile-use-outline-path t)

  ;; Targets complete directly with IDO
  (setq org-outline-path-complete-in-steps nil)

  ;; Allow refile to create parent tasks with confirmation
  (setq org-refile-allow-creating-parent-nodes (quote confirm))

  ;; Use the current window for indirect buffer display
  (setq org-indirect-buffer-display 'current-window)

  ;; Refile settings
  ;; Exclude DONE state tasks from refile targets
  (defun bh/verify-refile-target ()
    "Exclude todo keywords with a done state from refile targets."
    (not (member (nth 2 (org-heading-components)) org-done-keywords)))

  (setq org-refile-target-verify-function 'bh/verify-refile-target)
  ;; --------------------
  ;; end refile
  ;; --------------------
  )

(provide 'my-org)
