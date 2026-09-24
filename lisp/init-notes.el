;;; init-notes.el --- 笔记与写作：Org + Denote + 专注模式 -*- lexical-binding: t; -*-

;; 两个层次：
;;   Org    负责「待办、日程、日记、导出」（文件是你自己安排的）
;;   Denote 负责「一条笔记一个文件」，文件名自带日期和关键词，便于长期积累

;;; ── 日程文件 ────────────────────────────────────────────────────────────
(setq org-directory my/org-directory)
;; 参与「日程视图」（C-c a）的文件。想让笔记里的 TODO 也出现，
;; 把 ~/org/notes 也加进来： (list my/org-directory my/notes-directory)
(setq org-agenda-files (list (expand-file-name "inbox.org" my/org-directory)
                             (expand-file-name "tasks.org" my/org-directory)))
(setq org-default-notes-file (expand-file-name "inbox.org" my/org-directory))

;;; ── Org 基本设置 ────────────────────────────────────────────────────────
(setq org-startup-folded 'content          ; 打开时展开到二级标题
      org-startup-with-inline-images t
      org-hide-leading-stars t
      org-adapt-indentation nil            ; 正文不跟着标题自动缩进（写中文省心）
      org-return-follows-link t
      org-use-sub-superscripts '{}         ; 免得笔记里的 a_b 变成下标
      org-fontify-quote-and-verse-blocks t
      org-ellipsis " …"
      org-catch-invisible-edits 'show
      org-log-done 'time                   ; 记录完成时间
      org-log-into-drawer t
      org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)"))
      org-refile-targets '((nil :maxlevel . 3) (org-agenda-files :maxlevel . 3))
      org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps nil
      org-refile-allow-creating-parent-nodes 'confirm
      org-agenda-window-setup 'current-window ; 日程直接占用当前窗口，别乱切
      org-agenda-span 7
      org-agenda-start-on-weekday 1
      org-deadline-warning-days 7
      org-src-fontify-natively t
      org-src-tab-acts-natively t
      org-edit-src-content-indentation 0
      org-export-with-smart-quotes t
      org-export-headline-levels 6)        ; 导出时保留 6 级标题（默认只到 3 级）

;; Org 里的代码块可以执行（C-c C-c），顺带支持 Python
(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t) (python . t) (shell . t))))

;;; ── 快速记录模板：C-c c 之后按一个字母 ──────────────────────────────────
;;   t 待办   n 随手笔记   i 灵感/摘抄（会把剪贴板内容一起粘进来）
;;   j 日记（按日期自动归档）   r 读书笔记
(setq org-capture-templates
      `(("t" "待办事项 (TODO)" entry
         (file+headline ,(expand-file-name "tasks.org" my/org-directory) "任务")
         "* TODO %?\n  %U\n  %a\n  %i")
        ("n" "随手笔记" entry
         (file+headline ,(expand-file-name "inbox.org" my/org-directory) "笔记")
         "* %?\n  %U\n  %i")
        ("i" "灵感 / 摘抄" entry
         (file+headline ,(expand-file-name "inbox.org" my/org-directory) "灵感")
         "* %?\n  %U\n  %i\n  %x")
        ("r" "读书笔记" entry
         (file+headline ,(expand-file-name "inbox.org" my/org-directory) "读书")
         "* %?\n  %U\n  %i\n  %x")
        ("j" "日记（按日期归档）" entry
         (file+olp+datetree ,(expand-file-name "journal.org" my/org-directory))
         "* %U %?\n%i")))

;;; ── Denote：一条笔记一个文件 ────────────────────────────────────────────
;; 文件名长这样：20250101T120000--读书笔记的关键词__阅读_写作.org
;; 好处：不依赖数据库，文件名本身就是元数据，十年后照样能打开、能搜、能排序。
(use-package denote
  :ensure t
  :init
  (setq denote-directory (file-name-as-directory my/notes-directory)
        denote-file-type 'org
        denote-known-keywords '("笔记" "阅读" "写作" "工作" "软件" "想法" "待办")
        denote-infer-keywords t
        denote-sort-keywords t
        denote-prompts '(title keywords)      ; 新建笔记时只问标题和关键词
        denote-date-prompt-use-org-read-date t
        denote-rename-confirmations '(rewrite-front-matter modify-file-name))
  :config
  ;; 缓冲区名字显示笔记标题，而不是一长串文件名
  (when (fboundp 'denote-rename-buffer-mode)
    (denote-rename-buffer-mode 1)))

;;; ── 专注写作模式：C-c w 开关（正文居中、留白，像稿纸）──────────────────
(use-package olivetti
  :ensure t
  :init
  (setq olivetti-body-width 88
        olivetti-minimum-body-width 60
        olivetti-recall-visual-line-mode-entry-state t)
  :bind ("C-c w" . olivetti-mode))

;;; ── 启动后直接打开收件箱，坐下就能写 ────────────────────────────────────
;; 想改成别的文件就换文件名；想恢复成 *scratch* 就改成 nil。
(setq initial-buffer-choice
      (lambda ()
        (find-file-noselect (expand-file-name "inbox.org" my/org-directory))))

(provide 'init-notes)
;;; init-notes.el ends here
