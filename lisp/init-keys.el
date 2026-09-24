;;; init-keys.el --- 快捷键 -*- lexical-binding: t; -*-

;; 记号说明：C- 是 Ctrl，M- 是 Alt（Windows 上的 Alt 键），S- 是 Shift。
;; 忘了快捷键不要紧：M-x 输入命令名字，或者 C-h k 再按一个键，Emacs 会告诉你它是干什么的。

(require 'subr-x)   ; 下面用到 string-trim

;;; ── 配置自己 ────────────────────────────────────────────────────────────
(defun my/open-config ()
  "打开本配置文件 init.el。"
  (interactive)
  (find-file (expand-file-name "init.el" user-emacs-directory)))

(defun my/reload-config ()
  "重新加载所有配置模块。
个别设置（字体、主题、快捷键以外的钩子）重新加载后可能不生效，重启 Emacs 最干净。"
  (interactive)
  (dolist (name '("init-base" "init-ui" "init-completion" "init-edit"
                  "init-notes" "init-code" "init-keys"))
    (let ((path (expand-file-name (format "lisp/%s.el" name) user-emacs-directory)))
      (when (file-exists-p path)
        (load path nil 'nomessage))))
  (message "配置已重新加载（有个别项需要重启 Emacs）"))

(global-set-key (kbd "C-c I") #'my/open-config)   ; 打开配置
(global-set-key (kbd "<f5>") #'my/reload-config)  ; 改完配置按 F5

;;; ── 字号（写东西时最常用）──────────────────────────────────────────────
(defun my/font-inc () (interactive) (text-scale-increase 1))
(defun my/font-dec () (interactive) (text-scale-decrease 1))
(defun my/font-reset () (interactive) (text-scale-set 0))
(global-set-key (kbd "C-c =") #'my/font-inc)
(global-set-key (kbd "C-c -") #'my/font-dec)
(global-set-key (kbd "C-c 0") #'my/font-reset)

;;; ── Org：待办、日程、日记 ───────────────────────────────────────────────
(global-set-key (kbd "C-c a") #'org-agenda)       ; 日程总览
(global-set-key (kbd "C-c c") #'org-capture)      ; 快速记录（t 待办 / n 笔记 / i 摘抄 / j 日记）
(global-set-key (kbd "C-c l") #'org-store-link)   ; 存一个链接，之后可以插进笔记
(global-set-key (kbd "C-c h") #'consult-org-heading) ; 跳到当前笔记的某个标题

;;; ── 笔记（Denote）：C-c n 开头 ──────────────────────────────────────────
(defun my/search-notes ()
  "在笔记目录里全文搜索（需要 ripgrep）。"
  (interactive)
  (if (executable-find "rg")
      (consult-ripgrep my/notes-directory)
    (user-error "没找到 ripgrep（rg）。安装：winget install BurntSushi.ripgrep.MSVC")))

(defun my/open-notes-directory ()
  "打开笔记目录，用文件管理器的方式浏览。"
  (interactive)
  (dired my/notes-directory))

(defun my/denote-journal ()
  "打开今天的日记笔记（没有就新建一个）。"
  (interactive)
  (require 'denote-journal-extras nil t)
  (if (fboundp 'denote-journal-extras-new-or-existing-entry)
      (call-interactively #'denote-journal-extras-new-or-existing-entry)
    (user-error "这个版本的 Denote 没有日记功能，M-x list-packages 升级 denote 即可")))

(defvar my/notes-map (make-sparse-keymap) "笔记相关命令的前缀键（C-c n）。")
(global-set-key (kbd "C-c n") my/notes-map)
(define-key my/notes-map (kbd "n") #'denote-open-or-create) ; 新建 / 打开一篇笔记
(define-key my/notes-map (kbd "j") #'my/denote-journal)     ; 今天的日记
(define-key my/notes-map (kbd "s") #'my/search-notes)       ; 全文搜索笔记内容
(define-key my/notes-map (kbd "d") #'my/open-notes-directory)
(define-key my/notes-map (kbd "l") #'denote-link)           ; 插入指向另一篇笔记的链接
(define-key my/notes-map (kbd "b") #'denote-backlinks)      ; 看有哪些笔记提到当前这篇
(define-key my/notes-map (kbd "r") #'denote-rename-file)    ; 改标题 / 关键词（文件名一起改）

;;; ── 主题与查找 ──────────────────────────────────────────────────────────
(global-set-key (kbd "C-c t") #'consult-theme)     ; 预览式切换配色，回车确定
(global-set-key (kbd "C-c f") #'my/search-notes)

;;; ── 缓冲区与窗口 ────────────────────────────────────────────────────────
(global-set-key (kbd "<C-tab>") #'next-buffer)
(global-set-key (kbd "<C-S-tab>") #'previous-buffer)
(global-set-key (kbd "C-x C-b") #'ibuffer)          ; 好看好用的缓冲区列表
;; 窗口之间移动用 C-x o（默认键）；C-x 1 只留当前窗口，C-x 2 / C-x 3 分屏

;;; ── 配置同步：一键提交并推送到 GitHub ──────────────────────────────────
;; ~/.emacs.d 本身就是 git 仓库（远程是 philoemacs），所以改完配置不用拷贝文件，
;; 按 C-c g 就会「暂存 → 提交 → 推送」。想看细节用 C-x g 打开 magit。
(defun my/sync-config ()
  "把 ~/.emacs.d 的改动提交并推送到 GitHub。"
  (interactive)
  (let* ((default-directory (file-name-as-directory user-emacs-directory))
         (log (get-buffer-create "*配置同步*"))
         (fail (lambda (msg)
                 (display-buffer log)
                 (user-error "%s（详情见 *配置同步* 缓冲区）" msg)))
         (git (lambda (args)
                (zerop (apply #'process-file "git" nil log nil args)))))
    (unless (file-directory-p (expand-file-name ".git" default-directory))
      (user-error "配置目录还不是 git 仓库（缺少 ~/.emacs.d/.git）"))
    (with-current-buffer log (erase-buffer))
    (unless (funcall git '("add" "-A"))
      (funcall fail "git add 失败"))
    (if (funcall git '("diff" "--cached" "--quiet"))  ; 返回 0 表示暂存区没有改动
        (message "配置没有改动，无需同步")
      (let ((msg (string-trim (read-string "提交说明（留空自动生成）: "))))
        (when (string-empty-p msg)
          (setq msg (format-time-string "配置同步 %Y-%m-%d %H:%M")))
        (unless (funcall git (list "commit" "-m" msg))
          (funcall fail "git commit 失败"))
        (if (funcall git '("push"))
            (message "已同步到 GitHub：%s" msg)
          (funcall fail "git push 失败（可能需要登录 GitHub）"))))))

(global-set-key (kbd "C-c g") #'my/sync-config)     ; 改完配置：提交并推送

;;; ── 可选：Vim 按键（Evil）───────────────────────────────────────────────
;; 想用 Vim 按键：把 lisp/init-base.el 里的 (defvar my/evil nil) 改成 t，重启 Emacs。
;; 同时建议把 init-edit.el 里的 (cua-mode 1) 注释掉，两者会打架。
;; 注意：这里用 (when my/evil ...) 包起来，my/evil 为 nil 时连插件都不会去下载。
(when my/evil
  (use-package evil
    :ensure t
    :init
    (setq evil-want-integration t
          evil-want-keybinding nil
          evil-undo-system 'undo-redo
          evil-search-module 'evil-search)
    :config
    (evil-mode 1))

  (use-package evil-collection
    :ensure t
    :after evil
    :config
    (evil-collection-init)))

(provide 'init-keys)
;;; init-keys.el ends here
