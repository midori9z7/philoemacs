;;; early-init.el --- 启动最早期设置（在 init.el 之前执行） -*- lexical-binding: t; -*-

;; 这个文件在「图形界面」和「插件系统」初始化之前就生效，
;; 所以只放必须抢先的设置：启动加速、窗口外观、原生编译的噪声。

;;; ── 启动加速 ────────────────────────────────────────────────────────────
;; 启动阶段把垃圾回收阈值调到极高，启动完成后再调回正常值。
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Windows 上「文件名处理函数」会拖慢启动，先存起来，启动完成后再恢复。
(defvar my/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist my/file-name-handler-alist
                  gc-cons-threshold (* 64 1024 1024) ; 64 MB
                  gc-cons-percentage 0.1)
            (message "Emacs 启动完成，用时 %s" (emacs-init-time))))

;; 优先加载比 .elc 更新的 .el（改了配置立刻生效）
(setq load-prefer-newer t)

;; 原生编译（Emacs 29+）异步编译出错时不要弹 *Warnings* 窗口
(when (boundp 'native-comp-async-report-warnings-errors)
  (setq native-comp-async-report-warnings-errors 'silent))

;;; ── 别弹 Windows 对话框 ────────────────────────────────────────────────
;; Emacs 偶尔会问「真的要加载这个主题吗」之类的问题。若让它弹 Windows 对话框，
;; 人在别的窗口忙、没看见时就会以为 Emacs 死机了（真的会卡住不响应）。
;; 设成 nil 之后，这类提问都显示在下方命令行，按 y / n 就行。
(setq use-dialog-box nil)

;;; ── 界面：一开始就不要工具栏 / 滚动条，避免启动时闪一下 ────────────────
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars . nil) default-frame-alist)
(push '(menu-bar-lines . 1) default-frame-alist)      ; 菜单栏留着，方便新手查命令
(push '(fullscreen . maximized) default-frame-alist)  ; 不想最大化就删掉这一行
(setq frame-inhibit-implied-resize t)

(provide 'early-init)
;;; early-init.el ends here
