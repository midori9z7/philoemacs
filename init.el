;;; init.el --- 个人 Emacs 配置入口 -*- lexical-binding: t; -*-

;;; 目录结构
;;   ~/.emacs.d/
;;     early-init.el        启动最早期设置（启动加速、窗口外观）
;;     init.el              本文件：入口，只负责按顺序加载下面的模块
;;     custom.el            Emacs 自己写的设置（M-x customize 保存到这里）
;;     lisp/
;;       init-base.el       基础：目录、编码与中文、备份、使用习惯
;;       init-ui.el         外观：字体、主题、状态栏
;;       init-completion.el 补全：输入命令 / 搜索 / 代码补全
;;       init-edit.el       编辑：撤销、选区、跳转
;;       init-notes.el      笔记：Org + Denote + 专注写作
;;       init-code.el       写代码：magit、eglot、树形语法
;;       init-keys.el       快捷键
;;
;;; 常用操作
;;   C-c I   打开配置        F5      重新加载配置
;;   C-c a   日程            C-c c   快速记录        C-c n n 新建/打开笔记
;;   C-g     取消一切        M-x     按名字执行命令   C-h k   查这个键是干什么的

;;; ── 个人信息（建议改成你自己的，会影响 Org 导出和 Git 提交）─────────────
;; (setq user-full-name "你的名字")
;; (setq user-mail-address "you@example.com")

;;; ── 把 lisp/ 加进加载路径，并声明模块目录 ───────────────────────────────
(defvar my/lisp-directory (expand-file-name "lisp" user-emacs-directory)
  "个人配置模块所在目录。")
(add-to-list 'load-path my/lisp-directory)

;;; ── 让 M-x customize 的结果写到 custom.el，不污染 init.el ───────────────
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file nil 'nomessage))

;;; ── 按顺序加载各模块 ────────────────────────────────────────────────────
;;  顺序不能乱：base 里定义了路径变量和其它模块要用的开关。
(require 'init-base)        ; 基础与包管理（必须先加载）
(require 'init-ui)          ; 外观
(require 'init-completion)  ; 补全与搜索
(require 'init-edit)        ; 编辑增强
(require 'init-notes)       ; 笔记与写作
(require 'init-code)        ; 编程
(require 'init-keys)        ; 快捷键（最后加载，覆盖前面的绑定）

(provide 'init)
;;; init.el ends here
