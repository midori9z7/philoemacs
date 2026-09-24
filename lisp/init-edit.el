;;; init-edit.el --- 编辑手感：复制粘贴、撤销、选区、搜索 -*- lexical-binding: t; -*-

;;; ── 让 Windows 用户先用得顺手 ──────────────────────────────────────────
;; CUA 模式：选中内容后，C-c 复制、C-x 剪切、C-v 粘贴、C-z 撤销。
;; 没选中内容时，C-c / C-x 仍然是 Emacs 的前缀键，不会打架。
(cua-mode 1)

;;; ── 撤销：写长文最怕丢东西，把历史留大一点 ──────────────────────────────
(setq undo-limit (* 20 1024 1024)         ; 20 MB
      undo-strong-limit (* 30 1024 1024)
      undo-outer-limit (* 100 1024 1024))

;;; ── 中英文句读 ──────────────────────────────────────────────────────────
;; 让 M-a / M-e（按句子前后移动）、M-k（删到句末）认识中文的 。！？
(with-eval-after-load 'simple
  (setq sentence-end-base "[.?!。！？…][\"'”’）)】]*"))

;;; ── 搜索的小改进 ────────────────────────────────────────────────────────
(setq isearch-lazy-count t              ; 显示「第 3/17 个匹配」
      lazy-highlight-initial-delay 0.2
      isearch-wrap-pause 'no)           ; 搜到末尾再按 C-s 就绕回开头

;;; ── 剪贴板 ──────────────────────────────────────────────────────────────
(setq select-enable-clipboard t
      mouse-drag-copy-region t          ; 鼠标选中的内容直接进系统剪贴板
      save-interprogram-paste-before-kill t
      kill-do-not-save-duplicates t)

;;; ── C-= 连按：选中范围智能扩大（词 → 句 → 段 → 整块）──────────────────
;; 后悔了就 M-x er/contract-region
(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

;;; ── 括号与引号 ──────────────────────────────────────────────────────────
(setq electric-pair-preserve-balance t
      electric-pair-delete-adjacent-pairs t)

;;; ── 打字时的小习惯 ──────────────────────────────────────────────────────
(setq-default scroll-preserve-screen-position t)
(setq-default auto-fill-function nil)   ; 不自动硬换行（用 visual-line 折行更聪明）
(setq next-line-add-newlines nil)
(setq-default indicate-empty-lines nil)
;; 正文里别自动缩进（org / text），否则写完一段按回车会莫名缩进
(add-hook 'org-mode-hook (lambda () (electric-indent-local-mode -1)))
(add-hook 'text-mode-hook (lambda () (electric-indent-local-mode -1)))

(provide 'init-edit)
;;; init-edit.el ends here
