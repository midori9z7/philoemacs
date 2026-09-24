;;; init-completion.el --- 补全与搜索：vertico / consult / corfu -*- lexical-binding: t; -*-

;; 这一节负责「输入命令、找文件、搜内容、写代码时自动补全」的手感，
;; 是 Doom Emacs 用起来最爽的部分，这里用同一套插件自己搭。

;;; ── 通用补全行为 ────────────────────────────────────────────────────────
(setq completion-ignore-case t
      read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-cycle-threshold 3)   ; 只剩几个候选时，直接按 TAB 循环

;;; 模糊匹配：记住关键词就行，不用按顺序打全
(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless basic)
        completion-category-overrides '((file (styles basic partial-completion)))))

;;; 竖排候选列表（M-x、C-x b、C-x C-f 都变成这样）
(use-package vertico
  :ensure t
  :init
  (setq vertico-cycle t
        vertico-count 15)
  (vertico-mode 1))

;;; 候选旁边显示一点说明（文件大小、命令的快捷键等）
(use-package marginalia
  :ensure t
  :init (marginalia-mode 1))

;;; 更强的搜索 / 跳转命令
(use-package consult
  :ensure t
  :bind (("C-s"     . consult-line)       ; 在当前文件里搜索（带预览）
         ("M-y"     . consult-yank-pop)   ; 从剪贴板历史里挑
         ("C-x b"   . consult-buffer)     ; 切换缓冲区（也列出最近文件）
         ("C-x C-r" . consult-recent-file)
         ("C-c k"   . consult-kmacro)
         ("C-c F"   . consult-ripgrep)    ; 全项目/全目录全文搜索
         ("C-c i"   . consult-imenu)))    ; 在当前文件里跳到某个函数/标题

;;; 对补全候选本身做操作（C-. 之后可以「在另一个窗口打开」「批量改」……）
(use-package embark
  :ensure t
  ;; 注意：M-. 留给「跳到定义」，不要占用
  :bind (("C-."   . embark-act)
         ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook (embark-collect-mode . embark-consult-preview-minor-mode))

;;; 缓冲区内的自动补全（corfu）
(defun my/corfu-enable-auto ()
  "在代码缓冲区里打开自动弹出补全，正文写作时不弹（免得干扰打字）。"
  (setq-local corfu-auto t))
(defun my/corfu-disable-auto () (setq-local corfu-auto nil))

(use-package corfu
  :ensure t
  :init
  (setq corfu-auto nil                 ; 默认不自动弹
        corfu-auto-delay 0.25
        corfu-auto-prefix 2
        corfu-cycle t
        corfu-preselect 'prompt
        corfu-quit-no-match 'separator)
  (add-hook 'prog-mode-hook #'my/corfu-enable-auto)
  (add-hook 'eshell-mode-hook #'my/corfu-enable-auto)
  (add-hook 'text-mode-hook #'my/corfu-disable-auto)
  (global-corfu-mode 1))

;;; 补全内容来源：dabbrev = 本文件里出现过的词（写长文时很好用）
(use-package cape
  :ensure t
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file))

;;; 按键提示：按下前缀键后，等半秒会告诉你接下来能按什么
(use-package which-key
  :ensure t
  :init
  (setq which-key-idle-delay 0.5
        which-key-sort-order #'which-key-key-order-alpha
        which-key-max-description-length 42)
  (which-key-mode 1))

(provide 'init-completion)
;;; init-completion.el ends here
