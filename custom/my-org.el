;;; my-org.el --- custom org configuration
;;; Commentary:
;; http://doc.norang.ca/org-mode.html#HowToUseThisDocument
;;; Code:
;;; https://hugocisneros.com/org-config/
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

(use-package org
  :pin manual ;; :pin org
  ;; :ensure  org-plus-contrib
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
  ;;(setq system-time "C")
  (setq org-agenda-inhibit-startup nil)
  (setq org-startup-folded t)
  ;; Default directory for org file
  (setq
   ;; Default directory for org files
   org-directory "~/org"
   ;; Directory for notes/tasks to be refiled
   org-default-notes-file (concat org-directory "/refile.org")
   ;; Allows to store agenda files in their appropriate files.
   ;; This is useful when per project task lists are used.
   ;; Only show level 1 headings for refiling (level 2 are the task headers)
   org-refile-targets (quote ((nil :maxlevel . 2)
 			                  (org-agenda-files :maxlevel . 2)))
   ;; Org agenda files read from here
   org-agenda-files (list org-directory)
   )
  
  (setq
   ;; Be sure to use the full path for refile setup
   org-refile-use-outline-path 'file
   ;; Set this to nil to use helm/ivy for completion
   org-outline-path-complete-in-steps nil
   ;; Allow refile to create parent tasks with confirmation
   org-refile-allow-creating-parent-nodes 'confirm
   )

;;; Task categories
  (setq org-todo-keywords
	    (quote ((sequence "TODO(t)" "|" "DONE(d!/!)")
		        (sequence "PROJECT(p)" "|" "DONE(d)" "CANCELLED(c)")
		        (sequence "WAITING(w@/!)" "|")
		        (sequence "|" "CANCELLED(c@/!)")
		        (sequence "SOMEDAY(s)" "|" "CANCELLED(c)")
		        (sequence "|" "MEETING")
		        )))

  ;; todo (t) this is the standard task/todo item, which can be marked done
  ;; waiting (w) this keyword is added to a task when I’m waiting to hear back from someone before progressing the task
  ;; cancelled (c) pretty self-explanatory …
  ;; someday (s) this is for tasks that I may want to do at some stage, but not just yet. I still want to keep track of them though.
  ;; project (p) I’m using as a top-level to keep a track of projects.
  ;; On top of this, I’m going to try and use GS/BH’s keyword:
  ;; meeting This will be used for ‘true’ meetings, as well as any other interruptions that may carry on for a long time

  ;;; Colours for the agenda
  (setq
   ;; Coloured faces for agenda/todo items
   org-todo-keyword-faces
   '(
     ("DONE" . (:foreground "#2B4450" :weight bold))
     ("TODO" . (:foreground "#ff3030" :weight bold))
     ("WAITING" . (:foreground "#fe2f92" :weight bold))
     ("CANCELLED" . (:foreground "#999999" :weight bold))
     ("SOMEDAY" . (:foreground "#ab82ff" :weight bold))
     ("MEETING" . (:foreground "#1874cd" :weight bold))
     ))

  ;;; Capture templates
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
                )))
  
  ;; (setq
  ;;  ;; Define the custum capture templates
  ;;  org-capture-templates
  ;;  '(("t" "todo" entry (file+datetree org-default-notes-file)
  ;;     "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
  ;;    ("m" "Meeting/Interruption" entry (file org-default-notes-file)
  ;;     "* MEETING with %? :MEETING:\n%t" :clock-in t :clock-resume t)
  ;;    ;; ("d" "Diary" entry (file+datetree "~/org/diary.org")
  ;;    ;;  "* %?\n%U\n" :clock-in t :clock-resume t)
  ;;    ("i" "Idea" entry (file org-default-notes-file)
  ;;     "* %? :IDEA: \n%t\n" :clock-in t :clock-resume t)
  ;;    ;; ("n" "Next task" entry (file+headline org-default-notes-file "Tasks")
  ;;    ;;  "** NEXT %? \nDEADLINE: %t")
  ;;    ("e" "Respond email" entry (file org-default-notes-file)
  ;;     "* TODO Respond to %:from on %:subject :EMAIL: \nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
  ;;    ("s" "Someday" entry (file org-default-notes-file)
  ;;     "* SOMEDAY %? :SOMEDAY: \n%u\n" :clock-in t :clock-resume t :empty-lines 1)
  ;;    ("p" "Project entry" entry (file org-default-notes-file)
  ;;     "* PROJECT %? :PROJECT: \n%u\n" :clock-in t :clock-resume t :empty-lines 1)
  ;;    )
  ;;  ;; Keep a line between headers
  ;;  org-cycle-separator-lines 1
  ;;  )

  ;;; Tagging tasks
  ;; Everything between :startgroup :endgroup below is a single tag for that task—i.e. you can only choose one. ? gives the shortcut to add the tag.
  ;; Custom tags
  (setq org-tag-alist '((:startgroup . nil)
			            ("@work" . ?w)
			            ("@train" . ?t)
			            ("@home" . ?h)
			            (:endgroup . nil)
			            ("research" . ?r)
			            ("coding" . ?c)
			            ("writing" . ?p)
			            ("emacs" . ?e)
			            ("miscellaneous" . ?m)
			            ("supervision" . ?s)
			            ))
  (setq org-tag-faces
        (quote (("@office" :foreground "red" :background "yellow")
                ("@work" :foreground "red" :background "yellow")
                ("@home" :foreground "black" :background "red")
                ("@project" :foreground "white" :background "blue")
                ("@bug" :foreground "yellow" :background "red")
                )))

  ;;; Automatic tagging of tasks
  ;; moving a task to CANCELLED adds a :CANCELLED: tag
  ;; moving a task to a done state removes cancelled tags
  (setq org-todo-state-tags-triggers
        (quote(
               ;; Move to cancelled adds the cancelled tag
	           ("CANCELLED" ("CANCELLED" . t))
	           ;; Move to waiting adds the waiting tag
	           ("WAITING" ("WAITING" . t))
	           ;; Move to a done state removes waiting/cancelled
	           (done ("WAITING") ("CANCELLED"))
	           ("DONE" ("WAITING") ("CANCELLED"))
	           ;; Move to todo, removes waiting/cancelled
	           ("TODO" ("WAITING") ("CANCELLED"))
               ;; Move to next, removes waiting/cancelled
               ("NEXT" ("WAITING") ("CANCELLED"))
               )))

  ;;; Finishing tasks
  ;; To make sure that tasks with child tasks are not completed prematurely:
  (setq
   ;; Ensure child dependencies complete before parents can be marked complete
   org-enforce-todo-dependencies t
   )
  
  ;;; Archiving
  ;; Where I'm going to archive stuff
  (setq org-archive-location "archive/%s_archive::")

  ;; How archive files will appear
  (defvar org-archive-file-header-format "#+FILETAGS: ARCHIVE\nArchived entries from file %s\n")

  ;;; Effort
  (setq
   ;; Set column view headings
   org-columns-default-format "%50ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM"
   ;; Set default effort values
   org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")))
   ;; When there's 0 time spent, remove the entry
   org-clock-out-remove-zero-time-clocks t
   )

  ;;; Bling
  (setq org-agenda-category-icon-alist
        `(("TODO" (list (all-the-icons-faicon "tasks")) nil nil :ascent center)))
  ;; (setq
  ;; Add fancy icons to the agenda...
  ;; org-agenda-category-icon-alist
  ;; '(
  ;;   (("TODO" (#("" 0 1 (font-lock-ignore t rear-nonsticky t display (raise -0.24) face (:family "FontAwesome" :height 1.2)))) nil nil :ascent center))
  ;;   ;; (`(("MEETING" ,(list (all-the-icons-faicon "tasks")) nil nil :ascent center)))
  ;;   )
  ;; )
  
  ;;; Agenda View
  ;; some functions
  (defun org-agenda-skip-deadline-if-not-today ()
    "If this function returns nil, the current match should not be skipped.
Otherwise, the function must return a position from where the search
should be continued."
    (ignore-errors
      (let ((subtree-end (save-excursion (org-end-of-subtree t)))
            (deadline-day
             (time-to-days
              (org-time-string-to-time
               (org-entry-get nil "DEADLINE"))))
            (now (time-to-days (current-time))))
        (and deadline-day
             (not (= deadline-day now))
             subtree-end))))
  
  ;; https://orgmode.org/worg/org-tutorials/org-custom-agenda-commands.html
  ;; https://blog.aaronbieber.com/2016/09/24/an-agenda-for-life-with-org-mode.html
  (defun air-org-skip-subtree-if-priority (priority)
    "Skip an agenda subtree if it has a priority of PRIORITY.
     PRIORITY may be one of the characters ?A, ?B, or ?C."
    (let ((subtree-end (save-excursion (org-end-of-subtree t)))
          (pri-value (* 1000 (- org-lowest-priority priority)))
          (pri-current (org-get-priority (thing-at-point 'line t))))
      (if (= pri-value pri-current)
          subtree-end
        nil)))

  (defun air-org-skip-subtree-if-habit ()
    "Skip an agenda entry if it has a STYLE property equal to \"habit\"."
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (if (string= (org-entry-get nil "STYLE") "habit")
          subtree-end
        nil))) 
  ;;; Example:
  ;; (alltodo ""
  ;;          ((org-agenda-skip-function '(or (air-org-skip-subtree-if-habit)
  ;;                                          (air-org-skip-subtree-if-priority ?A)
  ;;                                          (org-agenda-skip-if nil '(scheduled deadline))))
  ;;           (org-agenda-overriding-header "\nUn-scheduled tasks:"))) 
  
  (defun my-skip-unless-waiting ()
    "Skip trees that are not waiting.
    Example: (org-agenda-skip-function 'my-skip-unless-waiting)"
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (if (re-search-forward ":waiting:" subtree-end t)
          nil          ; tag found, do not skip
        subtree-end))) ; tag not found, continue after end of subtree
  
  ;; Custom agenda views
  (setq org-agenda-custom-commands
        '(				; start list
          (" " "Agenda" (
                         ;;(tags-todo "SCHEDULED>=\"<today>\"&<\"<+1d>\""
                         (tags-todo "SCHEDULED=\"<today>\""
                                    ((org-agenda-overriding-header "Today's Schedule:")
                                     (org-agenda-entry-types '(:scheduled))))

                         (tags-todo "SCHEDULED<\"<today>\""
                                    ((org-agenda-overriding-header "Past Schedule:")
                                     (org-agenda-entry-types '(:scheduled))
                                     (org-agenda-skip-function '(or (air-org-skip-subtree-if-habit)
                                                                    ;; https://gnu.huihoo.org/emacs/manual/org/Special-agenda-views.html
                                                                    (org-agenda-skip-entry-if 'todo '("WAITING" "SOMEDAY"))
                                                                    ;; if both scheduled and deadline,show deadline.
                                                                    (org-agenda-skip-if nil '(deadline))))
                                     (org-agenda-sorting-strategy '(priority-down category-keep time-up))
                                     )
                                    )

                         (tags-todo "SCHEDULED=\"<tomorrow>\""
                                    ((org-agenda-overriding-header "Tomorrow's Schedule:")
                                     (org-agenda-entry-types '(:scheduled))))
                         
                         (tags-todo "DEADLINE<\"<today>\""
                                    ((org-agenda-overriding-header "Over Due: (deadline<today)")
                                     (org-agenda-entry-types '(:deadline))))

                         ;; (tags-todo "DEADLINE=\"<today>\"" ((org-agenda-overriding-header "\n-------------------------------\nMust Do Today: (deadline=today)\n-------------------------------")))
                         (tags-todo "DEADLINE=\"<today>\""
                                    ((org-agenda-overriding-header "Must Do Today: (deadline=today)")
                                     (org-agenda-entry-types '(:deadline))))

                         (tags-todo  "DEADLINE>\"<today>\""
                                     ((org-agenda-overriding-header "Upcoming deadlines:")
                                      (org-agenda-entry-types '(:deadline))
                                      (org-agenda-sorting-strategy '(deadline-up))))
                         
                         ;;(agenda "" ((org-agenda-overriding-header "\nAgenda:")))
                         
    	                 ;; Tasks that are unscheduled
    	                 (todo "TODO" ((org-agenda-overriding-header "Unscheduled Tasks:")
    			                       (org-tags-match-list-sublevels nil)
    			                       (org-agenda-todo-ignore-scheduled 'all)))
                         
    	                 ;; Tasks that are waiting or someday
    	                 (todo "WAITING|SOMEDAY" ((org-agenda-overriding-header "Waiting/Someday Tasks:")
    				                              (org-tags-match-list-sublevels nil)))
                         
    	                 )
           
           ;;((org-agenda-compact-blocks t))
           ) ; end list
          ("r" "Research"((tags "research")))
          )
        ;; If an item has a (near) deadline, and is scheduled, only show the deadline.
        ;;org-agenda-skip-scheduled-if-deadline-is-shown t
        )

  ;; custom header
  (custom-set-faces
   '(org-agenda-structure ((t (:foreground "orange" :box (:line-width 1 :color "bisque") :weight bold))))
   )

  ;;; Habits
  (add-to-list 'org-modules 'org-habit t)

  ;; add new line between blocks
  (setq org-agenda-compact-blocks nil)
  (setq org-agenda-block-separator "")

  (add-hook 'org-agenda-mode-hook 'org-agenda-to-appt)

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
  )

(provide 'my-org)
