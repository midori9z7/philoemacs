;;; init-ui.el --- 外观：字体、主题、状态栏、中文排版 -*- lexical-binding: t; -*-

;; 想换字体 / 字号 / 配色，改下面这几行就够了。

;;; ── 可调参数 ────────────────────────────────────────────────────────────
(defvar my/font-mono "Victor Mono"
  "代码与等宽字体。找不到就自动退回 Courier New。
Victor Mono 只有西文，中文由下面的 my/font-cjk 兜底；它的斜体是手写体风格。")
(defvar my/font-cjk "Microsoft YaHei"
  "中文字体：微软雅黑。想用宋体就改成 \"SimSun\"，黑体 \"SimHei\"。")
(defvar my/font-size 120
  "默认字号，120 = 12pt。嫌小就 140，嫌大就 110。")
(defvar my/font-symbol "Segoe UI Symbol")
(defvar my/font-emoji "Segoe UI Emoji")
(defvar my/theme nil
  "启动时加载的配色主题；nil 表示不加载，用 Emacs 默认外观，由你自己挑。
挑好后把名字填在这里，例如 (setq my/theme 'doom-one)。
临时试色用 C-c t（只是预览，不会写进配置）。")

;;; ── 字体 ────────────────────────────────────────────────────────────────
(defun my/apply-fonts (&optional frame)
  "给 FRAME 设置字体；找不到的字体自动退回系统默认，不会报错。"
  (when (display-graphic-p frame)
    (let* ((pick (lambda (name fallback)
                   (if (find-font (font-spec :family name) frame) name fallback)))
           (mono (funcall pick my/font-mono "Courier New"))
           (cjk  (funcall pick my/font-cjk "SimSun"))
           (sym  (funcall pick my/font-symbol "Segoe UI Symbol"))
           (emo  (funcall pick my/font-emoji "Segoe UI Emoji")))
      (set-face-attribute 'default frame :family mono :height my/font-size)
      (dolist (face '(fixed-pitch fixed-pitch-serif))
        (set-face-attribute face frame :family mono :height 1.0))
      (set-face-attribute 'variable-pitch frame :family cjk)
      ;; 中文用雅黑；符号、emoji 各找各的字体，避免出现「豆腐块」
      (set-fontset-font t 'han (font-spec :family cjk) frame)
      (set-fontset-font t 'cjk-misc (font-spec :family cjk) frame)
      (set-fontset-font t 'symbol (font-spec :family sym) frame 'append)
      (set-fontset-font t '(#x1F300 . #x1FAFF) (font-spec :family emo) frame 'append))))

(my/apply-fonts)
(add-hook 'after-make-frame-functions #'my/apply-fonts) ; 新开窗口时也生效

;;; ── 主题配色 ────────────────────────────────────────────────────────────
;; 故意不预设主题。doom-themes 只是把「一大堆可选主题」装上，不等于启用主题。
;;   · 随便试：C-c t 打开列表，上下移动即时预览，回车确定（只对本次有效）
;;   · 定下来：把名字填到上面的 my/theme，重启 Emacs 即生效
;;   · 常见选择：doom-one(深) / doom-one-light(浅) / doom-nord / doom-gruvbox
;;               内置的 modus-vivendi(深) / modus-operandi(浅) 也很好，无需下载
(use-package doom-themes
  :ensure t
  :init
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  :config
  (when my/theme
    (condition-case err
        (load-theme my/theme t)
      (error (message "主题 %s 加载失败：%S（用 C-c t 挑一个）" my/theme err)))
    (doom-themes-org-config)))  ; Org 的标题/表格/代码块配色更清楚

;;; ── 状态栏 ──────────────────────────────────────────────────────────────
(use-package doom-modeline
  :ensure t
  :init
  (setq doom-modeline-icon nil          ; 没装 Nerd 字体就别开图标，否则显示成方块
        doom-modeline-height 26
        doom-modeline-bar-width 4
        doom-modeline-window-width-limit 100
        doom-modeline-buffer-file-name-style 'relative-to-project)
  (doom-modeline-mode 1))

;;; ── 界面元素 ────────────────────────────────────────────────────────────
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode 1)              ; 菜单栏留着：新手查「这个功能叫什么」很方便
(column-number-mode 1)         ; 状态栏显示列号
(global-hl-line-mode 1)        ; 高亮当前行
(setq x-stretch-cursor t)      ; 光标在中文下自动变宽，更容易找到
(setq-default line-spacing 2)  ; 行距放宽一点，中文长文更好读
(setq inhibit-startup-screen t)          ; 不要那个 GNU Emacs 启动画面
(setq initial-scratch-message nil)

;; 行号：只在写代码时显示（写文章时有行号反而干扰）
(setq display-line-numbers-type 'absolute)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;;; ── 长行自动折行：写文章时不要横向滚动 ──────────────────────────────────
(dolist (hook '(text-mode-hook org-mode-hook markdown-mode-hook))
  (add-hook hook #'visual-line-mode))
(setq-default word-wrap t)

(provide 'init-ui)
;;; init-ui.el ends here
