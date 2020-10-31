;;; my-org.el --- custom org configuration
;;; Commentary:
;; http://doc.norang.ca/org-mode.html#HowToUseThisDocument
;;; Code:

;; (use-package org-beautify-theme :ensure t
;;   :config
;;   (add-hook 'org-mode-hook (lambda() (load-theme 'org-beautify))))

(use-package org-bullets
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook (lambda() (org-bullets-mode 1))))

(use-package org
  :pin manual
  ;; :defer 1
  :commands (org-agenda org-capture)
  :bind(("C-c a" . org-agenda)
        ("C-c c" . org-capture)
        :map org-mode-map
        ("C-c i" . org-clock-in)
        ("C-c o" . org-clock-out)
        ("C-'" . nil)
        )
  ;; :hook
  ;; ((org-agenda-mode-hook . org-agenda-to-appt)
  ;;  (org-mode-hook . my/org-mode-hook)
  ;;  )
  :config
  ;; (add-hook 'org-mode-hook (lambda ()
  ;;                            (set-face-attribute 'org-level-1 nil :height 1.0)
  ;;                            (set-face-attribute 'org-level-2 nil :height 0.9)
  ;;                            (set-face-attribute 'org-level-3 nil :height 0.8)
  ;;                            (set-face-attribute 'org-level-4 nil :height 0.7)
  ;;                            (set-face-attribute 'org-level-5 nil :height 0.6)
  ;;                            ))
  (add-hook 'org-agenda-mode-hook 'org-agenda-to-appt)
  ;; Agenda setup
  (setq org-agenda-files (list
                          "~/org"
                          "~/org/archive"
                          ))

  ;;(global-set-key (kbd "C-c a") 'org-agenda) ;; kbd <f12>

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

  ;; fast TODO selection
  (setq org-use-fast-tag-selection t)
  ;; allows changing TODO states with S-left/right
  (setq org-treat-S-cursor-todo-selection-as-state-change nil)

  ;; TODO state triggers
  (setq org-todo-state-tags-triggers
        (quote (("CANCELLED" ("CANCELLED" . t))
                ("WAITING" ("WAITING" . t))
                ("HOLD" ("WAITING") ("HOLD" . t))
                (done ("WAITING") ("HOLD"))
                ("TODO" ("WAITING") ("CANCELLED") ("HOLD") ("INBOX"))
                ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
                ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

  (setq org-default-notes-file "~/org/refile.org")

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

  ;; ;; Color tags based on regex
  ;; ;; https://stackoverflow.com/questions/40876294/color-tags-based-on-regex-emacs-org-mode
  ;; (add-to-list 'org-tag-faces '("@.*" . (:foreground "cyan")))
  ;; (add-to-list 'org-tag-faces '("qa" . (:foreground "red" :background "yellow")))
  ;; (add-to-list 'org-tag-faces '("project" . (:foreground "yellow" :background "red")))

  ;; ;; Reset the global variable to nil, just in case org-mode has already beeen used.
  ;; (when org-tags-special-faces-re
  ;;   (setq org-tags-special-faces-re nil))

  ;; (defun org-get-tag-face (kwd)
  ;;   "Get the right face for a TODO keyword KWD.
  ;; If KWD is a number, get the corresponding match group."
  ;;   (if (numberp kwd) (setq kwd (match-string kwd)))
  ;;   (let ((special-tag-face (or (cdr (assoc kwd org-tag-faces))
  ;;                               (and (string-match "^@.*" kwd) (cdr (assoc "@.*" org-tag-faces)))
  ;;                               (and (string-match "qa" kwd) (cdr (assoc "qa" org-tag-faces)))
  ;;                               (and (string-match "project" kwd) (cdr (assoc "project" org-tag-faces)))
  ;;                               )))
  ;;     (or (org-face-from-face-or-color 'tag 'org-tag special-tag-face)
  ;;         'org-tag)))

  ;; ===================================================================
  ;; Capture
  ;; ===================================================================
  ;;(global-set-key (kbd "C-c c") 'org-capture)
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
                 "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))
  ;; --------------------
  ;; end capture
  ;; --------------------

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


  ;; ===================================================================
  ;; Custom agenda views
  ;; ===================================================================
  ;; Do not dim blocked tasks
  (setq org-agenda-dim-blocked-tasks nil)

  ;; Compact the block agenda view
  (setq org-agenda-compact-blocks t)

  ;; Custom agenda command definitions
  (setq org-agenda-custom-commands
        (quote (("N" "Notes" tags "NOTE"
                 ((org-agenda-overriding-header "Notes")
                  (org-tags-match-list-sublevels t)))
                ("h" "Habits" tags-todo "STYLE=\"habit\""
                 ((org-agenda-overriding-header "Habits")
                  (org-agenda-sorting-strategy
                   '(todo-state-down effort-up category-keep))))
                (" " "Agenda"
                 ((agenda "" nil)
                  (tags "REFILE"
                        ((org-agenda-overriding-header "Tasks to Refile")
                         (org-tags-match-list-sublevels nil)))
                  (tags-todo "-CANCELLED/!"
                             ((org-agenda-overriding-header "Stuck Projects")
                              (org-agenda-skip-function 'bh/skip-non-stuck-projects)
                              (org-agenda-sorting-strategy
                               '(category-keep))))
                  (tags-todo "-HOLD-CANCELLED/!"
                             ((org-agenda-overriding-header "Projects")
                              (org-agenda-skip-function 'bh/skip-non-projects)
                              (org-tags-match-list-sublevels 'indented)
                              (org-agenda-sorting-strategy
                               '(category-keep))))
                  (tags-todo "-CANCELLED/!NEXT"
                             ((org-agenda-overriding-header (concat "Project Next Tasks"
                                                                    (if bh/hide-scheduled-and-waiting-next-tasks
                                                                        ""
                                                                      " (including WAITING and SCHEDULED tasks)")))
                              (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
                              (org-tags-match-list-sublevels t)
                              (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-sorting-strategy
                               '(todo-state-down effort-up category-keep))))
                  (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                             ((org-agenda-overriding-header (concat "Project Subtasks"
                                                                    (if bh/hide-scheduled-and-waiting-next-tasks
                                                                        ""
                                                                      " (including WAITING and SCHEDULED tasks)")))
                              (org-agenda-skip-function 'bh/skip-non-project-tasks)
                              (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-sorting-strategy
                               '(category-keep))))
                  (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
                             ((org-agenda-overriding-header (concat "Standalone Tasks"
                                                                    (if bh/hide-scheduled-and-waiting-next-tasks
                                                                        ""
                                                                      " (including WAITING and SCHEDULED tasks)")))
                              (org-agenda-skip-function 'bh/skip-project-tasks)
                              (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-sorting-strategy
                               '(category-keep))))
                  (tags-todo "-CANCELLED+WAITING|HOLD/!"
                             ((org-agenda-overriding-header (concat "Waiting and Postponed Tasks"
                                                                    (if bh/hide-scheduled-and-waiting-next-tasks
                                                                        ""
                                                                      " (including WAITING and SCHEDULED tasks)")))
                              (org-agenda-skip-function 'bh/skip-non-tasks)
                              (org-tags-match-list-sublevels nil)
                              (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
                              (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)))
                  (tags "-REFILE/"
                        ((org-agenda-overriding-header "Tasks to Archive")
                         (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
                         (org-tags-match-list-sublevels nil))))
                 nil))))

  ;; color file name in agenda view
  (add-hook 'org-finalize-agenda-hook
            (lambda ()
              (org-agenda-color-category "todo:" "wheat1" "black")
              (org-agenda-color-category "project:" "SeaGreen1" "black")
              (org-agenda-color-category "refile:" "yellow" "black")
              
              ))

  (defun org-agenda-color-category (category backcolor forecolor)
    "color agenda header."
    (let ((re (rx-to-string `(seq bol (0+ space) ,category (1+ space)))))
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward re nil t)
          (add-text-properties (match-beginning 0) (match-end 0)
                               (list 'face (list :background backcolor :foreground forecolor)))))))

  ;; --------------------
  ;; end custom agenda views
  ;; --------------------

  ;; ===================================================================
  ;; Clock
  ;; ===================================================================
  ;; Removes clocked tasks with 0:00 duration
  (setq org-clock-out-remove-zero-time-clocks t)

  ;; Resume clocking task when emacs is restarted
  (org-clock-persistence-insinuate)
  ;;
  ;; Show lot of clocking history so it's easy to pick items off the C-F11 list
  (setq org-clock-history-length 23)
  ;; Resume clocking task on clock-in if the clock is open
  (setq org-clock-in-resume t)
  ;; Change tasks to NEXT when clocking in
  (setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
  ;; Separate drawers for clocking and logs
  (setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
  ;; Save clock data and state changes and notes in the LOGBOOK drawer
  (setq org-clock-into-drawer t)
  ;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
  (setq org-clock-out-remove-zero-time-clocks t)
  ;; Clock out when moving task to a done state
  (setq org-clock-out-when-done t)
  ;; Save the running clock and all clock history when exiting Emacs, load it on startup
  (setq org-clock-persist t)
  ;; Do not prompt to resume an active clock
  (setq org-clock-persist-query-resume nil)
  ;; Enable auto clock resolution for finding open clocks
  (setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
  ;; Include current clocking task in clock reports
  (setq org-clock-report-include-clocking-task t)

  (setq bh/keep-clock-running nil)

  (defun bh/clock-in-to-next (kw)
    "Switch a task from TODO to NEXT when clocking in.
Skips capture tasks, projects, and subprojects.
Switch projects and subprojects from NEXT back to TODO"
    (when (not (and (boundp 'org-capture-mode) org-capture-mode))
      (cond
       ((and (member (org-get-todo-state) (list "TODO"))
             (bh/is-task-p))
        "NEXT")
       ((and (member (org-get-todo-state) (list "NEXT"))
             (bh/is-project-p))
        "TODO"))))

  (defun bh/find-project-task ()
    "Move point to the parent (project) task if any"
    (save-restriction
      (widen)
      (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
        (while (org-up-heading-safe)
          (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
            (setq parent-task (point))))
        (goto-char parent-task)
        parent-task)))

  (defun bh/punch-in (arg)
    "Start continuous clocking and set the default task to the
selected task.  If no task is selected set the Organization task
as the default task."
    (interactive "p")
    (setq bh/keep-clock-running t)
    (if (equal major-mode 'org-agenda-mode)
        ;;
        ;; We're in the agenda
        ;;
        (let* ((marker (org-get-at-bol 'org-hd-marker))
               (tags (org-with-point-at marker (org-get-tags-at))))
          (if (and (eq arg 4) tags)
              (org-agenda-clock-in '(16))
            (bh/clock-in-organization-task-as-default)))
      ;;
      ;; We are not in the agenda
      ;;
      (save-restriction
        (widen)
                                        ; Find the tags on the current task
        (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
            (org-clock-in '(16))
          (bh/clock-in-organization-task-as-default)))))

  (defun bh/punch-out ()
    (interactive)
    (setq bh/keep-clock-running nil)
    (when (org-clock-is-active)
      (org-clock-out))
    (org-agenda-remove-restriction-lock))

  (defun bh/clock-in-default-task ()
    (save-excursion
      (org-with-point-at org-clock-default-task
                         (org-clock-in))))

  (defun bh/clock-in-parent-task ()
    "Move point to the parent (project) task if any and clock in"
    (let ((parent-task))
      (save-excursion
        (save-restriction
          (widen)
          (while (and (not parent-task) (org-up-heading-safe))
            (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
              (setq parent-task (point))))
          (if parent-task
              (org-with-point-at parent-task
                                 (org-clock-in))
            (when bh/keep-clock-running
              (bh/clock-in-default-task)))))))

  (defvar bh/organization-task-id "eb155a82-92b2-4f25-a3c6-0304591af2f9")

  (defun bh/clock-in-organization-task-as-default ()
    (interactive)
    (org-with-point-at (org-id-find bh/organization-task-id 'marker)
                       (org-clock-in '(16))))

  (defun bh/clock-out-maybe ()
    (when (and bh/keep-clock-running
               (not org-clock-clocking-in)
               (marker-buffer org-clock-default-task)
               (not org-clock-resolving-clocks-due-to-idleness))
      (bh/clock-in-parent-task)))

  (add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)
  ;; --------------------
  ;; end clock
  ;; --------------------

  ;; ===================================================================
  ;; GTD stuff
  ;; ===================================================================
  ;; 只显示当天的议程
  (setq org-agenda-span 'day)
  ;; disable the default or- mode stuck
  (setq org-stuck-projects (quote ("" nil nil "")))

  (defun bh/is-project-p ()
    "Any task with a todo keyword subtask"
    (save-restriction
      (widen)
      (let ((has-subtask)
            (subtree-end (save-excursion (org-end-of-subtree t)))
            (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
        (save-excursion
          (forward-line 1)
          (while (and (not has-subtask)
                      (< (point) subtree-end)
                      (re-search-forward "^\*+ " subtree-end t))
            (when (member (org-get-todo-state) org-todo-keywords-1)
              (setq has-subtask t))))
        (and is-a-task has-subtask))))

  (defun bh/is-project-subtree-p ()
    "Any task with a todo keyword that is in a project subtree.
Callers of this function already widen the buffer view."
    (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
                                (point))))
      (save-excursion
        (bh/find-project-task)
        (if (equal (point) task)
            nil
          t))))

  (defun bh/is-task-p ()
    "Any task with a todo keyword and no subtask"
    (save-restriction
      (widen)
      (let ((has-subtask)
            (subtree-end (save-excursion (org-end-of-subtree t)))
            (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
        (save-excursion
          (forward-line 1)
          (while (and (not has-subtask)
                      (< (point) subtree-end)
                      (re-search-forward "^\*+ " subtree-end t))
            (when (member (org-get-todo-state) org-todo-keywords-1)
              (setq has-subtask t))))
        (and is-a-task (not has-subtask)))))

  (defun bh/is-subproject-p ()
    "Any task which is a subtask of another project"
    (let ((is-subproject)
          (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
        (while (and (not is-subproject) (org-up-heading-safe))
          (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
            (setq is-subproject t))))
      (and is-a-task is-subproject)))

  (defun bh/list-sublevels-for-projects-indented ()
    "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
    (if (marker-buffer org-agenda-restrict-begin)
        (setq org-tags-match-list-sublevels 'indented)
      (setq org-tags-match-list-sublevels nil))
    nil)

  (defun bh/list-sublevels-for-projects ()
    "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
    (if (marker-buffer org-agenda-restrict-begin)
        (setq org-tags-match-list-sublevels t)
      (setq org-tags-match-list-sublevels nil))
    nil)

  (defvar bh/hide-scheduled-and-waiting-next-tasks t)

  (defun bh/toggle-next-task-display ()
    (interactive)
    (setq bh/hide-scheduled-and-waiting-next-tasks (not bh/hide-scheduled-and-waiting-next-tasks))
    (when  (equal major-mode 'org-agenda-mode)
      (org-agenda-redo))
    (message "%s WAITING and SCHEDULED NEXT Tasks" (if bh/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))

  (defun bh/skip-stuck-projects ()
    "Skip trees that are not stuck projects"
    (save-restriction
      (widen)
      (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
        (if (bh/is-project-p)
            (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                   (has-next ))
              (save-excursion
                (forward-line 1)
                (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
                  (unless (member "WAITING" (org-get-tags-at))
                    (setq has-next t))))
              (if has-next
                  nil
                next-headline)) ; a stuck project, has subtasks but no next task
          nil))))

  (defun bh/skip-non-stuck-projects ()
    "Skip trees that are not stuck projects"
    ;; (bh/list-sublevels-for-projects-indented)
    (save-restriction
      (widen)
      (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
        (if (bh/is-project-p)
            (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
                   (has-next ))
              (save-excursion
                (forward-line 1)
                (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
                  (unless (member "WAITING" (org-get-tags-at))
                    (setq has-next t))))
              (if has-next
                  next-headline
                nil)) ; a stuck project, has subtasks but no next task
          next-headline))))

  (defun bh/skip-non-projects ()
    "Skip trees that are not projects"
    ;; (bh/list-sublevels-for-projects-indented)
    (if (save-excursion (bh/skip-non-stuck-projects))
        (save-restriction
          (widen)
          (let ((subtree-end (save-excursion (org-end-of-subtree t))))
            (cond
             ((bh/is-project-p)
              nil)
             ((and (bh/is-project-subtree-p) (not (bh/is-task-p)))
              nil)
             (t
              subtree-end))))
      (save-excursion (org-end-of-subtree t))))

  (defun bh/skip-non-tasks ()
    "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
    (save-restriction
      (widen)
      (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
        (cond
         ((bh/is-task-p)
          nil)
         (t
          next-headline)))))

  (defun bh/skip-project-trees-and-habits ()
    "Skip trees that are projects"
    (save-restriction
      (widen)
      (let ((subtree-end (save-excursion (org-end-of-subtree t))))
        (cond
         ((bh/is-project-p)
          subtree-end)
         ((org-is-habit-p)
          subtree-end)
         (t
          nil)))))

  (defun bh/skip-projects-and-habits-and-single-tasks ()
    "Skip trees that are projects, tasks that are habits, single non-project tasks"
    (save-restriction
      (widen)
      (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
        (cond
         ((org-is-habit-p)
          next-headline)
         ((and bh/hide-scheduled-and-waiting-next-tasks
               (member "WAITING" (org-get-tags-at)))
          next-headline)
         ((bh/is-project-p)
          next-headline)
         ((and (bh/is-task-p) (not (bh/is-project-subtree-p)))
          next-headline)
         (t
          nil)))))

  (defun bh/skip-project-tasks-maybe ()
    "Show tasks related to the current restriction.
When restricted to a project, skip project and sub project tasks, habits, NEXT tasks, and loose tasks.
When not restricted, skip project and sub-project tasks, habits, and project related tasks."
    (save-restriction
      (widen)
      (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
             (next-headline (save-excursion (or (outline-next-heading) (point-max))))
             (limit-to-project (marker-buffer org-agenda-restrict-begin)))
        (cond
         ((bh/is-project-p)
          next-headline)
         ((org-is-habit-p)
          subtree-end)
         ((and (not limit-to-project)
               (bh/is-project-subtree-p))
          subtree-end)
         ((and limit-to-project
               (bh/is-project-subtree-p)
               (member (org-get-todo-state) (list "NEXT")))
          subtree-end)
         (t
          nil)))))

  (defun bh/skip-project-tasks ()
    "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
    (save-restriction
      (widen)
      (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
        (cond
         ((bh/is-project-p)
          subtree-end)
         ((org-is-habit-p)
          subtree-end)
         ((bh/is-project-subtree-p)
          subtree-end)
         (t
          nil)))))

  (defun bh/skip-non-project-tasks ()
    "Show project tasks.
Skip project and sub-project tasks, habits, and loose non-project tasks."
    (save-restriction
      (widen)
      (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
             (next-headline (save-excursion (or (outline-next-heading) (point-max)))))
        (cond
         ((bh/is-project-p)
          next-headline)
         ((org-is-habit-p)
          subtree-end)
         ((and (bh/is-project-subtree-p)
               (member (org-get-todo-state) (list "NEXT")))
          subtree-end)
         ((not (bh/is-project-subtree-p))
          subtree-end)
         (t
          nil)))))

  (defun bh/skip-projects-and-habits ()
    "Skip trees that are projects and tasks that are habits"
    (save-restriction
      (widen)
      (let ((subtree-end (save-excursion (org-end-of-subtree t))))
        (cond
         ((bh/is-project-p)
          subtree-end)
         ((org-is-habit-p)
          subtree-end)
         (t
          nil)))))

  (defun bh/skip-non-subprojects ()
    "Skip trees that are not projects"
    (let ((next-headline (save-excursion (outline-next-heading))))
      (if (bh/is-subproject-p)
          nil
        next-headline)))

  ;; --------------------
  ;; end GTD
  ;; --------------------

  ;; ===================================================================
  ;; Archive
  ;; ===================================================================
  (setq org-archive-mark-done nil)
  (setq org-archive-location "%s_archive::* Archived Tasks")
  (defun bh/skip-non-archivable-tasks ()
    "Skip trees that are not available for archiving"
    (save-restriction
      (widen)
      ;; Consider only tasks with done todo headings as archivable candidates
      (let ((next-headline (save-excursion (or (outline-next-heading) (point-max))))
            (subtree-end (save-excursion (org-end-of-subtree t))))
        (if (member (org-get-todo-state) org-todo-keywords-1)
            (if (member (org-get-todo-state) org-done-keywords)
                (let* ((daynr (string-to-number(format-time-string "%d" (current-time))))
                       (a-month-ago (* 60 60 24 (+ daynr 1)))
                       (last-month (format-time-string "%Y-%m-" (time-subtract (current-time) (seconds-to-time a-month-ago))))
                       (this-month (format-time-string "%Y-%m-" (current-time)))
                       (subtree-is-current (save-excursion
                                             (forward-line 1)
                                             (and (< (point) subtree-end)
                                                  (re-search-forward (concat last-month "\\|" this-month) subtree-end t)))))
                  (if subtree-is-current
                      subtree-end ; Has a date in this month or last month, skip it
                    nil))  ; available to archive
              (or subtree-end (point-max)))
          next-headline))))
  ;; --------------------
  ;; end archive
  ;; --------------------

  ;; collapse the current outline
  ;; when the cursor in "Here is another line",press TAB the collapse ** Section A
  ;; * First headline
  ;; * Second headline
  ;; ** Section A
  ;;    Here is one line
  ;;    Here is another line
  ;;    blah, blah
  ;; ** Section B
  ;; (setq org-cycle-emulate-tab 'white)

  ;; Habit tracing
  ;; 1. customize-variables RET org-modules RET habit
  (setq org-habit-graph-column 60)
  ;;(setq org-habit-show-habits-only-for-today nil)

  ;; org-level headers font size
  ;; (defun my/org-mode-hook ()
  ;;   "Stop the org-level headers from increasing in height relative to the other text."
  ;;   (dolist (face '(org-level-1
  ;;                   org-level-2
  ;;                   org-level-3
  ;;                   org-level-4
  ;;                   org-level-5))
  ;;     (set-face-attribute face nil :weight 'semi-bold :height 0.8))
  ;;   ;; use english language
  ;;   (setq system-time-locale "C")
  ;;   )

  (setq system-time-locale "C")

 ;;; appt
  (setq
   appt-message-warning-time 2  ;提前2分钟提醒
   appt-display-interval 1      ;每过1分钟提醒一次
   ;;appt-display-duration 20   ;这里已经被notify-send接管了，所以此处持续时间无效。
   appt-display-mode-line t     ;; show in the modeline
   appt-display-format 'window) ;; use our func

  (appt-activate 1)             ;; active appt (appointment notification)
  ;;(display-time)              ;; time display is required for this...(will break spaceline)

  ;; 提醒
  ;; (defun djcb-popup (title msg &optional icon sound)
  ;;   "Show a popup if we're on X,or echo it otherwise.
  ;;    TITLE is the title of the message,
  ;;    MSG is the context.
  ;;    Optionally, you can provide an ICON and a SOUND to be played."
  ;;   (interactive)
  ;;   (if (eq window-system 'x)
  ;;       (shell-command (concat "notify-send "
  ;;                              (if icon (concat "-i " icon) "")
  ;;                              " '" title "' '" msg "' -t 30000"));持续显示30秒
  ;;     (message (concat title ": " msg)))
  ;;   ;;(when sound (shell-command (concat "mplayer -really-quiet " sound " 2> /dev/null")))
  ;;   (when sound (play-sound-file sound))
  ;;   )

  ;; ;; our little façade-function for djcb-popup
  ;; (defun djcb-appt-display (min-to-app new-time msg)
  ;;   "Display pop window's icon and sound.
  ;;   MIN-TO-APP: minutes,NEW-TIME:new time,MSG:message"
  ;;   (djcb-popup (format "Appointment in %s minute(s)" min-to-app) msg
  ;;               ;; display pop window
  ;;               "~/myemacs/resource/info_org.png"
  ;;               "~/myemacs/resource/ring.wav"))

  ;; (setq appt-disp-window-function (function djcb-appt-display))

  ;; overwrite built-in function
  ;;(proviError running timer appt-delete-window':
  ;;    (error "No buffer named *appt-buf*")de 'init-org)
  ;;(defun appt-delete-window () "Nothing.Overwrite built-in function." )

  ;;====================
  ;; toast notification
  ;; http://joonro.github.io/blog/posts/toast-notifications-org-mode-windows.html
  ;;====================
  (setq img-path (concat (getenv "HOME") "/myemacs/resource/org_mode.png"))
  ;; set up the call to the notifier
  (defun toast-appt-send-notification (title msg)
    (shell-command (concat "toast" ;; toast add in system PATH
                           " -t \"" title "\""
                           " -m \"" msg "\""
                           " -p " img-path)))

  ;; designate the window function for my-appt-send-notification
  (defun toast-appt-display (min-to-app new-time msg)
    (toast-appt-send-notification
     (format "Appointment in %s minutes" min-to-app)    ;; passed to -t in toast call
     (format "%s" msg)))                                ;; passed to -m in toast call

  ;;====================
  ;; growl notification
  ;;====================
  (defun growl-appt-display (min-to-app new-time msg)
    ;;(start-process "growlnotify" nil "growlnotify" (decode-coding-string(msg)))
    (start-process "growlnotify" nil "growlnotify" msg))

  (cond
   ((eq system-type 'windows-nt)
    (defun windows-version()
      (let ((ver (shell-command-to-string "ver")))
        (string-match "[[:digit:]].[[:digit:]]" ver)
        (match-string 0 ver)
        ))
    (if (equal "6.1" (windows-version))
        (progn
          (setq default-process-coding-system '(cp936 . cp936))
          (setq appt-disp-window-function (function growl-appt-display))) ;; Windows 7
      (progn
        (setq default-process-coding-system '(cp936 . cp936))
        (setq appt-disp-window-function (function toast-appt-display)) ;; Windows 10
        )
      ))
   ((eq system-type 'gnu/linux)
    (setq alert-default-style 'libnotify)
    ))

  (setq appt-delete-window-function (lambda () t))

  )
(provide 'my-org)
