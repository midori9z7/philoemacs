;;; init-code.el --- 写代码：版本控制、跳转定义、语法高亮、终端 -*- lexical-binding: t; -*-

;; 目标不是「重型 IDE」，而是：改一改脚本、看别人代码、记笔记时顺手跑几行。

;;; ── Git：magit（Emacs 里最好用的 Git 界面）──────────────────────────────
(use-package magit
  :ensure t
  :init
  (setq magit-save-repository-buffers 'dontask
        magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  :bind ("C-x g" . magit-status))       ; 改完文件按 C-x g，s 暂存，c c 提交，P p 推送

;;; ── 代码补全与诊断 ──────────────────────────────────────────────────────
;; Emacs 内置的 LSP 客户端 eglot：装了对应语言的 language server 之后，
;; 在代码文件里执行 M-x eglot 即可获得补全、跳转定义（M-.）、重命名（M-x eglot-rename）。
(use-package eglot
  :ensure nil                           ; Emacs 29 起内置，不用装
  :init
  (setq eglot-autoshutdown t            ; 关掉最后一个文件时自动停掉 server
        read-process-output-max (* 1024 1024))
  ;; 不留 LSP 调试日志（eglot 1.16 起变量改名，两种名字都兼容）
  (if (boundp 'eglot-events-buffer-config)
      (setq eglot-events-buffer-config '(:size 0 :format full))
    (setq eglot-events-buffer-size 0))
  :bind ("C-c e" . eglot))

(add-hook 'prog-mode-hook #'flymake-mode)   ; 语法检查（eglot 也会往这里塞错误）

;;; ── 树形语法（tree-sitter）：有语法文件才启用，没有就自动用老模式 ────────
(setq treesit-font-lock-level 4)
(dolist (entry '((python-mode     . python-ts-mode)
                 (js-mode         . js-ts-mode)
                 (typescript-mode . typescript-ts-mode)
                 (css-mode        . css-ts-mode)
                 (json-mode       . json-ts-mode)
                 (yaml-mode       . yaml-ts-mode)
                 (sh-mode         . bash-ts-mode)
                 (c-mode          . c-ts-mode)
                 (c++-mode        . c++-ts-mode)
                 (ruby-mode       . ruby-ts-mode)))
  (let* ((ts-mode (cdr entry))
         (lang (intern (string-remove-suffix "-ts-mode" (symbol-name ts-mode)))))
    (when (and (fboundp ts-mode)
               (fboundp 'treesit-ready-p)
               (treesit-ready-p lang t))
      (add-to-list 'major-mode-remap-alist entry))))
;; 想补语法文件：M-x treesit-install-language-grammar，输入 python / javascript …
;; （这一步需要 C 编译器，没装就算了，不影响其它功能）

;;; ── Python ──────────────────────────────────────────────────────────────
(setq python-indent-offset 4
      python-shell-interpreter "python")
(with-eval-after-load 'python
  (add-hook 'python-mode-hook
            (lambda ()
              (setq-local fill-column 88))))

;;; ── 通用编辑设置 ────────────────────────────────────────────────────────
(setq compilation-ask-about-save nil
      compilation-scroll-output 'first-error)
(setq-default show-trailing-whitespace nil)

;;; ── Markdown（写 README、写公众号草稿都能用）───────────────────────────
(use-package markdown-mode
  :ensure t
  :mode ("\\.md\\'" "\\.markdown\\'"))

;;; ── 终端 ────────────────────────────────────────────────────────────────
;; M-x shell     打开系统命令行（Windows 上是 cmd）
;; M-x eshell    纯 Emacs 的命令行，能在里面直接用 Emacs 的命令
;; 想让 M-x shell 用 PowerShell，把下面两行的注释去掉：
;; (setq explicit-shell-file-name "pwsh.exe")
;; (setq shell-file-name "pwsh.exe")

(provide 'init-code)
;;; init-code.el ends here
