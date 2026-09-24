# Emacs 使用教程

环境：GNU Emacs 30.1（Windows），配置目录 `C:\Users\venus\.emacs.d`，下文写作 `~/.emacs.d`。

按键记号：

| 记号 | 含义 |
| --- | --- |
| `C-` | Ctrl |
| `M-` | Alt |
| `S-` | Shift |
| `C-x C-s` | 按住 Ctrl，按 x，再按 s |
| `C-x b` | 按住 Ctrl 按 x，松开，再按 b |
| `C-c n n` | 按住 Ctrl 按 c，松开，按 n，再按 n |

`C-g` 取消当前操作。出现提示、卡顿或误操作时，连按数次 `C-g` 回到正常状态。

## 1. 启动与退出

| 操作 | 方法 |
| --- | --- |
| 启动 | 开始菜单搜索 Emacs；或终端执行 `emacs` |
| 退出 | `C-x C-c`；有未保存内容时会逐个询问 |
| 首次启动 | 自动下载插件，耗时取决于网络 |
| 无网络启动 | 插件缺失，弹出 `*Warnings*` 缓冲区，按 `q` 关闭；Emacs 基础功能可用 |

启动后默认打开 `~/org/inbox.org`。

## 2. 基本概念

| 名称 | 含义 |
| --- | --- |
| buffer | 文件在内存中的副本。编辑对象是 buffer，保存后才写入磁盘 |
| window | 显示 buffer 的区域，一个 frame 可分割为多个 window |
| frame | 操作系统窗口 |
| point | 光标位置 |
| mark | 选区起点。`C-SPC` 设置，移动 point 后形成选区 |
| minibuffer | 底部命令行。`M-x`、打开文件、搜索的输入都在此 |
| mode line | 窗口底部状态行，显示文件名、行号、列号、主模式 |
| major mode | 每个 buffer 一个，决定语法高亮与部分按键，如 `org-mode`、`python-mode` |
| minor mode | 可叠加的开关，如行号、自动折行 |

## 3. 文件

| 按键 | 命令 | 说明 |
| --- | --- | --- |
| `C-x C-f` | find-file | 打开文件；输入不存在的路径即新建 |
| `C-x C-s` | save-buffer | 保存 |
| `C-x C-w` | write-file | 另存为 |
| `C-x d` | dired | 打开目录（文件管理器） |
| `C-x C-c` | save-buffers-kill-terminal | 退出 |

已保存内容的管理：

| 项目 | 位置 |
| --- | --- |
| 带版本号的备份 | `~/.emacs.d/backups/` |
| 自动保存 | `~/.emacs.d/auto-save/` |
| 锁文件 | 不生成（`create-lockfiles` 为 nil） |
| 光标位置 | 自动记忆，重开文件回到上次位置 |
| 最近文件 | `C-x C-r` |

## 4. 光标移动

| 按键 | 位置 |
| --- | --- |
| `C-f` / `C-b` | 前 / 后一个字符 |
| `M-f` / `M-b` | 前 / 后一个词 |
| `C-n` / `C-p` | 下一行 / 上一行 |
| `C-a` / `C-e` | 行首 / 行尾 |
| `M-a` / `M-e` | 句首 / 句尾（识别中英文句读） |
| `M-<` / `M->` | 文件开头 / 结尾 |
| `C-v` / `M-v` | 下一页 / 上一页 |
| `M-g g` | 跳到指定行 |
| `C-l` | 重绘当前行到屏幕中央 |

## 5. 编辑

| 按键 | 说明 |
| --- | --- |
| 选中后 `C-c` / `C-x` | 复制 / 剪切（CUA 模式，仅在有选区时生效） |
| `C-v` | 粘贴 |
| `C-y` | 粘贴（Emacs 原生） |
| `M-y` | 从剪贴板历史中选择粘贴项 |
| `M-w` | 复制到 kill ring（不改动系统剪贴板） |
| `C-z` 或 `C-/` | 撤销 |
| `C-x u` | 撤销（同上，可重复触发） |
| `C-k` | 删除到行尾 |
| `M-d` / `M-DEL` | 向前 / 向后删除一个词 |
| `C-SPC` | 设置选区起点 |
| `C-x h` | 全选 |
| `C-=` | 连续按可扩大选区：词 → 句 → 段 |
| `M-x er/contract-region` | 反向缩小选区 |
| `M-\` | 删除光标周围的空白 |
| `M-/` | 补全当前 buffer 中出现过的词 |

撤销历史上限为 20 MB。

键盘宏：

| 按键 | 说明 |
| --- | --- |
| `C-x (` | 开始录制 |
| `C-x )` | 结束录制 |
| `C-x e` | 执行 |
| `C-c k` | 选择并执行已录制的宏 |

## 6. 搜索与替换

| 按键 | 命令 | 说明 |
| --- | --- | --- |
| `C-s` | consult-line | 在当前文件内搜索，输入时即时预览 |
| `C-r` | isearch-backward | 向上搜索 |
| `M-%` | query-replace | 逐个替换 |
| `C-M-%` | query-replace-regexp | 正则替换 |
| `M-s o` | occur | 把当前文件所有匹配行汇总到一个 buffer |
| `C-c F` | consult-ripgrep | 在目录中全文搜索（需 ripgrep） |
| `C-c f` | my/search-notes | 在 `~/org/notes/` 中全文搜索 |
| `C-c i` | consult-imenu | 跳到当前文件的函数或标题 |

搜索状态下的按键：`M-n` / `M-p` 取历史，`RET` 结束并停在此处，`C-g` 取消并回到原位。

补全界面（所有 `M-x`、打开文件、切换 buffer 的列表）：

| 按键 | 说明 |
| --- | --- |
| `C-n` / `C-p` 或方向键 | 上下移动 |
| `RET` | 选中 |
| `C-g` | 取消 |
| 空格分隔多个词 | 模糊匹配，顺序无关，如 `org cap` |
| `C-.` | 对当前候选项执行其他操作（embark） |

## 7. 窗口与 buffer

| 按键 | 说明 |
| --- | --- |
| `C-x b` | 切换 buffer（含最近打开的文件） |
| `C-x C-b` | buffer 列表（ibuffer） |
| `<C-tab>` / `<C-S-tab>` | 下一个 / 上一个 buffer |
| `C-x o` | 光标移到另一个 window |
| `C-x 2` / `C-x 3` | 上下 / 左右分割 |
| `C-x 1` | 只保留当前 window |
| `C-x 0` | 关闭当前 window |
| `C-x <left>` | 撤销上一次窗口布局变化 |
| `C-x k` | 关闭当前 buffer |

## 8. 帮助

| 按键 | 说明 |
| --- | --- |
| `C-h k` | 按下某个键，显示它绑定的命令 |
| `C-h b` | 列出当前所有按键绑定 |
| `C-h f` | 查询函数 |
| `C-h v` | 查询变量 |
| `C-h m` | 说明当前主模式 |
| `C-h e` | 显示 `*Messages*`（错误信息在此） |
| `C-h B` | 列出所有可用的按键前缀及命令（embark） |
| `C-h r` | Emacs 手册 |
| `C-h i` | Info 文档 |
| `C-h t` | 官方入门教程 |

按下前缀键后停留 0.5 秒，底部会列出后续可用按键（which-key）。

## 9. 本配置的按键总表

配置相关：

| 按键 | 说明 |
| --- | --- |
| `C-c I` | 打开 `init.el` |
| `F5` | 重新加载配置 |
| `C-c g` | 配置同步：提交并推送到 GitHub |
| `C-c t` | 选择配色主题（即时预览，回车确定） |
| `C-c =` / `C-c -` / `C-c 0` | 放大 / 缩小 / 复位字号 |
| `C-c w` | 专注写作模式开关（正文居中留白） |

笔记：

| 按键 | 说明 |
| --- | --- |
| `C-c n n` | 新建或打开一篇笔记（依次输入标题、关键词） |
| `C-c n s` | 全文搜索笔记内容 |
| `C-c n l` | 插入指向另一篇笔记的链接 |
| `C-c n b` | 查看指向当前笔记的反向链接 |
| `C-c n r` | 修改当前笔记的标题或关键词（文件名一并更新） |
| `C-c n d` | 用文件管理器打开笔记目录 |
| `C-c n j` | 打开今天的日记笔记 |

日程与记录：

| 按键 | 说明 |
| --- | --- |
| `C-c c` | 快速记录，随后按模板字母（见第 11 节） |
| `C-c a` | 日程总览 |
| `C-c l` | 为当前位置存一个链接 |
| `C-c h` | 跳到当前笔记的某个标题 |

代码：

| 按键 | 说明 |
| --- | --- |
| `C-x g` | magit，Git 界面 |
| `C-x p p` | 切换项目 |
| `C-c e` | 启动 eglot（语言服务器） |
| `M-.` / `M-,` | 跳到定义 / 返回 |
| `C-c i` | 跳到函数或标题 |

## 10. Org 基本语法

```org
#+TITLE: 文档标题

* 一级标题
** 二级标题
*** 三级标题

* TODO 未完成事项
* DONE 已完成事项

带标签的标题                                                    :标签:

普通段落。两个标题之间可以写任意多行。

- 列表项
- 列表项

1. 有序列表
2. 有序列表

| 列一 | 列二 |
|------|------|
| 内容 | 内容 |

#+BEGIN_SRC python
print("代码块")
#+END_SRC

[[https://example.com][链接文字]]
[[file:另一个文件.org][文件链接]]
```

| 按键 | 说明 |
| --- | --- |
| `TAB` | 折叠或展开当前标题 |
| `S-TAB` | 全局折叠或展开 |
| `C-c C-t` | 切换 TODO 状态（TODO → NEXT → WAIT → DONE） |
| `C-c C-s` / `C-c C-d` | 设置计划时间 / 截止时间 |
| `C-c C-l` | 插入链接 |
| `C-c C-o` | 打开光标处的链接 |
| `C-c C-c` | 执行上下文操作（更新统计、运行代码块等） |
| `C-c C-e` | 导出 |

导出：

| 按键 | 格式 |
| --- | --- |
| `C-c C-e h o` | HTML，并用浏览器打开 |
| `C-c C-e l p` | PDF（经 LaTeX，本机已装 MiKTeX） |
| `C-c C-e t a` | 纯文本 |

中文 PDF 需在文件头加入 `#+LATEX_HEADER: \usepackage{ctex}`。

导出 `.docx` 需另装 pandoc，然后执行 `pandoc 文件.org -o 文件.docx`。

## 11. 笔记（Denote）

一篇笔记一个文件，存放于 `~/org/notes/`。文件名为 `时间戳--标题__关键词.org`，例如 `20260919T214000--读书笔记__阅读.org`。

| 操作 | 按键 |
| --- | --- |
| 新建或打开 | `C-c n n`，依次输入标题、关键词，回车结束 |
| 插入链接 | `C-c n l`，选中目标笔记 |
| 查看反链 | `C-c n b` |
| 重命名 | `C-c n r` |
| 全文搜索 | `C-c n s` |
| 打开目录 | `C-c n d` |

关键词候选项来自已有笔记中出现过的关键词，并在 `init-notes.el` 的 `denote-known-keywords` 中预置。

## 12. 快速记录与日程

`C-c c` 后按模板字母：

| 字母 | 内容 | 写入位置 |
| --- | --- | --- |
| `t` | 待办事项 | `~/org/tasks.org` 的「任务」标题下 |
| `n` | 随手笔记 | `~/org/inbox.org` 的「笔记」标题下 |
| `i` | 灵感、摘抄 | `~/org/inbox.org` 的「灵感」标题下，并把系统剪贴板内容一并插入 |
| `r` | 读书笔记 | `~/org/inbox.org` 的「读书」标题下 |
| `j` | 日记 | `~/org/journal.org`，按年、月、日自动归档 |

写完按 `C-c C-c` 保存并关闭，按 `C-c C-k` 放弃。

`C-c a` 打开日程，随后按键：

| 按键 | 视图 |
| --- | --- |
| `a` | 本周日程 |
| `t` | 所有待办 |

日程 buffer 内：

| 按键 | 说明 |
| --- | --- |
| `RET` | 跳到对应条目 |
| `t` | 切换 TODO 状态 |
| `d` | 设置截止日期 |
| `s` | 保存所有 Org 文件 |
| `g` | 刷新 |
| `q` | 关闭 |

参与日程的文件在 `init-notes.el` 的 `org-agenda-files` 中列出，默认是 `inbox.org` 与 `tasks.org`。

## 13. 写代码

| 按键 | 说明 |
| --- | --- |
| `C-x p p` | 选择项目 |
| `C-x p f` | 在项目内查找文件 |
| `C-x p b` | 在项目内切换 buffer |
| `C-c F` | 在目录内全文搜索 |
| `C-c e` | 对当前文件启动语言服务器（需先安装对应语言的 server） |
| `M-.` | 跳到定义 |
| `M-x eglot-rename` | 重命名符号 |
| `M-x flymake-show-buffer-diagnostics` | 列出当前文件的所有诊断 |
| `M-x shell` | 打开系统命令行 |
| `M-x eshell` | 打开 Emacs 内置 shell |

Git（magit，`C-x g` 打开）：

| 按键 | 说明 |
| --- | --- |
| `TAB` | 展开或折叠当前区块 |
| `s` / `u` | 暂存 / 取消暂存 |
| `c c` | 提交，写信息后 `C-c C-c` 完成 |
| `P p` | 推送到远端 |
| `F u` | 从远端拉取 |
| `g` | 刷新 |
| `q` | 关闭 |

tree-sitter 语法高亮在语法文件存在时自动启用。补装语法文件：`M-x treesit-install-language-grammar`。

## 14. 补全

| 场景 | 行为 |
| --- | --- |
| 命令、文件、buffer | 竖排候选列表，边输入边过滤 |
| 代码 buffer | 输入两个字符后自动弹出候选，`C-n` / `C-p` 选择，`RET` 确认 |
| 正文 buffer | 不自动弹出；需要时按 `C-M-i` |

`M-x list-packages` 打开插件列表。在配置里用 `(use-package 包名 :ensure t)` 声明新插件，按 `F5` 或重启 Emacs 即会安装。

## 15. 外观

| 项目 | 位置 |
| --- | --- |
| 西文与代码字体 | `init-ui.el` 的 `my/font-mono`，默认 `Victor Mono` |
| 中文字体 | `init-ui.el` 的 `my/font-cjk`，默认 `Microsoft YaHei` |
| 字号 | `init-ui.el` 的 `my/font-size`，120 表示 12pt |
| 主题 | `init-ui.el` 的 `my/theme`，默认 nil，即不加载主题 |

选择主题：

| 方式 | 效果 |
| --- | --- |
| `C-c t` | 列表内即时预览，`RET` 确定；仅对本次运行有效 |
| 把主题名写入 `my/theme` | 每次启动自动加载，如 `(setq my/theme 'doom-one)` |
| `M-x customize-themes` | 勾选并保存到 `custom.el`；首次会询问是否信任该主题，按 `y` 回答 |

行号默认只在代码 buffer 显示。窗口标题栏与滚动条跟随系统深色模式。

## 16. 配置同步

`~/.emacs.d` 本身即 Git 仓库，远端为 `https://github.com/midori9z7/philoemacs`。仓库内不存在副本，改动即工作区改动。

| 操作 | 方法 |
| --- | --- |
| 提交并推送 | `C-c g`：暂存全部改动 → 询问提交说明（回车用默认）→ 推送 |
| 查看或分步操作 | `C-x g` 打开 magit |
| 命令行 | `cd ~/.emacs.d`，然后 `git add -A`、`git commit -m "说明"`、`git push` |
| 换电脑 | `git clone https://github.com/midori9z7/philoemacs.git ~/.emacs.d`，插件在首次启动时自动下载 |

版本控制包含的文件：`init.el`、`early-init.el`、`lisp/*.el`、`README.md`、`LICENSE`、`.gitignore`、`.gitattributes`。

被 `.gitignore` 排除的内容：`elpa/`、`*.elc`、`custom.el`、`backups/`、`auto-save/`、`url/`、`org-persist/`、`history`、`places`、`recentf`。

## 17. 配置结构与修改

| 文件 | 内容 |
| --- | --- |
| `early-init.el` | 启动早期设置：垃圾回收阈值、窗口初始参数、对话框开关 |
| `init.el` | 入口：定义目录变量、按顺序加载各模块 |
| `lisp/init-base.el` | 目录、插件源、UTF-8 与中文、备份、通用使用习惯 |
| `lisp/init-ui.el` | 字体、主题、状态栏、行号、折行 |
| `lisp/init-completion.el` | vertico、consult、corfu、cape、which-key |
| `lisp/init-edit.el` | CUA 剪贴板、撤销上限、句读、选区扩展 |
| `lisp/init-notes.el` | Org 设置、capture 模板、agenda、Denote、专注模式 |
| `lisp/init-code.el` | magit、eglot、tree-sitter、Markdown |
| `lisp/init-keys.el` | 全部自定义按键、配置同步命令 |
| `custom.el` | Emacs 自身写入的设置，不手工编辑 |

常用开关：

| 变量 | 文件 | 作用 |
| --- | --- | --- |
| `my/evil` | `init-base.el` | 设为 `t` 启用 Vim 按键；此时应注释掉 `init-edit.el` 中的 `(cua-mode 1)` |
| `my/theme` | `init-ui.el` | 启动时加载的主题 |
| `my/font-mono`、`my/font-cjk`、`my/font-size` | `init-ui.el` | 字体与字号 |
| `my/org-directory`、`my/notes-directory` | `init-base.el` | 笔记目录 |
| `org-agenda-files` | `init-notes.el` | 参与日程的文件 |
| `org-capture-templates` | `init-notes.el` | 记录模板 |
| `org-todo-keywords` | `init-notes.el` | 待办状态关键字 |
| `display-line-numbers-type` | `init-ui.el` | `absolute` 或 `relative` |
| `initial-buffer-choice` | `init-notes.el` | 启动时打开的文件 |

修改后按 `F5` 重新加载。个别设置需重启 Emacs。配置有误时，`C-h e` 查看 `*Messages*`。

## 18. 故障处理

| 现象 | 处理 |
| --- | --- |
| 无响应、提示不停 | 连按 `C-g` |
| 询问 yes/no | 按 `y` 或 `n` |
| 启动时询问是否加载主题 | 在底部命令行按 `y`；再问「以后是否信任」也按 `y`，此后不再询问 |
| 中文显示为方块 | 修改 `my/font-cjk`，按 `F5` |
| 西文未使用设定字体 | 确认字体已安装，重启 Emacs；找不到时自动回退 Courier New |
| 弹出 `*Warnings*` 且提示插件安装失败 | 确认网络后重启 Emacs |
| 打开大文件后卡顿 | `M-x so-long-mode` |
| 启动报错 | `C-h e` 查看 `*Messages*`；`M-x toggle-debug-on-error` 后重现可得到调用栈 |
| 忘记按键 | `C-h k` 后按该键；或 `C-h b` 列出全部绑定 |
| 忘记命令名 | `M-x` 后输入关键词，列表会过滤 |
| 中文输入 | 使用系统输入法，Emacs 内无需设置 |

## 19. 环境明细

| 项目 | 值 |
| --- | --- |
| Emacs | GNU Emacs 30.1，装在 `C:\Program Files\Emacs\emacs-30.1\` |
| 配置目录 | `C:\Users\venus\.emacs.d\`（Emacs 里写作 `~/.emacs.d/`） |
| 笔记目录 | `C:\Users\venus\org\`（`~/org/`），单篇笔记在 `~/org/notes/` |
| 全文搜索 | ripgrep 15.2.0（已装，命令 `rg`） |
| 附带可用 | MiKTeX（可导出 PDF）、Python 3.13、git |

## 20. 后续可增加

- 拼写检查、`org-modern`（Org 外观增强）、`jinx`
- 中英混排的字体方案（Sarasa Mono SC / 更纱黑体）
- 用 Emacs 收发邮件、看 RSS
- 把笔记目录用 git 版本管理（`C-x g` 就能提交）
