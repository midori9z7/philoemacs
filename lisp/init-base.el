;;; init-base.el --- 基础：目录、包管理、编码与中文、备份、使用习惯 -*- lexical-binding: t; -*-

;; 这里是最底层、与插件无关的设置。动这里的值要小心，出了问题先看这一节。

;;; ── 个人目录 ────────────────────────────────────────────────────────────
(defvar my/org-directory (expand-file-name "org" "~")
  "所有 Org 文件（笔记、待办、日记）的根目录：~/org/。")
(defvar my/notes-directory (expand-file-name "notes" my/org-directory)
  "Denote 笔记目录：一条笔记一个文件，放在 ~/org/notes/。")
(defvar my/evil nil
  "是否启用 Vim 按键（Evil）。
默认 nil：使用 Emacs 原生按键（推荐新手）。
想用 Vim 按键就改成 t，然后重启 Emacs。")

;; 目录不存在就顺手建好
(dolist (dir (list my/org-directory my/notes-directory))
  (unless (file-directory-p dir)
    (make-directory dir t)))

;;; ── 插件源与 use-package ────────────────────────────────────────────────
(require 'package)
(setq package-archives '(("gnu"    . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                         ("melpa"  . "https://melpa.org/packages/")))

;; 只在「从没下载过插件清单」时联网刷新一次，之后每次启动都不再联网
;; （真缺哪个插件时，use-package 自己会去刷新）。
(unless (file-exists-p (expand-file-name "archives/melpa/archive-contents" package-user-dir))
  (condition-case err
      (package-refresh-contents)
    (error (message "插件清单下载失败（可能没联网）：%S" err))))

(require 'use-package)
(require 'use-package-ensure nil t)   ; Emacs 30 已内置，老版本需要，加 noerror 更保险
(setq use-package-always-ensure nil   ; 要装插件必须显式写 :ensure t，避免误装内置包
      ;; 注意：这一项必须保持 nil。非 nil 会关掉 use-package 的 :catch，
      ;; 那样某个插件装不上时整个配置会中断加载（我们宁可它只报个警告）。
      use-package-expand-minimally nil)

;;; ── 编码与中文 ──────────────────────────────────────────────────────────
;; 全部统一成 UTF-8；Windows 上默认可能用 GBK，混用就会乱码。
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
;; 子进程（git / rg / python）的输出也按 UTF-8 读
(setq default-process-coding-system '(utf-8 . utf-8))
;; 如果 M-x shell 里 Windows 自带命令的输出变成乱码，把上一行换成：
;; (setq default-process-coding-system '(utf-8-dos . utf-8-unix))

;; Windows 上字体缓存导致大字体卡顿的老问题
(setq inhibit-compacting-font-caches t)
(when (eq system-type 'windows-nt)
  ;; 不去读真实的文件属性，dired / magit 在 Windows 上会快很多
  (setq w32-get-true-file-attributes nil))

;;; ── 外部程序：ripgrep（笔记全文搜索靠它）───────────────────────────────
;; 刚装好的软件有时要重开终端甚至重新登录才进 PATH，
;; 所以这里顺手去几个常见位置找一下，找到就加进搜索路径。
(let ((rg (or (executable-find "rg")
              (car (file-expand-wildcards
                    (expand-file-name
                     "Microsoft/WinGet/Packages/BurntSushi.ripgrep.MSVC_*/ripgrep-*/rg.exe"
                     (or (getenv "LOCALAPPDATA") ""))))
              (car (file-expand-wildcards
                    (expand-file-name
                     (concat "Programs/Microsoft VS Code/*/resources/app/"
                             "node_modules.asar.unpacked/@vscode/ripgrep-universal/bin/win32-x64/rg.exe")
                     (or (getenv "LOCALAPPDATA") "")))))))
  (when rg
    (add-to-list 'exec-path (file-name-directory rg))
    (setenv "PATH" (concat (file-name-directory rg) path-separator (getenv "PATH")))))

;;; ── 文件与自动备份 ──────────────────────────────────────────────────────
;; 备份和自动保存都丢到 ~/.emacs.d/ 下的专门目录，别把笔记目录弄脏。
(let ((backup-dir (expand-file-name "backups/" user-emacs-directory))
      (auto-save-dir (expand-file-name "auto-save/" user-emacs-directory)))
  (dolist (dir (list backup-dir auto-save-dir))
    (unless (file-directory-p dir)
      (make-directory dir t)))
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-save-dir t))
        auto-save-list-file-prefix (expand-file-name "auto-save/list" user-emacs-directory)))
(setq create-lockfiles nil      ; 不要生成 .#xxx 这种锁文件（Windows 上很烦）
      make-backup-files t
      backup-by-copying t       ; Windows 上更保险（有些文件不能直接改名）
      version-control t         ; 备份文件带版本号
      kept-new-versions 10
      kept-old-versions 2
      delete-old-versions t)

;;; ── 使用习惯 ────────────────────────────────────────────────────────────
(setq use-short-answers t)                 ; 问 yes/no 时直接按 y / n
(setq confirm-kill-emacs nil)              ; 退出不追问；想谨慎就改成 'y-or-n-p
(setq uniquify-buffer-name-style 'forward) ; 同名文件在名字里带上层目录
(setq sentence-end-double-space nil)       ; 一个空格也算句末（中英混写更顺手）
(setq use-file-dialog nil)                 ; C-x C-f 用 Emacs 自己的补全
                                           ; （use-dialog-box 在 early-init.el 里已设为 nil）
(setq-default indent-tabs-mode nil
              tab-width 4
              fill-column 80
              cursor-type 'bar
              word-wrap t)
(blink-cursor-mode -1)
(setq ring-bell-function #'ignore)         ; 出错不要「叮」
(setq scroll-conservatively 101            ; 滚动更顺滑
      scroll-margin 2
      next-screen-context-lines 4
      mouse-wheel-progressive-speed t
      frame-resize-pixelwise t)
(setq-default case-fold-search t)          ; 搜索默认忽略大小写

;;; ── 记住状态 / 自动刷新 ─────────────────────────────────────────────────
(savehist-mode 1)              ; 记住历史：M-x、搜索、打开过的文件
(recentf-mode 1)               ; 记住最近打开的文件
(setq recentf-max-saved-items 200
      recentf-exclude '("/elpa/" "/backups/" "/auto-save/" "\\.elc\\'"))
(save-place-mode 1)            ; 再打开文件时回到上次的光标位置
(global-auto-revert-mode 1)    ; 文件在别处被改动时自动刷新
(setq auto-revert-interval 3)
(delete-selection-mode 1)      ; 选中文字后直接打字 = 替换
(electric-pair-mode 1)         ; 自动配对标点 () [] "" ''
(repeat-mode 1)                ; C-x u u u… 可以连按
(winner-mode 1)                ; C-c <left> 撤销窗口布局变化
(show-paren-mode 1)            ; 高亮匹配的括号
(setq show-paren-delay 0.1)

;;; ── Dired（内置文件管理器，C-x d 打开）─────────────────────────────────
(setq dired-dwim-target t)     ; 两个窗口都是 dired 时，复制/移动默认指向另一个窗口
(when (boundp 'dired-kill-when-opening-new-dired-buffer)
  (setq dired-kill-when-opening-new-dired-buffer t))

(provide 'init-base)
;;; init-base.el ends here
